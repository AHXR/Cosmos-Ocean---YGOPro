--Cosmos Ocean - City Horizon
function c91000025.initial_effect(c)
	c:SetUniqueOnField(1,0,91000025)

	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)
	
	--Dharma
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCondition(c91000025.dhcondition)
	e1:SetOperation(c91000025.dhactivate)
	c:RegisterEffect(e1)
	
	--Kharma
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCode(EVENT_ATTACK_DISABLED)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c91000025.khcondition)
	e2:SetTarget(c91000025.khtarget)
	e2:SetOperation(c91000025.khactivate)
	c:RegisterEffect(e2)
	
	--Least Effort
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetCondition(c91000025.lecondition)
	e4:SetTarget(c91000025.letarget)
	e4:SetOperation(c91000025.leactivate)
	c:RegisterEffect(e4)
	
	--Detachment
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PREDRAW)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c91000025.dethcon)
	e5:SetTarget(c91000025.dethtg)
	e5:SetOperation(c91000025.dethop)
	c:RegisterEffect(e5)
	
	--Giving
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c91000025.gcost)
	e6:SetOperation(c91000025.gactivate)
	c:RegisterEffect(e6)
	
	--Intention&Desire
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_ACTIVATE)
	e7:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES)
	e7:SetCode(EVENT_DRAW)
	e7:SetCondition(c91000025.idcondition)
	e7:SetTarget(c91000025.idtarget)
	e7:SetOperation(c91000025.idactivate)
	c:RegisterEffect(e7)
	
	--Pure Potentiality
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_ACTIVATE)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(c91000025.ppcondition)
	e8:SetTarget(c91000025.pptarget)
	e8:SetOperation(c91000025.ppactivate)
	c:RegisterEffect(e8)
end
---------------------------------------------------------------------------------------------
function c91000025.ppcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst():GetSummonType()==SUMMON_TYPE_SYNCHRO and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsAttribute(ATTRIBUTE_WATER)
end
function c91000025.pptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c91000025.ppactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

---------------------------------------------------------------------------------------------
function c91000025.idfilter(c)
	return c:IsCode(91000006)
end

function c91000025.idcondition(e,tp,eg,ep,ev,re,r,rp)
	local c1 = Duel.GetMatchingGroupCount(c91000025.idfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
	local c2 = Duel.GetMatchingGroupCount(c91000025.gsfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
	
	return c1>0 and c2>0 and ep~=tp and bit.band(r,REASON_RULE)~=0
end

function c91000025.idtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c91000025.idactivate(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==0 then
	elseif sg:GetCount()==1 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,ep,HINTMSG_TOGRAVE)
		local dg=sg:Select(ep,1,1,nil)
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	end
end
---------------------------------------------------------------------------------------------
function c91000025.gfilter(c)
	return c:IsCode(91000002)
end

function c91000025.gsfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end

function c91000025.gcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1 = Duel.GetMatchingGroupCount(c91000025.gfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
	local c2 = Duel.GetMatchingGroupCount(c91000025.gsfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
	
	if chk==0 then return c1>0 and c2>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c91000025.gactivate(e,tp,eg,ep,ev,re,r,rp)
	--damage conversion
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	local e2=e1:Clone()
	Duel.RegisterEffect(e2,1-tp)
end

---------------------------------------------------------------------------------------------
function c91000025.decfilter(c)
	return c:IsCode(91000005)
end
function c91000025.dethcon(e,tp,eg,ep,ev,re,r,rp)
	local c1 = Duel.GetMatchingGroupCount(c91000025.decfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
	return c1>0 and tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetDrawCount(tp)>0 
end
function c91000025.defilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToHand()
end
function c91000025.dethtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000025.defilter,tp,LOCATION_REMOVED,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c91000025.dethop(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c91000025.defilter),tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
---------------------------------------------------------------------------------------------
function c91000025.leccfilter(c)
	return c:IsCode(91000005)
end
function c91000025.lecfilter(c,tp)
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE)
		and rc:IsAttribute(ATTRIBUTE_WATER) and rc:IsType(TYPE_SYNCHRO) and rc:IsControler(tp) and rc:IsRelateToBattle()
end
function c91000025.lecondition(e,tp,eg,ep,ev,re,r,rp)
	local c1 = Duel.GetMatchingGroupCount(c91000025.leccfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
	return eg:IsExists(c91000025.lecfilter,1,nil,tp) and c1>0
end
function c91000025.lefilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c91000025.letarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c91000025.lefilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c91000025.lefilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c91000025.lefilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c91000025.leactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
---------------------------------------------------------------------------------------------
function c91000025.khfilter(c)
	return c:IsCode(91000000)
end
function c91000025.khcondition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	local c1 = Duel.GetMatchingGroupCount(c91000025.khfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )

	return a:IsLocation(LOCATION_MZONE) and t and t:IsLocation(LOCATION_MZONE) and t:IsPosition(POS_FACEUP_ATTACK)
			and t:IsAttribute(ATTRIBUTE_WATER) and t:IsType(TYPE_SYNCHRO) and c1>0
end
function c91000025.khtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	local g=Group.FromCards(a,t)
	local dam=math.abs(a:GetAttack()-t:GetAttack())
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,dam)
end
function c91000025.khactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<2 then return end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	if c1:IsFaceup() and c2:IsFaceup() then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=math.abs(c1:GetAttack()-c2:GetAttack())
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
---------------------------------------------------------------------------------------------
function c91000025.cfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c91000025.dhfilter(c)
	return c:IsCode(91000000)
end
function c91000025.dhcondition(e,tp,eg,ep,ev,re,r,rp)
	local c1 = Duel.GetMatchingGroupCount(c91000025.dhfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() )
	
	return eg:IsExists(c91000025.cfilter,1,nil) and e:IsAttribute(ATTRIBUTE_WATER) and c1>0
end
function c91000025.dhactivate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c91000025.aclimit)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c91000025.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end