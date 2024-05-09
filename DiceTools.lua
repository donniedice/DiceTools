--v1.0.0
-- Function to output major faction data
local function OutputMajorFactionData()
    print("Major Faction Data:")
    for _, majorFactionID in ipairs(C_MajorFactions.GetMajorFactionIDs()) do
        local data = C_MajorFactions.GetMajorFactionData(majorFactionID)
        if data then
            print("Name: " .. data.name)
            print("Faction ID: " .. data.factionID)
            print("Expansion ID: " .. data.expansionID)
            print("Bounty Set ID: " .. data.bountySetID)
            print("Is Unlocked: " .. tostring(data.isUnlocked))
            print("Unlock Description: " .. (data.unlockDescription or "None"))
            print("UI Priority: " .. data.uiPriority)
            print("Renown Level: " .. data.renownLevel)
            print("Renown Reputation Earned: " .. data.renownReputationEarned)
            print("Renown Level Threshold: " .. data.renownLevelThreshold)
            print("Texture Kit: " .. data.textureKit)
            print("Celebration Sound Kit: " .. data.celebrationSoundKit)
            print("Renown Fanfare Sound Kit ID: " .. data.renownFanfareSoundKitID)
            print("------------------------------------")
        end
    end
end

-- Function to print perks activities data including specific parts
local function PrintPerksActivitiesData(option, id)
    print("Perks Activities Data:")
    print("Option:", option)
    print("ID:", id)
    local perksInfo = C_PerksActivities.GetPerksActivitiesInfo()
    if perksInfo then
        print("Active Perks Month: " .. perksInfo.activePerksMonth)
        print("Display Month Name: " .. perksInfo.displayMonthName)
        print("Seconds Remaining: " .. perksInfo.secondsRemaining)
        print("------------------------------------")
        print("Activities:")
        for _, activity in ipairs(perksInfo.activities) do
            if option == "-idname" then
                print("ID: " .. activity.ID .. ", Name: " .. activity.activityName)
            elseif option == "-progress" and tonumber(id) == activity.ID then
                print("Printing progress for perk ID:", id)
                if activity.progressInfo then
                    print("Progress Info:")
                    for _, progress in ipairs(activity.progressInfo) do
                        print("Progress Name: " .. progress.progressName)
                        print("Progress Quantity: " .. progress.progressQuantity)
                        print("------------------------------------")
                    end
                else
                    print("No progress info available for perk ID: " .. id)
                end
                return  -- Exit the function after printing progress for the specified ID
            else
                print("ID: " .. activity.ID)
                print("Name: " .. activity.activityName)
                print("Description: " .. activity.description)
                print("Completed: " .. tostring(activity.completed))
                print("In Progress: " .. tostring(activity.inProgress))
                print("Tracked: " .. tostring(activity.tracked))
                print("Supersedes: " .. activity.supersedes)
                print("UI Priority: " .. activity.uiPriority)
                print("Are All Conditions Met: " .. tostring(activity.areAllConditionsMet))
                print("Event Name: " .. (activity.eventName or "None"))
                print("Event Start Time: " .. (activity.eventStartTime or "None"))
                print("Event End Time: " .. (activity.eventEndTime or "None"))
                if activity.progressInfo then
                    print("Progress Info:")
                    for _, progress in ipairs(activity.progressInfo) do
                        print("Progress Name: " .. progress.progressName)
                        print("Progress Quantity: " .. progress.progressQuantity)
                        print("------------------------------------")
                    end
                else
                    print("No progress info available.")
                end
            end
            print("------------------------------------")
        end
    else
        print("Perks Activities data is not available.")
    end
end



-- Function to list available commands
local function ListCommands()
    print("Available commands:")
    print("/mfdata - Output major faction data")
    print("/perks - Print perks activities data")
    print("/perksidname - Print perks activity IDs and names")
    print("/perksprogress <ID> - Print perks progress by ID")
    print("/dt - Show list of all commands")
    print("/rl - Reload the UI")
    print("/clear - Clear the current chat log")
end

-- Slash command to output major faction data
SLASH_MFDATA1 = "/mfdata"
SlashCmdList["MFDATA"] = OutputMajorFactionData

-- Slash command to print perks activities data
SLASH_PERKS1 = "/perks"
SlashCmdList["PERKS"] = function(option)
    PrintPerksActivitiesData(option)
end

-- Slash command to print perks activity IDs and names
SLASH_PERKSIDNAME1 = "/perksidname"
SlashCmdList["PERKSIDNAME"] = function()
    PrintPerksActivitiesData("-idname")
end

-- Slash command to print perks progress by ID
SLASH_PERKSPROGRESS1 = "/perksprogress"
SlashCmdList["PERKSPROGRESS"] = function(id)
    PrintPerksActivitiesData("-progress", id)
end

-- Slash command to list available commands
SLASH_DT1 = "/dt"
SlashCmdList["DT"] = ListCommands

-- Slash command to reload UI
SLASH_RL1 = "/rl"
SlashCmdList["RL"] = ReloadUI

-- Slash command to clear chat log
SLASH_CLEAR1 = "/clear"
function SlashCmdList.CLEAR()
    for i = 1, NUM_CHAT_WINDOWS do
        _G["ChatFrame" .. i]:Clear()
    end
    print("Chat log cleared.")
end

-- Output a message to chat when the addon is loaded
print("DiceTools addon loaded.")

-- Register for PLAYER_ENTERING_WORLD event to list available commands
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", ListCommands)
