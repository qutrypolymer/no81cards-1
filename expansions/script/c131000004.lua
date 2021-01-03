--Vivid BAD SQUAD 小豆泽心羽☆
local m=131000004
local cm=_G["c"..m]
function cm.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xacda),4,3,c131000004.ovfilter,aux.Stringid(131000004,2))
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(131000004,0))
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC_G)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetRange(LOCATION_PZONE)
    e0:SetCountLimit(1,10000000)
    e0:SetCondition(c131000004.pendcon)
    e0:SetOperation(c131000004.pendop)
    e0:SetValue(SUMMON_TYPE_PENDULUM)
    c:RegisterEffect(e0)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_CHAIN_SOLVED)
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetRange(LOCATION_PZONE)
    e5:SetOperation(c131000004.cpop)
    c:RegisterEffect(e5)   

    --Search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(131000004,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c131000004.thcost)
    e2:SetTarget(c131000004.thtg)
    e2:SetOperation(c131000004.thop)
    c:RegisterEffect(e2)



end
c131000004.pendulum_level=4
function c131000004.ovfilter(c)
    return c:IsFaceup() and c:IsCode(131000000) 
end

function c131000004.scfilter(c)
    return c:IsCode(131000001,131000005)
end
function c131000004.pendcon(e,c,og)
    if c==nil then return true end
    local tp=c:GetControler()
    local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
    if aux.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
    local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if rpz==nil or lpz==nil or (not Duel.IsExistingMatchingCard(c131000004.scfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler()))  then return false end
    local lscale=lpz:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end

    local loc=0
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND+LOCATION_DECK end
    if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
    if loc==0 then return false end


    if og then
        return og:IsExists(c131000004.PConditionFilter,1,nil,e,tp,lscale,rscale)
    else
        return Duel.IsExistingMatchingCard(c131000004.PConditionFilter,tp,loc,0,1,nil,e,tp,lscale,rscale)
    end
end
function c131000004.PConditionFilter(c,e,tp,lscale,rscale)
    local lv=0
    if c.pendulum_level then
        lv=c.pendulum_level
    else
        lv=c:GetLevel()
    end
    local bool=Auxiliary.PendulumSummonableBool(c)
    return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))  or (c:IsLocation(LOCATION_DECK) and c:IsType(TYPE_PENDULUM) and  c:IsSetCard(0xacda)  ))
        and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
        and not c:IsForbidden()
end
function c131000004.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
                Duel.Hint(HINT_CARD,0,131000004)
                local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
                local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
                local lscale=lpz:GetLeftScale()
                local rscale=rpz:GetRightScale()
                if lscale>rscale then lscale,rscale=rscale,lscale end
                local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
                local ft2=Duel.GetLocationCountFromEx(tp)
                local ft=Duel.GetUsableMZoneCount(tp)
                if Duel.IsPlayerAffectedByEffect(tp,59822133) then
                    if ft1>0 then ft1=1 end
                    if ft2>0 then ft2=1 end
                    ft=1
                end
                local loc=0
                local ct0=0
                if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_DECK end
                if ft2>0 then loc=loc+LOCATION_EXTRA end
                local tg=nil
                if og then
                    tg=og:Filter(Card.IsLocation,nil,loc):Filter(c131000004.PConditionFilter,nil,e,tp,lscale,rscale)
                else
                    tg=Duel.GetMatchingGroup(c131000004.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale)
                end

    local tp=e:GetOwnerPlayer()
    local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
    local ce=nil
    local b1=aux.PendulumChecklist&(0x1<<tp)==0
    local b2=#eset>0
    if b1 and b2 then
        local options={1163}
        for _,te in ipairs(eset) do
            table.insert(options,te:GetDescription())
        end
        local op=Duel.SelectOption(tp,table.unpack(options))
        if op>0 then
            ce=eset[op]
        end
    elseif b2 and not b1 then
        local options={}
        for _,te in ipairs(eset) do
            table.insert(options,te:GetDescription())
        end
        local op=Duel.SelectOption(tp,table.unpack(options))
        ce=eset[op+1]
    end

                ft0=1
                ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK))
                ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
                local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
                if ect and ect<ft2 then ft2=ect end
                while true do
                    local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK)
                    local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
                    local ct=ft
                    if ct1>ft1 then ct=math.min(ct,ft1) end
                    if ct2>ft2 then ct=math.min(ct,ft2) end
                    if ct<=0 then break end
                    if sg:GetCount()>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                    local g=tg:Select(tp,1,ct,nil)
                    tg:Sub(g)
                    sg:Merge(g)
                    if g:GetCount()<ct then ft=0 break end
                    ft=ft-g:GetCount()
                    ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK)
                    ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
                end
                if ft>0 then
                    local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK)
                    local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
                    if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
                        local ct=math.min(ft1,ft)
                        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                        local g=tg1:Select(tp,1,ct,nil)
                        sg:Merge(g)
                    end
                    if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
                        local ct=math.min(ft2,ft)
                        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                        local g=tg2:Select(tp,1,ct,nil)
                        sg:Merge(g)
                    end
                end
    if ce then
        Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
        ce:Reset()
    else
        aux.PendulumChecklist=aux.PendulumChecklist|(0x1<<tp)
    end
                Duel.HintSelection(Group.FromCards(lpz))
                Duel.HintSelection(Group.FromCards(rpz))
end
function c131000004.cpop(e,tp,eg,ep,ev,re,r,rp)
    local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    if lpz==nil  then return false end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(131000004,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC_G)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,10000000)
    e1:SetCondition(c131000004.pendcon)
    e1:SetOperation(c131000004.pendop)
    e1:SetValue(SUMMON_TYPE_PENDULUM)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    lpz:RegisterEffect(e1)
    lpz:RegisterFlagEffect(131000004,RESET_EVENT+0x1fe0000,0,1)
end


function c131000004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c131000004.thfilter(c)
    return c:IsRace(RACE_WARRIOR) and c:IsLevelBelow(4)
        and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToHand()
end
function c131000004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c131000004.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c131000004.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c131000004.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if not tc then return end
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tc)
end