--方舟骑士·年
c29002020.named_with_Arknight=1
function c29002020.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),12,12,c29002020.ovfilter,aux.Stringid(29002020,0),12,c29002020.xyzop)
	c:EnableReviveLimit()   
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29002020,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCost(c29002020.icost)
	e3:SetTarget(c29002020.itarget)
	e3:SetOperation(c29002020.ioperation)
	c:RegisterEffect(e3)  
end 
function c29002020.ovfilter(c)
	local tp=c:GetControler()
	local x=Duel.GetActivityCount(tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)+Duel.GetActivityCount(1-tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(1-tp,ACTIVITY_SPSUMMON)
	return c:IsFaceup() and x>=12 and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) 
end 
function c29002020.xyzop(e,tp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29002020.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c29002020.icost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29002020.itarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c29002020.ioperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c29002020.val)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c29002020.efilter)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END) 
	e2:SetOwnerPlayer(tp) 
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(29002020,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(29002020)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
end
function c29002020.val(e,c)
	return c:GetBaseDefense()/2
end
function c29002020.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function c29002020.lrop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) then return false end
end