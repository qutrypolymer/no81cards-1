SNNM=SNNM or {}
local cm=SNNM
--53702700 alleffectreset
function cm.AllGlobalCheck(c)
	if not cm.snnm_global_check then
		cm.snnm_global_check=true
		local x=c:GetOriginalCodeRule()
		if c.main_peacecho then
			local alle1=Effect.CreateEffect(c)
			alle1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle1:SetCode(EFFECT_SEND_REPLACE)
			alle1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			alle1:SetTarget(cm.PeacechoToDeckTarget1)
			alle1:SetValue(function(e,c) return false end)
			--Duel.RegisterEffect(alle1,0)
			local alle2=Effect.CreateEffect(c)
			alle2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle2:SetCode(EFFECT_SEND_REPLACE)
			alle2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			alle2:SetTarget(cm.PeacechoToDeckTarget2)
			alle2:SetValue(function(e,c) return c:GetFlagEffect(53707099)>0 end)
			--Duel.RegisterEffect(alle2,0)
			cm[0]=Duel.GetDecktopGroup
			Duel.GetDecktopGroup=function(tp,ct)
				Duel.RegisterFlagEffect(tp,53707000,RESET_CHAIN,0,0)
				return cm[0](tp,ct)
			end
			cm[1]=Duel.DiscardDeck
			Duel.DiscardDeck=function(tp,ct,reason)
				local g=Duel.GetDecktopGroup(tp,ct)
				Duel.DisableShuffleCheck()
				Duel.SendtoGrave(g,reason)
			end
			cm[2]=Card.RemoveOverlayCard
			Card.RemoveOverlayCard=function(card,player,min,max,reason)
				local g=card:GetOverlayGroup()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
				g=g:Select(player,min,max,reason)
				Duel.SendtoGrave(g,reason)
				local ct=Duel.GetOperatedGroup():GetCount()
				--if ct>0 then return 1 else return 0 end
				return ct
			end
			cm[3]=Duel.RemoveOverlayCard
			Duel.RemoveOverlayCard=function(player,ints,into,min,max,reason)
				if ints==1 then ints=LOCATION_ONFIELD end
				if into==1 then into=LOCATION_ONFIELD end
				local g=Duel.GetMatchingGroup(function(c)return c:CheckRemoveOverlayCard(player,min,reason)end,player,ints,into,nil)
				local sg=Group.CreateGroup()
				for tc in aux.Next(g) do sg:Merge(tc:GetOverlayGroup()) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
				sg=sg:Select(player,min,max,reason)
				Duel.SendtoGrave(sg,reason)
				local ct=Duel.GetOperatedGroup():GetCount()
				--if ct>0 then return 1 else return 0 end
				return ct
			end
			cm[4]=Duel.SendtoGrave
			Duel.SendtoGrave=function(target,reason)
				if reason&REASON_RULE==0 then
					local tg=Group.__add(target,target)
					local g=tg:Filter(function(c)return c:IsLocation(LOCATION_OVERLAY) and c.main_peacecho and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and c:IsAbleToDeck()end,nil)
					for tc in aux.Next(g) do
						Duel.Hint(HINT_CARD,0,tc:GetOriginalCodeRule())
						Duel.SendtoDeck(tc,nil,1,reason)
						tc:ReverseInDeck()
					end
					return cm[4](Group.__sub(tg,g),reason)
				else return cm[4](target,reason) end
			end
			--cm[2]=Card.ReverseInDeck
			--Card.ReverseInDeck=function(card)
				--card:RegisterFlagEffect(53707050,RESET_EVENT+0x53c0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53702500,2))
				--return cm[2](card)
			--end
		end
		if c.alc_yaku then
			local alle3=Effect.CreateEffect(c)
			alle3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle3:SetCode(EVENT_SSET)
			alle3:SetOperation(cm.ALCYakuCheck)
			Duel.RegisterEffect(alle3,0)
		end
		if c.organic_saucer then
			local alle4=Effect.CreateEffect(c)
			alle4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle4:SetCode(EVENT_SPSUMMON_SUCCESS)
			alle4:SetOperation(cm.OSCheck)
			Duel.RegisterEffect(alle4,0)
		end
		if c.cybern_numc then
			local alle6=Effect.CreateEffect(c)
			alle6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle6:SetCode(EVENT_CHAINING)
			alle6:SetOperation(cm.CyberNSwitch)
			Duel.RegisterEffect(alle6,0)
		end
	end
end
function cm.UpRegi(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,53707080)>0 then return end
	Duel.RegisterFlagEffect(tp,53707080,0,0,0)
	if not Duel.SelectYesNo(tp,aux.Stringid(53702500,6)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.UpCheck)
	Duel.RegisterEffect(e1,tp)
end
function cm.UpCheck(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_DECK,0,nil)
	if #g>0 then Duel.ConfirmCards(tp,g) else Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702500,7)) end
end
function cm.UpConfirm()
	local UCg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_DECK,0,nil)
	if #UCg>0 then Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(53702500,2)) end
	if #UCg==1 then UCg:Select(tp,1,1,nil) elseif #UCg>1 then Duel.ConfirmCards(tp,UCg) end
end
function cm.Peacecho(c,typ)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0xff)
	e1:SetTarget(cm.RePeacechotg1)
	e1:SetOperation(cm.RePeacechoop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTarget(cm.RePeacechotg2)
	c:RegisterEffect(e2)
	if typ==TYPE_MONSTER then
		local e4=Effect.CreateEffect(c)
		e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e4:SetCode(EVENT_DRAW)
		e4:SetTarget(cm.PeacechoDrawTarget)
		e4:SetOperation(cm.PeacechoDrawOperation)
		c:RegisterEffect(e4)
	end
	if typ==TYPE_CONTINUOUS then
		local e5=Effect.CreateEffect(c)
		e5:SetCategory(CATEGORY_DRAW)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e5:SetCode(EVENT_DRAW)
		e5:SetTarget(cm.PeacechoDrawTarget2)
		e5:SetOperation(cm.PeacechoDrawOperation2)
		c:RegisterEffect(e5)
	end
	if typ==TYPE_FIELD then
		local e6=Effect.CreateEffect(c)
		e6:SetCategory(CATEGORY_DRAW)
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e6:SetCode(EVENT_DRAW)
		e6:SetTarget(cm.PeacechoDrawTarget3)
		e6:SetOperation(cm.PeacechoDrawOperation3)
		c:RegisterEffect(e6)
	end
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e9:SetRange(LOCATION_HAND+LOCATION_DECK)
	e9:SetOperation(cm.UpRegi)
	c:RegisterEffect(e9)
end
function cm.RePeacechotg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsLocation(LOCATION_DECK) and c:GetDestination()==LOCATION_GRAVE and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and c:IsAbleToDeck() end
	return true
end
function cm.RePeacechotg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_DECK) and c:GetDestination()==LOCATION_GRAVE and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence):GetFirst()~=c end
	return true
end
function cm.RePeacechoop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsFacedown() then Duel.ConfirmCards(1-tp,c) end
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	if c:IsLocation(LOCATION_DECK) then
		if Duel.GetFlagEffect(tp,53707000)==0 then Duel.ShuffleDeck(tp) end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetOperation(cm.RePeacechorst)
		e3:SetLabelObject(e)
		Duel.RegisterEffect(e3,tp)
		Duel.MoveSequence(c,1)
	else Duel.SendtoDeck(c,nil,1,REASON_RULE) end
	c:ReverseInDeck()
end
function cm.RePeacechorst(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.ResetFlagEffect(tp,53707000)
	e:Reset()
end
function cm.PeacechoRepFilter(c)
	return c:GetDestination()==LOCATION_GRAVE and c:IsOriginalSetCard(0x3537) and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and c:GetOriginalType()&TYPE_PENDULUM+TYPE_LINK==0 and c:IsAbleToDeck()
end
function cm.PeacechoToDeckTarget1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local p=c:GetControler()
	if chk==0 then return not eg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) and eg:IsExists(cm.PeacechoRepFilter,1,nil) end
	local g=eg:Filter(cm.PeacechoRepFilter,nil)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-p,cg) end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_DECKBOT)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(53707000,RESET_CHAIN,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_DECK)
		e2:SetCondition(cm.PeacechoTDCondition)
		e2:SetOperation(cm.PeacechoTDOperation)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,p)
	end
	return true
end
function cm.PeacechoRepFilter2(c,tp)
	return c:GetDestination()==LOCATION_GRAVE and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence):GetFirst()~=c
end
function cm.PeacechoRepFilter3(c,tp)
	return cm.PeacechoRepFilter2(c,tp) and c:IsOriginalSetCard(0x3537)
end
function cm.PeacechoToDeckTarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local p=c:GetControler()
	if chk==0 then return eg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) and eg:IsExists(cm.PeacechoRepFilter3,1,nil,p) end
	local bg=eg:Filter(cm.PeacechoRepFilter2,nil,p)
	local g=bg:Filter(Card.IsOriginalSetCard,nil,0x3537)
	Duel.ConfirmCards(1-p,g)
	if Duel.GetFlagEffect(p,53707000)==0 and #bg==#g then Duel.ShuffleDeck(p) end
	for tc in aux.Next(g) do
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		tc:RegisterFlagEffect(53707099,RESET_CHAIN,0,1)
		Duel.MoveSequence(tc,1)
		tc:ReverseInDeck()
	end
	Duel.ResetFlagEffect(p,53707000)
	return true
end
function cm.PeacechoTDFilter(c)
	return c:GetFlagEffect(53707000)~=0
end
function cm.PeacechoTDCondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.PeacechoTDFilter,1,nil)
end
function cm.PeacechoTDOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.PeacechoTDFilter,nil)
	for tc in aux.Next(g) do
		tc:ReverseInDeck()
		tc:ResetFlagEffect(53707000)
	end
	e:Reset()
	e:GetLabelObject():Reset()
