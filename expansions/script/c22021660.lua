--人理之诗 万古不变的迷宫
function c22021660.initial_effect(c)
	aux.AddCodeList(c,22021650)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c22021660.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c22021660.disable)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c22021660.spcon1)
	e4:SetTarget(c22021660.disable1)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(c22021660.spcon1)
	e5:SetTarget(c22021660.disable1)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetCondition(c22021660.spcon2)
	e6:SetTarget(c22021660.disable1)
	e6:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetCondition(c22021660.spcon2)
	e7:SetTarget(c22021660.disable1)
	e7:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e7)
end
function c22021660.disable(e,c)
	return c:IsType(TYPE_MONSTER) and not c:IsSetCard(0xff1)
end
function c22021660.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,22021670)
end
function c22021660.disable1(e,c)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(22021650)
end
function c22021660.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(1-tp,22021670)
end