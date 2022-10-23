--踏破新世界 ～平海之卷～
local m=33701443
local cm=_G["c"..m]
cm.named_with_NewVenture=1
function cm.NewVenture(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NewVenture
end
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e03=Effect.CreateEffect(c)
	e03:SetType(EFFECT_TYPE_SINGLE)
	e03:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e03:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e03:SetRange(LOCATION_SZONE)
	e03:SetValue(1)
	c:RegisterEffect(e03)
	--Effect 2 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.lpcon)
	e2:SetOperation(cm.lpop)
	c:RegisterEffect(e2)
	--Effect 3 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--Effect 4
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SELF_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.tgccon)
	c:RegisterEffect(e2)
end
--Effect 1
--Effect 2
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	local b1= Duel.IsPlayerCanRemove(1-tp) and #g>0
		and g:IsExists(Card.IsAbleToRemove,1,nil,1-tp,POS_FACEUP,REASON_RULE)
	return  eg:IsExists(cm.cfilter,1,nil,1-tp) and b1
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	local b1= Duel.IsPlayerCanRemove(1-tp) and #g>0
		and g:IsExists(Card.IsAbleToRemove,1,nil,1-tp,POS_FACEUP,REASON_RULE)
	if not b1 then return end
	Duel.Hint(HINT_CARD,0,m) 
	local rg=g:Filter(Card.IsAbleToRemove,nil,1-tp,POS_FACEUP,REASON_RULE)
	local sg=rg:RandomSelect(1-tp,1)
	Duel.HintSelection(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_RULE)
end
--Effect 3 
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()~=p and Duel.GetFlagEffect(p,m+m)==0
end
function cm.filter(c)
	if  c:IsForbidden() or c:IsCode(m) then return false end
	return c:IsType(TYPE_CONTINUOUS) and cm.NewVenture(c)
		and c:CheckUniqueOnField(tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() 
		and c:GetFlagEffect(m)==0 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m+m)>0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) 
		and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_DECK) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			Duel.RegisterFlagEffect(tp,m+m,RESET_PHASE+PHASE_END,0,1)
		end
	end
end 
--Effect 4
function cm.tgccon(e)
	return Duel.GetCurrentPhase()==PHASE_END 
end
