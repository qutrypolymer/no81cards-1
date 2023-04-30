--真神使者 螭吻
local m=91020019
local cm=c91020019
function c91020019.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m*3)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_FLIP)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(cm.tg2)
	e2:SetCountLimit(1,m)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FLIP)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.flipop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m*2)
	e5:SetCondition(cm.condition)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(91020019,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return  c:IsSetCard(0x9d0) or  c:IsSetCard(0x9d1)
end
--e4
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(91020019,RESET_EVENT+RESETS_STANDARD,0,1)
end
--e1
function cm.tag(e,c)
return not (c:IsSetCard(0x9d0) or  c:IsSetCard(0x9d1))
end
function cm.val1(e,c)
return not (c:IsSetCard(0x9d0) or c:IsSetCard(0x9d1)) 
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return  Duel.GetCurrentChain()<1 and Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.tag)
	Duel.RegisterEffect(e1,tp)
	local c=e:GetHandler()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,c)
end
--e2
function cm.fit(c)
	return c:IsSetCard(0x9d0) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.fit,tp,LOCATION_DECK,0,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.fit,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if  g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local op=0
		local g1=g:GetFirst()
		local b1=g1:IsSummonable(true,nil) 
		local b2=g1:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		if b1 and b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		elseif b1 then 
			op=Duel.SelectOption(tp,aux.Stringid(m,1)) 
		elseif b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 
		end 
		if op==0 then 
			Duel.Summon(tp,g1,true,nil) 
		elseif op==1 then 
			Duel.SpecialSummon(g1,0,tp,tp,true,true,POS_FACEDOWN_DEFENSE)  
		end 
	  end   
end
--e5
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
 return c:IsFaceup() and c:GetFlagEffect(91020019)>0 and  not c:IsDisabled()
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local g1=g:RandomSelect(tp,1)
	Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
