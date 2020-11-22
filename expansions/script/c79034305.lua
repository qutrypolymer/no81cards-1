--雷吉艾斯
function c79034305.initial_effect(c)
	c:SetSPSummonOnce(79034305)   
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_STEP_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79034305)
	e1:SetCost(c79034305.spcost)
	e1:SetTarget(c79034305.sptg)
	e1:SetOperation(c79034305.spop)
	c:RegisterEffect(e1) 
	--to tand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCountLimit(1)
	e3:SetTarget(c79034305.thtg1)
	e3:SetOperation(c79034305.thop1)
	c:RegisterEffect(e3)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,013005)
	e2:SetCondition(c79034305.sccon)
	e2:SetTarget(c79034305.sctarg)
	e2:SetOperation(c79034305.scop)
	c:RegisterEffect(e2)  
end
function c79034305.counterfilter(c)
	Duel.AddCustomActivityCounter(79034305,ACTIVITY_SPSUMMON,c79034305.counterfilter)
end
function c79034305.counterfilter(c)
	return c:GetAttack()==2300 and c:GetDefense()==2800
end
function c79034305.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(79034305,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79034305.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79034305.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:GetAttack()==2300 and c:GetDefense()==2800)
end
function c79034305.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c79034305.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
end
function c79034305.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_MZONE)
end
function c79034305.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
function c79034305.sccon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c79034305.xfil(c)
	return c:IsAbleToDeck() and c:IsAttack(2300) and c:IsDefense(2800) and c:IsLevel(7) and c:IsType(TYPE_TUNER)
end
function c79034305.spfil(c,e,tp)
	return c:IsCode(79034306,79034307) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c79034305.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c79034305.xfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c79034305.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c79034305.xfil,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79034305.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
	local sc=Duel.SelectMatchingCard(tp,c79034305.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	sc:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	end
end









