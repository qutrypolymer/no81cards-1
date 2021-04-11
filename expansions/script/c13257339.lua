--梦超时空战斗机-东风谷 早苗
local m=13257339
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	c:EnableCounterPermit(0x351)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.addc)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.pccon)
	e3:SetTarget(cm.pctg)
	e3:SetOperation(cm.pcop)
	c:RegisterEffect(e3)
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,6))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(cm.bombcost)
	e4:SetOperation(cm.bombop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(cm.bgmop)
	c:RegisterEffect(e11)
	eflist={{"power_capsule",e3},{"bomb",e4}}
	cm[c]=eflist
	
end
function cm.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsCanAddCounter(0x351,1) then
		e:GetHandler():AddCounter(0x351,1)
	end
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function cm.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.pcfilter,1,nil,1-tp)
end
function cm.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	e:SetCategory(CATEGORY_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Equip(tp,tc,c)
	end
end
function cm.tdfilter(c)
	return c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost()
end
function cm.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eqg=c:GetEquipGroup():Filter(Card.IsAbleToGraveAsCost,nil)
	local t1=eqg:GetCount()>0
	local t2=c:IsCanRemoveCounter(tp,0x351,1,REASON_COST)
	if chk==0 then return t1 or t2 end
	local op=0
	if t1 or t2 then
		local m1={}
		local n1={}
		local ct=1
		if t1 then m1[ct]=aux.Stringid(m,4) n1[ct]=1 ct=ct+1 end
		if t2 then m1[ct]=aux.Stringid(m,5) n1[ct]=2 ct=ct+1 end
		local sp=Duel.SelectOption(tp,table.unpack(m1))
		op=n1[sp+1]
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=eqg:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif op==2 then
		c:RemoveCounter(tp,0x351,1,REASON_COST)
	end
end
function cm.desfilter(c,ec)
	return ec:GetColumnGroup():IsContains(c)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.acfilter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function cm.desfilter(c)
	return c:IsFaceup() and (c:GetAttack()==0 or (c:GetDefense()==0 and not c:IsType(TYPE_LINK)))
end
function cm.bombop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(cm.efilter)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UPDATE_ATTACK)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e5:SetValue(500)
		c:RegisterEffect(e5)
	end
	local g1=Duel.GetMatchingGroup(cm.acfilter,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()>0 then
		local sc=g1:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-500)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g1:GetNext()
		end
	end
	g1=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(g1,REASON_EFFECT)
	end
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(m,7))
end
