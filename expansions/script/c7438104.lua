--背反之料理 主菜-半熟罗勒菲力
local m=7438104
local cm=_G["c"..m]

cm.named_with_Crooked_Cook=1
cm.named_with_Crooked_Cook_Main_Course=1

function cm.Crooked_Cook(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Crooked_Cook or c:IsCode(82697249))
end
function cm.Crooked_Cook_Antipasto(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Antipasto
end
function cm.Crooked_Cook_Soup(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Soup
end
function cm.Crooked_Cook_Enree(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Enree
end
function cm.Crooked_Cook_Main_Course(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Main_Course
end
function cm.Crooked_Cook_Salad(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Salad
end
function cm.Crooked_Cook_Dessert(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Dessert
end
function cm.Crooked_Cook_Drink(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Drink
end

function cm.initial_effect(c)
	--act qp in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(cm.actcon)
	c:RegisterEffect(e0)
	--rth or search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(cm.descon)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
function cm.confilter(c)
	return cm.Crooked_Cook(c) and c:IsFaceup()
end
function cm.actcon(e)
	return Duel.IsExistingMatchingCard(cm.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.rthfilter(c)
	return cm.Crooked_Cook_Salad(c) and c:IsAbleToHand()
end
function cm.thfilter(c)
	return cm.Crooked_Cook(c) and c:IsAbleToHand()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.rthfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=true
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rthfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.thcon)
		e1:SetOperation(cm.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and re and re:GetHandler():IsCode(82697249)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetTargetRange(0,LOCATION_ONFIELD)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetCondition(cm.lockcon)
	e5:SetValue(1)
	Duel.RegisterEffect(e5,tp)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e6:SetValue(cm.fuslimit)
	Duel.RegisterEffect(e6,tp)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	Duel.RegisterEffect(e7,tp)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	Duel.RegisterEffect(e8,tp)
end
function cm.lockcon(e)
	return Duel.GetCurrentPhase()~=PHASE_MAIN1 
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
