--=====================================================================================
-- DiceTools Addon - Enhanced for BLU Development
--=====================================================================================

-- Basic initialization
local DiceTools = {}
local frame = CreateFrame("Frame")

-- Event registration
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Event handler function
local function OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        print("DiceTools addon loaded.")
    end
end

frame:SetScript("OnEvent", OnEvent)

--=====================================================================================
-- Slash Command Handling
--=====================================================================================

-- Basic slash commands
SLASH_DT1 = "/dt"
SlashCmdList["DT"] = function()
    print("DiceTools Commands:")
    print("/dt - List this menu")
    print("/info - Output game and UI info")
    print("/rl - Reload UI")
    print("/clear - Clear chat log")
    print("/renown - Output Renown info")
    print("/friendship - Output Friendship info")
    print("/playerlevel - Output Player level and experience")
    print("/charlevel - Output Character level and experience")
    print("/petinfo - Output Pet Journal details")
    print("/tradepost - Output TradePost activities")
    -- BLU-related commands
    print("/questinfo [quest name/ID] - Get quest details")
    print("/questavailable - List available quests")
    print("/zoneinfo [zone name] - Get zone details")
    print("/zonelist - List all zones and level ranges")
    print("/xpdetails - Show XP and leveling info")
    print("/xpsources - List XP sources in current zone")
    print("/api [function name] - Explore WoW API")
end

-- Info command to get game version
SLASH_INFO1 = "/info"
SlashCmdList["INFO"] = function()
    print("Game Version: " .. GetBuildInfo())
end

-- Reload UI command
SLASH_RL1 = "/rl"
SlashCmdList["RL"] = ReloadUI

-- Clear chat log command
SLASH_CLEAR1 = "/clear"
function SlashCmdList.CLEAR()
    for i = 1, NUM_CHAT_WINDOWS do
        _G["ChatFrame" .. i]:Clear()
    end
    print("Chat log cleared.")
end

--=====================================================================================
-- Pet Journal Debugging Command
--=====================================================================================

SLASH_PETINFO1 = "/petinfo"
SlashCmdList["PETINFO"] = function()
    local numPets = C_PetJournal.GetNumPets()
    if not numPets or numPets == 0 then
        print("No pets found in the Pet Journal.")
        return
    end

    for i = 1, numPets do
        local petID, speciesID, isOwned, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, canBattle, tradable, unique = C_PetJournal.GetPetInfoByIndex(i, false)

        print("Pet #" .. i)
        print("  petID: " .. tostring(petID))
        print("  speciesID: " .. tostring(speciesID))
        print("  isOwned: " .. tostring(isOwned))
        print("  customName: " .. tostring(customName))
        print("  level: " .. tostring(level))
        print("  xp: " .. tostring(xp))
        print("  maxXp: " .. tostring(maxXp))
        print("  displayID: " .. tostring(displayID))
        print("  isFavorite: " .. tostring(isFavorite))
        print("  name: " .. tostring(name))
        print("  icon: " .. tostring(icon))
        print("  petType: " .. tostring(petType))
        print("  creatureID: " .. tostring(creatureID))
        print("  canBattle: " .. tostring(canBattle))
        print("  tradable: " .. tostring(tradable))
        print("  unique: " .. tostring(unique))

        -- Fetch additional stats
        if petID then
            local health, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats(petID)
            print("  Stats for petID: " .. tostring(petID))
            print("    Health: " .. tostring(health))
            print("    Max Health: " .. tostring(maxHealth))
            print("    Power: " .. tostring(power))
            print("    Speed: " .. tostring(speed))
            print("    Rarity: " .. tostring(rarity))
        else
            print("  Invalid petID: " .. tostring(petID))
        end
    end
end

--=====================================================================================
-- Renown and Friendship Information
--=====================================================================================