end
function cm.PeacechoDrawTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousPosition(POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.PeacechoDrawOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then Duel.Draw(tp,1,REASON_EFFECT) end
end
function cm.PeacechoDrawTarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousPosition(POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsPlayerCanDraw(tp,1) and not e:GetHandler():IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.PeacechoDrawOperation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
end
function cm.PeacechoDrawTarget3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousPosition(POS_FACEUP) and Duel.IsPlayerCanDraw(tp,1) and not e:GetHandler():IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.PeacechoDrawOperation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	if Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then
		local te=c:GetActivateEffect()
		local tep=c:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(c,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--
function cm.Faceupdeckcheck(g,tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_DECK,0,nil)
	if #g>1 then
		Debug.Message("请先确认卡组表面向上的卡的位置")
		Duel.ConfirmCards(tp,g)
	elseif #g>0 then
		Debug.Message("卡组表面向上的卡的位置序号是："..(g:GetFirst():GetSequence()+1).."")
	end
end
--
function cm.FanippetTrap(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCost(cm.GraveActCostchk)
	e4:SetTarget(cm.GraveActCostTarget)
	e4:SetOperation(cm.GraveActCostOp)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_RELEASE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCondition(cm.FanippetTrapTGCondition)
	e5:SetTarget(cm.FanippetTrapTGTarget)
	e5:SetOperation(cm.FanippetTrapTGOperation)
	c:RegisterEffect(e5)
end
function cm.FanippetTrapTGCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.FanippetTrapTGTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function cm.FanippetTrapTGOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end
function cm.GraveActCostchk(e,te,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.GraveActCostTarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.GraveActCostOp(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
end
function cm.FanippetTrapSPCondition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp or ep==1-tp or re:GetHandler():IsCode(53716006)
end
function cm.FanippetTrapSPCost(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return Duel.GetFlagEffect(tp,code)==0 and not c:IsLocation(LOCATION_ONFIELD) end
		Duel.RegisterFlagEffect(tp,code,RESET_CHAIN,0,1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVING)
		e3:SetOperation(cm.Fanippetready)
		e3:SetLabelObject(e)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.Fanippetready(e,tp)
	e:GetLabelObject():GetHandler():SetStatus(STATUS_EFFECT_ENABLED,true)
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.FanippetTrapSPTarget(code,dt)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsLocation(LOCATION_HAND) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x353b,TYPES_NORMAL_TRAP_MONSTER,table.unpack(dt))) end
		if not c:IsPreviousLocation(LOCATION_HAND) then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		else e:SetCategory(0) end
		e:SetLabel(c:GetPreviousLocation())
	end
end
function cm.FanippetTrapSPOperation(lpc,code,dt)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or e:GetLabel()==LOCATION_HAND then return end
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x353b,TYPES_NORMAL_TRAP_MONSTER,table.unpack(dt)) then
			c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
			if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
				Duel.SetLP(tp,Duel.GetLP(tp)-lpc)
				if e:GetLabel()==LOCATION_GRAVE then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(53702500,5))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
					e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
					e1:SetValue(LOCATION_REMOVED)
					c:RegisterEffect(e1,true)
				end
			end
		end
	end
end
--
function cm.ALCYakuNew(c,code,cf,loc,t)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetTarget(cm.NALCTtg(code,loc,t))
	e1:SetOperation(cm.NALCTac(code,cf,t))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(0x7f)
	e2:SetOperation(cm.ALCReload)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(cm.ALCYakuActCondition)
	c:RegisterEffect(e3)
end
function cm.ALCReload(e,tp)
	aux.AddFusionProcCode2=_tmp
	aux.AddFusionProcCode2FunRep=_tmp_1
	aux.AddFusionProcCode3=_tmp_2
	aux.AddFusionProcCode4=_tmp_3
	aux.AddFusionProcCodeFun=_tmp_4
	aux.AddFusionProcCodeFunRep=_tmp_5
	aux.AddFusionProcCodeRep=_tmp_6
	aux.AddFusionProcCodeRep2=_tmp_7
	aux.AddFusionProcFun2=_tmp_8
	aux.AddFusionProcFunFun=_tmp_9
	aux.AddFusionProcFunFunRep=_tmp_0
	aux.AddFusionProcFunRep=_tmp_1_0
	aux.AddFusionProcFunRep2=_tmp_1_1
	aux.AddFusionProcMix=_tmp_1_2
	aux.AddFusionProcMixRep=_tmp_1_3
	aux.AddFusionProcShaddoll=_tmp_1_4
end
_tmp=aux.AddFusionProcCode2
_tmp_1=aux.AddFusionProcCode2FunRep
_tmp_2=aux.AddFusionProcCode3
_tmp_3=aux.AddFusionProcCode4
_tmp_4=aux.AddFusionProcCodeFun
_tmp_5=aux.AddFusionProcCodeFunRep
_tmp_6=aux.AddFusionProcCodeRep
_tmp_7=aux.AddFusionProcCodeRep2
_tmp_8=aux.AddFusionProcFun2
_tmp_9=aux.AddFusionProcFunFun
_tmp_0=aux.AddFusionProcFunFunRep
_tmp_1_0=aux.AddFusionProcFunRep
_tmp_1_1=aux.AddFusionProcFunRep2
_tmp_1_2=aux.AddFusionProcMix
_tmp_1_3=aux.AddFusionProcMixRep
_tmp_1_4=aux.AddFusionProcShaddoll
function aux.AddFusionProcCode2(c,code1,code2,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2
	end
	return _tmp(c,code1,code2,sub,insf)
end
function aux.AddFusionProcCode2FunRep(c,code1,code2,f,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2+min
	end
	return _tmp_1(c,code1,code2,f,min,max,sub,insf)
end
function aux.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=3
	end
	return _tmp_2(c,code1,code2,code3,sub,insf)
end
function aux.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=4
	end
	return _tmp_3(c,code1,code2,code3,code4,sub,insf)
end
function aux.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=1+cc
	end
	return _tmp_4(c,code1,f,cc,sub,insf)
end
function aux.AddFusionProcCodeFunRep(c,code1,f,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min+1
	end
	return _tmp_5(c,code1,f,min,max,sub,insf)
end
function aux.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=cc
	end
	return _tmp_6(c,code1,cc,sub,insf)
end
function aux.AddFusionProcCodeRep2(c,code1,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min
	end
	return _tmp_7(c,code1,min,max,sub,insf)
end
function aux.AddFusionProcFun2(c,f,f1,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2
	end
	return _tmp_8(c,f,f1,insf)
end
function aux.AddFusionProcFunFun(c,f1,f2,cc,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=cc+1
	end
	return _tmp_9(c,f1,f2,cc,sub,insf)
end
function aux.AddFusionProcFunFunRep(c,f1,f2,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min+1
	end
	return _tmp_0(c,f1,f2,min,max,sub,insf)
end
function aux.AddFusionProcFunRep2(c,f,min,max,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min
	end
	return _tmp_1_1(c,f,min,max,insf)
end
function aux.AddFusionProcFunRep(c,f,cc,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=cc
	end
	return _tmp_1_0(c,f,cc,insf)
end
function aux.AddFusionProcMix(c,sub,insf,...)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	local val={...}
	local sum=#val 
	if not c.fst then
		ccodem.fst=sum
	end
	return _tmp_1_2(c,sub,insf,...)
end
function aux.AddFusionProcMixRep(c,sub,insf,f1,min,max,...)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min
	end
	return _tmp_1_3(c,sub,insf,f1,min,max,...)
end
function aux.AddFusionProcShaddoll(c,att)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2
	end
	return _tmp_1_4(c,att)
end
function cm.NALCTtg(code,loc,t)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x1535,TYPES_NORMAL_TRAP_MONSTER,table.unpack(t)) and Duel.GetFieldGroupCount(tp,0,loc)>0 end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function cm.NALCTac(code,cf,t)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x1535,TYPES_NORMAL_TRAP_MONSTER,table.unpack(t)) then return end
		local g=cf(c,tp)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53702600,2))
		local conc=g:Select(tp,1,1,nil):GetFirst()
		if conc:IsFacedown() then Duel.ConfirmCards(tp,conc) end
		Duel.HintSelection(Group.FromCards(conc))
		if conc:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
		if conc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(1-tp) end
		local cd=conc:GetCode()
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
		if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(cd)
			e1:SetReset(RESET_EVENT+0x7e0000)
			c:RegisterEffect(e1)
			local chkf=tp
			local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
			local mtf=function(c,e,tp)return bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and not c:IsImmuneToEffect(e)end
			local fuf=function(c,e,tp,m,f,chkf,ft)
						  return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and (not c.fst or ft>=c.fst)
					  end
			local zck=function(g,c,chkf,ft)return c:CheckFusionMaterial(g,nil,chkf) and ft>=#g end
			local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil):Filter(mtf,nil,e,tp)
			if #mg1==0 then return end
			local sg1=Duel.GetMatchingGroup(fuf,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,ft)
			local mg2=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(fuf,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf,114)
			end
			if (#sg1>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(code,0)) then
				Duel.BreakEffect()
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tc=tg:GetFirst()
				if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
					if tc.fst then
						Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53702600,3))
						local mat1=mg1:SelectSubGroup(tp,zck,false,tc.fst,#mg1,tc,chkf,ft)
						--local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
						tc:SetMaterial(mat1)
						for mvc in aux.Next(mat1) do Duel.MoveToField(mvc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
					end
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				else
					local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
					local fop=ce:GetOperation()
					fop(ce,e,tp,tc,mat2)
				end
				tc:CompleteProcedure()
			end
		end
	end
end
function cm.ALCYaku(c,code,num,loc,atk,def,rac,att)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	if c:GetOriginalCode()~=53713007 then e1:SetCost(cm.ALCYakuActCost(code,num,loc)) else e1:SetCost(cm.ALCYakuActCost2) end
	e1:SetTarget(cm.ALCYakuActTarget(code,atk,def,rac,att))
	e1:SetOperation(cm.ALCYakuActivate(code,atk,def,rac,att))
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(cm.ALCYakuActCondition)
	c:RegisterEffect(e3)
end
function cm.ALCYakuCheck(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(53713000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.ALCYakuActCost(code,num,loc)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local ct=Duel.GetFieldGroupCount(tp,0,loc)
		if chk==0 then return ct>0 end
		local ac=1
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(code,1))
			ac=Duel.AnnounceLevel(tp,1,math.min(ct,num))
		end
		local g=Duel.GetFieldGroup(1-tp,loc,0):RandomSelect(tp,ac)
		Duel.ConfirmCards(tp,g)
		if loc==LOCATION_HAND then Duel.ShuffleHand(1-tp) end
		if loc==LOCATION_DECK then Duel.ShuffleDeck(1-tp) end
		local list={}
		for tc in aux.Next(g) do
			table.insert(list,tc:GetCode())
		end
		e:SetLabel(table.unpack(list))
	end
end
function cm.ALCYakuActCost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)>0 end
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if #g1<1 or (#g2>0 and Duel.SelectYesNo(tp,aux.Stringid(53713007,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
		local cg=g2:Select(tp,1,1,nil)
		g1:Merge(cg)
	end
	Duel.ConfirmCards(tp,g1)
	local list={}
	for tc in aux.Next(g1) do
		table.insert(list,tc:GetCode())
	end
	e:SetLabel(table.unpack(list))
end
function cm.ALCYakuActTarget(code,atk,def,rac,att)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
			Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x1535,TYPES_NORMAL_TRAP_MONSTER,atk,def,4,rac,att) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function cm.ALCYakuFusionFilter1(c,e)
	return bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function cm.ALCYakuFusionFilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.ALCYakuActivate(code,atk,def,rac,att)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x1535,TYPES_NORMAL_TRAP_MONSTER,atk,def,4,rac,att) then return end
		local list={e:GetLabel()}
		local ct=1
		if #list>1 then
			Duel.Hint(24,tp,aux.Stringid(53702600,2))
			ct=Duel.AnnounceLevel(tp,1,#list)
		end
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
		if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(list[ct])
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE)
			c:RegisterEffect(e1)
			local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil):Filter(cm.ALCYakuFusionFilter1,nil,e)
			local sg1=Duel.GetMatchingGroup(cm.ALCYakuFusionFilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
			local mg2=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(cm.ALCYakuFusionFilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
			end
			if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(code,0)) then
				Duel.BreakEffect()
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tc=tg:GetFirst()
				if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
					local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
					tc:SetMaterial(mat1)
					Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				else
					local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
					local fop=ce:GetOperation()
					fop(ce,e,tp,tc,mat2)
				end
				tc:CompleteProcedure()
			end
		end
	end
end
function cm.ALCYakuActCondition(e)
	return e:GetHandler():GetFlagEffect(53713000)>0
end
--
function cm.ALCIppa(c,code,num)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xff)
	e0:SetCost(cm.ALCTFCost(num))
	e0:SetOperation(cm.ALCTFOperation(num))
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.ALCFusionCondition)
	e1:SetOperation(cm.ALCFusionOperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(code,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,code)
	e2:SetCondition(cm.ALCDisCondition)
	e2:SetTarget(cm.ALCDisTarget)
	e2:SetOperation(cm.ALCDisOperation(code))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(code,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetTarget(cm.ALCSetTarget)
	e3:SetOperation(cm.ALCSetOperation)
	c:RegisterEffect(e3)
end
function cm.ALCTFFilter(c)
	return bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.ALCFSelect(g,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())
end
function cm.ALCTFCost(num)
	return
	function(e,c,tp,st)
		if bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION then
			e:SetLabel(1)
			local cg=Duel.GetMatchingGroup(cm.ALCTFFilter,tp,LOCATION_MZONE,0,nil)
			return cg:CheckSubGroup(cm.ALCFSelect,num,num,e,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		else
			e:SetLabel(0)
			return true
		end
	end
end
function cm.ALCTFOperation(num)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetLabel()==0 then return true end
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(cm.ALCTFFilter,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local fg=g:SelectSubGroup(tp,cm.ALCFSelect,false,num,num,e,tp)
		Duel.HintSelection(fg)
		for tc in aux.Next(fg) do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function cm.ALCFusionCondition(e,g,gc,chkfnf)
	if g==nil then return true end
	if gc then return false end
	local c=e:GetHandler()
	local tp=c:GetControler()
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,Group.CreateGroup(),c) then return false end
	local chkf=(chkfnf & 0xff)
	return chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(chkf)>-1
end
function cm.ALCFusionOperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	Duel.SetFusionMaterial(Group.CreateGroup())
end
function cm.ALCDisCondition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.ALCRealSetFilter(c,code)
	return c:IsFaceup() and c:IsCode(code) and (c:IsSSetable(true) or c:IsCanTurnSet())
end
function cm.ALCDisTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ALCRealSetFilter,tp,LOCATION_ONFIELD,0,1,nil,eg:GetFirst():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.ALCDisOperation(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.ALCRealSetFilter,tp,LOCATION_ONFIELD,0,1,1,nil,eg:GetFirst():GetCode())
		if #g>0 then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			tc:CancelToGrave()
			Duel.ChangePosition(tc,POS_FACEDOWN)
			if tc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) end
			if code==53713002 then
				local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
				if Duel.NegateActivation(ev) and #g2>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg=g2:RandomSelect(tp,1)
					Duel.SendtoGrave(sg,REASON_EFFECT)
				end
			end
			if code==53713004 then
				local rg=Duel.GetDecktopGroup(1-tp,5)
				if Duel.NegateActivation(ev) and rg:FilterCount(Card.IsAbleToRemove,nil)==5 then
					Duel.DisableShuffleCheck()
					Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
				end
			end
			if code==53713008 then
				local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
				if Duel.NegateActivation(ev) and #rg>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil)
					Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
				end
			end
			if code==53713009 then
				local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
				if Duel.NegateActivation(ev) and #g2>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg=g2:Select(tp,1,1,nil)
					Duel.HintSelection(sg)
					Duel.SendtoGrave(sg,REASON_EFFECT)
				end
			end
		end
	end
end
function cm.ALCSetFilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsSSetable(true)
end
function cm.ALCSetTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ALCSetFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.ALCSetOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.ALCSetFilter,tp,LOCATION_ONFIELD,0,1,2,nil)
		if #g>0 then
			Duel.HintSelection(g)
			for tc in aux.Next(g) do
				tc:CancelToGrave()
				Duel.ChangePosition(tc,POS_FACEDOWN)
				Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			end
		end
	end
end
--
function cm.HTFSynchoro(c,lab,code)
	if lab==0 then aux.EnablePendulumAttribute(c,false) end
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.HTFsyncon(lab,code))
	e0:SetTarget(cm.HTFsyntg(lab,code))
	e0:SetOperation(cm.HTFsynop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	if lab>4 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(code,2))
		e2:SetCategory(CATEGORY_TODECK)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_GRAVE)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetCondition(aux.exccon)
		e2:SetTarget(cm.HTFTDTarget(lab))
		e2:SetOperation(cm.HTFTDOperation)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetCondition(cm.HTFSynMatCondition)
		e3:SetOperation(cm.HTFSynMatOperation(code))
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_MATERIAL_CHECK)
		e4:SetValue(cm.HTFvalcheck(lab))
		e4:SetLabelObject(e3)
		c:RegisterEffect(e4)
	end
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_MATERIAL_CHECK)
	e9:SetValue(cm.DoubleTunerCheck)
	c:RegisterEffect(e9)
end
function cm.DoubleTunerCheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,2,nil,TYPE_TUNER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(21142671)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function cm.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function cm.HTFval(c,syncard,lab)
	local slv=c:GetSynchroLevel(syncard)
	if lab>4 and c:IsSynchroType(TYPE_PENDULUM) and c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_EFFECT) then
		slv=1
	end
	return slv
