--无感动伊吕波
function c65130315.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(c65130315.peop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c65130315.splimit)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65130315,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c65130315.sptg)
	e3:SetOperation(c65130315.spop)
	c:RegisterEffect(e3)
end
function c65130315.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c65130315.peop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local op=0
	if c:GetLeftScale()==0 or c:GetRightScale()==0 then op=Duel.SelectOption(tp,aux.Stringid(65130315,0))
	else op=Duel.SelectOption(tp,aux.Stringid(65130315,0),aux.Stringid(65130315,1)) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	if op==0 then
		e1:SetValue(1)
	else 
		e1:SetValue(-1)
	end
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end
function c65130315.splimit(e,c)
	return not (c:IsAttack(878) and c:IsDefense(1157))
end
function c65130315.desfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER>0
end
function c65130315.spfilter(c,e,tp)
	return c:IsAttack(878) and c:IsDefense(1157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65130315.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c65130315.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65130315.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c65130315.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65130315.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local g=Duel.SelectMatchingCard(tp,c65130315.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			local sc=g:GetFirst()
			if not sc then return end
			if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				sc:RegisterFlagEffect(65130315,RESET_EVENT+RESETS_STANDARD,0,1)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetLabelObject(tc)
				e1:SetCondition(c65130315.descon)
				e1:SetOperation(c65130315.desop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c65130315.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(65130315)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c65130315.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end