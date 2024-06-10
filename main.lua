local mod = RegisterMod("Munkres Analysis Mod", 1)
local game = Game()
local munkresAnalysis = Isaac.GetItemIdByName("Munkres Analysis on Manifolds")
local need_to_update_floor = false


if EID then
    EID:addCollectible(munkresAnalysis, "Upon use transports Isaac to the floor above and changes its layout#Depletes charge upon entering a new floor", "Munkres Analysis on Manifolds")
end



function mod:MunkresUse(item)
    
    local level = game:GetLevel()
    local stage = level:GetStage()
    local stageType = level:GetStageType()

    local player = Isaac.GetPlayer()
    local rng = player:GetCollectibleRNG(munkresAnalysis)
    need_to_update_floor = true
    if stage == LevelStage.STAGE1_1 then
        -- Basement / Downpour I:
        if ( stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B) then
            -- Downpour:
            local randomStage = rng:RandomInt(2)
            if randomStage == 0 then
                level:SetStage ( LevelStage.STAGE1_1 , StageType.STAGETYPE_ORIGINAL )
            elseif randomStage == 1 then
                level:SetStage ( LevelStage.STAGE1_1 , StageType.STAGETYPE_WOTL )
            else
                level:SetStage ( LevelStage.STAGE1_1 , StageType.STAGETYPE_AFTERBIRTH )
            end
        else
            --Basement:
            need_to_update_floor = false

        end
    elseif 2 <= stage and stage <= 9 then
        -- Base - ???
        if ( stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B) then
            -- Alternate path
            local randomStage = rng:RandomInt(1)
            if randomStage == 0  or stage == LevelStage.STAGE4_2 then
                level:SetStage ( stage - 1 , StageType.STAGETYPE_REPENTANCE )
            else
                level:SetStage ( stage - 1 , StageType.STAGETYPE_REPENTANCE_B )
            end

        else
            --Main path
            local randomStage = rng:RandomInt(2)
            if randomStage == 0 then
                level:SetStage ( stage - 1 , StageType.STAGETYPE_ORIGINAL )
            elseif randomStage == 1 then
                level:SetStage ( stage - 1 , StageType.STAGETYPE_WOTL )
            else
                level:SetStage ( stage - 1 , StageType.STAGETYPE_AFTERBIRTH )
            end
        end
    elseif stage == LevelStage.STAGE5 then
        --Main path
        local randomStage = rng:RandomInt(2)
        if randomStage == 0 then
            level:SetStage ( LevelStage.STAGE4_2 , StageType.STAGETYPE_ORIGINAL )
        elseif randomStage == 1 then
            level:SetStage ( LevelStage.STAGE4_2 , StageType.STAGETYPE_WOTL )
        else
            level:SetStage ( LevelStage.STAGE4_2 , StageType.STAGETYPE_AFTERBIRTH )
        end


    elseif stage == LevelStage.STAGE7 then
        level:SetStage ( LevelStage.STAGE4_3 , stageType )


    elseif stage == LevelStage.STAGE8 then
        need_to_update_floor = false
    else 
        level:SetStage ( stage - 1 , stageType )
    end




    
    --Isaac.ExecuteCommand( "restart" )
    --game:StartStageTransition( true, 1, player )
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

function mod:updateFloor()
    local player = Isaac.GetPlayer()    
    if need_to_update_floor == true then
        --Game():StartStageTransition(true, 1 , player)
        Isaac.ExecuteCommand( "reseed" )
        need_to_update_floor = false
    end
end

function mod:depleteActive()
    
    local playerCount = game:GetNumPlayers()
    
    for playerIndex = 0, playerCount - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local blood_charges = player:GetBloodCharge()
        local soul_charges = player:GetSoulCharge()
        for slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
            if player:GetActiveItem(slot) == munkresAnalysis then
                player:SetActiveCharge(slot)
                player:SetSoulCharge(soul_charges)
                player:SetBloodCharge(blood_charges)

            end
        end

    end



end


mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.MunkresUse, munkresAnalysis)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.updateFloor)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.depleteActive)