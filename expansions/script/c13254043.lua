--元始飞球秘术·耀光
local m=13254043
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--steam
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	elements={{"tama_elements",{{TAMA_ELEMENT_ORDER,1},{TAMA_ELEMENT_MANA,1}}}}
	cm[c]=elements
	
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_ORDER,1}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x356))
	e3:SetValue(cm.efilter)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_ORDER,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,e:GetHandler()),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el) and e:GetHandler():IsAbleToRemoveAsCost()
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x356))
	e3:SetValue(cm.efilter)
	e3:SetReset(RESET_EVENT+EVENT_CHAIN_END)
	Duel.RegisterEffect(e3,tp)
end
