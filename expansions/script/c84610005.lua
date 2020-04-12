--ＥＭ振り子の魔術師
function c84610005.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum set
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(84610005,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c84610005.pctg)
    e1:SetOperation(c84610005.pcop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(84610005,1))    
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1) 
    e2:SetCondition(c84610005.pencon)
    e2:SetTarget(c84610005.thtg)
    e2:SetOperation(c84610005.thop)
    c:RegisterEffect(e2)
    --change scale
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(84610005,2))
    e3:SetCategory(CATEGORY_TOEXTRA)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1,84610005)
    e3:SetTarget(c84610005.sctg)
    e3:SetOperation(c84610005.scop)
    c:RegisterEffect(e3)    
    --Attribute Dark
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_ADD_ATTRIBUTE)
    e1:SetValue(ATTRIBUTE_DARK)
    c:RegisterEffect(e1)    
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetTarget(c84610005.target)
    e2:SetOperation(c84610005.operation)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)    
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCondition(c84610005.spcon1)
    e4:SetTarget(c84610005.sptg)
    e4:SetOperation(c84610005.spop)
    c:RegisterEffect(e4)    
end     
function c84610005.pcfilter(c)
    return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c84610005.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
        and Duel.IsExistingMatchingCard(c84610005.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c84610005.pcop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c84610005.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end 
function c84610005.penfilter(c)
    return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x98) or c:IsSetCard(0x9f) or c:IsSetCard(0xf2)) 
end
function c84610005.pencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c84610005.penfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c84610005.thfilter(c,e,tp)
    return (c:IsSetCard(0x98) or c:IsSetCard(0x9f) or c:IsSetCard(0xf2)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
    if chk==0 then return Duel.IsExistingMatchingCard(c84610005.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetTargetCard(sc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84610005.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c84610005.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function c84610005.scfilter(c,pc)
    return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x98) or c:IsSetCard(0x9f) or c:IsSetCard(0xf2)) and not c:IsForbidden()
end
function c84610005.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610005.scfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c84610005.scop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29432356,1))
    local g=Duel.SelectMatchingCard(tp,c84610005.scfilter,tp,LOCATION_DECK,0,1,1,nil,c)
    local tc=g:GetFirst()
    if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LSCALE)
        e1:SetValue(tc:GetLeftScale())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CHANGE_RSCALE)
        e2:SetValue(tc:GetRightScale())
        c:RegisterEffect(e2)
    end
end
function c84610005.filter(c)
    return (c:IsType(TYPE_PENDULUM) or c:IsSetCard(0xf2)) and c:IsAbleToHand()
end
function c84610005.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610005.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84610005.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c84610005.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c84610005.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c84610005.spfilter(c,e,tp)
    return c:IsSetCard(0x98) or c:IsSetCard(0x9f) or c:IsSetCard(0xf2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84610005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c84610005.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c84610005.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c84610005.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
