--蒙昧神迹-星移的脉动
function c9911105.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9911105.target)
	e1:SetOperation(c9911105.activate)
	c:RegisterEffect(e1)
end
function c9911105.cfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_NORMAL)
end
function c9911105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911105.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4+g:GetCount() end
end
function c9911105.filter(c,e,tp,ft)
	return c:IsSetCard(0xa954) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE))
end
function c9911105.activate(e,tp,eg,ep,ev,re,r,rp)
	local ng=Duel.GetMatchingGroup(c9911105.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local count=5+ng:GetCount()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=count then
		Duel.ConfirmDecktop(tp,count)
		local g=Duel.GetDecktopGroup(tp,count)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tg=g:Filter(c9911105.filter,nil,e,tp,ft)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(9911105,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=tg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc:IsAbleToHand() and (ft<=0 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end
		Duel.ShuffleDeck(tp)
	end
	if Duel.GetFlagEffect(tp,9911105)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(9911105,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetValue(0x1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_EXTRA_SET_COUNT)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,9911105,RESET_PHASE+PHASE_END,0,1)
end
