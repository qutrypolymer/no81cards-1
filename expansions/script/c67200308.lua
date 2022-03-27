--巧壳的封缄英杰 莉塞露
function c67200308.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--destory
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200308,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200308)
	e1:SetCost(c67200308.descon)
	e1:SetTarget(c67200308.destg)
	e1:SetOperation(c67200308.desop)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCondition(c67200308.spcon)
	e2:SetOperation(c67200308.spop)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)  
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c67200308.eqtg)
	e3:SetOperation(c67200308.eqop)
	c:RegisterEffect(e3)	 
end
function c67200308.cfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x676) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsSummonPlayer(tp)
end
function c67200308.spfilter(c,e,tp)
	return (c:IsSetCard(0x676) or c:IsSetCard(0x3674)) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c67200308.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200308.cfilter1,1,nil,tp)
end
function c67200308.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(c67200308.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_GRAVE)
end
function c67200308.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200308.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
--
function c67200308.spfilter1(c)
	return c:IsFaceup() and (c:IsSetCard(0x3674) or c:IsSetCard(0x676)) and c:IsReleasable()
end
function c67200308.spcon(e,c)
--
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if ct>2 then return false end
	if ct>0 and not Duel.IsExistingMatchingCard(c67200308.spfilter1,tp,LOCATION_SZONE+LOCATION_FZONE,0,ct,nil) then return false end
	return Duel.IsExistingMatchingCard(c67200308.spfilter1,tp,LOCATION_ONFIELD,0,2,nil)
end
function c67200308.spop(e,tp,eg,ep,ev,re,r,rp,c)
--
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if ct<0 then ct=0 end
	local g=Group.CreateGroup()
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectMatchingCard(tp,c67200308.spfilter1,tp,LOCATION_MZONE,0,ct,ct,nil)
		g:Merge(sg)
	end
	if ct<2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectMatchingCard(tp,c67200308.spfilter1,tp,LOCATION_ONFIELD,0,2-ct,2-ct,g:GetFirst())
		g:Merge(sg)
	end
	Duel.Release(g,REASON_COST)
end
--
function c67200308.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x676) and Duel.IsExistingMatchingCard(c67200308.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetOriginalAttribute(),tp)
end
function c67200308.eqfilter(c,att,race,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x676) and c:IsType(TYPE_PENDULUM) and c:GetOriginalAttribute()~=att and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c67200308.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67200308.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67200308.filter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c67200308.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c67200308.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c67200308.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetOriginalAttribute(),tp)
		local sc=g:GetFirst()
		if not sc then return end
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetLabelObject(tc)
		e3:SetValue(c67200308.eqlimit)
		sc:RegisterEffect(e3)
	end
end
function c67200308.eqlimit(e,c)
	return c==e:GetLabelObject()
end

