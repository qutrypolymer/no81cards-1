--终将传达的祈祷
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009796)
function cm.initial_effect(c)
	aux.AddCodeList(c,40009798,40009641,40010240,40009800)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp,mat)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCode(40009798,40009641,40010240,40009800)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		mat=mat:Filter(c.mat_filter,nil,tp)
	end
	return mat:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function cm.matfilter(c)
	return c:CheckSetCard("BlazeMaiden") and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		--c40009561.attach_list[tc] = nil
		Duel.SpecialSummon(ritc,SUMMON_TYPE_RITUAL+SUMMON_VALUE_SELF,tp,tp,false,true,POS_FACEUP)
			local code = ritc:GetOriginalCodeRule()
			matc:RegisterFlagEffect(m,rsrst.std,0,1)
			ritc:RegisterFlagEffect(code,rsrst.std,0,1)
			Duel.RegisterFlagEffect(tp,code,rsrst.ep,0,1)
			local tc = ritc:GetOverlayGroup():Filter(Card.IsSetCard,nil,"BlazeTalisman"):GetFirst()
			cm.attach_list[ritc] = tc
		tc:CompleteProcedure()
	end
end
