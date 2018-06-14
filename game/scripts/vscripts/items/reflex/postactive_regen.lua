LinkLuaModifier( "modifier_item_postactive_regen", "items/reflex/postactive_regen.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_generic_bonus", "modifiers/modifier_generic_bonus.lua", LUA_MODIFIER_MOTION_NONE)

item_regen_crystal_1 = class(ItemBaseClass)
item_regen_crystal_2 = item_regen_crystal_1
item_regen_crystal_3 = item_regen_crystal_1

function item_regen_crystal_1:GetIntrinsicModifierName()
  return "modifier_generic_bonus"
end

function item_regen_crystal_1:OnSpellStart()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, 'modifier_item_postactive_regen', {
    duration = self:GetSpecialValueFor( "duration" )
  })
end

modifier_item_postactive_regen = class(ModifierBaseClass)


function modifier_item_postactive_regen:OnCreated( kv )
  if IsServer() then
    if self.nPreviewFX == nil then
      self.nPreviewFX = ParticleManager:CreateParticle( "particles/items/regen_crystal/regen_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
      ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
    end
  end
end

function modifier_item_postactive_regen:OnDestroy(  )
  if IsServer() then
    if self.nPreviewFX ~= nil then
      ParticleManager:DestroyParticle( self.nPreviewFX, false )
      ParticleManager:ReleaseParticleIndex(self.nPreviewFX)
      self.nPreviewFX = nil
    end
  end
end

function modifier_item_postactive_regen:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
  }
end

function modifier_item_postactive_regen:GetModifierConstantHealthRegen()
  return self:GetAbility():GetSpecialValueFor( "active_health_regen" )
end