end
function cm.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	while ct<max and not (ct>=min and f(sg,...) and not (g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params) and Duel.SelectYesNo(tp,210))) do
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=g:FilterSelect(tp,cm.CheckGroupRecursive,1,1,sg,sg,g,f,min,max,ext_params)
		if tg:GetCount()==0 then error("Incorrect Group Filter",2) end
		sg:Merge(tg)
		ct=sg:GetCount()
	end
	return sg
end
function cm.HTFmatfilter1(c,syncard,tp,lab)
	if c:IsFacedown() or (lab>4 and not c:IsSynchroType(TYPE_SYNCHRO)) then return false end
	if not c:IsType(TYPE_EFFECT) and c:IsSynchroType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_TUNER) then return true end 
	return c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
		and (not c:IsType(TYPE_EFFECT) or not (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function cm.HTFmatfilter2(c,syncard)
	if not c:IsType(TYPE_EFFECT) and c:IsSynchroType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() then return true end
	return c:IsSynchroType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
		and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and (not c:IsType(TYPE_EFFECT) or not (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function cm.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp,lab)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return cm.CheckGroup(tsg,cm.HTFgoal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c,lab)
end
function cm.HTFgoal(g,tp,lv,syncard,tuc,lab)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(cm.HTFval,lv,ct,ct,syncard,lab)
end
function cm.HTFsyncon(lab,code)
	return
	function(e,c,tuner,mg)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local minc=2
		local maxc=c:GetLevel()
		local g1=nil
		local g2=nil
		local g3=nil
		if mg then
			g1=mg:Filter(cm.HTFmatfilter1,nil,c,tp,lab)
			g2=mg:Filter(cm.HTFmatfilter2,nil,c)
			g3=g2:Clone()
		else
			if Duel.GetFlagEffect(tp,code)==0 then
				g1=Duel.GetMatchingGroup(cm.HTFmatfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,LOCATION_MZONE,nil,c,tp,lab)
				g2=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE+LOCATION_EXTRA,LOCATION_MZONE,nil,c)
			else
				g1=Duel.GetMatchingGroup(cm.HTFmatfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp,lab)
				g2=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
			end
			g3=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		end
		local lv=c:GetLevel()
		local sg=nil
		if tuner then
			return cm.HTFmatfilter1(c,tp,lab) and cm.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp,lab)
		else
			return g1:IsExists(cm.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp,lab)
		end
	end
end
function cm.HTFsyntg(lab,code)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
		local minc=2
		local maxc=c:GetLevel()
		local g1=nil
		local g2=nil
		local g3=nil
		if mg then
			g1=mg:Filter(cm.HTFmatfilter1,nil,c,tp,lab)
			g2=mg:Filter(cm.HTFmatfilter2,nil,c)
			g3=g2:Clone()
		else
			if Duel.GetFlagEffect(tp,code)==0 then
				g1=Duel.GetMatchingGroup(cm.HTFmatfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,LOCATION_MZONE,nil,c,tp,lab)
				g2=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE+LOCATION_EXTRA,LOCATION_MZONE,nil,c)
			else
				g1=Duel.GetMatchingGroup(cm.HTFmatfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp,lab)
				g2=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
			end
			g3=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		end
		local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
		local lv=c:GetLevel()
		local tuc=nil
		if tuner then
			tuner=tuc
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			if not pe then
				local t1=g1:FilterSelect(tp,cm.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp,lab)
				tuc=t1:GetFirst()
			else
				tuc=pe:GetOwner()
				Group.FromCards(tuc):Select(tp,1,1,nil)
			end
		end
		tuc:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,1)
		local tsg=tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
		local f=tuc.tuner_filter
		if tuc.tuner_filter then tsg=tsg:Filter(f,nil) end
		local g=cm.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,cm.HTFgoal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc,lab)
		if g then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		else return false end
	end
