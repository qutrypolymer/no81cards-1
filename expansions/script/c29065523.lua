--方舟骑士-桃金娘
c29065523.named_with_Arknight=1
function c29065523.initial_effect(c)
	c:EnableCounterPermit(0x10ae)








	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065523,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c29065523.cttg)
	e2:SetOperation(c29065523.ctop)
	c:RegisterEffect(e2)
end
function c29065523.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local n=2 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,n,0,0x10ae)
end
function c29065523.refilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:GetBaseAttack()>0
end
function c29065523.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) then  
	local n=2
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	e:GetHandler():AddCounter(0x10ae,n)
	end
	if Duel.IsExistingMatchingCard(c29065523.refilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29065523,1)) then
	local tc=Duel.SelectMatchingCard(tp,c29065523.refilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local atk=tc:GetBaseAttack()
	Duel.Recover(tp,atk,REASON_EFFECT)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e1:SetValue(1)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	end
end