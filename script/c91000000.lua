--Cosmos Ocean - Dharma
function c91000000.initial_effect(c)
	c:SetUniqueOnField(1,0,91000000)

	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	--splimit
	local eSpecialSummon=Effect.CreateEffect(c)
	eSpecialSummon:SetType(EFFECT_TYPE_FIELD)
	eSpecialSummon:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	eSpecialSummon:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	eSpecialSummon:SetRange(LOCATION_PZONE)
	eSpecialSummon:SetTargetRange(1,0)
	eSpecialSummon:SetTarget(c91000000.splimit)
	c:RegisterEffect(eSpecialSummon)
	
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e3:SetValue(200)
	c:RegisterEffect(e3)
	
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91000000,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,91000000)
	e2:SetTarget(c91000000.pctg)
	e2:SetOperation(c91000000.pcop)
	c:RegisterEffect(e2)
	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(91000000,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c91000000.target)
	e3:SetOperation(c91000000.operation)
	c:RegisterEffect(e3)
end

function c91000000.cfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsControler(tp) and c:IsReason(REASON_DESTROY)
		and Duel.IsExistingMatchingCard(c91000000.filter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c91000000.filter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c91000000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(c91000000.cfilter,1,nil,e,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c91000000.cfilter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsControler(tp) and c:IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(c91000000.filter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c91000000.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=eg:Filter(c91000000.cfilter2,nil,e,tp)
	if sg:GetCount()==1 then
		local tc=sg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c91000000.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local tc=sg:GetFirst()
		if not tc then return end
		local code=tc:GetCode()
		tc=sg:GetNext()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c91000000.filter,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end


function c91000000.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000000.pcfilter(c)
	return (c:IsFaceup()) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c91000000.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c91000000.pcfilter(chkc) end
	local b2=Duel.IsExistingMatchingCard(c91000000.pcfilter,tp,LOCATION_EXTRA,0,1,nil)
	if chk==0 then
		if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
		return b2
	end

	if b2 then
		e:SetProperty(0)
	end
end
function c91000000.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c91000000.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end