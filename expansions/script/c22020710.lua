--人理之诗 誓言的羽织
function c22020710.initial_effect(c)
	aux.AddCodeList(c,22020690,22020720)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020710+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22020710.cost)
	e1:SetTarget(c22020710.target)
	e1:SetOperation(c22020710.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22020710.handcon)
	c:RegisterEffect(e2)
end
function c22020710.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c22020710.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,22020710,0x3ff1,0x11,500,500,2,RACE_WARRIOR,ATTRIBUTE_WIND) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22020710.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,22020710,0x3ff1,0x11,500,500,2,RACE_WARRIOR,ATTRIBUTE_WIND) then
		c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TUNER)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function c22020710.filter(c)
	return c:IsFaceup() and c:IsCode(22020690,22020720)
end
function c22020710.handcon(e)
	return Duel.IsExistingMatchingCard(c22020710.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
