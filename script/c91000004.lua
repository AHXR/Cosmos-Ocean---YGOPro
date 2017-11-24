--Cosmos Ocean - Detachment
function c91000004.initial_effect(c)
	c:SetUniqueOnField(1,0,91000004)

	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	--splimit
	local eSpecialSummon=Effect.CreateEffect(c)
	eSpecialSummon:SetType(EFFECT_TYPE_FIELD)
	eSpecialSummon:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	eSpecialSummon:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	eSpecialSummon:SetRange(LOCATION_PZONE)
	eSpecialSummon:SetTargetRange(1,0)
	eSpecialSummon:SetTarget(c91000004.splimit)
	c:RegisterEffect(eSpecialSummon)
	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(91000004,3))
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c91000004.spcon)
	c:RegisterEffect(e1)
	
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	-- Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(91000004,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c91000004.sptg)
	e3:SetOperation(c91000004.spop)
	c:RegisterEffect(e3)
end

function c91000004.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end

function c91000004.wfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then
		local g1=Duel.GetMatchingGroupCount(c91000004.wfilter,tp,LOCATION_DECK,0,e:GetHandler() )
		local g2=Duel.GetMatchingGroupCount(c91000004.filter,tp,LOCATION_DECK,0,e:GetHandler() )
		
		local sel=0
		
		if g1>0 and g2==0 then 
			sel=1 
		elseif g1==0 and g2>0 then
			sel=2
		elseif g1>0 and g2>0 then
			sel=3
		end
		e:SetLabel(sel)
		return sel~=0
	end
	
	local sel=e:GetLabel()
	
	if sel~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(91000004,2))
			
		if sel==3 then
			sel=Duel.SelectOption(tp,aux.Stringid(91000004,0),aux.Stringid(91000004,1))+1
		elseif sel==2 then
			Duel.SelectOption(tp,aux.Stringid(91000004,0))
		elseif sel==1 then
			Duel.SelectOption(tp,aux.Stringid(91000004,1))
		end
		
		e:SetLabel(sel)
			
		if sel==2 then
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		else
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		end
	end
	
end
function c91000004.spop(e,tp,eg,ep,ev,re,r,rp)

	local sel=e:GetLabel()
	
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c91000004.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c91000004.wfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

function c91000004.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000004.ssfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO)
end
function c91000004.spcon(e,c)
	local c1 = Duel.GetMatchingGroupCount(c91000004.ssfilter,tp,LOCATION_MZONE,0,e:GetHandler() )
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return c1>=1 and pc and pc:IsAttribute(ATTRIBUTE_WATER)
end