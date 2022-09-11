--渊异术士 月醒龙
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000450") end) then require("script/c20000450") end
function cm.initial_effect(c)
	cm.Hand_Be_Open = fu_Abyss.Hand_Be_Open(c,m,cm.tg1,cm.op1)
	local e1,e2 = fu_Abyss.Hand_Open(c,cm.op2)
end
--e1
function cm.tgf1(c)
	return c:IsAbleToGrave() and c:GetType()&0x82==0x82
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local v=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not v then return end
	Duel.SendtoGrave(v,REASON_EFFECT)
end
--e2
function cm.opf2(c,e)
	return c:GetType()&0x81==0x81 and c:IsRace(RACE_DRAGON) and not c:IsImmuneToEffect(e) and c:IsFaceup()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(24,0,aux.Stringid(m,0))
	local g=Duel.GetMatchingGroup(cm.opf2,tp,LOCATION_MZONE,0,nil,e)
	if #g==0 then return end
	local v=Duel.GetMatchingGroupCount(Card.IsPublic,tp,LOCATION_HAND,0,nil)*300
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		e1:SetValue(v)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end