end
function cm.HTFsynop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then Duel.RegisterFlagEffect(tp,c:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1) end
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function cm.HTFSynMatCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function cm.HTFSynMatOperation(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,0))
	end
end
function cm.HTFvalcheck(lab)
	return
	function(e,c)
		if c:GetMaterialCount()==lab then e:GetLabelObject():SetLabel(1) else e:GetLabelObject():SetLabel(0) end
	end
end
function cm.HTFTDFilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and c:IsAbleToDeck()
end
function cm.HTFTDTarget(lab)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
		if chk==0 then return e:GetHandler():IsAbleToExtra()
			and Duel.IsExistingTarget(cm.HTFTDFilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,cm.HTFTDFilter,tp,LOCATION_GRAVE,0,1,lab,e:GetHandler())
		g:AddCard(e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	end
end
function cm.HTFTDOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) and #g>0 then
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--
function cm.HTFPlacePZone(c,lv,loc,lab,event,code,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.HTFPlaceCondition(lv,loc,lab))
	e1:SetOperation(cm.HTFPlaceOperation(lv,loc,lab,code))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.HTFPlaceFilter(c,lv,lab)
	return c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(lv) and not c:IsType(TYPE_EFFECT) and not c:IsForbidden() and (c:IsFaceup() or lab==0)
end
function cm.HTFPlaceCondition(lv,loc,lab)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(cm.HTFPlaceFilter,tp,loc,0,1,nil,lv,lab) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	end
end
function cm.HTFPlaceOperation(lv,loc,lab,code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,code)
		if lab==0 or Duel.SelectYesNo(tp,aux.Stringid(code,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tc=Duel.SelectMatchingCard(tp,cm.HTFPlaceFilter,tp,loc,0,1,1,nil,lv,lab):GetFirst()
			if tc then Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
		end
	end
end
function cm.OrganicSaucer(c,lab,code)
	aux.EnablePendulumAttribute(c)
	if lab<4 then
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(code,0))
		e0:SetCategory(CATEGORY_TOGRAVE)
		e0:SetRange(LOCATION_PZONE)
		e0:SetCountLimit(1)
		e0:SetType(EFFECT_TYPE_QUICK_O)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+0x11e0)
		e0:SetCondition(cm.OSDiskCondition)
		e0:SetTarget(cm.OSDiskTarget1)
		e0:SetOperation(cm.OSDiskActivate1)
		c:RegisterEffect(e0)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(code,1))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_HAND)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetCondition(cm.OSKaijuCondition1)
		e2:SetTarget(cm.OSKaijuTarget(lab))
		e2:SetOperation(cm.OSKaijuOperation(lab))
		c:RegisterEffect(e2)
	else
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(code,0))
		e0:SetCategory(CATEGORY_DECKDES)
		e0:SetRange(LOCATION_PZONE)
		e0:SetCountLimit(1)
		e0:SetType(EFFECT_TYPE_QUICK_O)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+0x11e0)
		e0:SetCondition(cm.OSDiskCondition)
		e0:SetTarget(cm.OSDiskTarget2)
		e0:SetOperation(cm.OSDiskActivate2)
		c:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(code,1))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(cm.OSKaijuCondition2)
		e1:SetCost(cm.OSKaijuCost)
		e1:SetTarget(cm.OSKaijuTarget(lab))
		e1:SetOperation(cm.OSKaijuOperation(lab))
		c:RegisterEffect(e1)
	end
end
function cm.OSCheck(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local p=tc:GetSummonPlayer()
		local rac=Duel.GetFlagEffectLabel(p,53703000)
		Duel.ResetFlagEffect(p,53703000)
		local race=nil
		if rac==nil then race=tc:GetRace() else race=rac|tc:GetRace() end
		Duel.RegisterFlagEffect(p,53703000,RESET_PHASE+PHASE_END,0,1,race)
	end
end
function cm.OSDiskCondition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetCurrentChain()==0
end
function cm.OSDiskTarget1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>1 and Duel.GetDecktopGroup(tp,2):IsExists(Card.IsAbleToGrave,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function cm.OSDiskActivate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<2 then return end
	Duel.ConfirmDecktop(1-tp,2)
	local g=Duel.GetDecktopGroup(1-tp,2)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
		if #sg>0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(sg,REASON_EFFECT)
			g:Sub(sg)
			Duel.MoveSequence(g:GetFirst(),1)
		else
			for i=1,2 do
				local mg=Duel.GetDecktopGroup(1-tp,1)
				Duel.MoveSequence(mg:GetFirst(),1)
			end
		end
	end
end
function cm.OSCostfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function cm.OSKaijuCondition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.OSCostfilter,1,nil)
end
function cm.OSKaijuSPfilter(c,e,tp)
	return c:IsSetCard(0x3533) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.OSKaijuMfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function cm.OSKaijuTarget(lab)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(cm.OSKaijuSPfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
		if lab<4 and eg:IsExists(cm.OSKaijuMfilter,1,nil) then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
			Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
			if lab==1 and Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) then
				e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_DESTROY)
				local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
				Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
			end
			if lab==2 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) then
				e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_REMOVE)
				local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
				Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
			end
			if lab==3 and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) then
				e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_DESTROY)
				local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
				Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
			end
		end
	end
end
function cm.OSKaijuOperation(lab)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and lab<4 and c:IsRelateToEffect(e) and eg:IsExists(cm.OSKaijuMfilter,1,nil) then
			Duel.BreakEffect()
			Duel.SendtoExtraP(c,tp,REASON_EFFECT)
			if c:IsLocation(LOCATION_EXTRA) and lab==1 and Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=Duel.SelectMatchingCard(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,1,nil)
				if sg:GetCount()>0 then
					Duel.HintSelection(sg)
					Duel.Destroy(sg,REASON_EFFECT)
				end
			end
			if c:IsLocation(LOCATION_EXTRA) and lab==2 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
				if sg:GetCount()>0 then
					Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
				end
			end
			if c:IsLocation(LOCATION_EXTRA) and lab==3 and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
				if sg:GetCount()>0 then
					Duel.HintSelection(sg)
					Duel.Destroy(sg,REASON_EFFECT)
				end
			end
		end
	end
end
function cm.OSDiskTarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function cm.OSDiskActivate2(e,tp,eg,ep,ev,re,r,rp)
	local ct={}
	for i=3,1,-1 do
		if Duel.IsPlayerCanDiscardDeck(1-tp,i) then
			table.insert(ct,i)
		end
	end
	if #ct==1 then
		Duel.DiscardDeck(1-tp,ct[1],REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(e:GetHandler():GetOriginalCode(),4))
		local ac=Duel.AnnounceNumber(1-tp,table.unpack(ct))
		Duel.DiscardDeck(1-tp,ac,REASON_EFFECT)
	end
end
function cm.OSKaijuCondition2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.OSKaijuCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function cm.OSReturnFilter(c,tp)
	local rac=Duel.GetFlagEffectLabel(tp,53703000)
	local b1=nil
	if rac==nil then b1=0 else b1=rac&(c:GetRace())==0 end
	return c:IsSetCard(0x3533) and c:IsType(TYPE_PENDULUM) and b1 and not c:IsForbidden()
