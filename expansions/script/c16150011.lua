--大王剑使
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16150011,"DAIOUGUTSUKAI")
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m) 
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.sumlimit)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.con(e,tp)
	return e:GetHandler():GetEquipCount()>0
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_MONSTER)
end
function cm.filter(c)
	return rk.check(c,"DAIOUGU")
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m+200)==0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	c:RegisterFlagEffect(m+200,RESET_CHAIN,0,1)
end
function cm.eqfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and rk.check(c,"DAIOUGU") and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 and c:GetFlagEffect(m)==0
	local b=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,2,nil) and c:GetFlagEffect(m+100)==0
	if chk==0 then return a or b end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local a=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 and c:GetFlagEffect(m)==0
	local b=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,2,nil) and c:GetFlagEffect(m+100)==0
	local op=2
	if a and b then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	elseif a then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))
	elseif b then
		op=Duel.SelectOption(tp,aux.Stringid(m,3))+1
	else
		return 
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if not Duel.Equip(tp,tc,c) then return end
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
			c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,0)
		end
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,2,2,nil)
		if tg:GetCount()>0 then
			Duel.HintSelection(tg)
			Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
			c:RegisterFlagEffect(m+100,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,0)
		end
	else
		return
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end