SLASH_RENOWN1 = "/renown"
SlashCmdList["RENOWN"] = function()
    local renownFactions = C_Reputation.GetRenownFactions()

    if not renownFactions or #renownFactions == 0 then
        print("No Renown factions found.")
        return
    end

    for _, factionID in ipairs(renownFactions) do
        local renownInfo = C_Reputation.GetFactionParagonInfo(factionID)
        if renownInfo then
            print("Faction ID:", factionID)
            print("Renown Level:", renownInfo.renownLevel)
            print("Max Renown Level:", renownInfo.maxRenownLevel)
        else
            print("No valid Renown info for faction ID:", factionID)
        end
    end
end

SLASH_FRIENDSHIP1 = "/friendship"
SlashCmdList["FRIENDSHIP"] = function()
    local numFactions = GetNumFactions()
    for i = 1, numFactions do
        local name, _, standingID, _, _, _, _, _, _, _, _, _, isFriend = GetFactionInfo(i)
        if isFriend then
            local friendshipInfo = C_GossipInfo.GetFriendshipReputation(i)
            if friendshipInfo then
                print("Friendship with:", name)
                print("Standing:", friendshipInfo.reaction)
                print("Max Standing:", friendshipInfo.maxRep)
            end
        end
    end
end

--=====================================================================================
-- Player Level and Character Level Information
--=====================================================================================

SLASH_PLAYERLEVEL1 = "/playerlevel"
SlashCmdList["PLAYERLEVEL"] = function()
    local playerLevel = UnitLevel("player")
    local playerXP = UnitXP("player")
    local maxXP = UnitXPMax("player")

    print("Player Level:", playerLevel)
    print("Player XP:", playerXP)
    print("Max XP:", maxXP)
    print("XP to next level:", maxXP - playerXP)
end

SLASH_CHARLEVEL1 = "/charlevel"
SlashCmdList["CHARLEVEL"] = function()
    local charLevel = UnitEffectiveLevel("player")
    local charXP = UnitXP("player")
    local maxXP = UnitXPMax("player")

    print("Character Level:", charLevel)
    print("Character XP:", charXP)
    print("Max XP:", maxXP)
    print("XP to next level:", maxXP - charXP)
end

--=====================================================================================
-- TradePost Logic Re-Integrated from Older DiceTools Version
--=====================================================================================

SLASH_TRADEPOST1 = "/tradepost"
SlashCmdList["TRADEPOST"] = function()
    local activities = C_PerksActivities.GetPerksActivities()

    if not activities or #activities == 0 then
        print("No TradePost activities found.")
        return
    end

    print("TradePost Activities:")
    for _, activity in ipairs(activities) do
        local info = C_PerksActivities.GetActivityInfo(activity)
        if info then
            print("Activity ID:", info.id)
            print("Description:", info.description)
            print("Is Completed:", tostring(info.isComplete))
        else
            print("No valid info for activity ID:", activity)
        end
    end
end

--=====================================================================================
-- BLU Development Aids
--=====================================================================================

-- Quest Information
SLASH_QUESTINFO1 = "/questinfo"
SlashCmdList["QUESTINFO"] = function(args)
    local questNameOrID = args

    local questID = C_QuestLog.GetQuestIDByName(questNameOrID) 
    if not questID then
        questID = tonumber(questNameOrID) -- Try converting to a number if it's an ID
    end

    if questID then
        local questInfo = C_QuestLog.GetQuestInfo(questID)
        if questInfo then
            print("Quest Information:")
            print("- Title:", questInfo.title)
            print("- Level:", questInfo.level)
            print("- IsComplete:", tostring(questInfo.isComplete))
            print("- IsFailed:", tostring(questInfo.isFailed))
            
            -- Retrieve and print quest objectives
            local questObjectives = C_QuestLog.GetQuestObjectives(questID);
            if questObjectives then
                print("- Objectives:")
                for _, objective in ipairs(questObjectives) do
                    print("  * " .. objective.text .. " (" .. objective.numFulfilled .. "/" .. objective.numRequired .. ")")
                end
            end

            -- Retrieve and print quest rewards
            local rewardXP = GetQuestLogRewardXP(questID)
            local rewardMoney = GetQuestLogRewardMoney(questID)
            local numRewardChoices = GetNumQuestLogRewardChoices(questID)
            local numRewardItems = GetNumQuestLogRewards(questID)

            print("- Rewards:")
            if rewardXP > 0 then 
                print("  * XP:", rewardXP) 
            end
            if rewardMoney > 0 then 
                print("  * Money:", rewardMoney) 
            end
            if numRewardChoices > 0 then
                print("  * Choices:")
                for i = 1, numRewardChoices do
                    local name, texture, numItems, quality, isUsable = GetQuestLogRewardChoiceInfo(i)
                    print("    - " .. name .. " (x" .. numItems .. ")")
                end
            end
            if numRewardItems > 0 then
                print("  * Items:")
                for i = 1, numRewardItems do
                    local name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i)
                    print("    - " .. name .. " (x" .. numItems .. ")")
                end
            end
        else
            print("Quest not found.")
        end
    else
        print("Invalid quest name or ID.")
    end
