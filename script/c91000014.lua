--Cosmos Ocean - Destiny
function c91000014.initial_effect(c)
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
	eSpecialSummon:SetTarget(c91000014.splimit)
	c:RegisterEffect(eSpecialSummon)
	
	--pendulum
	local ependulum=Effect.CreateEffect(c)
	ependulum:SetDescription(aux.Stringid(91000014,0))
	ependulum:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ependulum:SetCode(EVENT_DESTROYED)
	ependulum:SetProperty(EFFECT_FLAG_DELAY)
	ependulum:SetCondition(c91000014.pencon)
	ependulum:SetTarget(c91000014.pentg)
	ependulum:SetOperation(c91000014.penop)
	c:RegisterEffect(ependulum)
	
    --actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c91000014.aclimit)
	e1:SetCondition(c91000014.actcon)
	c:RegisterEffect(e1)
	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c91000014.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	--4000 lp
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetDescription(aux.Stringid(91000014,1))
	e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c91000014.con)
	e3:SetOperation(c91000014.op)
	c:RegisterEffect(e3)
end

function c91000014.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c91000014.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end

function c91000014.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<4000
end
function c91000014.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,4000,REASON_EFFECT)
end

function c91000014.target(e,c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000014.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000014.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c91000014.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c91000014.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
