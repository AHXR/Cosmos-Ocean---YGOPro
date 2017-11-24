--Cosmos Ocean - Concord
function c91000039.initial_effect(c)
	--Activate
	local eCont=Effect.CreateEffect(c)
	eCont:SetType(EFFECT_TYPE_ACTIVATE)
	eCont:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(eCont)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91000039,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c91000039.target)
	e1:SetOperation(c91000039.activate)
	c:RegisterEffect(e1)
	
	--Graveyard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91000039,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c91000039.gtarget)
	e2:SetOperation(c91000039.goper)
	c:RegisterEffect(e2)
end
-----------------------------------------------------------------
function c91000039.gtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c91000027.ggfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingTarget(c91000027.ggfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c91000039.goper(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectTarget(tp,c91000039.ggfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end

function c91000039.ggfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToDeck() and c:IsType(TYPE_FUSION) and c:IsType(TYPE_PENDULUM)
end
-----------------------------------------------------------------
function c91000039.filter1(c,e)
	return c:IsAbleToGrave() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsFaceup()
end
function c91000039.filter2(c,e,tp,m,chkf)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf)
end

function c91000039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg=Duel.GetMatchingGroup(c91000039.filter1,tp,LOCATION_EXTRA+LOCATION_MZONE,0,nil,e)
		return Duel.IsExistingMatchingCard(c91000039.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c91000039.cffilter(c)
	return (c:IsLocation(LOCATION_MZONE)) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() )
end
function c91000039.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c91000039.filter1),tp,LOCATION_EXTRA+LOCATION_MZONE,0,nil,e)
	local sg=Duel.GetMatchingGroup(c91000039.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
		local cf=mat:Filter(c91000039.cffilter,nil)
		if cf:GetCount()>0 then
			Duel.ConfirmCards(1-tp,cf)
		end
		Duel.SendtoGrave(mat,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
	end
end
