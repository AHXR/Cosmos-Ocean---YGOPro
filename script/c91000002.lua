--Cosmos Ocean - Giving
function c91000002.initial_effect(c)
	c:SetUniqueOnField(1,0,91000002)

	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	--splimit
	local eSpecialSummon=Effect.CreateEffect(c)
	eSpecialSummon:SetType(EFFECT_TYPE_FIELD)
	eSpecialSummon:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	eSpecialSummon:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	eSpecialSummon:SetRange(LOCATION_PZONE)
	eSpecialSummon:SetTargetRange(1,0)
	eSpecialSummon:SetTarget(c91000002.splimit)
	c:RegisterEffect(eSpecialSummon)
	
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91000002,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c91000002.reccon)
	e1:SetTarget(c91000002.rectg)
	e1:SetOperation(c91000002.recop)
	c:RegisterEffect(e1)
	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91000002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c91000002.spcon)
	e2:SetTarget(c91000002.sptg)
	e2:SetOperation(c91000002.spop)
	c:RegisterEffect(e2)
	
	--giving
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,91000002)
	e3:SetTarget(c91000002.givtg)
	e3:SetOperation(c91000002.givop)
	c:RegisterEffect(e3)
end

function c91000002.givtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chk1 = Duel.IsPlayerCanDraw(1-tp);
		local chk2 = Duel.IsExistingTarget(c91000002.gfilter,tp,LOCATION_MZONE,0,1,nil)
		
		local sel=0
		
		if chk1 and chk2~=false then
			sel=1
		elseif chk1 and not chk2 then
			sel=2
		elseif not chk1 and chk2~=false then
			sel=3
		end
		
		e:SetLabel(sel)
		return sel~=0
	end
	
	local sel=e:GetLabel()
	
	if sel~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(91000002,2))
		
		if sel==1 then
			sel=Duel.SelectOption(tp,aux.Stringid(91000002,3),aux.Stringid(91000002,4))+1
		elseif sel==2 then
			Duel.SelectOption(tp,aux.Stringid(91000004,3))
		elseif sel==3 then
			Duel.SelectOption(tp,aux.Stringid(91000004,4))
		end
		
		e:SetLabel(sel)
		
		if sel==1 then
			Duel.SetTargetPlayer(1-tp)
			local ht=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
			local ct=5-ht
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*1000)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			Duel.SelectTarget(tp,c91000002.gfilter,tp,LOCATION_MZONE,0,1,1,nil)
		end
	end
end

function c91000002.givop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	
	if sel==1 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local ht=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
		local ct=5-ht
		if Duel.Draw(p,ct,REASON_EFFECT) then
			Duel.Recover(tp,ct*500,REASON_EFFECT)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(500)
			tc:RegisterEffect(e1)
			Duel.Recover(1-tp,500,REASON_EFFECT)
		end
	end
end

function c91000002.gfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLocation(LOCATION_MZONE)
end

function c91000002.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c91000002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c91000002.cfilter,1,nil)
end
function c91000002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c91000002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end

function c91000002.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c91000002.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c91000002.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c91000002.filter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam((ct)*300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,(ct)*300)
end
function c91000002.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c91000002.filter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Recover(tp,(ct)*300,REASON_EFFECT)
end

function c91000002.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end