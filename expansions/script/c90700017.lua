local m=90700017
local cm=_G["c"..m]
cm.name="钟楼使徒 泣"
if not pcall(function() require("expansions/script/c90700019") end) then require("expansions/script/c90700019") end
function cm.initial_effect(c)
	Seine_clock_tower.enable(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.actcon)
	c:RegisterEffect(e1)
end
function cm.actcon(e)
	return e:GetHandler():IsPublic()
end