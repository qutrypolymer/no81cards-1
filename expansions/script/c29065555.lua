--方舟骑士-玛恩纳
c29065555.named_with_Arknight=1
function c29065555.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c29065555.mfilter,nil,2,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c29065555.atkop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c29065555.discon)
	e3:SetCost(c29065555.discost)
	e3:SetTarget(c29065555.distg)
	e3:SetOperation(c29065555.disop)
	c:RegisterEffect(e3)
end
function c29065555.mfilter(c,xyzc)
	return (c:IsXyzLevel(xyzc,5) or c:IsXyzLevel(xyzc,6)) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c29065555.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler()~=c and c:GetFlagEffect(1)>0 and c:GetFlagEffect(29065555)<8 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(29065555,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c29065555.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c29065555.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065555.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local atk=c:GetAttack()-c:GetBaseAttack()
	local b1=atk>=1000 and atk<2000 and rc:IsRelateToEffect(re) and rc:IsDestructable()
	local b2=atk>=2000 Duel.IsChainNegatable(ev)
	if chk==0 then return b1 or b2 end
end
function c29065555.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local preatk=c:GetAttack()
	local atk=preatk-c:GetBaseAttack()
	if atk<=0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	atk=preatk-c:GetAttack()
	if atk<1000 then return end
	if atk<2000 then
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	elseif atk<4000 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	else
		if Duel.NegateActivation(ev) then
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end