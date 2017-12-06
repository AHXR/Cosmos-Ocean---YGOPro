--Cosmos Ocean - Intention & Rapprochement
function c91000041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c91000041.cost)
	c:RegisterEffect(e1)
	
	--Field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_EXTRA, 0)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e2)
	
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(91000041,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c91000041.descost)
	e3:SetTarget(c91000041.destarget)
	e3:SetOperation(c91000041.desactivate)
	c:RegisterEffect(e3)
end

function c91000041.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	Duel.Destroy(dg,REASON_EFFECT)
end

function c91000041.ssfilter(c)
	return c:IsCode( 91000006 )
end

function c91000041.destarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c91000041.ssfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,0,tp,false,false,POS_FACEUP,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c91000041.desactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
	
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg=Duel.GetMatchingGroup(c91000041.filter1,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e)
	
	if Duel.IsExistingMatchingCard(c91000041.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf) then
		local sg=Duel.GetMatchingGroup(c91000041.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			local cf=mat:Filter(c91000041.cffilter,nil)
			if cf:GetCount()>0 then
				Duel.ConfirmCards(1-tp,cf)
			end
			Duel.SendtoGrave(mat,nil,2,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
			
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CANNOT_ATTACK)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e4,true)
		end
	end
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c91000041.splimit)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end

function c91000041.splimit(e,c)
	return c:GetAttribute()~=ATTRIBUTE_WATER
end

function c91000041.cffilter(c)
	return (c:IsLocation(LOCATION_MZONE)) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() )
end

function c91000041.filter1(c,e)
	return c:IsAbleToGrave() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c91000041.filter2(c,e,tp,m,chkf)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf)
end
----------------------------------------------------------------
function c91000041.costfilter(c)
	return  ( c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM) ) or c:IsType(TYPE_FIELD)
end

function c91000041.costfiltermon(c)
	return  ( c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM) )
end

function c91000041.costfilterfield(c)
	return c:IsType(TYPE_FIELD)
end

function c91000041.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000041.costfiltermon,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler()) and
				Duel.IsExistingMatchingCard(c91000041.costfilterfield,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler()) end
				
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c91000041.costfiltermon,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c91000041.costfilterfield,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end