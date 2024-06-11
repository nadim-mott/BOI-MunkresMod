local mod = RegisterMod("Munkres Analysis Mod", 1)
local game = Game()
local munkresAnalysis = Isaac.GetItemIdByName("Munkres Analysis on Manifolds")
local need_to_update_floor = false
local used_r_key = false
local completed_r_key_use = false


if EID then
    EID:addCollectible(munkresAnalysis, "Upon use transports Isaac to the floor above and changes its layout#Depletes charge upon entering a new floor", "Munkres Analysis on Manifolds")
end



function mod:MunkresUse(item)
    local playerCount = game:GetNumPlayers()
    local player = Isaac.GetPlayer(playerIndex)
    for playerIndex = 0, playerCount - 1 do
        for slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
            if player:GetActiveItem(slot) == munkresAnalysis then
                Isaac.GetPlayer():AddBrokenHearts(1)
            end
        end

    end
    need_to_update_floor = true
       
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
    if completed_r_key_use == true then
        completed_r_key_use = false
        local level = game:GetLevel()
        level:SetStage ( LevelStage.STAGE3_2 , StageType.STAGETYPE_REPENTANCE )
        Isaac.ExecuteCommand( "reseed" )

    end
    if need_to_update_floor == true then
        --Game():StartStageTransition(true, 1 , player)
        local level = game:GetLevel()
        local stage = level:GetStage()
        local stageType = level:GetStageType()

        local player = Isaac.GetPlayer()
        local rng = player:GetCollectibleRNG(munkresAnalysis)
        
        if stage == LevelStage.STAGE1_1 then
            -- Basement / Downpour I:
            if ( stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B) then
                -- Downpour:
                local randomStage = rng:RandomInt(2)
                if randomStage == 0 then
                    Isaac.ExecuteCommand( "reseed" )
                    level:SetStage ( LevelStage.STAGE1_1 , StageType.STAGETYPE_ORIGINAL )
                elseif randomStage == 1 then
                    Isaac.ExecuteCommand( "reseed" )
                    level:SetStage ( LevelStage.STAGE1_1 , StageType.STAGETYPE_WOTL )
                else
                    Isaac.ExecuteCommand( "reseed" )
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
                    if stage == LevelStage.STAGE4_1 then
                        player:UseActiveItem(CollectibleType.COLLECTIBLE_R_KEY)
                        need_to_update_floor = false
                        used_r_key = true
                    else
                        Isaac.ExecuteCommand( "reseed" )
                        level:SetStage ( stage - 1 , StageType.STAGETYPE_REPENTANCE )
                    end
                    
                    
                else
                    if stage == LevelStage.STAGE4_1 then
                        player:UseActiveItem(CollectibleType.COLLECTIBLE_R_KEY)
                        need_to_update_floor = false 
                        used_r_key = true
                    else
                        Isaac.ExecuteCommand( "reseed" )
                        level:SetStage ( stage - 1 , StageType.STAGETYPE_REPENTANCE_B )
                    end
                    
                end

            else
                --Main path
                local randomStage = rng:RandomInt(2)
                if randomStage == 0 then
                    Isaac.ExecuteCommand( "reseed" )
                    level:SetStage ( stage - 1 , StageType.STAGETYPE_ORIGINAL )
                elseif randomStage == 1 then
                    Isaac.ExecuteCommand( "reseed" )
                    level:SetStage ( stage - 1 , StageType.STAGETYPE_WOTL )
                else
                    Isaac.ExecuteCommand( "reseed" )
                    level:SetStage ( stage - 1 , StageType.STAGETYPE_AFTERBIRTH )
                end
            end
        elseif stage == LevelStage.STAGE5 then
            --Main path
            local randomStage = rng:RandomInt(2)
            if randomStage == 0 then
                Isaac.ExecuteCommand( "reseed" )
                level:SetStage ( LevelStage.STAGE4_2 , StageType.STAGETYPE_ORIGINAL )
            elseif randomStage == 1 then
                Isaac.ExecuteCommand( "reseed" )
                level:SetStage ( LevelStage.STAGE4_2 , StageType.STAGETYPE_WOTL )
            else
                Isaac.ExecuteCommand( "reseed" )
                level:SetStage ( LevelStage.STAGE4_2 , StageType.STAGETYPE_AFTERBIRTH )
            end


        elseif stage == LevelStage.STAGE7 then
            Isaac.ExecuteCommand( "reseed" )
            level:SetStage ( LevelStage.STAGE4_3 , stageType )


        elseif stage == LevelStage.STAGE8 then
            need_to_update_floor = false
        else 
            Isaac.ExecuteCommand( "reseed" )
            level:SetStage ( stage - 1 , stageType )
        end

        if need_to_update_floor == true then
            Isaac.ExecuteCommand( "reseed" )
        end
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
    if used_r_key == true then
        completed_r_key_use = true
        used_r_key = false
    end



end


mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.MunkresUse, munkresAnalysis)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.updateFloor)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.depleteActive)