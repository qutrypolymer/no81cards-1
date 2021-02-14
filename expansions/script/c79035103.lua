--后巴别塔·苏苏洛
function c79035103.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79035103)
	e1:SetTarget(c79035103.thtg)
	e1:SetOperation(c79035103.thop)
	c:RegisterEffect(e1)
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c79035103.rectg)
	e4:SetOperation(c79035103.recop)
	c:RegisterEffect(e4)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_RECOVER)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,214015)
	e4:SetTarget(c79035103.sptg1)
	e4:SetOperation(c79035103.spop1)
	c:RegisterEffect(e4)
end
function c79035103.thfil(c)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79035103.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79035103.thfil,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function c79035103.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g1=Duel.GetMatchingGroup(c79035103.thfil,tp,LOCATION_DECK,0,1,nil)
	if Duel.Destroy(g,REASON_EFFECT) and g1:GetCount()>0 then
	local tg=g1:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 then
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT) 
	end
	end
end
function c79035103.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c79035103.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c79035103.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ep==tp end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c79035103.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end









