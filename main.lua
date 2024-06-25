local mod = RegisterMod("Munkres Analysis Mod", 1)
local game = Game()
local munkresAnalysis = Isaac.GetItemIdByName("Munkres Analysis on Manifolds")
local need_to_update_floor = false
local used_r_key = false
local completed_r_key_use = false
local used_r_key_home = false
local need_to_use_glowing = false
local need_update_player = nil

if EID then
    EID:addCollectible(munkresAnalysis, "Upon use transports Isaac to the floor above and changes its layout#Gives Isaac a broken heart for each use", "Munkres Analysis on Manifolds")
end



function mod:MunkresUse(itemID, itemRNG, player)
    
    need_update_player = player
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
    if need_to_use_glowing == true then
        need_to_use_glowing = false
        player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false, -1, 0)

    end
    if need_to_update_floor == true then
        need_update_player:AddBrokenHearts(1)
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
                player:UseActiveItem(CollectibleType.COLLECTIBLE_R_KEY, false, false, true, false, -1, 0)
                used_r_key_home = true

            end
        elseif 2 <= stage and stage <= 9 then
            -- Base - ???
            if ( stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B) then
                -- Alternate path
                local randomStage = rng:RandomInt(1)
                if randomStage == 0  or stage == LevelStage.STAGE4_2 then
                    if stage == LevelStage.STAGE4_1 then
                        player:UseActiveItem(CollectibleType.COLLECTIBLE_R_KEY, false, false, true, false, -1, 0)
                        need_to_update_floor = false
                        used_r_key = true
                    else
                        Isaac.ExecuteCommand( "reseed" )
                        level:SetStage ( stage - 1 , StageType.STAGETYPE_REPENTANCE )
                    end 

                    
                    
                    
                else
                    if stage == LevelStage.STAGE4_1 then
                        player:UseActiveItem(CollectibleType.COLLECTIBLE_R_KEY, false, false, true, false, -1, 0)
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
    --[[
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
    --]]
    if used_r_key == true then
        completed_r_key_use = true
        used_r_key = false
    end
    if used_r_key_home == true then
        need_to_use_glowing = true
        used_r_key_home = false
    end



end


mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.MunkresUse, munkresAnalysis)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.updateFloor)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.depleteActive)