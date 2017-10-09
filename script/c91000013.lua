--Cosmos Ocean - Self
function c91000013.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)

	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()
	
	--splimit
	local eSpecialSummon=Effect.CreateEffect(c)
	eSpecialSummon:SetType(EFFECT_TYPE_FIELD)
	eSpecialSummon:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	eSpecialSummon:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	eSpecialSummon:SetRange(LOCATION_PZONE)
	eSpecialSummon:SetTargetRange(1,0)
	eSpecialSummon:SetTarget(c91000013.splimit)
	c:RegisterEffect(eSpecialSummon)
	
	--pendulum
	local ependulum=Effect.CreateEffect(c)
	ependulum:SetDescription(aux.Stringid(91000013,0))
	ependulum:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ependulum:SetCode(EVENT_DESTROYED)
	ependulum:SetProperty(EFFECT_FLAG_DELAY)
	ependulum:SetCondition(c91000013.pencon)
	ependulum:SetTarget(c91000013.pentg)
	ependulum:SetOperation(c91000013.penop)
	c:RegisterEffect(ependulum)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c91000013.condition)
	e1:SetTarget(c91000013.target)
	e1:SetOperation(c91000013.operation)
	c:RegisterEffect(e1)
	if not c91000013.global_check then
		c91000013.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c91000013.archchk)
		Duel.RegisterEffect(ge2,0)
	end
	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91000013,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c91000013.destg)
	e2:SetOperation(c91000013.desop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c91000013.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c91000013.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c91000013.desfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c91000013.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c91000013.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c91000013.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c91000013.filterloli(c,mc)
	if mc then
		return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCode(mc:GetCode()) and c~=mc
	end
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c91000013.filterloli,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c)
end
function c91000013.condition(e,tp,eg,ev,ep,re,r,rp)
	return Duel.IsExistingMatchingCard(c91000013.filterloli,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,nil)
end
function c91000013.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsImmuneToEffect(e) and not c:IsDisabled()
end
function c91000013.target(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000013.filter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.SelectTarget(tp,c91000013.filter,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
end
function c91000013.operation(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tg:RegisterEffect(e1)
end

function c91000013.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000013.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c91000013.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c91000013.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
