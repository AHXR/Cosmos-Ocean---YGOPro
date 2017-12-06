--Cosmos Ocean - Moonlight Entrust
function c91000042.initial_effect(c)
	c:SetUniqueOnField(1,0,91000042)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c91000042.cost)
	e1:SetDescription(aux.Stringid(91000042,1))
	e1:SetOperation(c91000042.activate)
	c:RegisterEffect(e1)
	
	--Field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD, 0)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetTargetRange(LOCATION_HAND, 0)
	c:RegisterEffect(e3)
	
	local e4=e3:Clone()
	e3:SetTargetRange(LOCATION_HAND, 0)
	e3:SetCondition(c91000042.ActivCond)
	c:RegisterEffect(e4)
	
	local e5=e4:Clone()
	e3:SetTargetRange(LOCATION_ONFIELD, 0)
	c:RegisterEffect(e5)
	
	--Change
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(91000042,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetTarget(c91000042.chtarget)
	e6:SetOperation(c91000042.chactivate)
	c:RegisterEffect(e6)
end

-------------------------------------------------
function c91000042.chtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(c91000042.chfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c91000042.chactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,1-tp)
		Duel.Recover(1-tp,500,REASON_EFFECT)
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c91000042.chfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

function c91000042.chfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
-------------------------------------------------
function c91000042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Recover(1-tp,2000,REASON_EFFECT)
end

function c91000042.thfilter(c)
	return c:IsCode(91000002)
end
function c91000042.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c91000042.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(91000042,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
-------------------------------------------------
function c91000042.ActivCond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c91000042.bfilter,tp,LOCATION_ONFIELD,0,e:GetHandler() ) > 0
end

function c91000042.bfilter(c) -- Bliss
	return c:IsCode(91000013) and c:IsFaceup()
end
