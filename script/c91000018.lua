--Cosmos Ocean - Flow
function c91000018.initial_effect(c)
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
	eSpecialSummon:SetTarget(c91000018.splimit)
	c:RegisterEffect(eSpecialSummon)
	
	--pendulum
	local ependulum=Effect.CreateEffect(c)
	ependulum:SetDescription(aux.Stringid(91000018,0))
	ependulum:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ependulum:SetCode(EVENT_DESTROYED)
	ependulum:SetProperty(EFFECT_FLAG_DELAY)
	ependulum:SetCondition(c91000018.pencon)
	ependulum:SetTarget(c91000018.pentg)
	ependulum:SetOperation(c91000018.penop)
	c:RegisterEffect(ependulum)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91000018,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c91000018.target)
	e1:SetOperation(c91000018.activate)
	c:RegisterEffect(e1)
	
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(91000018,2))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c91000018.posop)
	c:RegisterEffect(e4)
	local e2=e4:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e4:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function c91000018.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end


function c91000018.filter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c91000018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c91000018.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c91000018.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c91000018.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c91000018.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c91000018.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000018.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c91000018.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c91000018.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
