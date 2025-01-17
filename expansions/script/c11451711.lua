--绛胧烈刃·发射频谱
local cm,m=GetID()
function cm.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	--e1:SetCountLimit(1)
	e1:SetCondition(cm.recon)
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.mvcon)
	e2:SetOperation(cm.mvop1)
	c:RegisterEffect(e2)
	--effect2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.mrtg)
	e3:SetOperation(cm.mrop)
	c:RegisterEffect(e3)
end
function cm.ccfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==tp
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0 --Duel.GetMatchingGroupCount(cm.ccfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,tp)==0
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	local t={}
	local i=1
	for i=1,7 do t[i]=i+2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x56e0000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),0,0,0)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:IsLocation(LOCATION_REMOVED) then
		c:RegisterFlagEffect(11451717,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(11451717,ct-3))
		c:RegisterFlagEffect(11451718,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,9-ct,aux.Stringid(11451718,9-ct))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabel(c:GetFieldID())
		e1:SetLabelObject(c)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local flag=c:GetFlagEffectLabel(11451718)
	if not flag or e:GetLabel()~=c:GetFieldID() then
		e:Reset()
	elseif flag>=9 then
		c:ResetFlagEffect(11451718)
		Duel.ReturnToField(c)
		e:Reset()
	else
		flag=flag+1
		c:ResetFlagEffect(11451718)
		c:RegisterFlagEffect(11451718,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(11451718,flag))
	end
end
function cm.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and not c:IsReason(REASON_SUMMON) and c:GetFlagEffect(11451717)>0
end
function cm.mvop1(e,tp,eg,ep,ev,re,r,rp)
	local n=11451718
	local cn=_G["c"..n]
	local chk=false
	while 1==1 do
		local off=1
		local ops={} 
		local opval={}
		if cm.mvop(e,tp,eg,ep,ev,re,r,rp,2) and not chk then
			ops[off]=aux.Stringid(n,10)
			opval[off-1]=1
			off=off+1
		end
		for i=11451711,11451715 do
			local ci=_G["c"..i]
			if ci and cn and cn[i] and Duel.GetFlagEffect(0,0xffffff+i)==0 and ci.mvop and ci.mvop(e,tp,eg,ep,ev,re,r,rp,2) then
				ops[off]=aux.Stringid(i,3)
				opval[off-1]=i-11451709
				off=off+1
			end
		end
		if off==1 then break end
		ops[off]=aux.Stringid(n,11)
		opval[off-1]=7
		--mobile adaption
		local ops2=ops
		local op=-1
		if off<=5 then
			op=Duel.SelectOption(tp,table.unpack(ops))
		else
			local page=0
			while op==-1 do
				if page==0 then
					ops2={table.unpack(ops,1,4)}
					table.insert(ops2,aux.Stringid(11451505,4))
					op=Duel.SelectOption(tp,table.unpack(ops2))
					if op==4 then op=-1 page=1 end
				else
					ops2={table.unpack(ops,5,off)}
					table.insert(ops2,1,aux.Stringid(11451505,3))
					op=Duel.SelectOption(tp,table.unpack(ops2))+3
					if op==3 then op=-1 page=0 end
				end
			end
		end
		if opval[op]==1 then
			cm.mvop(e,tp,eg,ep,ev,re,r,rp,0)
			chk=true
		elseif opval[op]>=2 and opval[op]<=6 then
			local ci=_G["c"..opval[op]+11451709]
			ci.mvop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif opval[op]==7 then break end
	end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp,opt)
	local c=e:GetHandler()
	local g=c:GetAttackableTarget()
	local b1=0
	local fid=e:GetLabel()
	if fid~=0 then b1=1 end
	if g and #g>0 and Duel.GetFlagEffect(0,m)==0 then
		if opt==2 then return true end
		Duel.HintSelection(Group.FromCards(c))
		--if Duel.SelectYesNo(tp,aux.Stringid(m,4+b1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
				e1:SetValue(c:GetFlagEffectLabel(11451717)*500)
				c:RegisterEffect(e1)
				Duel.CalculateDamage(c,tc)
				Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1)
			end
			if fid~=0 then Duel.RaiseEvent(c,11451718,e,fid,0,0,0) end
			if opt==1 then Duel.RegisterFlagEffect(0,0xffffff+m,RESET_PHASE+PHASE_END,0,1) end
		--end
	end
	--c:ResetFlagEffect(11451717)
end
function cm.pfilter(c)
	local seq=c:GetSequence()
	local p=c:GetControler()
	local loc=c:GetLocation()
	if c:IsLocation(LOCATION_FZONE) or c:IsLocation(LOCATION_PZONE) or seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(p,loc,seq-1)) or (seq<4 and Duel.CheckLocation(p,loc,seq+1))
end
function cm.mrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
end
function cm.mrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sc=Duel.SelectMatchingCard(tp,cm.pfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if sc then
		local seq=sc:GetSequence()
		local p=sc:GetControler()
		local b1=0
		if p~=tp then b1=1 end
		local loc=sc:GetLocation()
		local b2=0
		if loc==LOCATION_SZONE then b2=1 end
		if seq>4 then return end
		local flag=0
		if seq>0 and Duel.CheckLocation(p,loc,seq-1) then flag=flag|(1<<(seq-1+16*b1+8*b2)) end
		if seq<4 and Duel.CheckLocation(p,loc,seq+1) then flag=flag|(1<<(seq+1+16*b1+8*b2)) end
		if flag==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,~flag)
		local nseq=math.log(s,2)-16*b1-8*b2
		Duel.MoveSequence(sc,nseq)
	end
end