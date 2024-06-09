local mod = RegisterMod("Munkres Analysis Mod", 1)
local game = Game()
local munkresAnalysis = Isaac.GetItemIdByName("Munkres Analysis on Manifolds")
local MUNKRES_NUMBER_OF_SLOTS = 4
local munkres_inventory = {}

function mod:MunkresUse(item)
    local player = Isaac.GetPlayer()
    local level = game:GetLevel()
    local stage = level:GetStage()
    local stageType = level:GetStageType()

    level:SetStage ( 1, 0 )
    
    return {
        Discharge = false,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.MunkresUse, munkresAnalysis)