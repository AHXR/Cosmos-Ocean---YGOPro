--Cosmos Ocean - Pure Latent
function c91000043.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(91000043,0))
	e1:SetCost(c91000043.activateCost)
	e1:SetOperation(c91000043.activate)
	c:RegisterEffect(e1)
	
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c91000043.desop)
	c:RegisterEffect(e2)
	
	--Destroy2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c91000043.descon2)
	e3:SetOperation(c91000043.desop2)
	c:RegisterEffect(e3)
	
	--Disable atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(91000043,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_ATTACK)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c91000043.condition)
	e4:SetCost(c91000043.cost)
	e4:SetOperation(c91000043.operation)
	c:RegisterEffect(e4)
end

function c91000043.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function c91000043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c91000043.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() then Duel.NegateAttack()
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c91000043.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c91000043.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,91000043)
	Duel.NegateAttack()
end

------------------------------------------------------------
function c91000043.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c91000043.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c91000043.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

------------------------------------------------------------
function c91000043.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c91000043.ssfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		
		local tc=g:GetFirst()
		tc:CompleteProcedure()
		c:SetCardTarget(tc)
		
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end

function c91000043.activateCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000043.tgfilter,tp,LOCATION_DECK,0,1,nil)  
		and Duel.IsExistingMatchingCard(c91000043.tgfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c91000043.tgfilter3,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c91000043.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	
	g=Duel.SelectMatchingCard(tp,c91000043.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	
	g=Duel.SelectMatchingCard(tp,c91000043.tgfilter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	return true
end

function c91000043.ssfilter(c)
	return c:IsCode(91000003)
end

function c91000043.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end

function c91000043.tgfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave()
end

function c91000043.tgfilter3(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and c:IsAbleToGrave()
end