end
function cm.OSReturnTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.OSReturnOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToHand() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(cm.OSReturnFilter,tp,LOCATION_DECK,0,1,nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.OSReturnFilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
--
function cm.SorisonFish(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetTarget(cm.Sorisonsyntg)
	e0:SetValue(1)
	e0:SetOperation(cm.Sorisonsynop)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(EFFECT_HAND_SYNCHRO)
	e01:SetTarget(cm.Sorisonhsyntg)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e02:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e02:SetRange(LOCATION_HAND)
	e02:SetTargetRange(LOCATION_MZONE,0)
	--e02:SetCondition(cm.SorisonhsCondition)
	e02:SetTarget(cm.SorisonhsTarget)
	e02:SetLabelObject(e0)
	c:RegisterEffect(e02)
	local e03=e02:Clone()
	e03:SetLabelObject(e01)
	c:RegisterEffect(e03)
	--local e04=Effect.CreateEffect(c)
	--e04:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e04:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	--e04:SetCode(EVENT_ADJUST)
	--e04:SetRange(LOCATION_HAND)
	--e04:SetOperation(cm.SorisonAntiRepeat)
	--c:RegisterEffect(e04)
end
function cm.Sorisonsynfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function cm.Sorisonsynfilter2(c,syncard,tuner,f)
	return c:IsOriginalSetCard(0xa531) and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function cm.Sorisonsyncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=cm.Sorisonsyngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(cm.Sorisonsyncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function cm.Sorisonsyngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
end
function cm.Sorisonsyntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(cm.Sorisonsynfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsRace(RACE_AQUA) then
		local exg=Duel.GetMatchingGroup(cm.Sorisonsynfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		mg:Merge(exg)
	end
	return mg:IsExists(cm.Sorisonsyncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function cm.Sorisonsynop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(cm.Sorisonsynfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsRace(RACE_AQUA) then
		local exg=Duel.GetMatchingGroup(cm.Sorisonsynfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		mg:Merge(exg)
	end
	for i=1,maxc do
		local cg=mg:Filter(cm.Sorisonsyncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if cm.Sorisonsyngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #hg>0 then
		for tc in aux.Next(hg) do
			Duel.ConfirmCards(1-tp,tc)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetValue(LOCATION_DECK)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1,true)
		end
	end
	Duel.SetSynchroMaterial(g)
end
function cm.Sorisonhsyntg(e,c)
	return c:IsOriginalSetCard(0xa531) and c:IsNotTuner(syncard)
end
function cm.SorisonhsCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(53721049)>0
end
function cm.SorisonhsTarget(e,c)
	return c:IsType(TYPE_TUNER)
end
function cm.SorisonAntiRepeatf(c)
	return c:IsOriginalSetCard(0xa531) and not c:IsType(TYPE_TUNER) and c:GetFlagEffect(53721049)>0
end
function cm.SorisonAntiRepeat(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.SorisonAntiRepeatf,tp,LOCATION_HAND,0,c)
	if #g==0 then
		c:RegisterFlagEffect(53721049,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function cm.SorisonTGCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
--
function cm.GreatCircle(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(SUMMON_VALUE_SELF)
	e1:SetCondition(cm.GCSPCondition)
	e1:SetOperation(cm.GCSPOperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.GCTHCondition)
	e2:SetOperation(cm.GCTHOperation)
	c:RegisterEffect(e2)
end
function cm.GCSPFilter(c)
	return c:IsSetCard(0x3531) and c:IsDiscardable()
end
function cm.GCSPCondition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.GCSPFilter,tp,LOCATION_HAND,0,1,c)
end
function cm.GCSPOperation(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.GCSPFilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.GCTHCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and e:GetHandler()==Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
end
function cm.GCTHOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	if c:IsAbleToHand() and (not c:IsAbleToDeck() or Duel.SelectYesNo(tp,aux.Stringid(c:GetOriginalCode(),1))) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,c)
			Duel.SetLP(tp,Duel.GetLP(tp)-400)
		end
	else
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then Duel.SetLP(tp,Duel.GetLP(tp)-400) end
	end
end
--
function cm.SeadowRover(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	if c:GetOriginalType()&TYPE_TUNER==TYPE_TUNER then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_TO_DECK)
		e2:SetOperation(cm.SRoverDrawOp)
		c:RegisterEffect(e2)
	end
end
function cm.SRoverDrawOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_HAND) or not c:IsPreviousPosition(POS_FACEUP) then return end
	local ct=Duel.GetDrawCount(tp)
	if Duel.GetTurnCount()==1 then
		ct=1
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DRAW_COUNT)}
		for _,te in pairs(eset) do if te:GetValue()>dt then dt=te:GetValue() end end
	end
	if ct>3 then return end
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetTargetRange(1,0)
	e2:SetValue(ct+1)
	e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
end
function cm.SeadowRoverSyn(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	e2:SetCondition(cm.SRoverSPcon)
	e2:SetOperation(cm.SRoverSPop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(c:GetOriginalCode(),2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(cm.SRoverDrawCon2)
	e4:SetTarget(cm.SRoverDrawtg2)
	e4:SetOperation(cm.SRoverDrawOp2)
	c:RegisterEffect(e4)
end
function cm.SRovercfilter(c,tp)
	return c:IsSetCard(0x3534) and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(cm.SRovercfilter1,tp,LOCATION_HAND,0,1,c) and c:IsPublic() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)
end
function cm.SRovercfilter1(c)
	return c:IsSetCard(0x3534) and c:IsType(TYPE_TUNER) and c:IsAbleToDeckAsCost() and c:IsPublic()
end
function cm.SRoverSPcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.SRovercfilter,tp,LOCATION_HAND,0,1,c,tp) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.SRoverSPop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,cm.SRovercfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,cm.SRovercfilter1,tp,LOCATION_HAND,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function cm.SRoverDrawCon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function cm.SRoverDrawtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.SRoverDrawOp2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.SetPublic(c,lab,rst,rstct)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53702500,lab))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(rst,rstct)
	c:RegisterEffect(e1)
end
function cm.SetPublicGroup(c,g,rst,rstct)
	for pubc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(53702500,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(rst,rstct)
		pubc:RegisterEffect(e1)
	end
end
function cm.AnouguryLink(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.AnouguryReptg)
	e1:SetValue(function(e,c)return c:GetFlagEffect(53728000)>0 end)
	c:RegisterEffect(e1)
end
function cm.AnouguryReptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(function(c,ec)return c:GetDestination()==LOCATION_GRAVE and c:GetReasonCard()==ec and ((c:IsType(TYPE_UNION) and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)) or (c:GetEquipGroup():IsExists(function(c,ec)return c:IsType(TYPE_UNION) and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)end,1,nil,c)))end,nil,c)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=g:FilterCount(function(c,ec)return c:IsType(TYPE_UNION) and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)end,nil,c) end
	for mc in aux.Next(g) do
		local beg=mc:GetEquipGroup():Filter(function(c,ec,tp)return c:IsType(TYPE_UNION) and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)end,nil,c,tp)
		if #beg>0 then g:Merge(beg) end
	end
	g=g:Filter(Card.IsType,nil,TYPE_UNION)
	for ec in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_CHAIN)
		ec:RegisterEffect(e1)
	end
	g:ForEach(Card.RegisterFlagEffect,53728000,RESET_EVENT+0x7e0000,0,1)
	local mg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	for tc in aux.Next(mg) do Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_NEGATED)
	e2:SetOperation(cm.AnouguryRstop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetLabelObject(e2)
	e3:SetOperation(cm.AnouguryRstop2)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+53728000)
	e4:SetLabelObject(e3)
	e4:SetOperation(cm.AnouguryRstop3)
	Duel.RegisterEffect(e4,tp)
	return true
end
function cm.AnouguryRstop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(53728000)>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	for ec in aux.Next(g) do
		ec:ResetFlagEffect(53728000)
		ec:ResetEffect(EFFECT_INDESTRUCTABLE,RESET_CODE)
	end
	Duel.Destroy(g,REASON_RULE)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+53728000,re,r,rp,ep,ev)
	e:Reset()
end
function cm.AnouguryRstop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(53728000)>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		for ec in aux.Next(g) do
			Duel.Equip(tp,ec,c,true,true)
			aux.SetUnionState(ec)
			ec:ResetEffect(EFFECT_INDESTRUCTABLE,RESET_CODE)
			ec:ResetFlagEffect(53728000)
		end
		Duel.EquipComplete()
	end
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.AnouguryRstop3(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.MRSYakuSP(c,num,typ)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.MRSYakuSPcost(num,typ))
	e1:SetTarget(cm.MRSYakuSPtg)
	e1:SetOperation(cm.MRSYakuSPop)
	c:RegisterEffect(e1)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1_1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1_1:SetCode(EVENT_CUSTOM+53711005)
	e1_1:SetRange(LOCATION_HAND)
	e1_1:SetCost(cm.MRSYakuSPcost(num,typ))
	e1_1:SetTarget(cm.MRSYakuSPtg)
	e1_1:SetOperation(cm.MRSYakuSPop)
	c:RegisterEffect(e1_1)
end
function cm.MRSYakuspfilter1(c,e,tp,typ)
	if c:IsLocation(LOCATION_HAND) then
		return c:IsType(typ) and c:IsDiscardable()
	else
		return e:GetHandler():IsOriginalSetCard(0x3538) and e:GetHandler():IsLevel(4) and c:IsAbleToRemove() and c:IsHasEffect(53711009,tp)
	end
end
function cm.MRSYakuspfilter2(c,e,tp)
	return c:IsSetCard(0x3538) and c:IsType(TYPE_SPELL)
end
function cm.MRSYakutimefilter(c,tp)
	return c:IsHasEffect(53711099,tp) and c:GetFlagEffect(53711065)<2
end
function cm.MRSYakufselect(g,ct)
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return aux.dncheck(g2) and #g2<=ct
end
function cm.MRSYakuSPcost(num,typ)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local ltime=0
		local timeg=Duel.GetMatchingGroup(cm.MRSYakutimefilter,tp,LOCATION_MZONE,0,c,tp)
		if #timeg>0 then
			local ttct=0
			for timec in aux.Next(timeg) do
				local timect=timec:GetFlagEffect(53711065)
				ttct=ttct+timect
			end
			ltime=2*#timeg-ttct
		end
		local g=Duel.GetMatchingGroup(cm.MRSYakuspfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp,typ)
		local gdg=Duel.GetMatchingGroup(cm.MRSYakuspfilter2,tp,LOCATION_DECK,0,c,e,tp)
		local ct=gdg:GetClassCount(Card.GetCode)
		if ct>ltime then ct=ltime end
		if chk==0 then return #g+ct>num-1 end
		g:Merge(gdg)
		if ltime>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(c:GetOriginalCode(),3))
			local sg=g:SelectSubGroup(tp,cm.MRSYakufselect,false,num,num,ct)
			local dg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
			if #dg>0 then
				if #timeg>1 then
					for i=1,#dg do
						Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(c:GetOriginalCode(),5))
						local usedg=timeg:FilterSelect(tp,cm.MRSYakutimefilter,1,1,nil)
						Duel.HintSelection(usedg)
						local usedc=usedg:GetFirst()
						local trg=usedc:GetFlagEffect(53711065)
						usedc:RegisterFlagEffect(53711065,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53711015,trg+3))
					end
				else
					for i=1,#dg do
						local trg=timeg:GetFirst():GetFlagEffect(53711065)
						timeg:GetFirst():RegisterFlagEffect(53711065,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53711015,trg+3))
					end
				end
			end
			local tc=sg:GetFirst()
			while tc do
				local te=tc:IsHasEffect(53711009,tp)
				if te then
					Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
				else
					Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
				end
				tc=sg:GetNext()
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local sg=Duel.SelectMatchingCard(tp,cm.MRSYakuspfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,num,num,c,e,tp,typ)
			local tc=sg:GetFirst()
			while tc do
				local te=tc:IsHasEffect(53711009,tp)
				if te then
					Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_REPLACE)
				else
					Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
				end
				tc=sg:GetNext()
			end
		end
	end