end

-- List available quests in the current zone
SLASH_QUESTAVAILABLE1 = "/questavailable"
SlashCmdList["QUESTAVAILABLE"] = function()
    local currentMapID = C_Map.GetBestMapForUnit("player")
    local quests = C_QuestLog.GetQuestsOnMap(currentMapID)

    if quests and #quests > 0 then
        print("Available quests in the current zone:")
        for _, quest in ipairs(quests) do
            print("- " .. quest.title)
        end
    else
        print("No available quests in the current zone.")
    end
end

--=====================================================================================
-- Zone Information
--=====================================================================================

SLASH_ZONEINFO1 = "/zoneinfo"
SlashCmdList["ZONEINFO"] = function(zoneName)
    local mapID = C_Map.GetMapInfoByName(zoneName)
    if not mapID then
        print("Zone not found: " .. zoneName)
        return
    end

    local mapInfo = C_Map.GetMapInfo(mapID)
    if mapInfo then
        print("Zone Information:")
        print("- Name:", mapInfo.name)
        print("- Map ID:", mapID)
        print("- Parent Map ID:", mapInfo.parentMapID)
    else
        print("No information found for zone: " .. zoneName)
    end
end

SLASH_ZONELIST1 = "/zonelist"
SlashCmdList["ZONELIST"] = function()
    local continents = C_Map.GetMapChildrenInfo(947, Enum.UIMapType.Continent, true) -- 947 is Azeroth's Map ID

    print("List of Continents and Zones:")
    for _, continent in ipairs(continents) do
        print("- Continent: " .. continent.name)
        local zones = C_Map.GetMapChildrenInfo(continent.mapID, Enum.UIMapType.Zone, true)
        for _, zone in ipairs(zones) do
            print("  - Zone: " .. zone.name)
        end
    end
end

--=====================================================================================
-- Experience and Leveling Details
--=====================================================================================

SLASH_XPDETAILS1 = "/xpdetails"
SlashCmdList["XPDETAILS"] = function()
    local playerLevel = UnitLevel("player")
    local playerXP = UnitXP("player")
    local maxXP = UnitXPMax("player")
    local restedXP = GetXPExhaustion() or 0

    print("XP Details:")
    print("- Level:", playerLevel)
    print("- Current XP:", playerXP .. "/" .. maxXP)
    print("- XP to Next Level:", maxXP - playerXP)
    print("- Rested XP:", restedXP)
end

SLASH_XPSOURCES1 = "/xpsources"
SlashCmdList["XPSOURCES"] = function()
    -- Placeholder: Implement logic to list XP sources in current zone (quests, mobs, etc.)
    print("XP sources not yet implemented.")
end

--=====================================================================================
-- General API Exploration Command
--=====================================================================================

SLASH_API1 = "/api"
SlashCmdList["API"] = function(apiFunction)
    local func = _G[apiFunction]

    if func then
        local success, result = pcall(func)
        if success then
            print("API Call Result:")
            if type(result) == "table" then
                for k, v in pairs(result) do
                    print(k, v)
                end
            else
                print(tostring(result))
            end
        else
            print("Error calling API function: " .. result)
        end
    else
        print("API function not found: " .. apiFunction)
    end
end
