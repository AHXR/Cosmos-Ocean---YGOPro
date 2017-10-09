--Cosmos Ocean - Non-Judgment
function c91000020.initial_effect(c)
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
	eSpecialSummon:SetTarget(c91000020.splimit)
	c:RegisterEffect(eSpecialSummon)
	
	--pendulum
	local ependulum=Effect.CreateEffect(c)
	ependulum:SetDescription(aux.Stringid(91000020,0))
	ependulum:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ependulum:SetCode(EVENT_DESTROYED)
	ependulum:SetProperty(EFFECT_FLAG_DELAY)
	ependulum:SetCondition(c91000020.pencon)
	ependulum:SetTarget(c91000020.pentg)
	ependulum:SetOperation(c91000020.penop)
	c:RegisterEffect(ependulum)
	
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c91000020.atkcon)
	e1:SetOperation(c91000020.atkop)
	c:RegisterEffect(e1)
	
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c91000020.starget)
	e2:SetOperation(c91000020.sactivate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end

function c91000020.starget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function c91000020.sactivate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g2)
	Duel.ConfirmCards(1-tp,g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag1=g2:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local ag2=g1:Select(1-tp,1,1,nil)
	Duel.SendtoHand(ag1,tp,REASON_EFFECT)
	Duel.SendtoHand(ag2,1-tp,REASON_EFFECT)
end


function c91000020.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not a or not at then return end
	return a:IsControler(tp) and a:GetAttack()<=at:GetAttack()
end
function c91000020.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not at:IsRelateToBattle() then return end
	--double attack
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(a:GetAttack()*2)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	a:RegisterEffect(e1)
	--destroy spell
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c91000020.descon)
	e2:SetTarget(c91000020.destg)	  
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e2:SetOperation(c91000020.desop)
	Duel.RegisterEffect(e2,tp)
end

function c91000020.sfilter(c)
	return c:IsFacedown() or c:IsType(TYPE_SPELL)
end
function c91000020.descon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if a:IsControler(tp) and at:IsControler(1-tp) and a:IsOnField() and at and a:IsRelateToBattle() and not at:IsRelateToBattle() then return true end
	return false
end
function c91000020.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c91000020.sfilter(chkc) end
	if chk==0 then return true end
end
function c91000020.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local target=Duel.SelectMatchingCard(tp,c91000020.sfilter,tp,0,LOCATION_SZONE,1,1,nil)
	if not g then return end
	local g=target:GetFirst()
	if g:IsFacedown() then Duel.ConfirmCards(tp,g) end
	if g:IsType(TYPE_SPELL) then Duel.Destroy(g,REASON_EFFECT) end
end

function c91000020.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000020.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c91000020.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c91000020.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
