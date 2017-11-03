--Cosmos Ocean - Understanding
function c91000023.initial_effect(c)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)

	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91000023,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,91000023)
	e1:SetCondition(c91000023.condition)
	e1:SetTarget(c91000023.target)
	e1:SetOperation(c91000023.operation)
	c:RegisterEffect(e1)
	
	--effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,91000023)
	e2:SetTarget(c91000023.efftg)
	e2:SetOperation(c91000023.effop)
	c:RegisterEffect(e2)
end

function c91000023.dkfilter(c) -- Dharma+Kharma
	return c:IsCode(91000000) or c:IsCode(91000001)
end

function c91000023.delefilter(c) -- Detachment+Least Effort
	return c:IsCode(91000004) or c:IsCode(91000005)
end

function c91000023.gifilter(c) -- Giving+Intention&Desire
	return c:IsCode(91000002) or c:IsCode(91000006)
end

function c91000023.pdfilter(c) -- PurePot&Dharma
	return c:IsCode(91000000) or c:IsCode(91000003)
end

function c91000023.pkfilter(c) -- PurePot&Kharma
	return c:IsCode(91000001) or c:IsCode(91000003)
end

function c91000023.thfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end

function c91000023.fffilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end

function c91000023.remfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

opavail={}

function c91000023.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c1 = Duel.GetMatchingGroupCount(c91000023.dkfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
		local c2 = Duel.GetMatchingGroupCount(c91000023.delefilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
		local c3 = Duel.GetMatchingGroupCount(c91000023.gifilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
		local c4 = Duel.GetMatchingGroupCount(c91000023.pkfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
		local c5 = Duel.GetMatchingGroupCount(c91000023.pdfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
	
		opavail={}
		local b_op = false
		
		if c1>1 then
			opavail[0]=1
			b_op = true
		end
		
		if c2>1 and Duel.IsExistingMatchingCard(c91000023.thfilter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) then
			opavail[1]=1
			b_op = true
		end
		
		if c3>1 and Duel.IsExistingMatchingCard(c91000023.fffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
			opavail[2]=1
			b_op = true
		end
		
		if c4>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c91000023.remfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
			and Duel.IsExistingTarget(c91000023.remfilter,1-tp,LOCATION_REMOVED,0,1,nil,e,1-tp) then
			
			opavail[3]=1
			b_op = true
		end
		
		if c5>1 and Duel.CheckLPCost(tp,2000) then
			opavail[4]=1
			b_op = true
		end
		
		e:SetLabel(table.pack(opavail))
		return b_op
	end
	
	local off=1
	local ops={}
	local opval={}
	
	if opavail[0]==1 then
		ops[off]=aux.Stringid(91000023,1)
		opval[off-1]=1
		off=off+1
	end
	
	if opavail[1]==1 then
		ops[off]=aux.Stringid(91000023,2)
		opval[off-1]=1
		off=off+1
	end
	
	if opavail[2]==1 then
		ops[off]=aux.Stringid(91000023,3)
		opval[off-1]=1
		off=off+1
	end
	
	if opavail[3]==1 then
		ops[off]=aux.Stringid(91000023,4)
		opval[off-1]=1
		off=off+1
	end
	
	if opavail[4]==1 then
		ops[off]=aux.Stringid(91000023,5)
		opval[off-1]=1
		off=off+1
	end
	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=ops[op + 1]
	e:SetLabel(sel)
	
	if sel==aux.Stringid(91000023,1) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif sel==aux.Stringid(91000023,2) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	elseif sel==aux.Stringid(91000023,3) then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif sel==aux.Stringid(91000023,4) then
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
		
		if ft1>2 then ft1=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		
		local g1=Duel.SelectTarget(tp,c91000023.remfilter,tp,LOCATION_REMOVED,0,1,ft1,nil,e,tp)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ft2>2 then ft2=2 end
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
		
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectTarget(1-tp,c91000023.remfilter,1-tp,LOCATION_REMOVED,0,1,ft2,nil,e,1-tp)
		
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,g1:GetCount(),0,0)
	elseif sel==aux.Stringid(91000023,5) then
		Duel.PayLPCost(tp,2000)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,5)
	end
end

function c91000023.effop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	
	if sel==aux.Stringid(91000023,1) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c91000023.ssfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif sel==aux.Stringid(91000023,2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c91000023.thfilter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif sel==aux.Stringid(91000023,3) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c91000023.fffilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
		end
	elseif sel==aux.Stringid(91000023,4) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		local g1=g:Filter(Card.IsControler,nil,tp)
		local g2=g:Filter(Card.IsControler,nil,1-tp)
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct1=g1:GetCount()
		if ft1>=ct1 and (ct1==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) then
			local tc=g1:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				tc=g1:GetNext()
			end
		end
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		local ct2=g2:GetCount()
		if ft2>=ct2 and (ct2==1 or not Duel.IsPlayerAffectedByEffect(1-tp,59822133)) then
			local tc=g2:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
				tc=g2:GetNext()
			end
		end
		Duel.SpecialSummonComplete()
	elseif sel==aux.Stringid(91000023,5) then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
		if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT) end
		Duel.BreakEffect()
		Duel.Draw(tp,5,REASON_EFFECT)
		Duel.Draw(1-tp,5,REASON_EFFECT)
	end
end

function c91000023.ssfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c91000023.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c91000023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c91000023.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
