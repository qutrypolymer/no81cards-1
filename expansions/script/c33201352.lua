--六合精工 金瓯永固杯
local m=33201352
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201350") end,function() require("script/c33201350") end)
function cm.initial_effect(c)
	--deckes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--recover
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33201350,1))
	e0:SetCategory(CATEGORY_RECOVER)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,m+10000)
	e0:SetCondition(VHisc_CNTdb.thcon)
	e0:SetTarget(cm.thtg)
	e0:SetOperation(cm.thop)
	c:RegisterEffect(e0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_HAND)
		e2:SetOperation(aux.chainreg)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetRange(LOCATION_HAND)
		e3:SetLabelObject(e0)
		e3:SetOperation(cm.acop)
		c:RegisterEffect(e3)
end
cm.VHisc_CNTreasure=true

--e1
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function cm.tgfilter(c)
	return VHisc_CNTdb.nck(c) and c:IsAbleToGrave() and not c:IsCode(m)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		for tc in aux.Next(g) do
			--to grave
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCategory(CATEGORY_TOGRAVE)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetCountLimit(1)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetOperation(cm.tgop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		end
	end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKBOTTOM,REASON_EFFECT)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
end

--e0
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local hlp=Duel.GetFlagEffect(tp,m)*1200+1200
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(hlp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,hlp)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject()==re and e:GetHandler():GetFlagEffect(1)>0 then
		Duel.RegisterFlagEffect(tp,m,nil,EFFECT_FLAG_OATH,1)
	end
end