local m=53739014
local cm=_G["c"..m]
cm.name="异金之圣殿"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	local e5=e3:Clone()
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCode(EFFECT_ADD_TYPE)
	e6:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_REMOVE_TYPE)
	e7:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,3))
	e8:SetCategory(CATEGORY_POSITION)
	e8:SetType(EFFECT_TYPE_ACTIVATE)
	e8:SetCode(EVENT_BE_BATTLE_TARGET)
	e8:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e8:SetCondition(cm.poscon2)
	e8:SetTarget(cm.postg)
	e8:SetOperation(cm.posop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCondition(cm.poscon1)
	e9:SetCode(EVENT_BECOME_TARGET)
	c:RegisterEffect(e9)
	local e10=e8:Clone()
	e10:SetDescription(aux.Stringid(m,1))
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetDescription(aux.Stringid(m,1))
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e11)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d~=nil and d:IsPosition(POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d~=nil and d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
function cm.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsCanTurnSet()
end
function cm.poscon1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil)
	g:KeepAlive()
	e:SetLabelObject(g)
	return #g>0
end
function cm.poscon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local g=Group.FromCards(tc)
	g:KeepAlive()
	e:SetLabelObject(g)
	return tc and tc:IsFaceup() and tc:IsCanTurnSet()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return true end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function cm.filter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.filter,nil,e)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
