local m=53713008
local cm=_G["c"..m]
cm.name="ALC之腕 SKRNBU"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c)return c:GetOriginalType()&TYPE_TRAP~=0 and c:IsFusionType(TYPE_MONSTER)end,2,true)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_EXTRA)end)
	e2:SetTarget(cm.alctg)
	e2:SetOperation(cm.alcop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.con)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:GetType()&0x20004==0x20004
end
function cm.alctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c,g=e:GetHandler(),eg:Filter(Card.IsSummonLocation,nil,LOCATION_EXTRA)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() and not g:IsContains(chkc) end
	local b1=Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g) and Duel.GetFlagEffect(tp,m)==0
	local b2=c:IsAbleToExtra() and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,m+50)==0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1)) elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0)) else op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end
	e:SetLabel(op)
	if op==0 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	else
		Duel.RegisterFlagEffect(tp,m+50,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_TOEXTRA)
		e:SetProperty(EFFECT_FLAG_DELAY)
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	end
end
function cm.alcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) then return end
		Duel.Destroy(tc,REASON_EFFECT)
		local dc=Duel.GetOperatedGroup():GetFirst()
		if not dc then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil,dc:GetCode()) then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil)
		if #rg>0 then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) end
	else
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)==0 or not c:IsLocation(LOCATION_EXTRA) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,cm.setfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
		if #sg==0 then return end
		Duel.HintSelection(sg)
		local rg=Group.CreateGroup()
		for tc in aux.Next(sg) do
			tc:CancelToGrave()
			if Duel.ChangePosition(tc,POS_FACEDOWN)~=0 and tc:IsFacedown() then rg:AddCard(tc) end
		end
		Duel.RaiseEvent(rg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.indtg)
	e1:SetValue(cm.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
