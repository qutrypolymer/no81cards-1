local m=82209012
local cm=_G["c"..m]
function cm.initial_effect(c)
	--flip check
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_FLIP)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetOperation(cm.chkop)  
	c:RegisterEffect(e1) 
	--flip  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_POSITION)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.flipcon)  
	e2:SetCost(cm.flipcost)  
	e2:SetTarget(cm.fliptg)  
	e2:SetOperation(cm.flipop)  
	c:RegisterEffect(e2) 
	--pos
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_POSITION)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EVENT_PHASE+PHASE_END)  
	e3:SetCountLimit(1,m+10000)  
	e3:SetTarget(cm.postg)  
	e3:SetOperation(cm.posop)  
	c:RegisterEffect(e3)  
	--ac
	local e4=Effect.CreateEffect(c)   
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)  
	e4:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1) 
	e4:SetCondition(cm.effcon)
	e4:SetValue(cm.aclimit)  
	c:RegisterEffect(e4)   
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)  
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)  
end  
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)  
	return rc~=e:GetHandler()
end  
function cm.flipcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return c:IsFacedown() end  
	local pos=Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)  
	Duel.ChangePosition(c,pos)
end  
function cm.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end  
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)  
end  
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))  
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)  
end  
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetHandler():GetBattleTarget()  
	return tc and tc:IsRelateToBattle()  
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetHandler():GetBattleTarget()  
	Duel.Hint(HINT_CARD,0,m)  
	Duel.SendtoGrave(tc,REASON_EFFECT)  
end  
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsCanTurnSet() end  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)  
end  
function cm.posop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)  
	end  
end  
function cm.effcon(e)  
	return e:GetHandler():GetFlagEffect(m)~=0  
end 
function cm.aclimit(e,re,tp)  
	return re:GetActivateLocation()==LOCATION_GRAVE
end  