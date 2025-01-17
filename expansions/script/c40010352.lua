--龙刻秘仪
local m=40010352
local cm=_G["c"..m]
cm.named_with_DragWizard=1
function cm.DragWizard(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DragWizard
end
function cm.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,40010332)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.rtg)
	e1:SetOperation(cm.rtop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.rtf(c,filter,e,tp,m1,m2,level_function,greater_or_equal)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function cm.f3(c,filter,e,tp,m1,m2,level_function,greater_or_equal,rg)
	local mchk=cm.DragWizard(c) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToGrave() 
	if mchk and cm.rtf(c,filter,e,tp,m1,m2,level_function,greater_or_equal) then
		rg:AddCard(c)
	end
	return mchk and #rg>0
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp) 
		local rg=Duel.GetMatchingGroup(cm.rtf,tp,LOCATION_GRAVE,0,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		return Duel.IsExistingMatchingCard(cm.f3,tp,LOCATION_DECK,0,1,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater",rg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp) 
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.rtf),tp,LOCATION_GRAVE,0,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local ag=Duel.SelectMatchingCard(tp,cm.f3,tp,LOCATION_DECK,0,1,1,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater",rg)
	if #ag>0 and Duel.SendtoGrave(ag,REASON_EFFECT)~=0 then
		local agc=ag:GetFirst()
		if agc:IsLocation(LOCATION_GRAVE) and agc:IsAttribute(ATTRIBUTE_DARK) and agc:IsType(TYPE_RITUAL) then
			rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.rtf),tp,LOCATION_GRAVE,0,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=rg:FilterSelect(tp,aux.NecroValleyFilter(cm.rtf),1,1,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
			aux.GCheckAdditional=nil
			if not mat or mat:GetCount()==0 then return end
			tc:SetMaterial(mat) 
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end   
end
--Effect 2
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.atkfilter(c)
	return (c:IsRace(RACE_SPELLCASTER) or (cm.DragWizard(c) and c:IsType(TYPE_MONSTER))) 
	and c:IsDiscardable()
end
function cm.spfilter(c,e,tp)
	return c:GetType()&0x81==0x81 
		and c:IsCode(40010332) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.atkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		if c:IsLocation(LOCATION_HAND) 
			and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				tc:SetMaterial(nil)
				if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)>0 then
					tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
					tc:CompleteProcedure()
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_PHASE+PHASE_END)
					e2:SetCountLimit(1)
					e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e2:SetLabelObject(tc)
					e2:SetCondition(cm.descon)
					e2:SetOperation(cm.desop)
					Duel.RegisterEffect(e2,tp)
				end
			end
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsAbleToRemove() then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
end
--Effect 3 
--Effect 4 
--Effect 5   
