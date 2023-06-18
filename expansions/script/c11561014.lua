--变貌大妃 似似花
function c11561014.initial_effect(c)
	c:EnableCounterPermit(0x1) 
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	--counter 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetCountLimit(1,11561014) 
	e1:SetTarget(c11561014.addtg)
	e1:SetOperation(c11561014.addop)
	c:RegisterEffect(e1)   
	--token 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,21561014) 
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,4,REASON_COST) end)
	e2:SetTarget(c11561014.tktg) 
	e2:SetOperation(c11561014.tkop) 
	c:RegisterEffect(e2)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c11561014.desreptg)
	e3:SetOperation(c11561014.desrepop)
	c:RegisterEffect(e3)
end
function c11561014.addtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=e:GetHandler():GetMaterialCount() 
	if chk==0 then return x>0 and e:GetHandler():IsCanAddCounter(0x1,x) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,x,0,0x1)
end
function c11561014.addop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=c:GetMaterialCount()  
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x1,x)
	end
end 
function c11561014.tkfil(c,e,tp) 
	local zone=e:GetHandler():GetLinkedZone()
	return c:GetLevel()>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,11561015,0,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())   
end 
function c11561014.tktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local zone=e:GetHandler():GetLinkedZone()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsExistingTarget(c11561014.tkfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c11561014.tkfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11561014.tkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local zone=e:GetHandler():GetLinkedZone()
	local ec=Duel.GetFirstTarget()
	if not ec:IsRelateToEffect(e) or ec:IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,11561015,0,TYPES_TOKEN_MONSTER,ec:GetAttack(),ec:GetDefense(),ec:GetLevel(),ec:GetRace(),ec:GetAttribute()) then return end
	ec:RegisterFlagEffect(11561014,RESET_EVENT+0x17a0000,0,0)
	local token=Duel.CreateToken(tp,11561015)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(ec:GetAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(ec:GetDefense())
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(ec:GetLevel())
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(ec:GetRace())
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(ec:GetAttribute())
	token:RegisterEffect(e5)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP,zone) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(function(e)  
	return e:GetHandler():GetAttack()*2 end)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1) 
	local code=ec:GetOriginalCodeRule() 
	cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1) 
	local de=Effect.CreateEffect(e:GetHandler())
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetRange(LOCATION_MZONE)
	de:SetCode(EVENT_TO_GRAVE)
	de:SetLabelObject(e1,c) 
	de:SetLabel(cid)  
	de:SetCondition(c11561014.rstcon)
	de:SetOperation(c11561014.rstop) 
	de:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(de)
end 
function c11561014.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local e1,tc=e:GetLabelObject()
	return e1 and tc and tc:IsOnField()	
end 
function c11561014.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1,tc=e:GetLabelObject()  
	local cid=e:GetLabel() 
	if cid~=0 then 
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end 
	e1:Reset() 
	Duel.Hint(HINT_CARD,0,11561014)  
	Duel.HintSelection(Group.FromCards(tc)) 
end
function c11561014.repfilter(c,e)
	return c:IsFaceup() and c:IsCode(11561015) 
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c11561014.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c11561014.repfilter,tp,LOCATION_MZONE,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c11561014.repfilter,tp,LOCATION_MZONE,0,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c11561014.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end




