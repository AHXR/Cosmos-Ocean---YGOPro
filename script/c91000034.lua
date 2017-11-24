--Cosmos Ocean - Optimism
function c91000034.initial_effect(c)
	--Activate
	local eCont=Effect.CreateEffect(c)
	eCont:SetType(EFFECT_TYPE_ACTIVATE)
	eCont:SetCode(EVENT_FREE_CHAIN)
	eCont:SetCost(c91000034.ActivCost)
	eCont:SetTarget(c91000034.ActivTarget)
	eCont:SetOperation(c91000034.ActivOperation)
	c:RegisterEffect(eCont)
	
	-- Fusion + Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_FUSION)
	e1:SetTarget(c91000034.TargActivFusion)
	c:RegisterEffect(e1)
	
	local e2=e1:Clone()
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_SYNCHRO)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c91000034.ActivCond)
	c:RegisterEffect(e3)
end
-----------------------------------------------------------------
function c91000034.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c91000034.ActivTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000034.filter,tp,LOCATION_DECK,0,1,nil) end
end

function c91000034.ActivCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end

function c91000034.ActivOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c91000034.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_USE_AS_COST)
		e2:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
-----------------------------------------------------------------
function c91000034.TargActivFusion(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM)
end

function c91000034.ActivCond(e,tp,eg,ep,ev,re,r,rp)
	local c1 = Duel.GetMatchingGroupCount(c91000034.bfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,e:GetHandler() )
	local c2 = Duel.GetMatchingGroupCount(c91000034.efilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,e:GetHandler() )
	
	return c1 > 0 and c2 > 0
end

function c91000034.bfilter(c) -- Bliss
	return c:IsCode(91000008) and c:IsFaceup()
end

function c91000034.efilter(c) -- Bliss
	return c:IsCode(91000026) and c:IsFaceup()
end