end
function cm.MRSYakuSPtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.MRSYakuSPop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.IsInTable(value, tbl)
	for k,v in ipairs(tbl) do
		if v == value then
		return true
		end
	end
	return false
end
function cm.OnStageText(c,typ)
	if typ==act then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(cm.Stageactop)
		c:RegisterEffect(e1)
	elseif typ==nors then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetOperation(cm.Stagesop)
		c:RegisterEffect(e2)
	elseif typ==spes then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetOperation(cm.Stagesop)
		c:RegisterEffect(e3)
	end
end
function cm.Stageactop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetOriginalCode(),11))
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetOriginalCode(),12))
end
function cm.Stagesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetOriginalCode(),13))
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetOriginalCode(),14))
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetOriginalCode(),15))
end
function cm.SetDirectlyf(c)
	return c:IsFaceup() and ((c:IsLocation(LOCATION_MZONE) and ((bit.band(c:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)~=0 and (not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanTurnSet()) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c:IsCanTurnSet())) or (bit.band(c:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)==0 and c:IsCanTurnSet()))) or (c:IsLocation(LOCATION_SZONE) and c:IsSSetable(true))) and not (c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_PZONE))
end
function cm.SetDirectly(g,e,p)
	for tc in aux.Next(g) do
		tc:CancelToGrave()
		Duel.ChangePosition(tc,POS_FACEDOWN)
		local loc=0
		if tc:IsType(TYPE_FIELD) then loc=LOCATION_FZONE
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then loc=LOCATION_SZONE end
		if tc:GetOriginalType()&TYPE_MONSTER==0 and tc:IsLocation(LOCATION_MZONE) then Duel.MoveToField(tc,p,p,loc,POS_FACEDOWN,false) end
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,p,p,0) end
	end
end
function cm.CardnameBreak(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(0xff)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetOperation(cm.Breakcount)
	c:RegisterEffect(e3)
end
function cm.Breakcount(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON) then c53799250.sp=true end
	if not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE) then c53799250.ac=true end
end
function cm.DesertedHartrazLink(c,marker)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1163)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC_G)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.Hartrazlkcon)
	e0:SetOperation(cm.Hartrazlkop(marker))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
end
function cm.Hartrazlkfilter(c,lc,tp)
	return c:IsFaceup() and c:IsLinkRace(RACE_PYRO) and c:IsCanBeLinkMaterial(lc)
end
function cm.Hartrazlvfilter(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then return 1+0x10000*c:GetLink() else return 1 end
end
function cm.Hartrazlcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(cm.Hartrazlvfilter,lc:GetLink(),ct,ct)
end
function cm.Hartrazlkcheck(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=cm.Hartrazlcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(cm.Hartrazlkcheck,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function cm.Hartrazlkcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.Hartrazlkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=1
	local maxc=1
	if ct>maxc then return false end
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and cm.Hartrazlcheck(tp,sg,c,minc,ct) or mg:IsExists(cm.Hartrazlkcheck,1,nil,tp,sg,mg,c,ct,minc,maxc)
end
function cm.Hartrazlkop(marker)
	return
	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		local mg=Duel.GetMatchingGroup(cm.Hartrazlkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
		local sg2=Group.CreateGroup()
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do sg2:AddCard(pe:GetHandler()) end
		local ct=sg2:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		sg2:Select(tp,ct,ct,nil)
		local minc=1
		local maxc=1
		for i=ct,maxc-1 do
			local cg=mg:Filter(cm.Hartrazlkcheck,sg2,tp,sg2,mg,c,i,minc,maxc)
			if cg:GetCount()==0 then break end
			local minct=1
			if cm.Hartrazlcheck(tp,sg2,c,minc,i) then
				if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then break end
				minct=0
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			local g=cg:Select(tp,minct,1,nil)
			if g:GetCount()==0 then break end
			sg2:Merge(g)
		end
		Duel.SendtoGrave(sg2,REASON_MATERIAL+REASON_LINK)
		sg2:KeepAlive()
		local self=Group.FromCards(c)
		self:KeepAlive()
		cm[100]=sg2
		cm[101]=e
		cm[102]=self
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_MOVE)
		e3:SetProperty(EFFECT_FLAG_DELAY)
		e3:SetCondition(cm.adjustcon2)
		e3:SetOperation(cm.adjustop2)
		Duel.RegisterEffect(e3,tp)
		c:SetMaterial(sg2)
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
		e2:SetValue(marker)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e2)
		c:CompleteProcedure()
		c:RegisterFlagEffect(53729000,0,0,0)
		Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	end
end
function cm.adjustcon2(e,tp,eg,ep,ev,re,r,rp)
	return cm[102]:GetFirst():GetFlagEffect(53729000)>0
end
function cm.adjustop2(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(#cm[100])
	local sc=cm[102]:GetFirst()
	Debug.Message(sc:GetCode())
	if sc:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.RaiseEvent(cm[100],EVENT_BE_MATERIAL,cm[101],REASON_SYNCHRO,tp,tp,0)
	for tc in aux.Next(cm[100]) do
		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,cm[101],REASON_SYNCHRO,tp,tp,0)
	end
end
function cm.ORsideLink(c,f,min,max,gf,code)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=c:GetLink() end
	e1:SetCondition(cm.LinkCondition(f,min,max,gf,code))
	e1:SetTarget(cm.LinkTarget(f,min,max,gf))
	e1:SetOperation(cm.LinkOperation(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function cm.LConditionFilter(c,f,lc,e)
	return (c:IsFaceup() or not c:IsOnField() or e:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE))
		and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function cm.LExtraFilter(c,f,lc,tp)
	if c:IsLocation(LOCATION_ONFIELD) and not c:IsFaceup() then return false end
	if not c:IsCanBeLinkMaterial(lc) or f and not f(c) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		local related,valid=tf(te,lc,nil,c,tp)
		if related then return true end
	end
	return false
end
function cm.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function cm.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(cm.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(cm.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function cm.LCheckOtherMaterial(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	local res1=false
	local res2=true
	for _,te in pairs(le) do
		local f=te:GetValue()
		local related,valid=f(te,lc,mg,c,tp)
		if related then res2=false end
		if related and valid then res1=true end
	end
	return res1 or res2
end
function cm.LUncompatibilityFilter(c,sg,lc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not cm.LCheckOtherMaterial(c,mg,lc,tp)
end
function cm.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(cm.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(cm.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function cm.LExtraMaterialCount(mg,lc,tp)
	for tc in aux.Next(mg) do
		local le={tc:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
		for _,te in pairs(le) do
			local sg=mg:Filter(aux.TRUE,tc)
			local f=te:GetValue()
			local related,valid=f(te,lc,sg,tc,tp)
			if related and valid then
				te:UseCountLimit(tp)
			end
		end
	end
end
function cm.LinkCondition(f,minc,maxc,gf,code)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				if c:GetOriginalCode()~=code then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(aux.LConditionFilter,nil,f,c,e)
				else
					mg=aux.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not aux.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(aux.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function cm.LinkTarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(cm.LConditionFilter,nil,f,c,e)
				else
					mg=cm.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not cm.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,cm.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function cm.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				cm.LExtraMaterialCount(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function cm.EnableExtraDeckSummonCountLimit()
	if cm.ExtraDeckSummonCountLimit~=nil then return end
	cm.ExtraDeckSummonCountLimit={}
	cm.ExtraDeckSummonCountLimit[0]=1
	cm.ExtraDeckSummonCountLimit[1]=1
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	ge1:SetOperation(cm.ExtraDeckSummonCountLimitReset)
	Duel.RegisterEffect(ge1,0)
end
function cm.ExtraDeckSummonCountLimitReset()
	cm.ExtraDeckSummonCountLimit[0]=1
	cm.ExtraDeckSummonCountLimit[1]=1
end
function cm.HartrazCheck(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xff)
	e0:SetCost(cm.Hztfcost)
	e0:SetOperation(cm.Hztfop)
	c:RegisterEffect(e0)
end
function cm.Hztfcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK then
		e:SetLabel(1)
		local cg=Duel.GetMatchingGroup(cm.ALCTFFilter,tp,LOCATION_MZONE,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	else
		e:SetLabel(0)
		return true
	end
end
function cm.Hztfop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return true end
	e:SetLabel(0)
end
function cm.LinkMonstertoSpell(c,marker)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e2:SetValue(marker)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e2)
end
function cm.CyberNSwitch(c)
	if Duel.GetFlagEffect(0,53727000)>0 then return end
	Duel.RegisterFlagEffect(0,53727000,0,0,0)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(53702500,8))
	Duel.Hint(HINT_OPSELECTED,1,aux.Stringid(53702500,8))
	Duel.SelectYesNo(0,aux.Stringid(53702600,1))
	Duel.SelectYesNo(1,aux.Stringid(53702600,1))
	if Duel.GetFlagEffect(0,53727097)==0 and not Duel.SelectYesNo(0,aux.Stringid(53702500,13)) then Duel.RegisterFlagEffect(0,53727097,0,0,0) end
	if Duel.GetFlagEffect(1,53727097)==0 and not Duel.SelectYesNo(1,aux.Stringid(53702500,13)) then Duel.RegisterFlagEffect(1,53727097,0,0,0) end
	if Duel.GetFlagEffect(0,53727097)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetOperation(cm.CyberNCheck)
		Duel.RegisterEffect(e1,0)
	end
	if Duel.GetFlagEffect(0,53727097)>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetOperation(cm.CyberNCheck)
		Duel.RegisterEffect(e2,1)
	end
end
function cm.CyberNCheck(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53702500,9))
	local sel=Duel.SelectOption(tp,aux.Stringid(53727004,6),aux.Stringid(53727005,6),aux.Stringid(53727006,6),aux.Stringid(53727007,6))
	if sel==0 then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702601,Duel.GetFlagEffect(0,53727004)+1))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702602,Duel.GetFlagEffect(0,53727037)+3))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702603,Duel.GetFlagEffect(0,53727070)+6))
	elseif sel==1 then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702604,Duel.GetFlagEffect(0,53727005)+1))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702605,Duel.GetFlagEffect(0,53727038)+3))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702606,Duel.GetFlagEffect(0,53727071)+5))
	elseif sel==2 then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702607,Duel.GetFlagEffect(0,53727006)+1))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702608,Duel.GetFlagEffect(0,53727039)+3))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702609,Duel.GetFlagEffect(0,53727072)+5))
	else
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702610,Duel.GetFlagEffect(0,53727007)+1))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702611,Duel.GetFlagEffect(0,53727040)+3))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702612,Duel.GetFlagEffect(0,53727073)+5))
	end
