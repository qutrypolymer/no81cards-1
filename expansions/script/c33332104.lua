--澄炎龙 辉龙
function c33332104.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--sp and sy 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,33332104) 
	e1:SetTarget(c33332104.ssytg) 
	e1:SetOperation(c33332104.ssyop) 
	c:RegisterEffect(e1) 
	--to grave
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetCountLimit(1,13332104) 
	e2:SetCondition(c33332104.tgcon)
	e2:SetTarget(c33332104.tgtg)
	e2:SetOperation(c33332104.tgop)
	c:RegisterEffect(e2) 
	--to hand and des
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,23332104)
	e3:SetTarget(c33332104.thdtg) 
	e3:SetOperation(c33332104.thdop) 
	c:RegisterEffect(e3) 
end
function c33332104.syfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x6567) and c:IsType(TYPE_TUNER) 
end 
function c33332104.ssytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c33332104.syfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c33332104.syfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end 
function c33332104.espfil(c,e,tp,mg) 
	return c:IsSynchroSummonable(nil,mg)  
end 
function c33332104.ssyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then 
		local mg=Group.FromCards(c,tc) 
		if Duel.IsExistingMatchingCard(c33332104.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) and Duel.SelectYesNo(tp,aux.Stringid(33332104,0)) then 
			local sc=Duel.SelectMatchingCard(tp,c33332104.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst() 
			Duel.SynchroSummon(tp,sc,nil,mg)   
		end 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33332104.splimit)
	Duel.RegisterEffect(e1,tp) 
end
function c33332104.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c33332104.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end 
function c33332104.sthfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)  
end 
function c33332104.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c33332104.sthfil,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,c33332104.sthfil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
end
function c33332104.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT) 
	end 
end 
function c33332104.tsrfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x6567) and c:IsType(TYPE_TUNER) 
end 
function c33332104.thdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332104.tsrfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end 
function c33332104.thdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332104.tsrfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)  
		if c:IsRelateToEffect(e) then 
			Duel.BreakEffect() 
			Duel.Destroy(c,REASON_EFFECT)   
		end   
	end  
end 











