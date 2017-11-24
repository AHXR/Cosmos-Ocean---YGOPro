--Cosmos Ocean Dragon
function c91000032.initial_effect(c)
	aux.EnablePendulumAttribute(c)

	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c91000032.descon)
	c:RegisterEffect(e1)
	
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c91000032.subcon)
	c:RegisterEffect(e2)
	
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c91000032.target)
	e3:SetOperation(c91000032.activate)
	c:RegisterEffect(e3)
	
end

function c91000032.filter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c91000032.eqfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,c,tp)
end
function c91000032.eqfilter(c,tc,tp)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==1 and c:IsFaceup()
end
function c91000032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c91000032.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c91000032.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c91000032.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c91000032.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c91000032.eqfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end

function c91000032.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():IsFaceup()
end

function c91000032.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end