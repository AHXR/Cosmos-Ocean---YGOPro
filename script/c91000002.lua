--Cosmos Ocean - Giving
function c91000002.initial_effect(c)
	c:SetUniqueOnField(1,0,91000002)

	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	--splimit
	local eSpecialSummon=Effect.CreateEffect(c)
	eSpecialSummon:SetType(EFFECT_TYPE_FIELD)
	eSpecialSummon:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	eSpecialSummon:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	eSpecialSummon:SetRange(LOCATION_PZONE)
	eSpecialSummon:SetTargetRange(1,0)
	eSpecialSummon:SetTarget(c91000002.splimit)
	c:RegisterEffect(eSpecialSummon)
	
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91000002,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c91000002.reccon)
	e1:SetTarget(c91000002.rectg)
	e1:SetOperation(c91000002.recop)
	c:RegisterEffect(e1)
	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91000002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c91000002.spcon)
	e2:SetTarget(c91000002.sptg)
	e2:SetOperation(c91000002.spop)
	c:RegisterEffect(e2)
end

function c91000002.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c91000002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c91000002.cfilter,1,nil)
end
function c91000002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c91000002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end

function c91000002.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c91000002.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c91000002.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c91000002.filter,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c91000002.filter,tp,LOCATION_PZONE,0,nil)
	local ctadd=ct+ct2
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam((ctadd)*300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,(ctadd)*300)
end
function c91000002.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c91000002.filter,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c91000002.filter,tp,LOCATION_PZONE,0,nil)
	local ctadd=ct+ct2
	Duel.Recover(tp,(ctadd)*300,REASON_EFFECT)
end

function c91000002.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end