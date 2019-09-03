local MAJOR, MINOR = "LibQuestXP-1.0", 1
local LibQuestXP = LibStub:NewLibrary(MAJOR, MINOR)

if not LibQuestXP then
    return	-- already loaded and no upgrade necessary
  end

local selectedQuestLogIndex = nil

local function hookSelectQuestLogEntry(questLogIndex)
    selectedQuestLogIndex = questLogIndex
end
hooksecurefunc("SelectQuestLogEntry", hookSelectQuestLogEntry)

function LibQuestXP:GetQuestInfo(questID)
    if LibQuestXPDB[questID] ~= nil then
        return LibQuestXPDB[questID]['xp'], LibQuestXPDB[questID]['level']
    end

    return 0, nil
end

function LibQuestXP:GetAdjustedXP(xp, qLevel)
    local charLevel = UnitLevel("player");

    if (charLevel <= qLevel + 5)  then return xp end;
    if (charLevel == qLevel + 6)  then return floor(xp * 0.8 / 5) * 5 end
    if (charLevel == qLevel + 7)  then return floor(xp * 0.6 / 5) * 5 end
    if (charLevel == qLevel + 8)  then return floor(xp * 0.4 / 5) * 5 end
    if (charLevel == qLevel + 9)  then return floor(xp * 0.2 / 5) * 5 end
    if (charLevel >= qLevel + 10) then return floor(xp * 0.1 / 5) * 5 end
end

function GetQuestLogRewardXP(questID)
    local title, qLevel, xp

    -- Try getting the quest from the quest log if no questID was provided
    if questID == nil and selectedQuestLogIndex ~= nil then
        title, qLevel, _, _, _, _, _, questID = GetQuestLogTitle(selectedQuestLogIndex)
    end

    -- Return 0 if quest ID is not found for some reason
    if (questID == nil) then return 0 end

    -- Get stored quest XP and quest level
    xp, qLevel = LibQuestXP:GetQuestInfo(questID)

    -- Return base XP if level information is not available
    if qLevel == nil then return xp end

    -- Return adjusted XP if all information are available
    return LibQuestXP:GetAdjustedXP(xp, qLevel)
end
