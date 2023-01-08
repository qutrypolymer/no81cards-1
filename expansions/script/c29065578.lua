--Mon3tr
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,m)
	aux.AddCodeList(c,29056009)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetCondition(cm.con4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(cm.con5)
	c:RegisterEffect(e5)
end
--e2
function cm.con2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):IsExists(Card.IsCode,1,nil,29056009) 
		and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,1,REASON_COST)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x10ae,1,REASON_COST)
end
--e4
function cm.con4(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
--e5
function cm.con5(e)
	return not Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil):IsExists(Card.IsCode,1,nil,29056009) 
end