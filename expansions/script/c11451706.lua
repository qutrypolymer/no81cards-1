--大型废件
local m=11451706
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Stuck
	local EFFECT_STUCK=11451695
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_STUCK)
	e1:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1)
	--Tohand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1,m)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_DECK)
	e2:SetCondition(cm.thcon)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsAbleToDeckAsCost()
end
function cm.filter2(c)
	return c:IsAbleToHand() and c:IsCode(m)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()==0 and e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.ConfirmCards(1-tp,g)
	if Duel.SendtoDeck(g,nil,2,REASON_COST)>0 then
		local tg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,2,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end