end
function cm.CyberNRecord(c)
	if Duel.GetFlagEffect(0,53727099)>0 then return end
	Duel.RegisterFlagEffect(0,53727099,0,0,0)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(53702500,10))
	Duel.Hint(HINT_OPSELECTED,1,aux.Stringid(53702500,10))
	Duel.SelectYesNo(0,aux.Stringid(53702600,0))
	Duel.SelectYesNo(1,aux.Stringid(53702600,0))
	local check0,check1=false,false
	if Duel.GetFlagEffect(0,53727097)==0 and not Duel.SelectYesNo(0,aux.Stringid(53702500,13)) then Duel.RegisterFlagEffect(0,53727097,0,0,0) end
	if Duel.GetFlagEffect(1,53727097)==0 and not Duel.SelectYesNo(1,aux.Stringid(53702500,13)) then Duel.RegisterFlagEffect(1,53727097,0,0,0) end
	if Duel.SelectYesNo(0,aux.Stringid(53702500,12)) then check0=true end
	if Duel.SelectYesNo(1,aux.Stringid(53702500,12)) then check1=true end
	if not check0 or not check1 then check0,check1=false,false end
	if Duel.GetFlagEffect(0,53727097)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		if check0 then e1:SetOperation(cm.CyberNCode1) else e1:SetOperation(cm.CyberNCode2) end
		Duel.RegisterEffect(e1,0)
	end
	if Duel.GetFlagEffect(1,53727097)>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_FREE_CHAIN)
		if check1 then e2:SetOperation(cm.CyberNCode1) else e2:SetOperation(cm.CyberNCode2) end
		Duel.RegisterEffect(e2,1)
	end
end
function cm.CyberNCode1(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local max=Duel.GetFlagEffect(0,53727001)
	for i=1,max do
		if Duel.GetFlagEffect(0,53777000+i)>0 then
			local cd=Duel.GetFlagEffectLabel(0,53777000+i)
			if not cm.IsInTable(cd,t) and cd~=114 then table.insert(t,cd) end
		else break end
	end
	local g=Group.CreateGroup()
	for i=1,#t do
		local cre=Duel.CreateToken(1-tp,t[i])
		g:AddCard(cre)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(53702500,14))
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(53702500,15))
end
function cm.CyberNCode2(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local max=Duel.GetFlagEffect(0,53727001)
	for i=1,max do
		if Duel.GetFlagEffect(0,53777000+i)>0 then
			local cd=Duel.GetFlagEffectLabel(0,53777000+i)
			if not cm.IsInTable(cd,t) and cd~=114 then table.insert(t,cd) end
		else break end
	end
	local g=Group.CreateGroup()
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(53702500,14))
	for i=1,#t do Duel.Hint(HINT_CARD,tp,t[i]) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(53702500,15))
end
function cm.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(0xff)
	e1:SetOperation(cm.AllEffectRstop)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL+53702700)
	c:RegisterEffect(e1)
end
function cm.AllEffectRstop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,53702700)>0 then return end
	Duel.RegisterFlagEffect(0,53702700,0,0,0)
	local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,nil)
	local reg=Card.RegisterEffect
	local rstg=Duel.GetMatchingGroup(function(c)return _G["c"..c:GetOriginalCode()].Snnm_Ef_Rst end,0,0xff,0xff,nil)
	local rstt={}
	for rstc in aux.Next(rstg) do if not cm.IsInTable(rstc:GetOriginalCode(),rstt) then table.insert(rstt,rstc:GetOriginalCode()) end end
	local code=e:GetHandler():GetOriginalCode()
	Card.RegisterEffect=function(sc,se,bool)
		if cm.IsInTable(25000008,rstt) then
		if se:GetCode()==EVENT_BATTLE_DESTROYED then
			local ex=se:Clone()
			ex:SetCode(EVENT_CUSTOM+25000008)
			sc:RegisterEffect(ex)
		end
		if se:GetCode()==EVENT_DESTROYED then
			local ex=se:Clone()
			ex:SetCode(EVENT_CUSTOM+25000008)
			sc:RegisterEffect(ex)
		end
		end
		if cm.IsInTable(25000061,rstt) then
		if se:GetType()&EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O~=0 then sc:RegisterFlagEffect(25000061,0,0,0) end
		end
		if cm.IsInTable(25000103,rstt) then
		local pro=se:GetProperty()
		if pro&EFFECT_FLAG_UNCOPYABLE==0 then
			if se:GetType()&(EFFECT_TYPE_IGNITION+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_ACTIVATE)==0 then
				local con=se:GetCondition()
				if con then
					se:SetCondition(function(e,...)
						if Duel.GetFlagEffect(0,25000103+e:GetHandler():GetOriginalCodeRule())>0 and not e:GetHandler():IsLocation(LOCATION_ONFIELD) then return false end
						return con(e,...)
					end)
				else
					se:SetCondition(function(e,...)
						if Duel.GetFlagEffect(0,25000103+e:GetHandler():GetOriginalCodeRule())>0 and not e:GetHandler():IsLocation(LOCATION_ONFIELD) then return false end
						return true
					end)
				end
			end
		end
		end
		if cm.IsInTable(53796002,rstt) then
		if se:GetRange()==LOCATION_PZONE and se:GetProperty()&EFFECT_FLAG_UNCOPYABLE==0 then
			_G["c"..sc:GetOriginalCode()].pend_effect=se
		end
		end
		if cm.IsInTable(53796005,rstt) then
		local cd,et=se:GetCode(),se:GetType()
		if (cd==EVENT_SUMMON_SUCCESS or cd==EVENT_FLIP_SUMMON_SUCCESS or cd==EVENT_SPSUMMON_SUCCESS) and et&EFFECT_TYPE_SINGLE and et&(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)~=0 then
			local ex1=Effect.CreateEffect(sc)
			ex1:SetType(EFFECT_TYPE_FIELD)
			ex1:SetCode(EFFECT_ACTIVATE_COST)
			ex1:SetRange(0xff)
			ex1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
			ex1:SetTargetRange(1,1)
			ex1:SetLabelObject(se)
			ex1:SetTarget(function(e,te,tp)return te==e:GetLabelObject()end)
			ex1:SetCost(function(e,te,tp)return Duel.GetFlagEffect(0,53796005)==0 end)
			sc:RegisterEffect(ex1)
			local x=true
			if sc:IsHasEffect(53796005) then
			for _,i in ipairs{sc:IsHasEffect(53796005)} do
				if i:GetOperation()==se:GetOperation() then x=false end
			end
			end
			if x then
			local ex2=se:Clone()
			ex2:SetCode(EVENT_LEAVE_FIELD)
			sc:RegisterEffect(ex2)
			local ex3=ex1:Clone()
			ex3:SetLabelObject(ex2)
			ex3:SetTarget(function(e,te,tp)return te==e:GetLabelObject()end)
			ex3:SetCost(function(e,te,tp)return Duel.GetFlagEffect(0,53796005)>0 end)
			sc:RegisterEffect(ex3)
			local ex4=Effect.CreateEffect(sc)
			ex4:SetType(EFFECT_TYPE_SINGLE)
			ex4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			ex4:SetCode(53796005)
			ex4:SetRange(0xff)
			ex4:SetOperation(se:GetOperation())
			sc:RegisterEffect(ex4)
			end
		end
		end
		if cm.IsInTable(53799017,rstt) then
		if se:GetType()==EFFECT_TYPE_ACTIVATE then
			local tg=se:GetTarget()
			if tg then
				se:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
					if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
					if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,chk) end
					tg(e,tp,eg,ep,ev,re,r,rp,chk)
					if Duel.GetFlagEffect(tp,53799017)>0 then Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) end
				end)
			else
				se:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return true end
					if Duel.GetFlagEffect(tp,53799017)>0 then Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) end
				end)
			end
		end
		end
		reg(sc,se,bool)
	end
	for tc in aux.Next(g) do
		if tc.initial_effect then
			local ini=cm.initial_effect
			cm.initial_effect=function() end
			tc:ReplaceEffect(m,0)
			cm.initial_effect=ini
			tc.initial_effect(tc)
		end
	end
	Card.RegisterEffect=reg
	e:Reset()
end
function cm.reni(c,sdes,scat,styp,spro,scod,sran,sct,sht,scon,scos,stg,sop)
	if scon==0 then scon=aux.TRUE end
	if scos==0 then scos=aux.TRUE end
	if stg==0 then stg=aux.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(sdes)
	e1:SetCategory(scat)
	e1:SetType(styp)
	e1:SetProperty(spro)
	e1:SetCode(scod)
	e1:SetRange(sran)
	if sct~=0 then e1:SetCountLimit(table.unpack(sct)) end
	e1:SetHintTiming(table.unpack(sht))
	e1:SetCondition(scon)
	e1:SetCost(scos)
	e1:SetTarget(stg)
	e1:SetOperation(sop)
	c:RegisterEffect(e1)
	return e1
