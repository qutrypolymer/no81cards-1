--真龙战士 点火烈·炽热
function c12249903.initial_effect(c)
    --summon with s/t
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(12249903,0))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c12249903.otcon)
    e1:SetOperation(c12249903.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(12249903,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c12249903.thcon)
    e2:SetTarget(c12249903.thtg)
    e2:SetOperation(c12249903.thop)
    c:RegisterEffect(e2)
end
function c12249903.otfilter(c)
    return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()
end
function c12249903.otcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    return c:GetLevel()>4 and minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c12249903.otfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c12249903.otop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local sg=Duel.SelectMatchingCard(tp,c12249903.otfilter,tp,LOCATION_SZONE,0,1,1,nil)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c12249903.thcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and rp~=tp
end
function c12249903.thfilter(c,tp)
    return c:IsSetCard(0xf9) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
        and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c12249903.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c12249903.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12249903.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12249903,3))
    local g=Duel.SelectMatchingCard(tp,c12249903.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        local b1=tc:IsAbleToHand()
        local b2=tc:GetActivateEffect():IsActivatable(tp)
        if b1 and (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not b2 or Duel.SelectYesNo(tp,aux.Stringid(12249903,2))) then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        else
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            local te=tc:GetActivateEffect()
            local tep=tc:GetControler()
            local cost=te:GetCost()
            if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
            Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
        end
    end
end
