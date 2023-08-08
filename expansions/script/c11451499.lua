--流年如歌
--A souvenir of 2020
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ADJUST)
	e10:SetRange(LOCATION_FZONE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCondition(cm.condition0)
	e10:SetOperation(cm.operation0)
	c:RegisterEffect(e10)
	--spring
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetCondition(function(e,c) return Duel.GetTurnCount()%4==1 end)
	e1:SetValue(cm.indct)
	c:RegisterEffect(e1)
	--summer
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(function(e,c) return Duel.GetTurnCount()%4==2 end)
	e2:SetValue(cm.lvval)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CHANGE_RANK)
	e5:SetValue(cm.rkval)
	c:RegisterEffect(e5)
	--autumn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(function(e,c) return Duel.GetTurnCount()%4==3 end)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(cm.damcon)
	e6:SetOperation(cm.damop)
	c:RegisterEffect(e6)
	--winter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetTargetRange(0xff,0xff)
	e4:SetValue(LOCATION_DECKBOT)
	e4:SetCondition(function(e,c) return Duel.GetTurnCount()%4==0 end)
	c:RegisterEffect(e4)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetRange(LOCATION_FZONE)
	e10:SetCode(EVENT_TO_DECK)
	e10:SetCondition(function(e,c) return Duel.GetTurnCount()%4==0 end)
	e10:SetOperation(cm.sortop)
	c:RegisterEffect(e10)
	--cannot be destroyed
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--cannot set/activate
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_SSET)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(1,0)
	e8:SetTarget(cm.setlimit)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(1,0)
	e9:SetValue(cm.actlimit)
	c:RegisterEffect(e9)
end
function cm.condition0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m+1)==0
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==4 then Duel.SendtoGrave(c,REASON_RULE) end
end
function cm.operation0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,2))
	local c=e:GetHandler()
	c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,0,1)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(cm.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,4)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then return 1 else return 0 end
end
function cm.lvval(e,c)
	return c:GetOriginalLevel()*2
end
function cm.rkval(e,c)
	return c:GetOriginalRank()*2
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.SetLP(ep,Duel.GetLP(ep)-300)
end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.sfilter(c,loc,p)
	return c:IsReason(REASON_REDIRECT) and c:IsLocation(loc) and (not p or c:IsControler(p))
end
function cm.sortop(e,tp,eg,ep,ev,re,r,rp)
	local tp=Duel.GetTurnPlayer()
	local g=eg:Filter(cm.sfilter,nil,LOCATION_DECK)
	local mg={}
	mg[1]=g:Filter(cm.sfilter,nil,LOCATION_DECK,tp)
	mg[2]=g:Filter(cm.sfilter,nil,LOCATION_DECK,1-tp)
	for i=1,2 do
		if #mg[i]>1 then
			local p=tp
			if i>1 then p=1-tp end
			for i=1,#mg[i] do
				local mgx=Duel.GetDecktopGroup(p,1)
				Duel.MoveSequence(mgx:GetFirst(),SEQ_DECKTOP)
			end
			Duel.SortDecktop(tp,p,#mg[i])
			for i=1,#mg[i] do
				local mgx=Duel.GetDecktopGroup(p,1)
				Duel.MoveSequence(mgx:GetFirst(),SEQ_DECKBOTTOM)
			end
		end
	end
	if #mg[2]>0 then Duel.ConfirmCards(tp,mg[2]) end
	if #mg[1]>0 then Duel.ConfirmCards(1-tp,mg[1]) end
end