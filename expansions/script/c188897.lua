local m=188897
local cm=_G["c"..m]
cm.name="灰烬机兵-伽德"
function cm.initial_effect(c)
	--indes  
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,188897) 
	e1:SetTarget(c188897.idtg) 
	e1:SetOperation(c188897.idop) 
	c:RegisterEffect(e1)  
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,288897)
	e1:SetTarget(cm.tg)
	c:RegisterEffect(e1)
end
function cm.filter(c,l)
	return ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_NORMAL)) or (c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER))) and ((l==1 and c:IsAbleToDeck()) or (l==2 and c:IsAbleToHand()))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc~=c and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
	local b1=c:IsLocation(LOCATION_HAND) and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove() and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c,2)
	if chk==0 then return b1 or b2 end
	if b1 then
		e:SetDescription(aux.Stringid(m,0))
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
		e:SetOperation(cm.op1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
	if b2 then
		e:SetDescription(aux.Stringid(m,1))
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
		e:SetOperation(cm.op2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c,2)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE,0)<=0 or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
	Duel.SendtoDeck(tc,nil,1,REASON_EFFECT) 
	end 
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) and tc:IsRelateToEffect(e) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
function c188897.idtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c188897.idop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,10))
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
end 








