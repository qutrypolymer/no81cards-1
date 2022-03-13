--暗金教
local m=10419905
local cm=_G["c"..m]
cm.named_with_Kabal=1
function cm.Kabal(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kabal
end
function cm.Potion(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Potion
end

function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(10419902)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(cm.ntcon)
	c:RegisterEffect(e2)
	--to hand instead of send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.rthcon)
	e3:SetOperation(cm.rthop)
	c:RegisterEffect(e3)
end
function cm.ntfilter(c)
	return c:IsFaceup() and cm.Potion(c)
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and Duel.IsExistingMatchingCard(cm.ntfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.rthcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.GetFlagEffect(tp,m)==0 and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL|TYPE_TRAP)
		and rc:IsType(TYPE_SPELL|TYPE_TRAP) and rc:IsRelateToEffect(re) and rc:IsStatus(STATUS_LEAVE_CONFIRMED) and cm.Potion(rc)
end
function cm.rthop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,rc,aux.Stringid(m,1)) then
		rc:CancelToGrave()
		Duel.SendtoHand(rc,nil,REASON_EFFECT)
		Duel.RaiseEvent(rc,EVENT_TO_HAND,e,REASON_EFFECT,tp,tp,0)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,0)
	end
end
