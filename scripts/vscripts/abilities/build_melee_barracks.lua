
local build_tower_base = require('abilities.build_tower_base')

-- 0 is true in lua. sadly this does not go well with
-- some dota c++ functions that return 0 on no value
local def = function(value, defaultValue)
    return value ~= 0 and value or defaultValue
end

build_melee_barracks = build_tower_base.MakeAbility({
    datadrivenName = 'npc_dota_envy_melee_barracks',
    ---@param tower CDOTA_BaseNPC
    ---@param abil CDOTABaseAbility
    OnCreated = function(tower, abil)
        tower:SetRenderColor(0,192,0)
        local spell = tower:FindAbilityByName("train_envy_melee_creep")
        if spell ~= nil then
            spell:ToggleAutoCast()
        end
        local dmgBase = def(abil:GetSpecialValueFor('dmg_base'), 20)
        local dmgMult = def(abil:GetSpecialValueFor('dmg_mult'), 1.5)
        local hpBase = def(abil:GetSpecialValueFor('hp_base'), 80)
        local hpMult = def(abil:GetSpecialValueFor('hp_mult'), 2.0)
        local dmg = dmgBase * math.pow(dmgMult, abil:GetLevel())
        local creepHp = hpBase * math.pow(hpMult, abil:GetLevel())
        tower:SetBaseDamageMin(dmg)
        tower:SetBaseDamageMax(dmg)
        -- 250 is likely something like "default" hp in dota, it is not included to "BaseMaxHealth"
        tower:SetBaseMaxHealth(math.max(creepHp * 4, 1))

        -- need to apply any modifier to update npc gui hp numbers
        tower:AddNewModifier(nil, nil, 'modifier_stunned', {duration = 0.05})
    end,
})