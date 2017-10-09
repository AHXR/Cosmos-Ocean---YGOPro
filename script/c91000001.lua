--Cosmos Ocean - Karma
function c91000001.initial_effect(c)
	c:SetUniqueOnField(1,0,91000001)

	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	--splimit
	local eSpecialSummon=Effect.CreateEffect(c)
	eSpecialSummon:SetType(EFFECT_TYPE_FIELD)
	eSpecialSummon:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	eSpecialSummon:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	eSpecialSummon:SetRange(LOCATION_PZONE)
	eSpecialSummon:SetTargetRange(1,0)
	eSpecialSummon:SetTarget(c91000001.splimit)
	c:RegisterEffect(eSpecialSummon)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91000001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c91000001.sptg)
	e1:SetOperation(c91000001.spop)
	c:RegisterEffect(e1)
	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91000001,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c91000001.condition)
	e2:SetTarget(c91000001.target)
	e2:SetOperation(c91000001.operation)
	c:RegisterEffect(e2)
	
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(91000001,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,91000001)
	e3:SetTarget(c91000001.pctg)
	e3:SetOperation(c91000001.pcop)
	c:RegisterEffect(e3)
end

function c91000001.pcfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c91000001.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c91000001.pcfilter(chkc) end
	local b2=Duel.IsExistingMatchingCard(c91000001.pcfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then
		if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
		return b2
	end

	if b2 then
		e:SetProperty(0)
	end
end
function c91000001.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c91000001.pcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c91000001.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
		and e:GetHandler():GetReasonCard():IsRelateToBattle()
end
function c91000001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rc=e:GetHandler():GetReasonCard()
	rc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end
function c91000001.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	if rc:IsRelateToEffect(e) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end

function c91000001.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelBelow(1) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c91000001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c91000001.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c91000001.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c91000001.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c91000001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetOperation(c91000001.desop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_ATTACK)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4,true)
		Duel.SpecialSummonComplete()
	end
end
function c91000001.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function c91000001.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end