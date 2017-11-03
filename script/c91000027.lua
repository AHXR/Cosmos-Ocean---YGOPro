--Cosmos Ocean - Dream Energy
function c91000027.initial_effect(c)
	--Activate
	local eCont=Effect.CreateEffect(c)
	eCont:SetType(EFFECT_TYPE_ACTIVATE)
	eCont:SetCode(EVENT_FREE_CHAIN)
	eCont:SetCost(c91000027.Activcost)
	c:RegisterEffect(eCont)
	
	--Galaxy Wishes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(c91000027.gwOperation)
	c:RegisterEffect(e1)
	
	--Paradise
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91000027,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c91000027.pcon)
	e2:SetOperation(c91000027.pop)
	c:RegisterEffect(e2)
	
	--Understanding
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(91000027,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetCondition(c91000027.ucon)
	e3:SetTarget(c91000027.utarget)
	e3:SetOperation(c91000027.uoperation)
	c:RegisterEffect(e3)
	
	--Graveyard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(91000027,2))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(c91000027.gtarget)
	e4:SetOperation(c91000027.goper)
	c:RegisterEffect(e4)
	
	--indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetTarget(c91000027.infilter)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c91000027.infilter(e,c)
	return c:IsType(TYPE_FIELD)
end
----------------------------------------------------------------
function c91000027.gtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c91000027.ggfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingTarget(c91000027.ggfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c91000027.goper(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectTarget(tp,c91000027.ggfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end

function c91000027.ggfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToDeck() and c:IsType(TYPE_SYNCHRO)
end
----------------------------------------------------------------
function c91000027.ufilter(c,val)
	local atk=c:GetAttack()
	return atk>=0 and atk<val and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c91000027.utarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsAttribute(ATTRIBUTE_WATER) and tc:GetControler()==tp
		and Duel.IsExistingMatchingCard(c91000027.ufilter,tp,LOCATION_DECK,0,1,nil,tc:GetAttack()) end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c91000027.uoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c91000027.ufilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttack())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c91000027.ucon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c91000027.underfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() ) >0
end
----------------------------------------------------------------


function c91000027.pcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(91000027)==0 and Duel.GetMatchingGroupCount(c91000027.parafilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )>0
end
function c91000027.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e1:SetCondition(c91000027.imcon)
		e1:SetOperation(c91000027.imop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c91000027.discon)
		e1:SetOperation(c91000027.disop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(91000027,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
end

function c91000027.pfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000027.imcon(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) or not Duel.IsChainDisablable(ev) then return false end
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsExists(c91000027.pfilter,1,nil) then return true end
	end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex and tg~=nil and tc+tg:FilterCount(c91000027.pfilter,nil)-tg:GetCount()>0 then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	if ex and tg~=nil and tc+tg:FilterCount(c91000027.pfilter,nil)-tg:GetCount()>0 then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	if ex and tg~=nil and tc+tg:FilterCount(c91000027.pfilter,nil)-tg:GetCount()>0 then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	if ex and tg~=nil and tc+tg:FilterCount(c91000027.pfilter,nil)-tg:GetCount()>0 then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_RELEASE)
	if ex and tg~=nil and tc+tg:FilterCount(c91000027.pfilter,nil)-tg:GetCount()>0 then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	if ex and tg~=nil and tc+tg:FilterCount(c91000027.pfilter,nil)-tg:GetCount()>0 then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_CONTROL)
	if ex and tg~=nil and tc+tg:FilterCount(c91000027.pfilter,nil)-tg:GetCount()>0 then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
	if ex and tg~=nil and tc+tg:FilterCount(c91000027.pfilter,nil)-tg:GetCount()>0 then
		return true
	end
	return false
end
function c91000027.imop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(799183,0)) then
		Duel.NegateEffect(ev)
	end
end

function c91000027.tgg(c,card)
	return c:GetCardTarget() and c:GetCardTarget():IsContains(card) and not c:IsDisabled()
end
function c91000027.disfilter(c)
	local eqg=c:GetEquipGroup():Filter(c91000027.dischk,nil)
	local tgg=Duel.GetMatchingGroup(c91000027.tgg,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c)
	eqg:Merge(tgg)
	return c:IsRace(RACE_DEVINE) and eqg:GetCount()>0
end
function c91000027.dischk(c)
	return not c:IsDisabled()
end
function c91000027.discon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c91000027.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c91000027.disop(e,tp,eg,ep,ev,re,r,rp,c,og)
	Duel.Hint(HINT_CARD,0,91000027)
	local g=Duel.GetMatchingGroup(c91000027.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local eqg=tc:GetEquipGroup():Filter(c91000027.dischk,nil)
		local tgg=Duel.GetMatchingGroup(c91000027.tgg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tc)
		sg:Merge(eqg)
		sg:Merge(tgg)
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local dg=sg:Select(tp,1,99,nil)
	local dc=dg:GetFirst()
	while dc do
		Duel.NegateRelatedChain(dc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		dc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		dc:RegisterEffect(e2)
		if dc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			dc:RegisterEffect(e3)
		end
		dc=dg:GetNext()
	end
	Duel.BreakEffect()
	return
end

----------------------------------------------------------------
function c91000027.gwfilter(c)
	return c:IsCode(91000015) and c:IsFaceup()
end

function c91000027.parafilter(c)
	return c:IsCode(91000021) and c:IsFaceup()
end

function c91000027.underfilter(c)
	return c:IsCode(91000023) and c:IsFaceup()
end

function c91000027.afilter(c)
	return c:IsCode(91000016) and c:IsFaceup()
end

function c91000027.gwafilter(c)
	return ( c:IsCode(91000015) or c:IsCode(91000016) ) and c:IsFaceup()
end

function c91000027.gwCondition(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount( c91000027.gwafilter,tp,LOCATION_ONFIELD,0,e:GetHandler() ) > 0 end
end

function c91000027.gwOperation(e,tp,eg,ep,ev,re,r,rp)
	local cgw = Duel.GetMatchingGroupCount(c91000027.gwfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
	local catt = Duel.GetMatchingGroupCount(c91000027.afilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )

	local i_add=0
	
	if cgw>0 then
		i_add=100
	end
	
	if catt>0 then
		i_add=200
	end

	return i_add
end
----------------------------------------------------------------
function c91000027.Activcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
