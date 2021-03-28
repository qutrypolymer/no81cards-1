--三和弦乐团
c9910051.named_with_Traid=1
function c9910051.initial_effect(c)
	--apply effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER)
	e1:SetCost(c9910051.cost)
	e1:SetTarget(c9910051.target)
	e1:SetOperation(c9910051.operation)
	c:RegisterEffect(e1)
end
function c9910051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9910051.filter(c,tp)
	local code=c:GetCode()-9910000
	local flag=Duel.GetFlagEffectLabel(tp,9910051)
	if flag and math.fmod(flag,code)==0 then return false end
	local m=_G["c"..c:GetCode()]
	if not (m and m.named_with_Traid and c:IsAbleToGraveAsCost()) then return false end
	local te=m.onfield_effect
	if not te then return false end
	local event=te:GetCode()
	local con=te:GetCondition()
	local tg=te:GetTarget()
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
	if not res then return false end
	local res1=not con or con(e,tp,teg,tep,tev,tre,tr,trp)
	local res2=not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0)
	return res1 and res2
end
function c9910051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return e:GetHandler():IsAbleToDeckAsCost()
			and Duel.IsExistingMatchingCard(c9910051.filter,tp,LOCATION_EXTRA,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910051.filter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local m=_G["c"..tc:GetCode()]
	local te=m.onfield_effect
	local event=te:GetCode()
	local tg=te:GetTarget()
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
	if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,1) end
end
function c9910051.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if tc then
		local m=_G["c"..tc:GetCode()]
		local te=m.onfield_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	local code=tc:GetCode()-9910000
	local flag=Duel.GetFlagEffectLabel(tp,9910051)
	if flag then code=code*flag end
	Duel.ResetFlagEffect(tp,9910051)
	Duel.RegisterFlagEffect(tp,9910051,RESET_PHASE+PHASE_END,0,1,code)
end