end
function cm.renf(c,spro,scod,sran,stran,scon,stg,sval)
	if scon==0 then scon=aux.TRUE end
	if stg==0 then stg=aux.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(spro)
	e1:SetCode(scod)
	e1:SetRange(sran)
	e1:SetTargetRange(table.unpack(stran))
	e1:SetCondition(scon)
	e1:SetTarget(stg)
	e1:SetValue(sval)
	c:RegisterEffect(e1)
	return e1
end
function cm.renst(c,sdes,scat,styp,spro,scod,sct,scon,scos,stg,sop)
	if scon==0 then scon=aux.TRUE end
	if scos==0 then scos=aux.TRUE end
	if stg==0 then stg=aux.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(sdes)
	e1:SetCategory(scat)
	e1:SetType(EFFECT_TYPE_SINGLE+styp)
	e1:SetProperty(spro)
	e1:SetCode(scod)
	if sct~=0 then e1:SetCountLimit(table.unpack(sct)) end
	e1:SetCondition(scon)
	e1:SetCost(scos)
	e1:SetTarget(stg)
	e1:SetOperation(sop)
	c:RegisterEffect(e1)
	return e1
end
function cm.renft(c,sdes,scat,styp,spro,scod,sran,sct,scon,scos,stg,sop)
	if scon==0 then scon=aux.TRUE end
	if scos==0 then scos=aux.TRUE end
	if stg==0 then stg=aux.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(sdes)
	e1:SetCategory(scat)
	e1:SetType(EFFECT_TYPE_FIELD+styp)
	e1:SetProperty(spro)
	e1:SetCode(scod)
	e1:SetRange(sran)
	if sct~=0 then e1:SetCountLimit(table.unpack(sct)) end
	e1:SetCondition(scon)
	e1:SetCost(scos)
	e1:SetTarget(stg)
	e1:SetOperation(sop)
	c:RegisterEffect(e1)
	return e1
end
function cm.recst(c,sct)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	if sct~=0 then e1:SetCountLimit(table.unpack(sct)) end
	c:RegisterEffect(e1)
	return e1
end
function cm.rest(c,scat,styp,spro,scod,sct,scon,scos,stg,sop)
	if scon==0 then scon=aux.TRUE end
	if scos==0 then scos=aux.TRUE end
	if stg==0 then stg=aux.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(scat)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(spro)
	e1:SetCode(scod)
	if sct~=0 then e1:SetCountLimit(table.unpack(sct)) end
	e1:SetCondition(scon)
	e1:SetCost(scos)
	e1:SetTarget(stg)
	e1:SetOperation(sop)
	c:RegisterEffect(e1)
	return e1
end
function cm.bettertrg(c,scod,code)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.btcount(code))
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.btreset(code))
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(scod)
		ge3:SetOperation(cm.bteg(code))
		Duel.RegisterEffect(ge3,0)
end
function cm.btcount(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	_G["c"..code].chain=true
	end
end
function cm.bteg(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local class=_G["c"..code]
	if class.chain==true then
		local g=Group.CreateGroup()
		if class[0] then g=class[0] end
		g:Merge(eg)
		g:KeepAlive()
		class[0]=g
	end
	if class.chain==false then
		Duel.RaiseEvent(eg,EVENT_CUSTOM+code,re,r,rp,ep,ev)
	end
	end
end
function cm.btreset(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local class=_G["c"..code]
	class.chain=false
	if not class[0] then return end
	Duel.RaiseEvent(class[0],EVENT_CUSTOM+code,re,r,rp,ep,ev)
	class[0]=nil
	end
end
function cm.RinnaZone(tp,cg)
	local fdzone=0
	for cc in aux.Next(cg) do
		local cs=cc:GetSequence()
		local cz=1<<cs
		fdzone=fdzone|cz
		local bcz=1<<(cs+16)
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
		for _,te in ipairs(ce) do
			local con=te:GetCondition()
			local val=te:GetValue()
			if (not con or con(te)) then
				if val then
					if aux.GetValueType(val)=="function" then
						if tp==0 then
							if cz&val(te)>0 then fdzone=fdzone&(~cz) end
						else
							if bcz&val(te)>0 then fdzone=fdzone&(~cz) end
						end
					else
						if tp==0 then
							if cz&val>0 then fdzone=fdzone&(~cz) end
						else
							if bcz&val>0 then fdzone=fdzone&(~cz) end
						end
					end
				end
			end
		end
	end
	return fdzone
end
function cm.DisMZone(tp)
	local zone=0
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
	for _,te in ipairs(ce) do
		local con=te:GetCondition()
		local val=te:GetValue()
		if (not con or con(te)) then
			if val then if aux.GetValueType(val)=="function" then zone=zone|val(te) else zone=zone|val end end
		end
	end
	if tp==1 then zone=((zone&0xffff)<<16)|((zone>>16)&0xffff) end
	return zone
end
function cm.ReleaseMZone(e,tp,z)
	if tp==1 then z=((z&0xffff)<<16)|((z>>16)&0xffff) end
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
	for _,te in ipairs(ce) do
		local con=te:GetCondition()
		local val=te:GetValue()
		if (not con or con(te)) and val then
			local e1=Effect.CreateEffect(e:GetHandler())
			local res=false
			local xe={Duel.IsPlayerAffectedByEffect(tp,53734000)}
			local t={}
			for _,i in ipairs(xe) do table.insert(t,i:GetLabelObject()) end
			if not cm.IsInTable(te,t) then res=true end
			if not Duel.IsPlayerAffectedByEffect(tp,53734000) or res then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(53734000)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetTargetRange(1,1)
				e2:SetLabelObject(te)
				e2:SetValue(val)
				Duel.RegisterEffect(e2,tp)
			end
			local xe={Duel.IsPlayerAffectedByEffect(tp,53734000)}
			local eval=0
			for _,i in ipairs(xe) do
				if i:GetLabelObject()==te then eval=i:GetValue() end
			end
			local zone=0
			if aux.GetValueType(eval)=="function" then
				zone=eval(te)
				eval=zone
				e1:SetValue(0)
			else
				zone=eval
				e1:SetValue(1)
			end
			if aux.GetValueType(val)=="function" then val=val(te) end
			if z&val~=0 then
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_ADJUST)
				e1:SetLabel(zone)
				e1:SetLabelObject(te)
				e1:SetOperation(cm.ReturnLock)
				Duel.RegisterEffect(e1,tp)
				val=val&(~z)
				te:SetValue(val)
			end
		end
	end
end
function cm.ReturnLock(e,tp,eg,ep,ev,re,r,rp)
	local zone,te=e:GetLabel(),e:GetLabelObject()
	if not te then
		e:Reset()
		return
	end
	local res=true
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
	for _,ke in ipairs(ce) do
		if ke==te then res=false end
	end
	local xe={Duel.IsPlayerAffectedByEffect(tp,53734000)}
	local val=0
	for _,i in ipairs(xe) do
		if i:GetLabelObject()==te then val=i:GetValue() end
	end
	local eval=0
	if e:GetValue()==0 then eval=val(te) else eval=val end
	--Debug.Message(res)
	if zone~=eval or res then
		te:SetValue(val)
		e:Reset()
	end
end
function cm.OjamaAdjust()--Deserted
	f1=Duel.RegisterEffect
	Duel.RegisterEffect=function(e,p)
		if e:GetCode()==EFFECT_DISABLE_FIELD then
			local pro,pro2=e:GetProperty()
			pro=pro|EFFECT_FLAG_PLAYER_TARGET
			e:SetProperty(pro,pro2)
			e:SetTargetRange(1,1)
		end
		f1(e,p)
	end
	f2=Card.RegisterEffect
	Card.RegisterEffect=function(sc,e,bool)
		if e:GetCode()==EFFECT_DISABLE_FIELD then
			local op,range,con=e:GetOperation(),e:GetRange(),e:GetCondition()
			if op then
				local res=false
				local xe={Duel.IsPlayerAffectedByEffect(0,53734099)}
				local t={}
				for _,i in ipairs(xe) do table.insert(t,i:GetLabelObject()) end
				if not cm.IsInTable(e,t) then res=true end
				if not Duel.IsPlayerAffectedByEffect(0,53734099) or res then
					local ex2=Effect.CreateEffect(sc)
					ex2:SetType(EFFECT_TYPE_FIELD)
					ex2:SetCode(53734099)
					ex2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					ex2:SetTargetRange(1,1)
					ex2:SetLabelObject(e)
					if range then ex2:SetRange(range) end
					if con then ex2:SetCondition(con) end
					ex2:SetOperation(op)
					Duel.RegisterEffect(ex2,0)
				end
				local ex=Effect.CreateEffect(sc)
				ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ex:SetCode(EVENT_ADJUST)
				ex:SetRange(range)
				ex:SetLabelObject(e)
				ex:SetOperation(cm.OjamaAdjustop)
				f2(sc,ex)
				e:SetOperation(nil)
			else
				local pro,pro2=e:GetProperty()
				pro=pro|EFFECT_FLAG_PLAYER_TARGET
				e:SetProperty(pro,pro2)
				e:SetTargetRange(1,1)
			end
		end
		f2(sc,e,bool)
	end
end
function cm.OjamaAdjustop(e,tp,eg,ep,ev,re,r,rp)--Deserted
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 then return end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY,0,0)
	local te=e:GetLabelObject()
	local con,range,op=0,0,0
	local xe={Duel.IsPlayerAffectedByEffect(0,53734099)}
	local t={}
	for _,i in ipairs(xe) do
		if te==i:GetLabelObject() then
			if i:GetCondition() then con=i:GetCondition() end
			if i:GetRange() then range=i:GetRange() end
			op=i:GetOperation()
		end
	end
	local val=op(e,tp)
	if tp==1 then val=((val&0xffff)<<16)|((val>>16)&0xffff) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	if range~=0 then e1:SetRange(range) else e1:SetRange(LOCATION_MZONE) end
	if con~=0 then e1:SetCondition(con) end
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY)
	c:RegisterEffect(e1)
end
