--Cosmos Ocean - Tirthankara

local c_cosmos_card = 91000000

function c91000030.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c91000030.dacost)
	e1:SetTarget(c91000030.datarget)
	e1:SetOperation(c91000030.daop)
	c:RegisterEffect(e1)	
	-----------------------------------------------------
	
	--pendulum summon
	aux.EnablePendulumAttribute(c)

	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,c_cosmos_card,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),1,true,true)
	
	--equip
	local cosEquip=Effect.CreateEffect(c)
	cosEquip:SetDescription(aux.Stringid(91000030,0))
	cosEquip:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	cosEquip:SetProperty(EFFECT_FLAG_CARD_TARGET)
	cosEquip:SetCategory(CATEGORY_EQUIP)
	cosEquip:SetCode(EVENT_SPSUMMON_SUCCESS)
	cosEquip:SetCondition(c91000030.cosEquipCon)
	cosEquip:SetTarget(c91000030.cosEquipTarget)
	cosEquip:SetOperation(c91000030.cosEquipOper)
	c:RegisterEffect(cosEquip)
	
	--Destroy replace
	local cosEquipDestroy=Effect.CreateEffect(c)
	cosEquipDestroy:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	cosEquipDestroy:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	cosEquipDestroy:SetRange(LOCATION_MZONE)
	cosEquipDestroy:SetCode(EFFECT_DESTROY_REPLACE)
	cosEquipDestroy:SetTarget(c91000030.cosEquipdesreptg)
	cosEquipDestroy:SetOperation(c91000030.cosEquipdesrepop)
	c:RegisterEffect(cosEquipDestroy)
	
	--Tribute
	local cosTribute=Effect.CreateEffect(c)
	cosTribute:SetCategory(CATEGORY_SPECIAL_SUMMON)
	cosTribute:SetType(EFFECT_TYPE_IGNITION)
	cosTribute:SetRange(LOCATION_PZONE)
	cosTribute:SetCost(c91000030.cosTributeCost)
	cosTribute:SetTarget(c91000030.cosTributeTarget)
	cosTribute:SetOperation(c91000030.cosTributeOperation)
	c:RegisterEffect(cosTribute)
end
--------------------------------------------------------------------------------------------
function c91000030.filter1(c)
	return c:IsLocation(LOCATION_SZONE)
end

function c91000030.pcfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end

function c91000030.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_EFFECT) and g:IsExists(c91000030.filter1,1,nil)
	end
	local g=c:GetEquipGroup()
	local sg=g:FilterSelect(tp,c91000030.filter1,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end

function c91000030.datarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c91000030.pcfilter(chkc) end
	local b2=Duel.IsExistingMatchingCard(c91000030.pcfilter,tp,LOCATION_EXTRA,0,1,nil)
	if chk==0 then
		if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
		return b2
	end

	if b2 then
		e:SetProperty(0)
	end
end

function c91000030.daop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c91000030.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
--------------------------------------------------------------------------------------------
function c91000030.cosTributeCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,c_cosmos_card) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,c_cosmos_card)
	Duel.Release(g,REASON_COST)
end
function c91000030.cosTributeTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c91000030.cosTributeOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoGrave(c,REASON_EFFECT)
	if Duel.SpecialSummon(c,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
--------------------------------------------------------------------------------------------
function c91000030.cosEquiprepfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c91000030.cosEquipdesreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c91000030.cosEquiprepfilter,1,nil)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(91000030,1)) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,c91000030.cosEquiprepfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function c91000030.cosEquipdesrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end

function c91000030.cosEquipCon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c91000030.cosEquipFilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c91000030.cosEquipCheck(c) and c:GetLevel()==1
end
function c91000030.cosEquipCheck(c) 
	return c:IsLocation(LOCATION_DECK) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() ) and c:IsAttribute(ATTRIBUTE_WATER)
end

function c91000030.cosEquipTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c91000030.cosEquipCheck(chkc) and c91000030.cosEquipFilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c91000030.cosEquipFilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c91000030.cosEquipFilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c91000030.cosEquipOper(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown()
		or not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	Duel.Equip(tp,tc,c,false)
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c91000030.cosEquipLimit)
	tc:RegisterEffect(e1)
	local atk=tc:GetTextAttack()
	if atk<0 then atk=0 end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(atk)
	tc:RegisterEffect(e2)
	local def=tc:GetTextDefense()
	if def<0 then def=0 end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetValue(def)
	tc:RegisterEffect(e3)
end
function c91000030.cosEquipLimit(e,c)
	return e:GetOwner()==c
end
