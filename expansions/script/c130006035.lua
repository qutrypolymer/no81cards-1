--炼击帝-迦陵频伽
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local s,id = Scl.SetID(130006035, "LordOfChain")
function s.initial_effect(c)
	local e1 = Scl.CreateSingleBuffEffect(c, "Reveal", 1, "Hand")
	local e2 = Scl.CreateQuickMandatoryEffect(c, "ActivateEffect", nil, nil, nil, nil, "Hand,MonsterZone", nil, nil, s.mixtg, s.mixop)
	if not s.chain_id_scl then
		s.chain_id_scl = {}
	end
end
function s.get_count(zone)
	local ct = Duel.GetFieldGroupCount(0, zone, 0) - Duel.GetFieldGroupCount(0, 0, zone)
	return math.abs(ct)
end
function s.mixtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	local cct = Duel.GetCurrentChain()
	local b1 = (c:IsOnField() or c:IsPublic()) and c:GetFlagEffect(id) < s.get_count(LOCATION_HAND)
	local b2 = c:IsLocation(LOCATION_HAND) and c:GetFlagEffect(id + 100) == 0  and cct > 1
	if chk == 0 then return b1 or b2 end
	--local op = b1 and 1 or 2
	--if b1 and b2 then 
		--op = Scl.SelectOption(tp, true, "Damage", true, {id, 0})
	--end
	local op = b2 and 2 or 1
	if op == 1 then
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetCategory(CATEGORY_RECOVER)
		c:RegisterFlagEffect(id, RESET_CHAIN, 0, 1)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(100)
		Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 100)
	else
		e:SetProperty(0)
		c:RegisterFlagEffect(id + 100, RESET_CHAIN, 0, 1)
		local ctgy = 0
		if cct >= 3 then
			ctgy = ctgy + CATEGORY_SPECIAL_SUMMON + CATEGORY_HANDES 
		end
		if cct >= 5 then
			ctgy = ctgy + CATEGORY_SEARCH + CATEGORY_TOHAND 
		end
		if cct >= 9 then
			ctgy = ctgy + CATEGORY_DRAW 
		end
		e:SetCategory(ctgy)
	end
	s.chain_id_scl[cct] = op
end
function s.mixop(e,tp,eg,ep,ev,re,r,rp)
	local cct = Duel.GetCurrentChain()
	local op = s.chain_id_scl[cct]
	if op == 1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	else
		local c = e:GetHandler()
		if cct >= 3 then 
			if c:IsRelateToChain(0) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) > 0 then
				Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT,nil)
			end
		end
		if cct >= 5 then
			Scl.SelectAndOperateCards("Add2Hand",tp,s.thfilter,tp,"Deck",0,1,1,nil,e,tp)()
		end
		if cct >= 9 then
			local e1 = Scl.CreateFieldTriggerContinousEffect({c, tp}, "AfterEffectResolving", nil, nil, nil, nil, s.drcon, s.drop, RESET_EP_SCL)
		end
	end
end
function s.thfilter(c,e,tp)
	return c:IsAbleToHand() and Scl.IsSeries(c, "LordOfChain")
end
function s.drcon(e,tp,eg,ep,ev,re)
	return Scl.IsSeries(re:GetHandler(), "LordOfChain") 
end
function s.drop(e,tp)
	Scl.HintCard(id)
	if Duel.Draw(tp,1,REASON_EFFECT) > 0 then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT,nil)
	end
end