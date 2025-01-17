--乱型镜·镜迷宫
local m=11630205
local cm=_G["c"..m]
function c11630205.initial_effect(c)
	c:EnableCounterPermit(0x640)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--02
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.ctcon)
	e4:SetCost(cm.tkccost)
	e4:SetTarget(cm.tkctg)
	e4:SetOperation(cm.tkcop)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE) 
	e5:SetCost(aux.bfgcost)
	e5:SetCountLimit(1,m+1)
	e5:SetTarget(cm.thtg)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
end
cm.SetCard_xxj_Mirror=true
function cm.cfilter(c,tp)
	return c:IsControler(tp)
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x640,1)
end
--02
function cm.tkccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x640,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x640,4,REASON_COST)
end
function cm.tkcfilter(c)
	return c:IsFaceup()
end
function cm.tkctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(cm.tkcfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(cm.tkcfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g1=Duel.SelectTarget(tp,cm.tkcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst()) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g2=Duel.SelectTarget(tp,cm.tkcfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,g1+g2,2,0,0)
end
function cm.tkcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if (tc:IsFacedown() and not tc:IsRelateToEffect(e)) or (hc:IsFacedown() and not hc:IsRelateToEffect(e)) then return end
	local atk1=tc:GetAttack()
	local att1=tc:GetAttribute()
	local race1=tc:GetRace()
	local def1=tc:GetDefense()
	local lv1=tc:GetLevel()
	local code1=tc:GetCode()
	--
	local atk2=hc:GetAttack()
	local att2=hc:GetAttribute()
	local race2=hc:GetRace()
	local def2=hc:GetDefense()
	local lv2=hc:GetLevel()
	local code2=hc:GetCode()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(att1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	hc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(race1)
	hc:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetValue(atk1)
	hc:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
	e4:SetValue(def1)
	hc:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_LEVEL)
	e5:SetValue(lv1)
	hc:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_CODE)
	e6:SetValue(code1)
	hc:RegisterEffect(e6)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(att2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(race2)
	tc:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetValue(atk2)
	tc:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
	e4:SetValue(def2)
	tc:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_LEVEL)
	e5:SetValue(lv2)
	tc:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_CODE)
	e6:SetValue(code2)
	tc:RegisterEffect(e6)   
end
--03
function cm.thfilter(c)
	return c.SetCard_xxj_Mirror and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end