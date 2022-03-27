local m=53707017
local cm=_G["c"..m]
cm.name="幽谷清响"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.Peacecho(c)
	SNNM.AllGlobalCheck(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.reptg)
	e2:SetValue(function(e,c)return cm.repfilter2(c,e:GetHandlerPlayer())end)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,5) end
	Duel.DiscardDeck(tp,5,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local ct=g:GetCount()-1
	if chk==0 then return Duel.IsPlayerCanRemove(tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(tp) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local ct=g:GetCount()-1
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,Card.IsAbleToRemove,ct,ct,nil,tp,nil)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function cm.repfilter2(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.repfilter(c,tp)
	return cm.repfilter2(c,tp) and c:GetFlagEffect(m)==0
end
function cm.tgfilter(c)
	return c:IsSetCard(0x3537) and c:IsFacedown() and c:IsAbleToGrave() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.repfilter,nil,tp)
	local ct=#g
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,ct,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:SetLabel(ct)
		g:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,ct,ct,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
