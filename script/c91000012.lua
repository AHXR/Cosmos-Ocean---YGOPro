--Cosmos Ocean - Freedom
function c91000012.initial_effect(c)
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
	eSpecialSummon:SetTarget(c91000012.splimit)
	c:RegisterEffect(eSpecialSummon)
	
	--pendulum
	local ependulum=Effect.CreateEffect(c)
	ependulum:SetDescription(aux.Stringid(91000012,0))
	ependulum:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ependulum:SetCode(EVENT_DESTROYED)
	ependulum:SetProperty(EFFECT_FLAG_DELAY)
	ependulum:SetCondition(c91000012.pencon)
	ependulum:SetTarget(c91000012.pentg)
	ependulum:SetOperation(c91000012.penop)
	c:RegisterEffect(ependulum)
	
	--gain lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91000012,1))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c91000012.reccon)
	e1:SetTarget(c91000012.rectg)
	e1:SetOperation(c91000012.recop)
	c:RegisterEffect(e1)
	if not c91000012.global_check then
		c91000012.global_check=true
		c91000012[0]=0
		--register
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(c91000012.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c91000012.clear)
		Duel.RegisterEffect(ge2,0)
	end
	
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(c91000012.distg)
	c:RegisterEffect(e3)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c91000012.disop)
	c:RegisterEffect(e2)
end

function c91000012.disfilter(c,tp,n)
	if n~=0 and not c:IsLocation(LOCATION_MZONE) then return false end
	return c:IsControler(tp) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c91000012.distg(e,c)
	if not e:GetHandler():IsAttackPos() then return false end
	local tc=c:GetCardTarget()
	return tc:IsExists(c91000012.disfilter,1,nil,e:GetHandlerPlayer(),0)
end
function c91000012.disop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsAttackPos() or re:IsActiveType(TYPE_MONSTER) then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return end
	if g:IsExists(c91000012.disfilter,1,nil,tp,1) and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.NegateEffect(ev)
	end
end

function c91000012.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c91000012.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c91000012[0]>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c91000012.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local i=1
	local ct=c91000012[0]
	local rg=Group.CreateGroup()
	local dam=0
	while i<ct do
		rg:AddCard(c91000012[i])
		i=i+2
	end
	local sc=rg:Select(tp,1,1,nil):GetFirst()
	local multiatk=false
	i=1
	while i<ct and sc~=c91000012[i] do
		i=i+2
	end
	dam=c91000012[i+1]
	t=i+2
	while i<ct do
		if sc==c91000012[i] then
			multiatk=true
		end
		i=i+2
	end
	if multiatk then
		i=1
		local t={}
		local p=1
		while i<ct do
			if sc==c91000012[i] then
				t[p]=c91000012[i+1]
				p=p+1
			end
			i=i+2
		end
		t[p]=nil
		dam=Duel.AnnounceNumber(tp,table.unpack(t))
	end
	Duel.Recover(p,dam,REASON_EFFECT)
end
function c91000012.regop(e,tp,eg,ep,ev,re,r,rp)
	if ep==1-Duel.GetTurnPlayer() then
		local ct=c91000012[0]
		c91000012[ct+1]=eg:GetFirst()
		c91000012[ct+2]=ev
		c91000012[0]=ct+2
	end
end
function c91000012.clear(e,tp,eg,ep,ev,re,r,rp)
	local ct=c91000012[0]
	if ct>0 then
		local i=1
		while c91000012[i]~=nil do
			c91000012[i]=nil
			i=i+1
		end
		c91000012[0]=0
	end
end

function c91000012.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000012.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c91000012.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c91000012.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end