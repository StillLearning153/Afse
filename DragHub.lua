-- ╔══════════════════════════════════════════════════════╗
-- ║                     DRAG HUB                        ║
-- ║         AFS Endless  |  Sailor Piece                ║
-- ╚══════════════════════════════════════════════════════╝

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local LocalPlayer       = Players.LocalPlayer

local AFS_ID      = 130247632398296
local SAILOR_ID   = 77747658251236
local DUNGEON_GID = 9186719164       -- GameId (same across all places in the game)
local DUNGEON_PID = 75159314259063   -- PlaceId (specific dungeon place)
print("[DRAG HUB] PlaceId:", game.PlaceId, "| GameId:", game.GameId)

-- ── Custom Loading Screen ─────────────────────────────────────────────────────

local screenGui = Instance.new("ScreenGui")
screenGui.Name             = "DragHubLoader"
screenGui.IgnoreGuiInset   = true
screenGui.ResetOnSpawn     = false
screenGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
screenGui.Parent           = game:GetService("CoreGui")

-- Dark red background with 50% opacity
local bg = Instance.new("Frame")
bg.Size            = UDim2.new(1, 0, 1, 0)
bg.Position        = UDim2.new(0, 0, 0, 0)
bg.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
bg.BackgroundTransparency = 0.5
bg.BorderSizePixel = 0
bg.ZIndex          = 1
bg.Parent          = screenGui

-- "DRAG HUB" bold label
local label = Instance.new("TextLabel")
label.Size                  = UDim2.new(1, 0, 0, 80)
label.Position              = UDim2.new(0, 0, 0.42, 0)
label.BackgroundTransparency = 1
label.Text                  = "DRAG HUB"
label.TextColor3            = Color3.fromRGB(255, 255, 255)
label.TextScaled            = true
label.Font                  = Enum.Font.GothamBold
label.ZIndex                = 2
label.Parent                = screenGui

-- Subtitle
local sub = Instance.new("TextLabel")
sub.Size                  = UDim2.new(1, 0, 0, 30)
sub.Position              = UDim2.new(0, 0, 0.56, 0)
sub.BackgroundTransparency = 1
sub.Text                  = "Loading..."
sub.TextColor3            = Color3.fromRGB(200, 200, 200)
sub.TextScaled            = true
sub.Font                  = Enum.Font.Gotham
sub.ZIndex                = 2
sub.Parent                = screenGui

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Destroy our custom loader now that Rayfield has taken over
screenGui:Destroy()

local windowConfig = {
    Icon            = 0,
    ShowText        = "DRAG HUB",
    Theme           = "Ocean",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings   = false,
    ConfigurationSaving = {
        Enabled    = true,
        FolderName = "DragHub",
        FileName   = "DragHubConfig",
    },
    Discord = {
        Enabled       = false,
        Invite        = "",
        RememberJoins = true,
    },
    KeySystem = false,
}

-- ╔══════════════════════════════════════════════════════╗
-- ║              ANIME FIGHTING SIMULATOR                ║
-- ╚══════════════════════════════════════════════════════╝

if game.PlaceId == AFS_ID then

    local AFSRemote = nil
    pcall(function()
        AFSRemote = ReplicatedStorage
            :WaitForChild("shared",      10)
            :WaitForChild("Remotes",     10)
            :WaitForChild("RemoteEvent", 10)
    end)

    local afsFarmThread = nil
    local afsActiveStat = nil
    local afsToggles    = {}

    local afsStatValues = {
        Strength   = 1,
        Durability = 2,
        Chakra     = 3,
        Sword      = 4,
    }

    local function afsStopFarm()
        if afsFarmThread then task.cancel(afsFarmThread) afsFarmThread = nil end
        afsActiveStat = nil
    end

    local function afsStartFarm(statName)
        afsStopFarm()
        afsActiveStat = statName
        afsFarmThread = task.spawn(function()
            while afsActiveStat == statName do
                local character = LocalPlayer.Character
                local hum = character and character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    pcall(function() AFSRemote:FireServer("Train", afsStatValues[statName]) end)
                else
                    task.wait(1)
                end
                task.wait(0.1)
            end
        end)
    end

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(2)
        if afsActiveStat then afsStartFarm(afsActiveStat) end
    end)

    -- UI setup
    windowConfig.Name            = "DRAG HUB | AFS Endless"
    windowConfig.LoadingTitle    = "<b>DRAG HUB</b>"
    windowConfig.LoadingSubtitle = "Anime Fighting Simulator Endless"

    local Window = Rayfield:CreateWindow(windowConfig)
    local AFSTab = Window:CreateTab("Auto Farm", 4483362458)

    local statSections = {
        { name = "Strength",   icon = "💪" },
        { name = "Durability", icon = "🛡" },
        { name = "Chakra",     icon = "⚡" },
        { name = "Sword",      icon = "⚔" },
    }

    for _, s in ipairs(statSections) do
        AFSTab:CreateSection(s.icon .. " " .. s.name)
        local toggle = AFSTab:CreateToggle({
            Name = "Auto Farm " .. s.name, CurrentValue = false,
            Callback = function(val)
                if val then
                    for n, t in pairs(afsToggles) do if n ~= s.name then t:Set(false) end end
                    afsStartFarm(s.name)
                    Rayfield:Notify({ Title = "Auto Farm", Content = "Farming " .. s.name .. "!", Duration = 3, Image = 4483362458 })
                else
                    if afsActiveStat == s.name then afsStopFarm() end
                end
            end,
        })
        afsToggles[s.name] = toggle
        AFSTab:CreateDivider()
    end

    AFSTab:CreateSection("⚙ Controls")
    AFSTab:CreateButton({
        Name = "Stop All Farming",
        Callback = function()
            afsStopFarm()
            for _, t in pairs(afsToggles) do t:Set(false) end
            Rayfield:Notify({ Title = "DRAG HUB", Content = "All farming stopped.", Duration = 3, Image = 4483362458 })
        end,
    })


elseif game.PlaceId == SAILOR_ID then


-- ╔══════════════════════════════════════════════════════╗
-- ║                   SAILOR PIECE                       ║
-- ╚══════════════════════════════════════════════════════╝


    -- ── Remotes ───────────────────────────────────────────────────────────────

    local RequestAbility = nil
    pcall(function()
        RequestAbility = ReplicatedStorage
            :WaitForChild("AbilitySystem",  10)
            :WaitForChild("Remotes",        10)
            :WaitForChild("RequestAbility", 10)
    end)

    local RequestHit = nil
    pcall(function()
        RequestHit = ReplicatedStorage
            :WaitForChild("CombatSystem", 10)
            :WaitForChild("Remotes",      10)
            :WaitForChild("RequestHit",   10)
    end)

    local autoM1Enabled = false

    local function doM1()
        if autoM1Enabled and RequestHit then
            pcall(function() RequestHit:FireServer() end)
        end
    end

    -- Global M1 loop — only fires when autoM1Enabled is true
    task.spawn(function()
        while true do
            if autoM1Enabled then
                doM1()
            end
            task.wait(0.08)
        end
    end)

    local QuestAccept = nil
    pcall(function()
        QuestAccept = ReplicatedStorage
            :WaitForChild("RemoteEvents", 10)
            :WaitForChild("QuestAccept",  10)
    end)

    local AllocateStat = nil
    pcall(function()
        AllocateStat = ReplicatedStorage
            :WaitForChild("RemoteEvents", 10)
            :WaitForChild("AllocateStat", 10)
    end)

    local TeleportRemote = nil
    pcall(function()
        TeleportRemote = ReplicatedStorage
            :WaitForChild("Remotes",          10)
            :WaitForChild("TeleportToPortal", 10)
    end)

    -- ── Quest UI reader ───────────────────────────────────────────────────────

    local questUI = nil
    pcall(function()
        questUI = LocalPlayer.PlayerGui
            :WaitForChild("QuestUI", 10)
            :WaitForChild("Quest",   10)
    end)

    local function getQuestKills()
        if not questUI then return nil, nil end
        for _, obj in pairs(questUI:GetDescendants()) do
            if obj:IsA("TextLabel") then
                local cur, req = obj.Text:match("(%d+)%s*/%s*(%d+)")
                if cur and req then return tonumber(cur), tonumber(req) end
            end
        end
        return nil, nil
    end

    local function isQuestDone()
        local cur, req = getQuestKills()
        return cur and req and cur >= req
    end

    -- ── Quest & mob data ──────────────────────────────────────────────────────

    local questData = {
        { npc = "QuestNPC1",  mob = "Thief",          minLvl = 0,    maxLvl = 99    },
        { npc = "QuestNPC2",  mob = "ThiefBoss",      minLvl = 100,  maxLvl = 249   },
        { npc = "QuestNPC3",  mob = "Monkey",         minLvl = 250,  maxLvl = 499   },
        { npc = "QuestNPC4",  mob = "MonkeyBoss",     minLvl = 500,  maxLvl = 749   },
        { npc = "QuestNPC5",  mob = "DesertBandit",   minLvl = 750,  maxLvl = 999   },
        { npc = "QuestNPC6",  mob = "DesertBoss",     minLvl = 1000, maxLvl = 1499  },
        { npc = "QuestNPC7",  mob = "FrostRogue",     minLvl = 1500, maxLvl = 1999  },
        { npc = "QuestNPC8",  mob = "SnowBoss",       minLvl = 2000, maxLvl = 2999  },
        { npc = "QuestNPC9",  mob = "Sorcerer",       minLvl = 3000, maxLvl = 3999  },
        { npc = "QuestNPC10", mob = "PandaMiniBoss",  minLvl = 4000, maxLvl = 5000  },
        { npc = "QuestNPC11", mob = "Hollow",         minLvl = 5000, maxLvl = 6249  },
        { npc = "QuestNPC12", mob = "StrongSorcerer", minLvl = 6250, maxLvl = 6999  },
        { npc = "QuestNPC13", mob = "Curse",          minLvl = 7000, maxLvl = 7999  },
        { npc = "QuestNPC14", mob = "Slime",          minLvl = 8000, maxLvl = 8999  },
        { npc = "QuestNPC15", mob = "AcademyTeacher", minLvl = 9000,  maxLvl = 9999  },
        { npc = "QuestNPC16", mob = "Swordsman",       minLvl = 10000, maxLvl = 10750 },
        { npc = "QuestNPC17", mob = "Quincy",           minLvl = 10750, maxLvl = 99999 },
    }

    local mobCoords = {
        ["Thief"]          = Vector3.new( 194.943,   11.207,   -171.994),
        ["ThiefBoss"]      = Vector3.new( -66.662,   -2.584,   -162.957),
        ["Monkey"]         = Vector3.new(-566.029,   -0.875,    425.000),
        ["MonkeyBoss"]     = Vector3.new(-494.756,   49.211,    496.790),
        ["DesertBandit"]   = Vector3.new(-774.852,   -4.223,   -405.228),
        ["DesertBoss"]     = Vector3.new(-897.797,    2.346,   -462.508),
        ["FrostRogue"]     = Vector3.new(-423.527,   -0.222,   -968.642),
        ["SnowBoss"]       = Vector3.new(-594.788,   29.430,  -1060.376),
        ["Sorcerer"]       = Vector3.new(1407.890,    8.606,    522.877),
        ["PandaMiniBoss"]  = Vector3.new(1688.408,    9.574,    513.446),
        ["Hollow"]         = Vector3.new(-341.802,   -0.441,   1091.144),
        ["StrongSorcerer"] = Vector3.new( 684.110,    2.376,  -1715.858),
        ["Curse"]          = Vector3.new( -41.328,    1.907,  -1816.006),
        ["Slime"]          = Vector3.new(-1144.351,  19.703,    364.112),
        ["AcademyTeacher"] = Vector3.new(1074.662,    2.370,   1250.483),
        ["Swordsman"]      = Vector3.new(-1268.647,   1.306,  -1161.301),
        ["Quincy"]         = Vector3.new(-1331.364, 1603.621, 1567.672),
    }

    -- Island each mob/boss belongs to (for TeleportRemote before CFrame tp)
    local mobIsland = {
        ["Thief"]          = "Starter",
        ["ThiefBoss"]      = "Starter",
        ["Monkey"]         = "Jungle",
        ["MonkeyBoss"]     = "Jungle",
        ["DesertBandit"]   = "Desert",
        ["DesertBoss"]     = "Desert",
        ["FrostRogue"]     = "Snow",
        ["SnowBoss"]       = "Snow",
        ["Sorcerer"]       = "Sailor",
        ["PandaMiniBoss"]  = "Sailor",
        ["Hollow"]         = "HuecoMundo",
        ["StrongSorcerer"] = "Shibuya",
        ["Curse"]          = "Shibuya",
        ["Slime"]          = "Slime",
        ["AcademyTeacher"] = "Academy",
        ["Swordsman"]      = "Judgement",
        ["Quincy"]         = "SoulSociety",
    }

    local mobList = {
        "Thief", "Monkey", "DesertBandit", "FrostRogue",
        "Sorcerer", "Hollow", "StrongSorcerer", "Curse", "Slime", "AcademyTeacher", "Swordsman", "Quincy",
    }

    local bossList = { "ThiefBoss", "MonkeyBoss", "DesertBoss", "SnowBoss", "PandaMiniBoss" }

    local bosses = {
        ThiefBoss = true, MonkeyBoss = true, DesertBoss    = true,
        SnowBoss  = true, PandaMiniBoss = true,
        -- All regular bossList entries — exact name match, no numbered suffix
        Swordsman = true, AcademyTeacher = true, Slime = true,
        Curse = true, StrongSorcerer = true, Hollow = true,
        PandaMiniBoss = true, Sorcerer = true, SnowBoss = true,
    }

    local skillKeys = {
        ["Z (Skill 1)"] = 1, ["X (Skill 2)"] = 2, ["C (Skill 3)"] = 3,
        ["V (Skill 4)"] = 4, ["F (Skill 5)"] = 5,
    }

    -- ── State variables ───────────────────────────────────────────────────────

    local selectedMob      = "Thief"
    local selectedBoss     = "ThiefBoss"
    local selectedMobs     = {}
    local mobQuestMode     = "No Quest"
    local selectedSkills   = {}
    local selectedWeapon   = "Combat"
    local selectedStats    = {"Melee"}
    local inventoryList    = {}

    local mobEnabled        = false
    local bossEnabled       = false
    local skillEnabled      = false
    local levelEnabled      = false
    local upgradeEnabled    = false
    local autoSummonEnabled = false
    local instantKillMob    = false
    local mobThread        = nil
    local bossThread       = nil
    local skillThread      = nil
    local levelThread      = nil
    local upgradeThread    = nil
    local noclipThread     = nil
    local autoSummonThread = nil

    local FLY_HEIGHT       = 9
    local FLY_SMOOTHNESS   = 60
    local FLY_DISTANCE     = 2.5
    local LOOK_DOWN_OFFSET = 4
    local ORBIT_RADIUS     = 2
    local ORBIT_SPEED      = 2

    -- ── Fly system (AlignPosition + smooth orbit) ─────────────────────────────

    local flyAlignPosition    = nil
    local flyAlignOrientation = nil
    local flyAttachment0      = nil
    local flyAttachment1      = nil
    local flyTargetPart       = nil
    local flyConnection       = nil
    local currentFlyRoot      = nil

    local function cleanupFlyObjects()
        if flyConnection       then flyConnection:Disconnect()    flyConnection       = nil end
        if flyAlignPosition    then flyAlignPosition:Destroy()    flyAlignPosition    = nil end
        if flyAlignOrientation then flyAlignOrientation:Destroy() flyAlignOrientation = nil end
        if flyAttachment0      then flyAttachment0:Destroy()      flyAttachment0      = nil end
        if flyAttachment1      then flyAttachment1:Destroy()      flyAttachment1      = nil end
        if flyTargetPart       then flyTargetPart:Destroy()       flyTargetPart       = nil end
    end

    local function startFlyAbove(targetRoot)
        local character = LocalPlayer.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local hum = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or not targetRoot or not targetRoot.Parent then return end

        cleanupFlyObjects()
        hum.PlatformStand = false
        hum.AutoRotate    = false

        flyAttachment0        = Instance.new("Attachment")
        flyAttachment0.Name   = "DragFly_Att0"
        flyAttachment0.Parent = hrp

        flyTargetPart              = Instance.new("Part")
        flyTargetPart.Name         = "DragFly_Target"
        flyTargetPart.Size         = Vector3.new(1, 1, 1)
        flyTargetPart.Transparency = 1
        flyTargetPart.Anchored     = true
        flyTargetPart.CanCollide   = false
        flyTargetPart.CanQuery     = false
        flyTargetPart.CanTouch     = false
        flyTargetPart.CFrame       = CFrame.new(targetRoot.Position + Vector3.new(0, FLY_HEIGHT, 0))
        flyTargetPart.Parent       = workspace

        flyAttachment1        = Instance.new("Attachment")
        flyAttachment1.Name   = "DragFly_Att1"
        flyAttachment1.Parent = flyTargetPart

        flyAlignPosition                      = Instance.new("AlignPosition")
        flyAlignPosition.Attachment0          = flyAttachment0
        flyAlignPosition.Attachment1          = flyAttachment1
        flyAlignPosition.Mode                 = Enum.PositionAlignmentMode.TwoAttachment
        flyAlignPosition.RigidityEnabled      = false
        flyAlignPosition.ReactionForceEnabled = false
        flyAlignPosition.MaxForce             = 1e9
        flyAlignPosition.MaxVelocity          = 200
        flyAlignPosition.Responsiveness       = FLY_SMOOTHNESS
        flyAlignPosition.Parent               = hrp

        flyAlignOrientation                       = Instance.new("AlignOrientation")
        flyAlignOrientation.Attachment0           = flyAttachment0
        flyAlignOrientation.Mode                  = Enum.OrientationAlignmentMode.OneAttachment
        flyAlignOrientation.RigidityEnabled       = false
        flyAlignOrientation.ReactionTorqueEnabled = false
        flyAlignOrientation.MaxTorque             = 1e9
        flyAlignOrientation.Responsiveness        = 40
        flyAlignOrientation.Parent                = hrp

        flyConnection = RunService.Heartbeat:Connect(function()
            if not targetRoot or not targetRoot.Parent then return end
            if not hrp        or not hrp.Parent        then return end
            if not flyTargetPart then return end

            -- Orbit around target
            local t           = tick() * ORBIT_SPEED
            local orbitOffset = Vector3.new(math.cos(t) * ORBIT_RADIUS, 0, math.sin(t) * ORBIT_RADIUS)

            local targetPos = targetRoot.Position
                + Vector3.new(0, FLY_HEIGHT, 0)
                + (targetRoot.CFrame.LookVector * -FLY_DISTANCE)
                + orbitOffset

            -- Distance-based lerp: faster when far, smoother when close
            local dist  = (flyTargetPart.Position - targetPos).Magnitude
            local alpha = math.clamp(dist / 25, 0.12, 0.35)
            flyTargetPart.CFrame = CFrame.new(flyTargetPart.Position:Lerp(targetPos, alpha))

            -- Smooth downward look toward boss
            local lookTarget = targetRoot.Position - Vector3.new(0, LOOK_DOWN_OFFSET, 0)
            flyAlignOrientation.CFrame = flyAlignOrientation.CFrame:Lerp(
                CFrame.lookAt(hrp.Position, lookTarget),
                0.35
            )
        end)
    end

    local function updateFlyTarget(targetRoot)
        if not targetRoot or not targetRoot.Parent then return end
        if not flyTargetPart then startFlyAbove(targetRoot) end
    end

    local function stopFly()
        cleanupFlyObjects()
        currentFlyRoot = nil
        local character = LocalPlayer.Character
        if character then
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                hum.AutoRotate    = true
            end
        end
    end

    local function flyAbove(targetRoot)
        if currentFlyRoot ~= targetRoot then
            currentFlyRoot = targetRoot
            startFlyAbove(targetRoot)
        else
            updateFlyTarget(targetRoot)
        end
    end

    -- ── Noclip ────────────────────────────────────────────────────────────────

    local function startNoclip()
        if noclipThread then return end
        noclipThread = task.spawn(function()
            while true do
                local c = LocalPlayer.Character
                if c then
                    for _, part in pairs(c:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
                task.wait(0.1)
            end
        end)
    end

    local function stopNoclip()
        if noclipThread then task.cancel(noclipThread) noclipThread = nil end
        local c = LocalPlayer.Character
        if c then
            for _, part in pairs(c:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end

    local function noclipNeeded()
        return mobEnabled or bossEnabled or levelEnabled
    end

    -- ── Utility ───────────────────────────────────────────────────────────────

    local function isAlive()
        local c = LocalPlayer.Character
        if not c then return false end
        local h = c:FindFirstChildOfClass("Humanoid")
        return h ~= nil and h.Health > 0
    end

    local function waitForCharacter()
        if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not h or h.Health <= 0 then LocalPlayer.CharacterAdded:Wait() end
        task.wait(2)
    end

    local function getPlayerLevel()
        local ok, lvl = pcall(function() return LocalPlayer.Data.Level.Value end)
        return (ok and lvl) or 0
    end

    local function getQuestForLevel(lvl)
        for _, q in ipairs(questData) do
            if lvl >= q.minLvl and lvl <= q.maxLvl then return q end
        end
        return questData[#questData]
    end

    local function getQuestForMob(mobName)
        for _, q in ipairs(questData) do
            if q.mob == mobName then return q end
        end
        return nil
    end

    local equipWeapon
    equipWeapon = function(toolName)
        pcall(function()
            local character = LocalPlayer.Character
            if not character then return end
            local name = toolName or selectedWeapon
            if character:FindFirstChild(name) then return end
            local tool = LocalPlayer.Backpack:FindFirstChild(name)
            if tool then
                local hum = character:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(tool) end
            end
        end)
    end

    local lastTeleportedMob = ""

    local function teleportForMob(mobName)
        if mobName == lastTeleportedMob then return end
        local coords = mobCoords[mobName]
        if not coords then return end
        local c   = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        -- Fire island teleport first so the server loads the right area
        local island = mobIsland[mobName]
        if island and TeleportRemote then
            pcall(function() TeleportRemote:FireServer(island) end)
            task.wait(1.5)
        end
        -- Then CFrame snap to exact mob location
        hrp.CFrame        = CFrame.new(coords + Vector3.new(0, 5, 0))
        lastTeleportedMob = mobName
        Rayfield:Notify({ Title = "Teleport", Content = "Moved to " .. mobName .. " (" .. (island or "?") .. ")!", Duration = 2, Image = 4483362458 })
        task.wait(0.5)
    end

    local function getAllMobs(exactName)
        local list    = {}
        local escaped = exactName:gsub("([^%w])", "%%%1")
        local isBoss  = bosses[exactName] == true

        local function searchFolder(folder)
            for _, mob in pairs(folder:GetChildren()) do
                if mob:IsA("Model") then
                    -- For bosses: exact name match only
                    -- For mobs: numbered suffix match (e.g. "Thief1", "Thief2")
                    -- Fallback: also accept exact name for anything (catches bosses not in bosses table)
                    local matches = (mob.Name == exactName)
                        or (not isBoss and mob.Name:match("^" .. escaped .. "%d+$") ~= nil)
                    if matches then
                        local hum  = mob:FindFirstChildOfClass("Humanoid")
                        local root = mob:FindFirstChild("HumanoidRootPart")
                        if hum and root and hum.Health > 0 then
                            table.insert(list, mob)
                        end
                    end
                end
            end
        end

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Folder") and obj.Name == "NPCs" then searchFolder(obj) end
        end
        return list
    end

    local function snapNearTarget(root, maxDist)
        local c   = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if not hrp or not root then return end
        if (hrp.Position - root.Position).Magnitude > (maxDist or 120) then
            hrp.CFrame = CFrame.new(root.Position + Vector3.new(0, FLY_HEIGHT, 0))
            task.wait(0.05)
        end
    end

    -- Keep player floating at current height when no mobs are nearby
    local function hoverInPlace()
        if flyTargetPart then return end -- already flying via main system, don't interfere
        local c   = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        -- Lock to current Y position (don't add FLY_HEIGHT — player is already in air)
        local lockPos = hrp.Position
        local att0 = Instance.new("Attachment", hrp)
        local anchor = Instance.new("Part")
        anchor.Size        = Vector3.new(1,1,1)
        anchor.Transparency = 1
        anchor.Anchored    = true
        anchor.CanCollide  = false
        anchor.CanQuery    = false
        anchor.CanTouch    = false
        anchor.CFrame      = CFrame.new(lockPos) -- stay exactly here
        anchor.Parent      = workspace
        local att1 = Instance.new("Attachment", anchor)
        local ap = Instance.new("AlignPosition")
        ap.Attachment0          = att0
        ap.Attachment1          = att1
        ap.Mode                 = Enum.PositionAlignmentMode.TwoAttachment
        ap.MaxForce             = 1e9
        ap.MaxVelocity          = 50
        ap.Responsiveness       = 30
        ap.Parent               = hrp
        -- Cleanup after 0.6s
        task.delay(0.6, function()
            if att0   then att0:Destroy()   end
            if att1   then att1:Destroy()   end
            if ap     then ap:Destroy()     end
            if anchor then anchor:Destroy() end
        end)
    end

    local function killMob(mob)
        if not mob then return false end
        local root   = mob:FindFirstChild("HumanoidRootPart")
        local mobHum = mob:FindFirstChildOfClass("Humanoid")
        if not root or not mobHum or mobHum.Health <= 0 then return false end
        snapNearTarget(root, 120)
        flyAbove(root)
        local t = 0
        repeat
            task.wait(0.1)
            t += 0.1
            flyAbove(root)
        until mobHum.Health <= 0 or not mobEnabled or t > 30 or not isAlive()
        stopFly()
        task.wait(0.1)
        return mobHum.Health <= 0
    end

    local function handleDeath(mobName)
        if not isAlive() then
            stopFly()
            waitForCharacter()
            if not mobEnabled then return false end
            equipWeapon()
            lastTeleportedMob = ""
            teleportForMob(mobName)
            task.wait(0.1)
        end
        if not mobEnabled then return false end
        return true
    end

    -- ── Special boss data ─────────────────────────────────────────────────────

    local specialBossData = {
        { name = "AizenBoss",   pos = Vector3.new(-567.223,  2.579, 1228.490), island = "HuecoMundo" },
        { name = "AlucardBoss", pos = Vector3.new( 248.742, 12.093,  927.542), island = "Sailor"     },
        { name = "GojoBoss",    pos = Vector3.new(1858.327, 15.986,  338.140), island = "Shibuya"    },
        { name = "JinwooBoss",  pos = Vector3.new( 248.738,  7.594,  927.545), island = "Sailor"     },
        { name = "SukunaBoss",  pos = Vector3.new(1571.267, 80.221,  -34.113), island = "Shibuya"    },
        { name = "YujiBoss",    pos = Vector3.new(1537.929, 12.986,  226.108), island = "Shibuya"    },
        { name = "YamatoBoss",  pos = Vector3.new(-1422.681, 21.471, -1383.469), island = "Judgement"  },
    }

    local chatKeywordToBoss = {
        ["Aizen"]  = "AizenBoss",   ["Alucard"] = "AlucardBoss",
        ["Gojo"]   = "GojoBoss",    ["Jinwoo"]  = "JinwooBoss",
        ["Madoka"] = "MadokaBoss",  ["Ragna"]   = "RagnaBoss",
        ["Sukuna"] = "SukunaBoss",  ["Yuji"]    = "YujiBoss",
        ["Yamato"] = "YamatoBoss",
    }

    local selectedSpecialBosses  = {}
    local specialBossEnabled     = false
    local specialBossThread      = nil
    local specialBossQueue       = {}
    local specialBossConnection  = nil
    local specialBossConnections = {}

    local function isSelectedBoss(bossName)
        for _, n in ipairs(selectedSpecialBosses) do
            if n == bossName then return true end
        end
        return false
    end

    local function getBossModel(bossName)
        local NPCs = workspace:FindFirstChild("NPCs")
        if not NPCs then return nil, nil, nil end
        local model = NPCs:FindFirstChild(bossName)
        if not model then return nil, nil, nil end
        local hum  = model:FindFirstChildOfClass("Humanoid")
        local root = model:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.Health > 0 then return model, root, hum end
        return nil, nil, nil
    end

    local function waitForBossModel(bossName, timeout)
        local t = 0
        while t < (timeout or 10) do
            local _, root, hum = getBossModel(bossName)
            if root and hum then return getBossModel(bossName) end
            task.wait(0.5)
            t += 0.5
        end
        return nil, nil, nil
    end

    -- ── Forward declarations ──────────────────────────────────────────────────

    local startMob, stopMob, startBoss, stopBoss, startLevel, stopLevel

    -- ── Special boss fight system ─────────────────────────────────────────────

    local resumeAfterBoss = { mob = false, boss = false, level = false }

    local function resumePreviousFarming()
        lastTeleportedMob = ""
        local didResume = false
        if resumeAfterBoss.mob then
            mobEnabled = true
            startMob()
            didResume = true
        end
        if resumeAfterBoss.boss then
            bossEnabled = true
            startBoss()
            didResume = true
        end
        if resumeAfterBoss.level then
            levelEnabled = true
            startLevel()
            didResume = true
        end
        if noclipNeeded() then startNoclip() end
        resumeAfterBoss = { mob = false, boss = false, level = false }
        if didResume then
            Rayfield:Notify({ Title = "Boss Farm", Content = "Resumed previous farming!", Duration = 3, Image = 4483362458 })
        end
    end

    local function fightDetectedBoss(bossName)
        -- Save what was running before the boss interrupted
        resumeAfterBoss.mob   = resumeAfterBoss.mob   or mobEnabled
        resumeAfterBoss.boss  = resumeAfterBoss.boss  or bossEnabled
        resumeAfterBoss.level = resumeAfterBoss.level or levelEnabled

        -- Stop all current farming immediately
        if mobEnabled   then mobEnabled   = false if mobThread   then task.cancel(mobThread)   mobThread   = nil end end
        if bossEnabled  then bossEnabled  = false if bossThread  then task.cancel(bossThread)  bossThread  = nil end end
        if levelEnabled then levelEnabled = false if levelThread then task.cancel(levelThread) levelThread = nil end end
        stopFly()
        stopNoclip()

        local bossData = nil
        for _, d in ipairs(specialBossData) do
            if d.name == bossName then bossData = d break end
        end
        if not bossData then
            -- Unknown boss — still resume whatever was running before
            resumePreviousFarming()
            return
        end

        Rayfield:Notify({ Title = "⚡ Boss!", Content = "Going to " .. bossName .. " (" .. (bossData.island or "?") .. ")...", Duration = 4, Image = 4483362458 })

        -- Fire island teleport first, then CFrame snap to boss position
        if bossData.island and TeleportRemote then
            pcall(function() TeleportRemote:FireServer(bossData.island) end)
            task.wait(0.5)
        end
        local c   = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(bossData.pos + Vector3.new(0, FLY_HEIGHT, 0))
            task.wait(0.3)
        end

        local model, root, hum = waitForBossModel(bossName, 5)
        if not model then
            -- Boss not found or already dead — resume previous farming
            Rayfield:Notify({ Title = "Boss Farm", Content = bossName .. " not found, resuming...", Duration = 3, Image = 4483362458 })
            resumePreviousFarming()
            return
        end

        startNoclip()

        while specialBossEnabled do
            if not isAlive() then
                stopFly()
                waitForCharacter()
                if not specialBossEnabled then break end
                equipWeapon()
                task.wait(0.3)
                -- Re-teleport back to boss area after death
                local c2   = LocalPlayer.Character
                local hrp2 = c2 and c2:FindFirstChild("HumanoidRootPart")
                if hrp2 then
                    hrp2.CFrame = CFrame.new(bossData.pos + Vector3.new(0, FLY_HEIGHT, 0))
                    task.wait(0.3)
                end
                startNoclip()
                -- Wait for boss to reappear (it may respawn)
                model, root, hum = waitForBossModel(bossName, 5)
                if not model then
                    -- Boss gone after our death — resume farming
                    Rayfield:Notify({ Title = "Boss Farm", Content = bossName .. " gone after death, resuming...", Duration = 3, Image = 4483362458 })
                    break
                end
            end

            model, root, hum = getBossModel(bossName)
            if not model then
                -- Boss defeated!
                Rayfield:Notify({ Title = "Boss Farm", Content = bossName .. " defeated! Resuming farming...", Duration = 3, Image = 4483362458 })
                break
            end

            snapNearTarget(root, 120)
            flyAbove(root)

            if instantKillMob then
                pcall(function()
                    local _, _, h = getBossModel(bossName)
                    if h then h.Health = 0 end
                end)
                stopFly()
            else
                repeat
                    task.wait(0.1)
                    local _, r = getBossModel(bossName)
                    if r then flyAbove(r) end
                until not getBossModel(bossName) or not specialBossEnabled or not isAlive()
                stopFly()
            end
        end

        stopFly()
        stopNoclip()

        -- Always resume previous farming when done with this boss
        -- Even if specialBoss was toggled off mid-fight, restore what was running before
        if #specialBossQueue > 0 and specialBossEnabled then
            -- More bosses queued — don't resume yet, let the queue handle it
        else
            resumePreviousFarming()
        end
    end

    local function stopSpecialBoss()
        specialBossEnabled = false
        if specialBossThread     then task.cancel(specialBossThread)     specialBossThread     = nil end
        if specialBossConnection then specialBossConnection:Disconnect() specialBossConnection = nil end
        for _, conn in ipairs(specialBossConnections) do conn:Disconnect() end
        specialBossConnections = {}
        specialBossQueue = {}
        stopFly()
        stopNoclip()
        resumeAfterBoss = { mob = false, boss = false, level = false }
    end

    local function addToQueue(bossName)
        for _, q in ipairs(specialBossQueue) do if q == bossName then return end end
        table.insert(specialBossQueue, bossName)
        Rayfield:Notify({ Title = "Boss Queue", Content = bossName .. " queued!", Duration = 3, Image = 4483362458 })
    end

    local function startSpecialBossLoop()
        if specialBossThread then return end
        specialBossEnabled = true
        specialBossQueue   = {}

        local TextChatService = game:GetService("TextChatService")
        if specialBossConnection then specialBossConnection:Disconnect() end
        specialBossConnection = TextChatService.MessageReceived:Connect(function(msg)
            if not specialBossEnabled then return end
            local text = msg.Text or ""
            if not text:find("%[SERVER%]") then return end
            for keyword, bossName in pairs(chatKeywordToBoss) do
                if text:find(keyword) and text:lower():find("spawn") and isSelectedBoss(bossName) then
                    addToQueue(bossName) break
                end
            end
        end)

        -- Scan for bosses already present in workspace when loop starts
        local NPCs = workspace:FindFirstChild("NPCs")
        if NPCs then
            for _, npc in ipairs(NPCs:GetChildren()) do
                if isSelectedBoss(npc.Name) then
                    local hum = npc:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then addToQueue(npc.Name) end
                end
            end
            local conn = NPCs.ChildAdded:Connect(function(npc)
                if specialBossEnabled and isSelectedBoss(npc.Name) then addToQueue(npc.Name) end
            end)
            table.insert(specialBossConnections, conn)
        end

        specialBossThread = task.spawn(function()
            while specialBossEnabled do
                if #specialBossQueue > 0 then
                    fightDetectedBoss(table.remove(specialBossQueue, 1))
                else
                    task.wait(0.2)
                end
            end
        end)
    end

    -- ── Auto Skill ────────────────────────────────────────────────────────────

    local function stopSkill()
        skillEnabled = false
        if skillThread then task.cancel(skillThread) skillThread = nil end
    end

    local function startSkill()
        skillEnabled = true
        skillThread  = task.spawn(function()
            while skillEnabled do
                if not isAlive() then
                    waitForCharacter()
                else
                    for _, skillName in ipairs(selectedSkills) do
                        if not skillEnabled then break end
                        local arg = skillKeys[skillName]
                        if arg then
                            pcall(function() RequestAbility:FireServer(arg) end)
                            task.wait(0.3)
                        end
                    end
                    task.wait(0.5)
                end
            end
        end)
    end

    -- ── Auto Upgrade ──────────────────────────────────────────────────────────

    local function stopUpgrade()
        upgradeEnabled = false
        if upgradeThread then task.cancel(upgradeThread) upgradeThread = nil end
    end

    local function startUpgrade()
        upgradeEnabled = true
        upgradeThread  = task.spawn(function()
            while upgradeEnabled do
                for _, stat in ipairs(selectedStats) do
                    if not upgradeEnabled then break end
                    pcall(function() AllocateStat:FireServer(stat, 1) end)
                    task.wait(0.1)
                end
            end
        end)
    end

    -- ── Farm loop ─────────────────────────────────────────────────────────────

    local function farmLoop(getEnabled, getMobName)
        local lastMob = ""
        while getEnabled() do
            if not isAlive() then
                stopFly()
                waitForCharacter()
                if not getEnabled() then break end
                equipWeapon()
                lastTeleportedMob = ""
                lastMob           = ""
                task.wait(0.5)
            end
            if not getEnabled() then break end

            local mobName = getMobName()
            if mobName and mobName ~= "" then
                if mobName ~= lastMob then
                    lastMob = mobName
                    stopFly()
                    teleportForMob(mobName)
                    task.wait(0.1)
                end
                if not getEnabled() then break end

                local mobs = getAllMobs(mobName)
                if #mobs == 0 then
                    -- No mobs detected — hover in place and keep scanning
                    hoverInPlace()
                    task.wait(0.5)
                else
                    for _, mob in ipairs(mobs) do
                        if not getEnabled() or not isAlive() then break end
                        if getMobName() ~= mobName then break end
                        local root   = mob:FindFirstChild("HumanoidRootPart")
                        local mobHum = mob:FindFirstChildOfClass("Humanoid")
                        if root and mobHum and mobHum.Health > 0 then
                            snapNearTarget(root, 120)
                            flyAbove(root)
                            local t = 0
                            repeat
                                task.wait(0.1)
                                t += 0.1
                                flyAbove(root)
                            until mobHum.Health <= 0 or not getEnabled() or t > 120 or not isAlive() or getMobName() ~= mobName
                            stopFly()
                            task.wait(0.1)
                        end
                    end
                    task.wait(0.1)
                end
            end
            task.wait(0.3)
        end
        stopFly()
    end

    -- ── Mob farm ──────────────────────────────────────────────────────────────

    stopMob = function()
        mobEnabled        = false
        lastTeleportedMob = ""
        resumeAfterBoss.mob = false
        if mobThread then task.cancel(mobThread) mobThread = nil end
        stopFly()
        if not noclipNeeded() then stopNoclip() end
    end

    startMob = function()
        if not mobEnabled then return end
        if autoSummonEnabled then
            autoSummonEnabled = false
            if autoSummonThread then task.cancel(autoSummonThread) autoSummonThread = nil end
        end
        startNoclip()
        mobThread = task.spawn(function()
            while mobEnabled do
                local mobQueue = #selectedMobs > 0 and selectedMobs or {selectedMob}
                if #mobQueue == 0 then task.wait(1) end
                for _, mobName in ipairs(mobQueue) do
                    if not mobEnabled then break end
                    if not handleDeath(mobName) then break end
                    if not mobEnabled then break end
                    teleportForMob(mobName)
                    if not mobEnabled then break end

                    if mobQuestMode == "With Quest" then
                        local quest = getQuestForMob(mobName)
                        if quest and QuestAccept then
                            pcall(function() QuestAccept:FireServer(quest.npc) end)
                            task.wait(0.5)
                            local killCount    = 0
                            local KILLS_NEEDED = 5
                            Rayfield:Notify({ Title = "Auto Mob", Content = "Quest: " .. mobName .. " (0/" .. KILLS_NEEDED .. ")", Duration = 3, Image = 4483362458 })
                            while mobEnabled and killCount < KILLS_NEEDED do
                                if not handleDeath(mobName) then break end
                                if not mobEnabled then break end
                                local mobs = getAllMobs(mobName)
                                if #mobs == 0 then
                                    hoverInPlace()
                                    task.wait(0.5)
                                else
                                    for _, mob in ipairs(mobs) do
                                        if not mobEnabled or killCount >= KILLS_NEEDED then break end
                                        if not handleDeath(mobName) then break end
                                        if killMob(mob) then
                                            killCount += 1
                                            Rayfield:Notify({ Title = "Auto Mob", Content = mobName .. " " .. killCount .. "/" .. KILLS_NEEDED, Duration = 2, Image = 4483362458 })
                                        end
                                    end
                                end
                            end
                            if mobEnabled then
                                Rayfield:Notify({ Title = "Auto Mob", Content = "Quest done! " .. mobName .. " 5/5 → Next mob...", Duration = 4, Image = 4483362458 })
                            end
                        else
                            local mobs = getAllMobs(mobName)
                            for _, mob in ipairs(mobs) do
                                if not mobEnabled then break end
                                killMob(mob)
                            end
                        end
                    else
                        local mobs = getAllMobs(mobName)
                        if #mobs == 0 then
                            hoverInPlace()
                            task.wait(0.5)
                        else
                            for _, mob in ipairs(mobs) do
                                if not mobEnabled then break end
                                if not handleDeath(mobName) then break end
                                killMob(mob)
                            end
                        end
                    end
                    if not mobEnabled then break end
                end
            end
            stopFly()
            stopNoclip()
        end)
    end

    -- ── Boss farm ─────────────────────────────────────────────────────────────

    stopBoss = function()
        bossEnabled = false
        resumeAfterBoss.boss = false
        if bossThread then task.cancel(bossThread) bossThread = nil end
        stopFly()
        lastTeleportedMob = ""
        if not noclipNeeded() then stopNoclip() end
    end

    startBoss = function()
        if not bossEnabled then return end
        startNoclip()
        bossThread = task.spawn(function()
            teleportForMob(selectedBoss)
            farmLoop(function() return bossEnabled end, function() return selectedBoss end)
            bossThread = nil
        end)
    end

    -- ── Auto Level ────────────────────────────────────────────────────────────

    stopLevel = function()
        levelEnabled = false
        resumeAfterBoss.level = false
        if levelThread then task.cancel(levelThread) levelThread = nil end
        stopFly()
        lastTeleportedMob = ""
        if not noclipNeeded() then stopNoclip() end
    end

    startLevel = function()
        if not levelEnabled then return end
        startNoclip()
        levelThread = task.spawn(function()
            while levelEnabled do
                if not isAlive() then
                    stopFly()
                    waitForCharacter()
                    if not levelEnabled then break end
                    equipWeapon()
                    lastTeleportedMob = ""
                    task.wait(0.5)
                end
                if not levelEnabled then break end

                local lvl   = getPlayerLevel()
                local quest = getQuestForLevel(lvl)
                teleportForMob(quest.mob)
                if not levelEnabled then break end

                pcall(function() QuestAccept:FireServer(quest.npc) end)

                local mobs = getAllMobs(quest.mob)
                if #mobs == 0 then
                    task.wait(0.5) -- keep scanning, stay in air
                else
                    local mob    = mobs[1]
                    local root   = mob:FindFirstChild("HumanoidRootPart")
                    local mobHum = mob:FindFirstChildOfClass("Humanoid")
                    if root and mobHum and mobHum.Health > 0 then
                        snapNearTarget(root, 120)
                        flyAbove(root)
                        local t = 0
                        repeat
                            task.wait(0.1)
                            t += 0.1
                            flyAbove(root)
                            if t % 2 == 0 then
                                pcall(function() QuestAccept:FireServer(quest.npc) end)
                            end
                            local newQuest = getQuestForLevel(getPlayerLevel())
                            if newQuest.npc ~= quest.npc then
                                lastTeleportedMob = ""
                                Rayfield:Notify({ Title = "Auto Level", Content = "Level up! → " .. newQuest.mob, Duration = 4, Image = 4483362458 })
                                break
                            end
                        until mobHum.Health <= 0 or not levelEnabled or t > 20 or not isAlive()
                        stopFly()
                        pcall(function() QuestAccept:FireServer(quest.npc) end)
                        task.wait(0.1)
                    end
                end
            end
            stopFly()
        end)
    end

    -- ── Respawn handler ───────────────────────────────────────────────────────

    LocalPlayer.CharacterAdded:Connect(function()
        stopFly()
        if noclipThread then task.cancel(noclipThread) noclipThread = nil end
        task.wait(2)
        equipWeapon()
        if skillEnabled       then startSkill()   end
        if mobEnabled         then startMob()     end
        if bossEnabled        then startBoss()    end
        if levelEnabled       then startLevel()   end
        if upgradeEnabled     then startUpgrade() end
        if noclipNeeded()     then startNoclip()  end
        if specialBossEnabled then
            -- Don't cancel specialBossThread here — fightDetectedBoss handles
            -- death internally via waitForCharacter. Only restart if the thread
            -- has actually died (e.g. crashed), not just because we respawned.
            if not specialBossThread then
                startSpecialBossLoop()
            end
        end
    end)

    -- ╔══════════════════════════════════════════════════════╗
    -- ║                 SAILOR PIECE UI                      ║
    -- ╚══════════════════════════════════════════════════════╝

    windowConfig.Name            = "DRAG HUB | Sailor Piece"
    windowConfig.LoadingTitle    = "<b>DRAG HUB</b>"
    windowConfig.LoadingSubtitle = "Sailor Piece"

    local Window = Rayfield:CreateWindow(windowConfig)

    -- ── TAB 1: AUTO MOB ───────────────────────────────────────────────────────

    local SPTab = Window:CreateTab("Auto Mob", 4483362458)

    SPTab:CreateSection("🗡 Weapon")

    local function getInventory()
        local tools, seen = {}, {}
        local function addTools(parent)
            if not parent then return end
            for _, obj in pairs(parent:GetChildren()) do
                if obj:IsA("Tool") and not seen[obj.Name] then
                    seen[obj.Name] = true
                    table.insert(tools, obj.Name)
                end
            end
        end
        addTools(LocalPlayer.Backpack)
        addTools(LocalPlayer.Character)
        if #tools == 0 then table.insert(tools, "No tools found") end
        return tools
    end

    inventoryList = getInventory()

    local WeaponDropdown = SPTab:CreateDropdown({
        Name = "Select Weapon", Options = inventoryList,
        CurrentOption = {inventoryList[1]}, MultipleOptions = false, Flag = "WeaponDropdown",
        Callback = function(options)
            selectedWeapon = options[1]
            if selectedWeapon and selectedWeapon ~= "No tools found" then
                equipWeapon(selectedWeapon)
                Rayfield:Notify({ Title = "Weapon", Content = selectedWeapon .. " equipped!", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    SPTab:CreateButton({
        Name = "🔄 Refresh Inventory",
        Callback = function()
            inventoryList = getInventory()
            WeaponDropdown:Refresh(inventoryList)
            Rayfield:Notify({ Title = "Weapon", Content = "Refreshed! " .. #inventoryList .. " tool(s) found.", Duration = 3, Image = 4483362458 })
        end,
    })

    SPTab:CreateSlider({
        Name = "Fly Height (Studs)", Range = {1, 50}, Increment = 1,
        Suffix = " studs", CurrentValue = 10, Flag = "FlyHeightSlider",
        Callback = function(val) FLY_HEIGHT = val end,
    })

    SPTab:CreateDivider()
    SPTab:CreateSection("👊 Mobs")

    local MobFarmToggle = SPTab:CreateToggle({
        Name = "Auto Farm Mob", CurrentValue = false,
        Callback = function(val)
            if val then
                if #selectedMobs == 0 then
                    Rayfield:Notify({ Title = "Auto Farm Mob", Content = "⚠ Select at least one mob from the dropdown first!", Duration = 4, Image = 4483362458 })
                    task.defer(function() MobFarmToggle:Set(false) end)
                    return
                end
                equipWeapon() mobEnabled = true startMob()
                Rayfield:Notify({ Title = "Auto Mob", Content = "Farming: " .. table.concat(selectedMobs, ", "), Duration = 3, Image = 4483362458 })
            else
                mobEnabled = false stopMob()
                Rayfield:Notify({ Title = "Auto Mob", Content = "Mob farm stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    SPTab:CreateDropdown({
        Name = "Select Mob(s)", Options = mobList, CurrentOption = {},
        MultipleOptions = true, Flag = "MobDropdown",
        Callback = function(options)
            selectedMobs = options
            lastTeleportedMob = ""
            if mobEnabled then stopMob() mobEnabled = true startMob() end
            Rayfield:Notify({ Title = "Auto Mob", Content = "Mobs: " .. (#options > 0 and table.concat(options, ", ") or "None"), Duration = 2, Image = 4483362458 })
        end,
    })

    SPTab:CreateDropdown({
        Name = "Quest Mode", Options = {"No Quest", "With Quest"},
        CurrentOption = {"No Quest"}, MultipleOptions = false, Flag = "QuestModeDropdown",
        Callback = function(options)
            mobQuestMode = options[1] or "No Quest"
            if mobEnabled then stopMob() mobEnabled = true startMob() end
            Rayfield:Notify({ Title = "Quest Mode", Content = "Mode: " .. mobQuestMode, Duration = 2, Image = 4483362458 })
        end,
    })

    SPTab:CreateDivider()
    SPTab:CreateSection("💀 Boss")

    local BossFarmToggle = SPTab:CreateToggle({
        Name = "Auto Farm Boss", CurrentValue = false,
        Callback = function(val)
            if val then
                equipWeapon() bossEnabled = true startBoss()
                Rayfield:Notify({ Title = "Auto Boss", Content = "Farming: " .. selectedBoss, Duration = 3, Image = 4483362458 })
            else
                bossEnabled = false stopBoss()
                Rayfield:Notify({ Title = "Auto Boss", Content = "Boss farm stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    SPTab:CreateDropdown({
        Name = "Select Boss", Options = bossList, CurrentOption = {"ThiefBoss"},
        MultipleOptions = false, Flag = "BossDropdown",
        Callback = function(options)
            if options[1] then
                selectedBoss = options[1]
                if bossEnabled then
                    lastTeleportedMob = ""
                    if not bossThread then bossEnabled = true equipWeapon() startBoss() end
                end
                Rayfield:Notify({ Title = "Auto Boss", Content = "Boss: " .. selectedBoss, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    SPTab:CreateDivider()
    SPTab:CreateSection("📈 Upgrade Stats")

    local UpgradeToggle = SPTab:CreateToggle({
        Name = "Auto Upgrade Stat", CurrentValue = false,
        Callback = function(val)
            if val then
                if #selectedStats == 0 then
                    Rayfield:Notify({ Title = "Upgrade Stats", Content = "Select at least one stat first!", Duration = 3, Image = 4483362458 })
                    UpgradeToggle:Set(false) return
                end
                startUpgrade()
                Rayfield:Notify({ Title = "Upgrade Stats", Content = "Upgrading: " .. table.concat(selectedStats, ", "), Duration = 3, Image = 4483362458 })
            else
                stopUpgrade()
                Rayfield:Notify({ Title = "Upgrade Stats", Content = "Upgrade stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    SPTab:CreateDropdown({
        Name = "Select Stats",
        Options = {"Melee", "Defense", "Sword", "Power"},
        CurrentOption = {"Melee"}, MultipleOptions = true, Flag = "StatDropdown",
        Callback = function(options)
            selectedStats = options
            Rayfield:Notify({ Title = "Upgrade Stats", Content = "Stats: " .. (#options > 0 and table.concat(options, ", ") or "None"), Duration = 2, Image = 4483362458 })
        end,
    })

    SPTab:CreateDivider()
    SPTab:CreateSection("⚙ Controls")

    SPTab:CreateButton({
        Name = "Stop All",
        Callback = function()
            mobEnabled = false bossEnabled = false
            skillEnabled = false levelEnabled = false upgradeEnabled = false
            stopMob() stopBoss() stopSkill() stopLevel()
            stopFly() stopUpgrade() stopNoclip() stopSpecialBoss()
            MobFarmToggle:Set(false)  BossFarmToggle:Set(false)
            SkillToggle:Set(false)    UpgradeToggle:Set(false)
            Rayfield:Notify({ Title = "DRAG HUB", Content = "All farming stopped.", Duration = 3, Image = 4483362458 })
        end,
    })


    -- ── TAB: PLAYER ──────────────────────────────────────────────────────────

    local PlayerTab = Window:CreateTab("Player", 4483362458)

    -- ── Remotes ──
    local HakiRemote = nil
    pcall(function()
        HakiRemote = ReplicatedStorage
            :WaitForChild("RemoteEvents", 10)
            :WaitForChild("HakiRemote", 10)
    end)

    local DeathVFX = nil
    pcall(function()
        DeathVFX = ReplicatedStorage
            :WaitForChild("RemoteEvents", 10)
            :WaitForChild("DeathVFX", 10)
    end)

    local ObservationHakiRemote = nil
    pcall(function()
        ObservationHakiRemote = ReplicatedStorage
            :WaitForChild("RemoteEvents", 10)
            :WaitForChild("ObservationHakiRemote", 10)
    end)

    -- ── State ──
    local autoHakiEnabled        = false
    local autoObsHakiEnabled     = false
    local obsHakiThread          = nil
    local obsHakiDeathConnection = nil
    local hakiDeathConnection    = nil

    -- ── Section: Auto M1 ──
    PlayerTab:CreateSection("🥊 Auto M1")

    PlayerTab:CreateToggle({
        Name = "Auto M1 Attack", CurrentValue = false, Flag = "AutoM1Toggle",
        Callback = function(val)
            autoM1Enabled = val
            if val then
                Rayfield:Notify({ Title = "Auto M1", Content = "M1 attack enabled!", Duration = 2, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Auto M1", Content = "M1 attack disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    PlayerTab:CreateDivider()

    -- ── Section: Auto Skill ──
    PlayerTab:CreateSection("✨ Auto Skill")

    local SkillToggle = PlayerTab:CreateToggle({
        Name = "Auto Skill", CurrentValue = false,
        Callback = function(val)
            if val then
                if #selectedSkills == 0 then
                    Rayfield:Notify({ Title = "Auto Skill", Content = "Select at least one skill first!", Duration = 3, Image = 4483362458 })
                    SkillToggle:Set(false) return
                end
                startSkill()
                Rayfield:Notify({ Title = "Auto Skill", Content = "Auto Skill enabled!", Duration = 3, Image = 4483362458 })
            else
                stopSkill()
            end
        end,
    })

    PlayerTab:CreateDropdown({
        Name = "Select Skills",
        Options = {"Z (Skill 1)", "X (Skill 2)", "C (Skill 3)", "V (Skill 4)", "F (Skill 5)"},
        CurrentOption = {}, MultipleOptions = true, Flag = "SkillDropdown",
        Callback = function(options)
            selectedSkills = options
            Rayfield:Notify({ Title = "Auto Skill", Content = "Skills: " .. (#options > 0 and table.concat(options, ", ") or "None"), Duration = 2, Image = 4483362458 })
        end,
    })

    PlayerTab:CreateDivider()

    -- ── Section: Auto Haki ──
    PlayerTab:CreateSection("🔥 Auto Haki")

    PlayerTab:CreateToggle({
        Name = "Auto Haki", CurrentValue = false,
        Callback = function(val)
            autoHakiEnabled = val
            if val then
                -- Activate haki immediately on enable
                pcall(function() HakiRemote:FireServer("Toggle") end)
                -- Connect death handler: fire DeathVFX then re-toggle haki on respawn
                if hakiDeathConnection then hakiDeathConnection:Disconnect() hakiDeathConnection = nil end
                hakiDeathConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                    if not autoHakiEnabled then return end
                    task.wait(1.5)
                    pcall(function() DeathVFX:FireServer(LocalPlayer.Character) end)
                    task.wait(0.5)
                    pcall(function() HakiRemote:FireServer("Toggle") end)
                end)
                Rayfield:Notify({ Title = "Auto Haki", Content = "Haki activated! Will auto re-activate on death.", Duration = 3, Image = 4483362458 })
            else
                autoHakiEnabled = false
                if hakiDeathConnection then hakiDeathConnection:Disconnect() hakiDeathConnection = nil end
                Rayfield:Notify({ Title = "Auto Haki", Content = "Auto Haki disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    PlayerTab:CreateDivider()

    -- ── Section: Auto Observation Haki ──
    PlayerTab:CreateSection("👁 Auto Observation Haki")

    local function stopObsHaki()
        autoObsHakiEnabled = false
        if obsHakiThread then task.cancel(obsHakiThread) obsHakiThread = nil end
        if obsHakiDeathConnection then obsHakiDeathConnection:Disconnect() obsHakiDeathConnection = nil end
    end

    local function startObsHaki()
        if not autoObsHakiEnabled then return end
        if obsHakiThread then task.cancel(obsHakiThread) obsHakiThread = nil end
        obsHakiThread = task.spawn(function()
            while autoObsHakiEnabled do
                pcall(function() ObservationHakiRemote:FireServer("Toggle") end)
                -- Wait 60 seconds, checking every second so death can reset timer
                local waited = 0
                while waited < 60 and autoObsHakiEnabled do
                    task.wait(1)
                    waited += 1
                end
            end
        end)
    end

    PlayerTab:CreateToggle({
        Name = "Auto Observation Haki", CurrentValue = false,
        Callback = function(val)
            if val then
                autoObsHakiEnabled = true
                startObsHaki()
                -- Reset timer and reactivate on death
                if obsHakiDeathConnection then obsHakiDeathConnection:Disconnect() obsHakiDeathConnection = nil end
                obsHakiDeathConnection = LocalPlayer.CharacterAdded:Connect(function()
                    if not autoObsHakiEnabled then return end
                    task.wait(1.5)
                    -- Reset timer by restarting the loop
                    if obsHakiThread then task.cancel(obsHakiThread) obsHakiThread = nil end
                    startObsHaki()
                end)
                Rayfield:Notify({ Title = "Obs Haki", Content = "Auto Observation Haki enabled!", Duration = 3, Image = 4483362458 })
            else
                stopObsHaki()
                Rayfield:Notify({ Title = "Obs Haki", Content = "Auto Observation Haki disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    -- ── TAB 2: TELEPORT ───────────────────────────────────────────────────────

    local TPTab = Window:CreateTab("Teleport", 4483362458)

    TPTab:CreateSection("🌍 Islands")

    local islandList     = { "Starter", "Jungle", "Desert", "Snow", "Sailor", "Shibuya", "HuecoMundo", "Boss", "Dungeon", "Shinjuko", "Slime", "Academy", "Judgement", "SoulSociety" }
    local selectedIsland = "Starter"

    TPTab:CreateDropdown({
        Name = "Select Island", Options = islandList,
        CurrentOption = {"Starter"}, MultipleOptions = false, Flag = "IslandDropdown",
        Callback = function(options)
            selectedIsland = options[1]
            Rayfield:Notify({ Title = "Teleport", Content = "Selected: " .. selectedIsland, Duration = 2, Image = 4483362458 })
        end,
    })

    TPTab:CreateButton({
        Name = "🚀 Teleport",
        Callback = function()
            pcall(function() TeleportRemote:FireServer(selectedIsland) end)
            Rayfield:Notify({ Title = "Teleport", Content = "Teleporting to " .. selectedIsland .. "!", Duration = 3, Image = 4483362458 })
        end,
    })

    TPTab:CreateDivider()
    TPTab:CreateSection("🧑 NPC Teleport")

    local NPCDatabase      = {}
    local selectedNPC      = ""
    local islandLoadThread = nil

    local function getNPCPos(npc)
        if not npc then return nil end
        local hrp = npc:FindFirstChild("HumanoidRootPart")
        if hrp then return hrp.Position end
        if npc.PrimaryPart then return npc.PrimaryPart.Position end
        for _, part in ipairs(npc:GetDescendants()) do
            if part:IsA("BasePart") then return part.Position end
        end
        return nil
    end

    local function getDatabaseNames()
        local list = {}
        for name in pairs(NPCDatabase) do table.insert(list, name) end
        table.sort(list)
        if #list == 0 then table.insert(list, "None") end
        return list
    end

    local function scanAndStoreNPCs()
        local folder = workspace:FindFirstChild("ServiceNPCs")
        if not folder then return end
        for _, npc in ipairs(folder:GetChildren()) do
            if npc:IsA("Model") then
                local pos = getNPCPos(npc)
                if pos then NPCDatabase[npc.Name] = pos end
            end
        end
    end

    -- Don't auto-scan on startup — list starts empty, player uses Load All Islands
    local npcList = getDatabaseNames() -- returns {"None"} since NPCDatabase is empty

    local NPCDropdown = TPTab:CreateDropdown({
        Name = "Select NPC", Options = npcList, CurrentOption = {npcList[1]},
        MultipleOptions = false, Flag = "NPCDropdown",
        Callback = function(options)
            if options[1] and options[1] ~= "None" then
                selectedNPC = options[1]
                Rayfield:Notify({ Title = "NPC Teleport", Content = "Selected: " .. selectedNPC, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    local serviceFolder = workspace:FindFirstChild("ServiceNPCs")
    if serviceFolder then
        serviceFolder.ChildAdded:Connect(function(npc)
            task.wait(0.5)
            if npc:IsA("Model") then
                local pos = getNPCPos(npc)
                if pos then
                    NPCDatabase[npc.Name] = pos
                    NPCDropdown:Refresh(getDatabaseNames(), false)
                end
            end
        end)
        serviceFolder.ChildRemoved:Connect(function()
            NPCDropdown:Refresh(getDatabaseNames(), false)
        end)
    end

    TPTab:CreateButton({
        Name = "🚀 Teleport to NPC",
        Callback = function()
            if selectedNPC == "" or selectedNPC == "None" then
                Rayfield:Notify({ Title = "NPC Teleport", Content = "Select an NPC first!", Duration = 3, Image = 4483362458 })
                return
            end
            local pos = NPCDatabase[selectedNPC]
            if not pos then scanAndStoreNPCs() pos = NPCDatabase[selectedNPC] end
            if pos then
                local c   = LocalPlayer.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
                    Rayfield:Notify({ Title = "NPC Teleport", Content = "Teleported to " .. selectedNPC .. "!", Duration = 3, Image = 4483362458 })
                end
            else
                Rayfield:Notify({ Title = "NPC Teleport", Content = selectedNPC .. " not found. Try Load All Islands.", Duration = 4, Image = 4483362458 })
            end
        end,
    })

    TPTab:CreateButton({
        Name = "🌐 Load All Islands (Auto Scan NPCs)",
        Callback = function()
            if islandLoadThread then
                task.cancel(islandLoadThread) islandLoadThread = nil
                Rayfield:Notify({ Title = "NPC Scan", Content = "Stopped.", Duration = 3, Image = 4483362458 })
                return
            end
            Rayfield:Notify({ Title = "NPC Scan", Content = "Visiting all islands...", Duration = 5, Image = 4483362458 })
            islandLoadThread = task.spawn(function()
                for _, island in ipairs(islandList) do
                    pcall(function() TeleportRemote:FireServer(island) end)
                    task.wait(1)
                    scanAndStoreNPCs()
                    NPCDropdown:Refresh(getDatabaseNames(), false)
                end
                local count = 0
                for _ in pairs(NPCDatabase) do count += 1 end
                Rayfield:Notify({ Title = "NPC Scan", Content = "Done! " .. count .. " NPCs stored.", Duration = 5, Image = 4483362458 })
                islandLoadThread = nil
            end)
        end,
    })

    -- ── TAB 3: BOSS FARM ──────────────────────────────────────────────────────

    local SBTab = Window:CreateTab("Boss Farm", 4483362458)

    SBTab:CreateSection("⚔ Special Bosses")

    SBTab:CreateDropdown({
        Name = "Select Bosses",
        Options = { "AizenBoss", "AlucardBoss", "GojoBoss", "JinwooBoss", "SukunaBoss", "YujiBoss", "YamatoBoss" },
        CurrentOption = {}, MultipleOptions = true, Flag = "SpecialBossDropdown",
        Callback = function(options)
            selectedSpecialBosses = options
            Rayfield:Notify({ Title = "Boss Farm", Content = "Selected: " .. (#options > 0 and table.concat(options, ", ") or "None"), Duration = 2, Image = 4483362458 })
            -- If already running, restart so new selection takes effect immediately
            if specialBossEnabled then
                stopSpecialBoss()
                if #selectedSpecialBosses > 0 then
                    equipWeapon()
                    startSpecialBossLoop()
                end
            end
        end,
    })

    local SpecialBossFarmToggle = SBTab:CreateToggle({
        Name = "Auto Farm Boss", CurrentValue = false,
        Callback = function(val)
            if val then
                if #selectedSpecialBosses == 0 then
                    Rayfield:Notify({ Title = "Boss Farm", Content = "Select at least one boss first!", Duration = 3, Image = 4483362458 })
                    SpecialBossFarmToggle:Set(false) return
                end
                equipWeapon()
                startSpecialBossLoop()
                Rayfield:Notify({ Title = "Boss Farm", Content = "Watching for: " .. table.concat(selectedSpecialBosses, ", "), Duration = 4, Image = 4483362458 })
            else
                stopSpecialBoss()
                Rayfield:Notify({ Title = "Boss Farm", Content = "Boss farm stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    SBTab:CreateDivider()
    SBTab:CreateSection("⚙ Controls")

    SBTab:CreateButton({
        Name = "Stop Boss Farm",
        Callback = function()
            stopSpecialBoss()
            SpecialBossFarmToggle:Set(false)
            Rayfield:Notify({ Title = "Boss Farm", Content = "Stopped.", Duration = 3, Image = 4483362458 })
        end,
    })

    SBTab:CreateDivider()
    SBTab:CreateSection("⚡ Instant Kill")

    SBTab:CreateToggle({
        Name = "⚡ Instant Kill Special Boss", CurrentValue = false,
        Callback = function(val)
            instantKillMob = val
            if val then
                Rayfield:Notify({ Title = "Instant Kill", Content = "Special bosses will be killed instantly!", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Instant Kill", Content = "Instant Kill disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    SBTab:CreateDivider()
    SBTab:CreateSection("🔮 Auto Summon Boss")

    local summonBossData = {
        ["Anos"] = {
            npcPath = "AnosBoss_Normal",
            pos     = Vector3.new(950.100, 1.463, 1378.449),
            remote  = "RequestSpawnAnosBoss",
            folder  = "Remotes",
            args    = function(d) return {"Anos", d} end,
        },
        ["Rimuru"] = {
            npcPath = "RimuruBoss_Normal",
            pos     = Vector3.new(-1363.471, 22.349, 221.351),
            remote  = "RequestSpawnRimuru",
            folder  = "RemoteEvents",
            args    = function(d) return {d} end,
        },
        ["Strongest of Today"] = {
            npcPath = "StrongestofTodayBoss_Normal",
            pos     = Vector3.new(136.511, 5.243, -2431.629),
            remote  = "RequestSpawnStrongestBoss",
            folder  = "Remotes",
            args    = function(d) return {"StrongestToday", d} end,
        },
        ["Strongest in History"] = {
            npcPath = "StrongestinHistoryBoss_Normal",
            pos     = Vector3.new(611.819, 3.668, -2315.373),
            remote  = "RequestSpawnStrongestBoss",
            folder  = "Remotes",
            args    = function(d) return {"StrongestHistory", d} end,
        },
        ["Saber"] = {
            npcPath = "SaberBoss",
            pos     = Vector3.new(776.951, -2.672, -1090.399),
            remote  = "RequestSummonBoss",
            folder  = "Remotes",
            args    = function(_) return {"SaberBoss"} end,
        },
        ["Qinshi"] = {
            npcPath = "QinShiBoss",
            pos     = Vector3.new(776.951, -2.672, -1090.399),
            remote  = "RequestSummonBoss",
            folder  = "Remotes",
            args    = function(_) return {"QinShiBoss"} end,
        },
        ["Ichigo"] = {
            npcPath = "IchigoBoss",
            pos     = Vector3.new(776.951, -2.672, -1090.399),
            remote  = "RequestSummonBoss",
            folder  = "Remotes",
            args    = function(_) return {"IchigoBoss"} end,
        },
        ["Gilgamesh"] = {
            npcPath = "GilgameshBoss",
            pos     = Vector3.new(776.951, -2.672, -1090.399),
            remote  = "RequestSummonBoss",
            folder  = "Remotes",
            args    = function(d) return {"GilgameshBoss", d} end,
        },
        ["TrueAizen"] = {
            npcPath = "TrueAizenBoss_Normal",
            pos     = Vector3.new(-1199.470, 1604.119, 1775.046),
            remote  = "RequestSpawnTrueAizen",
            folder  = "RemoteEvents",
            args    = function(d) return {d} end,
        },
        ["BlessedMaiden"] = {
            npcPath = "BlessedMaidenBoss",
            pos     = Vector3.new(776.951, -2.672, -1090.399),
            remote  = "RequestSummonBoss",
            folder  = "Remotes",
            args    = function(d) return {"BlessedMaidenBoss", d} end,
        },
    }

    local selectedSummonBoss = "Anos"
    local selectedDifficulty = "Normal"
    local summonFarmEnabled  = false
    local summonFarmThread   = nil

    local summonBossNames = {}
    for name in pairs(summonBossData) do table.insert(summonBossNames, name) end
    table.sort(summonBossNames)

    SBTab:CreateDropdown({
        Name = "Select Summon Boss", Options = summonBossNames, CurrentOption = {"Anos"},
        MultipleOptions = false, Flag = "SummonBossDropdown",
        Callback = function(options)
            if options[1] then
                selectedSummonBoss = options[1]
                Rayfield:Notify({ Title = "Summon Boss", Content = "Selected: " .. selectedSummonBoss, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    local function stopAutoSummon()
        autoSummonEnabled = false
        if autoSummonThread then task.cancel(autoSummonThread) autoSummonThread = nil end
    end

    SBTab:CreateToggle({
        Name = "⚡ Auto Summon Boss", CurrentValue = false,
        Callback = function(val)
            if val then
                autoSummonEnabled = true
                autoSummonThread  = task.spawn(function()
                    while autoSummonEnabled do
                        local data = summonBossData[selectedSummonBoss]
                        if data then
                            pcall(function()
                                local remote = ReplicatedStorage:WaitForChild(data.folder, 5):WaitForChild(data.remote, 5)
                                remote:FireServer(unpack(data.args(selectedDifficulty)))
                            end)
                        end
                        task.wait(2)
                    end
                end)
                Rayfield:Notify({ Title = "Auto Summon", Content = "Summoning " .. selectedSummonBoss .. " (" .. selectedDifficulty .. ")", Duration = 3, Image = 4483362458 })
            else
                stopAutoSummon()
                Rayfield:Notify({ Title = "Auto Summon", Content = "Auto summon stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    SBTab:CreateDropdown({
        Name = "Difficulty", Options = {"Normal", "Medium", "Hard", "Extreme"},
        CurrentOption = {"Normal"}, MultipleOptions = false, Flag = "DifficultyDropdown",
        Callback = function(options)
            if options[1] then
                selectedDifficulty = options[1]
                Rayfield:Notify({ Title = "Difficulty", Content = "Set to: " .. selectedDifficulty, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    local function stopSummonFarm()
        summonFarmEnabled = false
        if summonFarmThread then task.cancel(summonFarmThread) summonFarmThread = nil end
        stopFly()
        if not noclipNeeded() then stopNoclip() end
    end

    local function startSummonFarm()
        if not summonFarmEnabled then return end
        startNoclip()
        summonFarmThread = task.spawn(function()
            while summonFarmEnabled do
                local data = summonBossData[selectedSummonBoss]
                if not data then
                    task.wait(1)
                else
                    -- Summon the boss
                    pcall(function()
                        local remote = ReplicatedStorage:WaitForChild(data.folder, 5):WaitForChild(data.remote, 5)
                        remote:FireServer(unpack(data.args(selectedDifficulty)))
                    end)
                    Rayfield:Notify({ Title = "Summon Farm", Content = "Summoning " .. selectedSummonBoss .. "...", Duration = 3, Image = 4483362458 })

                    -- Teleport to spawn area
                    local c   = LocalPlayer.Character
                    local hrp = c and c:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = CFrame.new(data.pos + Vector3.new(0, FLY_HEIGHT, 0)) end
                    task.wait(1)

                    -- Wait for boss to fully load (up to 15s)
                    local bossModel, root, bosHum = nil, nil, nil
                    local waited = 0
                    while waited < 15 and summonFarmEnabled do
                        local npcs = workspace:FindFirstChild("NPCs")
                        if npcs then
                            local m = npcs:FindFirstChild(data.npcPath)
                            if m then
                                local r = m:FindFirstChild("HumanoidRootPart")
                                local h = m:FindFirstChildOfClass("Humanoid")
                                if r and h and h.Health > 0 then
                                    bossModel, root, bosHum = m, r, h
                                    break
                                end
                            end
                        end
                        task.wait(0.5)
                        waited += 0.5
                    end

                    if bossModel and root and bosHum and summonFarmEnabled then
                        snapNearTarget(root, 120)
                        task.wait(0.15)
                        flyAbove(root)

                        local t = 0
                        repeat
                            task.wait(0.1)
                            t += 0.1
                            flyAbove(root)

                            if not isAlive() then
                                stopFly()
                                waitForCharacter()
                                if not summonFarmEnabled then break end
                                equipWeapon()
                                task.wait(0.5)
                                local npcs2 = workspace:FindFirstChild("NPCs")
                                if npcs2 then
                                    local m2 = npcs2:FindFirstChild(data.npcPath)
                                    if m2 then
                                        root   = m2:FindFirstChild("HumanoidRootPart")
                                        bosHum = m2:FindFirstChildOfClass("Humanoid")
                                        if root and bosHum and bosHum.Health > 0 then
                                            snapNearTarget(root, 120)
                                            task.wait(0.15)
                                            flyAbove(root)
                                        end
                                    end
                                end
                            end
                        until not bosHum or bosHum.Health <= 0 or not summonFarmEnabled or t > 120

                        stopFly()
                    end

                    if summonFarmEnabled then
                        Rayfield:Notify({ Title = "Summon Farm", Content = selectedSummonBoss .. " defeated! Re-summoning...", Duration = 3, Image = 4483362458 })
                        task.wait(1)
                    end
                end
            end
            stopFly()
        end)
    end

    SBTab:CreateToggle({
        Name = "⚔ Auto Farm Summoned Boss", CurrentValue = false,
        Callback = function(val)
            if val then
                equipWeapon() summonFarmEnabled = true startSummonFarm()
                Rayfield:Notify({ Title = "Summon Farm", Content = "Farming " .. selectedSummonBoss .. " (" .. selectedDifficulty .. ")", Duration = 3, Image = 4483362458 })
            else
                stopSummonFarm()
                Rayfield:Notify({ Title = "Summon Farm", Content = "Summon farm stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })


    SBTab:CreateDivider()
    SBTab:CreateSection("⚡ Instant Kill")

    local instantKillEnabled    = false
    local instantKillConnections = {}
    local instantKillTracked    = {}

    local function stopInstantKill()
        instantKillEnabled = false
        for _, conn in ipairs(instantKillConnections) do pcall(function() conn:Disconnect() end) end
        instantKillConnections = {}
        instantKillTracked = {}
    end

    local function trackBossForInstantKill(bossModel)
        if instantKillTracked[bossModel] then return end
        instantKillTracked[bossModel] = true

        local humanoid = bossModel:FindFirstChildWhichIsA("Humanoid")
        if not humanoid then return end

        local maxHealth = humanoid.MaxHealth
        if maxHealth <= 0 then return end

        -- Snapshot health RIGHT NOW as the baseline — only count damage WE deal from this point
        local baselineHealth = humanoid.Health
        local triggered = false

        local conn
        conn = humanoid.HealthChanged:Connect(function(currentHealth)
            if triggered then return end
            if not instantKillEnabled then
                triggered = true
                task.defer(function() pcall(function() conn:Disconnect() end) end)
                return
            end
            -- Only measure damage from our baseline snapshot, not from maxHealth
            -- This prevents pre-existing damage from other players triggering it
            if currentHealth >= baselineHealth then
                -- Health went up (regen) — update baseline so we measure from here
                baselineHealth = currentHealth
                return
            end
            local damagePct = ((baselineHealth - currentHealth) / maxHealth) * 100
            if damagePct >= 15 then
                triggered = true
                task.defer(function()
                    pcall(function() humanoid.Health = 0 end)
                    pcall(function() conn:Disconnect() end)
                    instantKillTracked[bossModel] = nil
                end)
            end
        end)
        table.insert(instantKillConnections, conn)
    end

    local function startInstantKill()
        if not instantKillEnabled then return end
        instantKillTracked = {}

        -- Track all existing NPCs
        local NPCs = workspace:FindFirstChild("NPCs")
        if NPCs then
            for _, npc in ipairs(NPCs:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChildWhichIsA("Humanoid") then
                    trackBossForInstantKill(npc)
                end
            end
            -- Watch for new bosses spawning
            local spawnConn = NPCs.ChildAdded:Connect(function(npc)
                if not instantKillEnabled then return end
                task.wait(0.1)
                if npc:IsA("Model") then
                    trackBossForInstantKill(npc)
                end
            end)
            table.insert(instantKillConnections, spawnConn)
        end
    end

    SBTab:CreateToggle({
        Name = "⚡ Instant Kill Boss", CurrentValue = false,
        Callback = function(val)
            if val then
                instantKillEnabled = true
                startInstantKill()
                Rayfield:Notify({ Title = "Instant Kill", Content = "Watching bosses — will kill at 15% damage!", Duration = 3, Image = 4483362458 })
            else
                stopInstantKill()
                Rayfield:Notify({ Title = "Instant Kill", Content = "Instant Kill disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    -- ── TAB 4: AUTO LEVEL ─────────────────────────────────────────────────────

    local LVTab = Window:CreateTab("Auto Level", 4483362458)

    LVTab:CreateSection("⭐ Auto Level")

    local LevelToggle = LVTab:CreateToggle({
        Name = "Auto Farm Level", CurrentValue = false,
        Callback = function(val)
            if val then
                equipWeapon() levelEnabled = true startLevel()
                local quest = getQuestForLevel(getPlayerLevel())
                Rayfield:Notify({ Title = "Auto Level", Content = "Level " .. getPlayerLevel() .. " → " .. quest.mob, Duration = 4, Image = 4483362458 })
            else
                levelEnabled = false stopLevel()
                Rayfield:Notify({ Title = "Auto Level", Content = "Auto Level stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    LVTab:CreateDivider()
    LVTab:CreateSection("⚙ Controls")

    LVTab:CreateButton({
        Name = "Stop Level Farm",
        Callback = function()
            levelEnabled = false stopLevel()
            LevelToggle:Set(false)
            Rayfield:Notify({ Title = "Auto Level", Content = "Level farm stopped.", Duration = 3, Image = 4483362458 })
        end,
    })




    -- ── TAB 5: MISC ──────────────────────────────────────
    local MiscTab = Window:CreateTab("Misc", 4483362458)

    MiscTab:CreateSection("🛒 Merchant")

    local shopItemNames = {
        "Trait Reroll", "Haki Color Reroll", "Race Reroll",
        "Rush Key", "Boss Key", "Dungeon Key", "Clan Reroll",
    }

    -- Items the player wants to buy (multi-select)
    local selectedShopItems = {}
    local autoBuyEnabled    = false
    local autoBuyThread     = nil

    local PurchaseRemote = nil
    pcall(function()
        PurchaseRemote = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("MerchantRemotes", 10)
            :WaitForChild("PurchaseMerchantItem", 10)
    end)

    local GetStockRemote = nil
    pcall(function()
        GetStockRemote = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("MerchantRemotes", 10)
            :WaitForChild("GetMerchantStock", 10)
    end)

    MiscTab:CreateButton({
        Name = "📦 Get Merchant Stock",
        Callback = function()
            local ok, result = pcall(function()
                return GetStockRemote:InvokeServer()
            end)
            if ok and result then
                if type(result) == "table" then
                    local lines = {}
                    for k, v in pairs(result) do
                        table.insert(lines, tostring(k) .. ": " .. tostring(v))
                    end
                    local text = #lines > 0 and table.concat(lines, " | ") or "Empty stock"
                    Rayfield:Notify({ Title = "Merchant Stock", Content = text, Duration = 8, Image = 4483362458 })
                else
                    Rayfield:Notify({ Title = "Merchant Stock", Content = tostring(result), Duration = 6, Image = 4483362458 })
                end
                print("[DRAG HUB] Merchant Stock:", result)
            else
                Rayfield:Notify({ Title = "Merchant Stock", Content = "Failed — are you near a merchant?", Duration = 4, Image = 4483362458 })
            end
        end,
    })

    MiscTab:CreateDivider()
    MiscTab:CreateSection("🛍 Auto Buy")

    MiscTab:CreateDropdown({
        Name = "Select Item(s) to Buy",
        Options = shopItemNames,
        CurrentOption = {}, MultipleOptions = true, Flag = "ShopItemDropdown",
        Callback = function(options)
            selectedShopItems = options
            local names = #options > 0 and table.concat(options, ", ") or "None"
            Rayfield:Notify({ Title = "Auto Buy", Content = "Selected: " .. names, Duration = 2, Image = 4483362458 })
        end,
    })

    local AutoBuyToggle = MiscTab:CreateToggle({
        Name = "Auto Buy", CurrentValue = false,
        Callback = function(val)
            if val then
                if #selectedShopItems == 0 then
                    Rayfield:Notify({ Title = "Auto Buy", Content = "⚠ Select at least one item first!", Duration = 4, Image = 4483362458 })
                    task.defer(function() AutoBuyToggle:Set(false) end)
                    return
                end
                autoBuyEnabled = true
                autoBuyThread = task.spawn(function()
                    while autoBuyEnabled do
                        for _, itemName in ipairs(selectedShopItems) do
                            if not autoBuyEnabled then break end
                            pcall(function()
                                PurchaseRemote:InvokeServer(itemName, 1)
                            end)
                        end
                        -- No wait — buy as fast as the server allows
                    end
                end)
                Rayfield:Notify({ Title = "Auto Buy", Content = "Buying: " .. table.concat(selectedShopItems, ", "), Duration = 3, Image = 4483362458 })
            else
                autoBuyEnabled = false
                if autoBuyThread then task.cancel(autoBuyThread) autoBuyThread = nil end
                Rayfield:Notify({ Title = "Auto Buy", Content = "Auto buy stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })


    MiscTab:CreateDivider()
    MiscTab:CreateSection("⚗ Crafting")

    local autoCraftGrailEnabled = false
    local autoCraftGrailThread  = nil
    local RequestGrailCraft = nil
    pcall(function()
        RequestGrailCraft = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("RequestGrailCraft", 10)
    end)

    MiscTab:CreateToggle({
        Name = "Auto Craft Divine Grail", CurrentValue = false,
        Callback = function(val)
            if val then
                autoCraftGrailEnabled = true
                autoCraftGrailThread = task.spawn(function()
                    while autoCraftGrailEnabled do
                        pcall(function()
                            RequestGrailCraft:InvokeServer("DivineGrail", 1)
                        end)
                        task.wait(0.1)
                    end
                end)
                Rayfield:Notify({ Title = "Auto Craft", Content = "Crafting Divine Grail!", Duration = 3, Image = 4483362458 })
            else
                autoCraftGrailEnabled = false
                if autoCraftGrailThread then task.cancel(autoCraftGrailThread) autoCraftGrailThread = nil end
                Rayfield:Notify({ Title = "Auto Craft", Content = "Divine Grail crafting stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })



    MiscTab:CreateDivider()
    MiscTab:CreateSection("🛡 Anti AFK")

    local antiAfkEnabled    = false
    local antiAfkThread     = nil
    local antiAfkIdleConn   = nil
    local VirtualUser       = game:GetService("VirtualUser")

    local function stopAntiAfk()
        antiAfkEnabled = false
        if antiAfkThread   then task.cancel(antiAfkThread)   antiAfkThread   = nil end
        if antiAfkIdleConn then antiAfkIdleConn:Disconnect() antiAfkIdleConn = nil end
    end

    local function startAntiAfk()
        if not antiAfkEnabled then return end

        -- Method 1: Intercept Roblox's Idled event and simulate right-click to reset idle timer
        if antiAfkIdleConn then antiAfkIdleConn:Disconnect() end
        antiAfkIdleConn = LocalPlayer.Idled:Connect(function()
            if not antiAfkEnabled then return end
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)

        -- Method 2: Every 4-6 minutes, simulate camera nudge + key tap + tiny movement
        -- Randomized timing so it looks human
        antiAfkThread = task.spawn(function()
            while antiAfkEnabled do
                -- Randomize wait between 240-360 seconds (4-6 min)
                local waitTime = math.random(240, 360)
                local elapsed  = 0
                while elapsed < waitTime and antiAfkEnabled do
                    task.wait(1)
                    elapsed += 1
                end
                if not antiAfkEnabled then break end

                -- Simulate a small camera movement
                pcall(function()
                    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(0.05)
                    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)

                -- Simulate a key tap (spacebar — harmless)
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end)

                -- Simulate tiny humanoid movement so server-side position checks don't flag us
                pcall(function()
                    local char = LocalPlayer.Character
                    local hum  = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        hum:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)), true)
                        task.wait(0.1)
                        hum:Move(Vector3.new(0, 0, 0), true)
                    end
                end)
            end
        end)
    end

    MiscTab:CreateToggle({
        Name = "🛡 Anti AFK", CurrentValue = false,
        Callback = function(val)
            if val then
                antiAfkEnabled = true
                startAntiAfk()
                Rayfield:Notify({ Title = "Anti AFK", Content = "Anti AFK enabled — you won't be kicked!", Duration = 4, Image = 4483362458 })
            else
                stopAntiAfk()
                Rayfield:Notify({ Title = "Anti AFK", Content = "Anti AFK disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    -- ── TAB 6: AUTO DUNGEON ──────────────────────────────
    local DGTab = Window:CreateTab("Auto Dungeon", 4483362458)

    -- ── Remotes ──
    local RequestDungeonPortal = nil
    pcall(function()
        RequestDungeonPortal = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("RequestDungeonPortal", 10)
    end)

    local DungeonWaveVote = nil
    pcall(function()
        DungeonWaveVote = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("DungeonWaveVote", 10)
    end)

    local DungeonReplayVote = nil
    pcall(function()
        DungeonReplayVote = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("DungeonWaveReplayVote", 10)
    end)

    -- ── State ──
    local dungeonList = {
        { name = "Cid",    arg = "CidDungeon"    },
        { name = "Rune",   arg = "RuneDungeon"   },
        { name = "Double", arg = "DoubleDungeon" },
    }
    local dungeonNames        = { "Cid", "Rune", "Double" }
    local selectedDungeon     = "Cid"
    local selectedDungeonDiff = "Easy"
    local dungeonKillEnabled  = false
    local dungeonKillThread   = nil
    local autoReplayEnabled   = false
    local autoReplayThread    = nil

    local function getDungeonArg(name)
        for _, d in ipairs(dungeonList) do
            if d.name == name then return d.arg end
        end
        return nil
    end

    -- ── Section: Join Dungeon ──
    DGTab:CreateSection("🏯 Dungeon")

    DGTab:CreateDropdown({
        Name = "Select Dungeon", Options = dungeonNames,
        CurrentOption = {"Cid"}, MultipleOptions = false, Flag = "DungeonDropdown",
        Callback = function(options)
            if options[1] then
                selectedDungeon = options[1]
                Rayfield:Notify({ Title = "Dungeon", Content = "Selected: " .. selectedDungeon, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    DGTab:CreateButton({
        Name = "🚪 Auto Join Dungeon",
        Callback = function()
            local arg = getDungeonArg(selectedDungeon)
            if arg and RequestDungeonPortal then
                pcall(function() RequestDungeonPortal:FireServer(arg) end)
                Rayfield:Notify({ Title = "Dungeon", Content = "Joining " .. selectedDungeon .. " dungeon...", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Dungeon", Content = "Failed to join dungeon.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    DGTab:CreateButton({
        Name = "⚔ Join Boss Rush",
        Callback = function()
            if RequestDungeonPortal then
                pcall(function() RequestDungeonPortal:FireServer("BossRush") end)
                Rayfield:Notify({ Title = "Dungeon", Content = "Joining Boss Rush...", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Dungeon", Content = "Failed to join Boss Rush.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    DGTab:CreateDivider()

    -- ── Section: Difficulty & Auto Replay ──
    DGTab:CreateSection("⚔ Difficulty & Auto Replay")

    DGTab:CreateDropdown({
        Name = "Select Difficulty",
        Options = { "Easy", "Medium", "Hard", "Extreme" },
        CurrentOption = {"Easy"}, MultipleOptions = false, Flag = "DungeonDiffDropdown",
        Callback = function(options)
            if options[1] then
                selectedDungeonDiff = options[1]
                -- Vote difficulty immediately when changed
                if DungeonWaveVote then
                    pcall(function() DungeonWaveVote:FireServer(selectedDungeonDiff) end)
                end
                Rayfield:Notify({ Title = "Difficulty", Content = "Set to: " .. selectedDungeonDiff, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    local function stopAutoReplay()
        autoReplayEnabled = false
        if autoReplayThread then task.cancel(autoReplayThread) autoReplayThread = nil end
    end

    local function startAutoReplay()
        if not autoReplayEnabled then return end
        autoReplayThread = task.spawn(function()
            while autoReplayEnabled do
                -- Vote difficulty
                if DungeonWaveVote then
                    pcall(function() DungeonWaveVote:FireServer(selectedDungeonDiff) end)
                end
                -- Pay key and vote to replay
                if DungeonReplayVote then
                    pcall(function() DungeonReplayVote:FireServer("sponsor") end)
                end
                task.wait(2)
            end
        end)
    end

    local AutoReplayToggle = DGTab:CreateToggle({
        Name = "🔁 Auto Replay Dungeon", CurrentValue = false,
        Callback = function(val)
            if val then
                autoReplayEnabled = true
                startAutoReplay()
                Rayfield:Notify({ Title = "Auto Replay", Content = "Auto replaying with " .. selectedDungeonDiff .. " difficulty!", Duration = 3, Image = 4483362458 })
            else
                stopAutoReplay()
                Rayfield:Notify({ Title = "Auto Replay", Content = "Auto replay stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    DGTab:CreateDivider()

    -- ── Section: Auto Kill ──
    DGTab:CreateSection("💀 Auto Kill")

    local function stopDungeonKill()
        dungeonKillEnabled = false
        if dungeonKillThread then task.cancel(dungeonKillThread) dungeonKillThread = nil end
        stopFly()
        if not noclipNeeded() then stopNoclip() end
    end

    local function getDungeonEnemies()
        local enemies = {}
        local NPCs = workspace:FindFirstChild("NPCs")
        if not NPCs then return enemies end
        for _, npc in ipairs(NPCs:GetChildren()) do
            if npc:IsA("Model") then
                local hum  = npc:FindFirstChildOfClass("Humanoid")
                local root = npc:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    table.insert(enemies, npc)
                end
            end
        end
        return enemies
    end

    local function startDungeonKill()
        if not dungeonKillEnabled then return end
        startNoclip()
        dungeonKillThread = task.spawn(function()
            while dungeonKillEnabled do
                if not isAlive() then
                    stopFly()
                    waitForCharacter()
                    if not dungeonKillEnabled then break end
                    equipWeapon()
                    task.wait(0.5)
                end

                local enemies = getDungeonEnemies()
                if #enemies == 0 then
                    hoverInPlace()
                    task.wait(0.5) -- keep scanning, stay in air
                else
                    for _, enemy in ipairs(enemies) do
                        if not dungeonKillEnabled or not isAlive() then break end
                        local root   = enemy:FindFirstChild("HumanoidRootPart")
                        local mobHum = enemy:FindFirstChildOfClass("Humanoid")
                        if root and mobHum and mobHum.Health > 0 then
                            snapNearTarget(root, 120)
                            flyAbove(root)
                            if instantKillMob then
                                pcall(function() mobHum.Health = 0 end)
                                stopFly()
                            else
                                local t = 0
                                repeat
                                    task.wait(0.1)
                                    t += 0.1
                                    flyAbove(root)
                                until mobHum.Health <= 0 or not dungeonKillEnabled or t > 30 or not isAlive()
                                stopFly()
                            end
                            task.wait(0.1)
                        end
                    end
                end
            end
            stopFly()
            stopNoclip()
        end)
    end

    local DungeonKillToggle = DGTab:CreateToggle({
        Name = "Auto Kill Enemies", CurrentValue = false,
        Callback = function(val)
            if val then
                equipWeapon()
                dungeonKillEnabled = true
                startDungeonKill()
                Rayfield:Notify({ Title = "Dungeon", Content = "Auto killing dungeon enemies!", Duration = 3, Image = 4483362458 })
            else
                stopDungeonKill()
                Rayfield:Notify({ Title = "Dungeon", Content = "Auto kill stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    DGTab:CreateDivider()
    DGTab:CreateSection("⚙ Controls")

    DGTab:CreateButton({
        Name = "Stop All Dungeon",
        Callback = function()
            stopDungeonKill()
            stopAutoReplay()
            DungeonKillToggle:Set(false)
            AutoReplayToggle:Set(false)
            Rayfield:Notify({ Title = "Dungeon", Content = "All stopped.", Duration = 3, Image = 4483362458 })
        end,
    })

    DGTab:CreateDivider()
    DGTab:CreateSection("⚡ Instant Kill Boss Rush")

    DGTab:CreateToggle({
        Name = "⚡ Instant Kill Boss Rush", CurrentValue = false,
        Callback = function(val)
            instantKillMob = val
            if val then
                Rayfield:Notify({ Title = "Instant Kill Boss Rush", Content = "Boss Rush enemies will be killed instantly!", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Instant Kill Boss Rush", Content = "Instant Kill disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })


elseif game.GameId == DUNGEON_GID or game.PlaceId == DUNGEON_PID then


-- ╔══════════════════════════════════════════════════════╗
-- ║                   SAILOR PIECE                       ║
-- ╚══════════════════════════════════════════════════════╝


    -- ── Remotes ───────────────────────────────────────────────────────────────

    local RequestAbility = nil
    pcall(function()
        RequestAbility = ReplicatedStorage
            :WaitForChild("AbilitySystem",  10)
            :WaitForChild("Remotes",        10)
            :WaitForChild("RequestAbility", 10)
    end)

    local RequestHit = nil
    pcall(function()
        RequestHit = ReplicatedStorage
            :WaitForChild("CombatSystem", 10)
            :WaitForChild("Remotes",      10)
            :WaitForChild("RequestHit",   10)
    end)

    local autoM1Enabled = false

    local function doM1()
        if autoM1Enabled and RequestHit then
            pcall(function() RequestHit:FireServer() end)
        end
    end

    -- Global M1 loop — only fires when autoM1Enabled is true
    task.spawn(function()
        while true do
            if autoM1Enabled then
                doM1()
            end
            task.wait(0.08)
        end
    end)

    local QuestAccept = nil
    pcall(function()
        QuestAccept = ReplicatedStorage
            :WaitForChild("RemoteEvents", 10)
            :WaitForChild("QuestAccept",  10)
    end)

    local AllocateStat = nil
    pcall(function()
        AllocateStat = ReplicatedStorage
            :WaitForChild("RemoteEvents", 10)
            :WaitForChild("AllocateStat", 10)
    end)

    local TeleportRemote = nil
    pcall(function()
        TeleportRemote = ReplicatedStorage
            :WaitForChild("Remotes",          10)
            :WaitForChild("TeleportToPortal", 10)
    end)

    -- ── Quest UI reader ───────────────────────────────────────────────────────

    local questUI = nil
    pcall(function()
        questUI = LocalPlayer.PlayerGui
            :WaitForChild("QuestUI", 10)
            :WaitForChild("Quest",   10)
    end)

    local function getQuestKills()
        if not questUI then return nil, nil end
        for _, obj in pairs(questUI:GetDescendants()) do
            if obj:IsA("TextLabel") then
                local cur, req = obj.Text:match("(%d+)%s*/%s*(%d+)")
                if cur and req then return tonumber(cur), tonumber(req) end
            end
        end
        return nil, nil
    end

    local function isQuestDone()
        local cur, req = getQuestKills()
        return cur and req and cur >= req
    end

    -- ── Quest & mob data ──────────────────────────────────────────────────────

    local questData = {
        { npc = "QuestNPC1",  mob = "Thief",          minLvl = 0,    maxLvl = 99    },
        { npc = "QuestNPC2",  mob = "ThiefBoss",      minLvl = 100,  maxLvl = 249   },
        { npc = "QuestNPC3",  mob = "Monkey",         minLvl = 250,  maxLvl = 499   },
        { npc = "QuestNPC4",  mob = "MonkeyBoss",     minLvl = 500,  maxLvl = 749   },
        { npc = "QuestNPC5",  mob = "DesertBandit",   minLvl = 750,  maxLvl = 999   },
        { npc = "QuestNPC6",  mob = "DesertBoss",     minLvl = 1000, maxLvl = 1499  },
        { npc = "QuestNPC7",  mob = "FrostRogue",     minLvl = 1500, maxLvl = 1999  },
        { npc = "QuestNPC8",  mob = "SnowBoss",       minLvl = 2000, maxLvl = 2999  },
        { npc = "QuestNPC9",  mob = "Sorcerer",       minLvl = 3000, maxLvl = 3999  },
        { npc = "QuestNPC10", mob = "PandaMiniBoss",  minLvl = 4000, maxLvl = 5000  },
        { npc = "QuestNPC11", mob = "Hollow",         minLvl = 5000, maxLvl = 6249  },
        { npc = "QuestNPC12", mob = "StrongSorcerer", minLvl = 6250, maxLvl = 6999  },
        { npc = "QuestNPC13", mob = "Curse",          minLvl = 7000, maxLvl = 7999  },
        { npc = "QuestNPC14", mob = "Slime",          minLvl = 8000, maxLvl = 8999  },
        { npc = "QuestNPC15", mob = "AcademyTeacher", minLvl = 9000,  maxLvl = 9999  },
        { npc = "QuestNPC16", mob = "Swordsman",       minLvl = 10000, maxLvl = 10750 },
        { npc = "QuestNPC17", mob = "Quincy",           minLvl = 10750, maxLvl = 99999 },
    }

    local mobCoords = {
        ["Thief"]          = Vector3.new( 194.943,   11.207,   -171.994),
        ["ThiefBoss"]      = Vector3.new( -66.662,   -2.584,   -162.957),
        ["Monkey"]         = Vector3.new(-566.029,   -0.875,    425.000),
        ["MonkeyBoss"]     = Vector3.new(-494.756,   49.211,    496.790),
        ["DesertBandit"]   = Vector3.new(-774.852,   -4.223,   -405.228),
        ["DesertBoss"]     = Vector3.new(-897.797,    2.346,   -462.508),
        ["FrostRogue"]     = Vector3.new(-423.527,   -0.222,   -968.642),
        ["SnowBoss"]       = Vector3.new(-594.788,   29.430,  -1060.376),
        ["Sorcerer"]       = Vector3.new(1407.890,    8.606,    522.877),
        ["PandaMiniBoss"]  = Vector3.new(1688.408,    9.574,    513.446),
        ["Hollow"]         = Vector3.new(-341.802,   -0.441,   1091.144),
        ["StrongSorcerer"] = Vector3.new( 684.110,    2.376,  -1715.858),
        ["Curse"]          = Vector3.new( -41.328,    1.907,  -1816.006),
        ["Slime"]          = Vector3.new(-1144.351,  19.703,    364.112),
        ["AcademyTeacher"] = Vector3.new(1074.662,    2.370,   1250.483),
        ["Swordsman"]      = Vector3.new(-1268.647,   1.306,  -1161.301),
        ["Quincy"]         = Vector3.new(-1331.364, 1603.621, 1567.672),
    }

    -- Island each mob/boss belongs to (for TeleportRemote before CFrame tp)
    local mobIsland = {
        ["Thief"]          = "Starter",
        ["ThiefBoss"]      = "Starter",
        ["Monkey"]         = "Jungle",
        ["MonkeyBoss"]     = "Jungle",
        ["DesertBandit"]   = "Desert",
        ["DesertBoss"]     = "Desert",
        ["FrostRogue"]     = "Snow",
        ["SnowBoss"]       = "Snow",
        ["Sorcerer"]       = "Sailor",
        ["PandaMiniBoss"]  = "Sailor",
        ["Hollow"]         = "HuecoMundo",
        ["StrongSorcerer"] = "Shibuya",
        ["Curse"]          = "Shibuya",
        ["Slime"]          = "Slime",
        ["AcademyTeacher"] = "Academy",
        ["Swordsman"]      = "Judgement",
        ["Quincy"]         = "SoulSociety",
    }

    local mobList = {
        "Thief", "Monkey", "DesertBandit", "FrostRogue",
        "Sorcerer", "Hollow", "StrongSorcerer", "Curse", "Slime", "AcademyTeacher", "Swordsman", "Quincy",
    }

    local bossList = { "ThiefBoss", "MonkeyBoss", "DesertBoss", "SnowBoss", "PandaMiniBoss" }

    local bosses = {
        ThiefBoss = true, MonkeyBoss = true, DesertBoss    = true,
        SnowBoss  = true, PandaMiniBoss = true,
        -- All regular bossList entries — exact name match, no numbered suffix
        Swordsman = true, AcademyTeacher = true, Slime = true,
        Curse = true, StrongSorcerer = true, Hollow = true,
        PandaMiniBoss = true, Sorcerer = true, SnowBoss = true,
    }

    local skillKeys = {
        ["Z (Skill 1)"] = 1, ["X (Skill 2)"] = 2, ["C (Skill 3)"] = 3,
        ["V (Skill 4)"] = 4, ["F (Skill 5)"] = 5,
    }

    -- ── State variables ───────────────────────────────────────────────────────

    local selectedMob      = "Thief"
    local selectedBoss     = "ThiefBoss"
    local selectedMobs     = {}
    local mobQuestMode     = "No Quest"
    local selectedSkills   = {}
    local selectedWeapon   = "Combat"
    local selectedStats    = {"Melee"}
    local inventoryList    = {}

    local mobEnabled        = false
    local bossEnabled       = false
    local skillEnabled      = false
    local levelEnabled      = false
    local upgradeEnabled    = false
    local autoSummonEnabled = false
    local instantKillMob    = false
    local mobThread        = nil
    local bossThread       = nil
    local skillThread      = nil
    local levelThread      = nil
    local upgradeThread    = nil
    local noclipThread     = nil
    local autoSummonThread = nil

    local FLY_HEIGHT       = 9
    local FLY_SMOOTHNESS   = 60
    local FLY_DISTANCE     = 2.5
    local LOOK_DOWN_OFFSET = 4
    local ORBIT_RADIUS     = 2
    local ORBIT_SPEED      = 2

    -- ── Fly system (AlignPosition + smooth orbit) ─────────────────────────────

    local flyAlignPosition    = nil
    local flyAlignOrientation = nil
    local flyAttachment0      = nil
    local flyAttachment1      = nil
    local flyTargetPart       = nil
    local flyConnection       = nil
    local currentFlyRoot      = nil

    local function cleanupFlyObjects()
        if flyConnection       then flyConnection:Disconnect()    flyConnection       = nil end
        if flyAlignPosition    then flyAlignPosition:Destroy()    flyAlignPosition    = nil end
        if flyAlignOrientation then flyAlignOrientation:Destroy() flyAlignOrientation = nil end
        if flyAttachment0      then flyAttachment0:Destroy()      flyAttachment0      = nil end
        if flyAttachment1      then flyAttachment1:Destroy()      flyAttachment1      = nil end
        if flyTargetPart       then flyTargetPart:Destroy()       flyTargetPart       = nil end
    end

    local function startFlyAbove(targetRoot)
        local character = LocalPlayer.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local hum = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or not targetRoot or not targetRoot.Parent then return end

        cleanupFlyObjects()
        hum.PlatformStand = false
        hum.AutoRotate    = false

        flyAttachment0        = Instance.new("Attachment")
        flyAttachment0.Name   = "DragFly_Att0"
        flyAttachment0.Parent = hrp

        flyTargetPart              = Instance.new("Part")
        flyTargetPart.Name         = "DragFly_Target"
        flyTargetPart.Size         = Vector3.new(1, 1, 1)
        flyTargetPart.Transparency = 1
        flyTargetPart.Anchored     = true
        flyTargetPart.CanCollide   = false
        flyTargetPart.CanQuery     = false
        flyTargetPart.CanTouch     = false
        flyTargetPart.CFrame       = CFrame.new(targetRoot.Position + Vector3.new(0, FLY_HEIGHT, 0))
        flyTargetPart.Parent       = workspace

        flyAttachment1        = Instance.new("Attachment")
        flyAttachment1.Name   = "DragFly_Att1"
        flyAttachment1.Parent = flyTargetPart

        flyAlignPosition                      = Instance.new("AlignPosition")
        flyAlignPosition.Attachment0          = flyAttachment0
        flyAlignPosition.Attachment1          = flyAttachment1
        flyAlignPosition.Mode                 = Enum.PositionAlignmentMode.TwoAttachment
        flyAlignPosition.RigidityEnabled      = false
        flyAlignPosition.ReactionForceEnabled = false
        flyAlignPosition.MaxForce             = 1e9
        flyAlignPosition.MaxVelocity          = 200
        flyAlignPosition.Responsiveness       = FLY_SMOOTHNESS
        flyAlignPosition.Parent               = hrp

        flyAlignOrientation                       = Instance.new("AlignOrientation")
        flyAlignOrientation.Attachment0           = flyAttachment0
        flyAlignOrientation.Mode                  = Enum.OrientationAlignmentMode.OneAttachment
        flyAlignOrientation.RigidityEnabled       = false
        flyAlignOrientation.ReactionTorqueEnabled = false
        flyAlignOrientation.MaxTorque             = 1e9
        flyAlignOrientation.Responsiveness        = 40
        flyAlignOrientation.Parent                = hrp

        flyConnection = RunService.Heartbeat:Connect(function()
            if not targetRoot or not targetRoot.Parent then return end
            if not hrp        or not hrp.Parent        then return end
            if not flyTargetPart then return end

            -- Orbit around target
            local t           = tick() * ORBIT_SPEED
            local orbitOffset = Vector3.new(math.cos(t) * ORBIT_RADIUS, 0, math.sin(t) * ORBIT_RADIUS)

            local targetPos = targetRoot.Position
                + Vector3.new(0, FLY_HEIGHT, 0)
                + (targetRoot.CFrame.LookVector * -FLY_DISTANCE)
                + orbitOffset

            -- Distance-based lerp: faster when far, smoother when close
            local dist  = (flyTargetPart.Position - targetPos).Magnitude
            local alpha = math.clamp(dist / 25, 0.12, 0.35)
            flyTargetPart.CFrame = CFrame.new(flyTargetPart.Position:Lerp(targetPos, alpha))

            -- Smooth downward look toward boss
            local lookTarget = targetRoot.Position - Vector3.new(0, LOOK_DOWN_OFFSET, 0)
            flyAlignOrientation.CFrame = flyAlignOrientation.CFrame:Lerp(
                CFrame.lookAt(hrp.Position, lookTarget),
                0.35
            )
        end)
    end

    local function updateFlyTarget(targetRoot)
        if not targetRoot or not targetRoot.Parent then return end
        if not flyTargetPart then startFlyAbove(targetRoot) end
    end

    local function stopFly()
        cleanupFlyObjects()
        currentFlyRoot = nil
        local character = LocalPlayer.Character
        if character then
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                hum.AutoRotate    = true
            end
        end
    end

    local function flyAbove(targetRoot)
        if currentFlyRoot ~= targetRoot then
            currentFlyRoot = targetRoot
            startFlyAbove(targetRoot)
        else
            updateFlyTarget(targetRoot)
        end
    end

    -- ── Noclip ────────────────────────────────────────────────────────────────

    local function startNoclip()
        if noclipThread then return end
        noclipThread = task.spawn(function()
            while true do
                local c = LocalPlayer.Character
                if c then
                    for _, part in pairs(c:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
                task.wait(0.1)
            end
        end)
    end

    local function stopNoclip()
        if noclipThread then task.cancel(noclipThread) noclipThread = nil end
        local c = LocalPlayer.Character
        if c then
            for _, part in pairs(c:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end

    local function noclipNeeded()
        return mobEnabled or bossEnabled or levelEnabled
    end

    -- ── Utility ───────────────────────────────────────────────────────────────

    local function isAlive()
        local c = LocalPlayer.Character
        if not c then return false end
        local h = c:FindFirstChildOfClass("Humanoid")
        return h ~= nil and h.Health > 0
    end

    local function waitForCharacter()
        if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not h or h.Health <= 0 then LocalPlayer.CharacterAdded:Wait() end
        task.wait(2)
    end

    local function getPlayerLevel()
        local ok, lvl = pcall(function() return LocalPlayer.Data.Level.Value end)
        return (ok and lvl) or 0
    end

    local function getQuestForLevel(lvl)
        for _, q in ipairs(questData) do
            if lvl >= q.minLvl and lvl <= q.maxLvl then return q end
        end
        return questData[#questData]
    end

    local function getQuestForMob(mobName)
        for _, q in ipairs(questData) do
            if q.mob == mobName then return q end
        end
        return nil
    end

    local equipWeapon
    equipWeapon = function(toolName)
        pcall(function()
            local character = LocalPlayer.Character
            if not character then return end
            local name = toolName or selectedWeapon
            if character:FindFirstChild(name) then return end
            local tool = LocalPlayer.Backpack:FindFirstChild(name)
            if tool then
                local hum = character:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(tool) end
            end
        end)
    end

    local lastTeleportedMob = ""

    local function teleportForMob(mobName)
        if mobName == lastTeleportedMob then return end
        local coords = mobCoords[mobName]
        if not coords then return end
        local c   = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        -- Fire island teleport first so the server loads the right area
        local island = mobIsland[mobName]
        if island and TeleportRemote then
            pcall(function() TeleportRemote:FireServer(island) end)
            task.wait(1.5)
        end
        -- Then CFrame snap to exact mob location
        hrp.CFrame        = CFrame.new(coords + Vector3.new(0, 5, 0))
        lastTeleportedMob = mobName
        Rayfield:Notify({ Title = "Teleport", Content = "Moved to " .. mobName .. " (" .. (island or "?") .. ")!", Duration = 2, Image = 4483362458 })
        task.wait(0.5)
    end

    local function getAllMobs(exactName)
        local list    = {}
        local escaped = exactName:gsub("([^%w])", "%%%1")
        local isBoss  = bosses[exactName] == true

        local function searchFolder(folder)
            for _, mob in pairs(folder:GetChildren()) do
                if mob:IsA("Model") then
                    -- For bosses: exact name match only
                    -- For mobs: numbered suffix match (e.g. "Thief1", "Thief2")
                    -- Fallback: also accept exact name for anything (catches bosses not in bosses table)
                    local matches = (mob.Name == exactName)
                        or (not isBoss and mob.Name:match("^" .. escaped .. "%d+$") ~= nil)
                    if matches then
                        local hum  = mob:FindFirstChildOfClass("Humanoid")
                        local root = mob:FindFirstChild("HumanoidRootPart")
                        if hum and root and hum.Health > 0 then
                            table.insert(list, mob)
                        end
                    end
                end
            end
        end

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Folder") and obj.Name == "NPCs" then searchFolder(obj) end
        end
        return list
    end

    local function snapNearTarget(root, maxDist)
        local c   = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if not hrp or not root then return end
        if (hrp.Position - root.Position).Magnitude > (maxDist or 120) then
            hrp.CFrame = CFrame.new(root.Position + Vector3.new(0, FLY_HEIGHT, 0))
            task.wait(0.05)
        end
    end

    -- Keep player floating at current height when no mobs are nearby
    local function hoverInPlace()
        if flyTargetPart then return end -- already flying via main system, don't interfere
        local c   = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        -- Lock to current Y position (don't add FLY_HEIGHT — player is already in air)
        local lockPos = hrp.Position
        local att0 = Instance.new("Attachment", hrp)
        local anchor = Instance.new("Part")
        anchor.Size        = Vector3.new(1,1,1)
        anchor.Transparency = 1
        anchor.Anchored    = true
        anchor.CanCollide  = false
        anchor.CanQuery    = false
        anchor.CanTouch    = false
        anchor.CFrame      = CFrame.new(lockPos) -- stay exactly here
        anchor.Parent      = workspace
        local att1 = Instance.new("Attachment", anchor)
        local ap = Instance.new("AlignPosition")
        ap.Attachment0          = att0
        ap.Attachment1          = att1
        ap.Mode                 = Enum.PositionAlignmentMode.TwoAttachment
        ap.MaxForce             = 1e9
        ap.MaxVelocity          = 50
        ap.Responsiveness       = 30
        ap.Parent               = hrp
        -- Cleanup after 0.6s
        task.delay(0.6, function()
            if att0   then att0:Destroy()   end
            if att1   then att1:Destroy()   end
            if ap     then ap:Destroy()     end
            if anchor then anchor:Destroy() end
        end)
    end

    local function killMob(mob)
        if not mob then return false end
        local root   = mob:FindFirstChild("HumanoidRootPart")
        local mobHum = mob:FindFirstChildOfClass("Humanoid")
        if not root or not mobHum or mobHum.Health <= 0 then return false end
        snapNearTarget(root, 120)
        flyAbove(root)
        local t = 0
        repeat
            task.wait(0.1)
            t += 0.1
            flyAbove(root)
        until mobHum.Health <= 0 or not mobEnabled or t > 30 or not isAlive()
        stopFly()
        task.wait(0.1)
        return mobHum.Health <= 0
    end

    local function handleDeath(mobName)
        if not isAlive() then
            stopFly()
            waitForCharacter()
            if not mobEnabled then return false end
            equipWeapon()
            lastTeleportedMob = ""
            teleportForMob(mobName)
            task.wait(0.1)
        end
        if not mobEnabled then return false end
        return true
    end

    -- ── Special boss data ─────────────────────────────────────────────────────

    local specialBossData = {
        { name = "AizenBoss",   pos = Vector3.new(-567.223,  2.579, 1228.490), island = "HuecoMundo" },
        { name = "AlucardBoss", pos = Vector3.new( 248.742, 12.093,  927.542), island = "Sailor"     },
        { name = "GojoBoss",    pos = Vector3.new(1858.327, 15.986,  338.140), island = "Shibuya"    },
        { name = "JinwooBoss",  pos = Vector3.new( 248.738,  7.594,  927.545), island = "Sailor"     },
        { name = "SukunaBoss",  pos = Vector3.new(1571.267, 80.221,  -34.113), island = "Shibuya"    },
        { name = "YujiBoss",    pos = Vector3.new(1537.929, 12.986,  226.108), island = "Shibuya"    },
        { name = "YamatoBoss",  pos = Vector3.new(-1422.681, 21.471, -1383.469), island = "Judgement"  },
    }

    local chatKeywordToBoss = {
        ["Aizen"]  = "AizenBoss",   ["Alucard"] = "AlucardBoss",
        ["Gojo"]   = "GojoBoss",    ["Jinwoo"]  = "JinwooBoss",
        ["Madoka"] = "MadokaBoss",  ["Ragna"]   = "RagnaBoss",
        ["Sukuna"] = "SukunaBoss",  ["Yuji"]    = "YujiBoss",
        ["Yamato"] = "YamatoBoss",
    }

    local selectedSpecialBosses  = {}
    local specialBossEnabled     = false
    local specialBossThread      = nil
    local specialBossQueue       = {}
    local specialBossConnection  = nil
    local specialBossConnections = {}

    local function isSelectedBoss(bossName)
        for _, n in ipairs(selectedSpecialBosses) do
            if n == bossName then return true end
        end
        return false
    end

    local function getBossModel(bossName)
        local NPCs = workspace:FindFirstChild("NPCs")
        if not NPCs then return nil, nil, nil end
        local model = NPCs:FindFirstChild(bossName)
        if not model then return nil, nil, nil end
        local hum  = model:FindFirstChildOfClass("Humanoid")
        local root = model:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.Health > 0 then return model, root, hum end
        return nil, nil, nil
    end

    local function waitForBossModel(bossName, timeout)
        local t = 0
        while t < (timeout or 10) do
            local _, root, hum = getBossModel(bossName)
            if root and hum then return getBossModel(bossName) end
            task.wait(0.5)
            t += 0.5
        end
        return nil, nil, nil
    end

    -- ── Forward declarations ──────────────────────────────────────────────────

    local startMob, stopMob, startBoss, stopBoss, startLevel, stopLevel

    -- ── Special boss fight system ─────────────────────────────────────────────

    local resumeAfterBoss = { mob = false, boss = false, level = false }

    local function resumePreviousFarming()
        lastTeleportedMob = ""
        local didResume = false
        if resumeAfterBoss.mob then
            mobEnabled = true
            startMob()
            didResume = true
        end
        if resumeAfterBoss.boss then
            bossEnabled = true
            startBoss()
            didResume = true
        end
        if resumeAfterBoss.level then
            levelEnabled = true
            startLevel()
            didResume = true
        end
        if noclipNeeded() then startNoclip() end
        resumeAfterBoss = { mob = false, boss = false, level = false }
        if didResume then
            Rayfield:Notify({ Title = "Boss Farm", Content = "Resumed previous farming!", Duration = 3, Image = 4483362458 })
        end
    end

    local function fightDetectedBoss(bossName)
        -- Save what was running before the boss interrupted
        resumeAfterBoss.mob   = resumeAfterBoss.mob   or mobEnabled
        resumeAfterBoss.boss  = resumeAfterBoss.boss  or bossEnabled
        resumeAfterBoss.level = resumeAfterBoss.level or levelEnabled

        -- Stop all current farming immediately
        if mobEnabled   then mobEnabled   = false if mobThread   then task.cancel(mobThread)   mobThread   = nil end end
        if bossEnabled  then bossEnabled  = false if bossThread  then task.cancel(bossThread)  bossThread  = nil end end
        if levelEnabled then levelEnabled = false if levelThread then task.cancel(levelThread) levelThread = nil end end
        stopFly()
        stopNoclip()

        local bossData = nil
        for _, d in ipairs(specialBossData) do
            if d.name == bossName then bossData = d break end
        end
        if not bossData then
            -- Unknown boss — still resume whatever was running before
            resumePreviousFarming()
            return
        end

        Rayfield:Notify({ Title = "⚡ Boss!", Content = "Going to " .. bossName .. " (" .. (bossData.island or "?") .. ")...", Duration = 4, Image = 4483362458 })

        -- Fire island teleport first, then CFrame snap to boss position
        if bossData.island and TeleportRemote then
            pcall(function() TeleportRemote:FireServer(bossData.island) end)
            task.wait(0.5)
        end
        local c   = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(bossData.pos + Vector3.new(0, FLY_HEIGHT, 0))
            task.wait(0.3)
        end

        local model, root, hum = waitForBossModel(bossName, 5)
        if not model then
            -- Boss not found or already dead — resume previous farming
            Rayfield:Notify({ Title = "Boss Farm", Content = bossName .. " not found, resuming...", Duration = 3, Image = 4483362458 })
            resumePreviousFarming()
            return
        end

        startNoclip()

        while specialBossEnabled do
            if not isAlive() then
                stopFly()
                waitForCharacter()
                if not specialBossEnabled then break end
                equipWeapon()
                task.wait(0.3)
                -- Re-teleport back to boss area after death
                local c2   = LocalPlayer.Character
                local hrp2 = c2 and c2:FindFirstChild("HumanoidRootPart")
                if hrp2 then
                    hrp2.CFrame = CFrame.new(bossData.pos + Vector3.new(0, FLY_HEIGHT, 0))
                    task.wait(0.3)
                end
                startNoclip()
                -- Wait for boss to reappear (it may respawn)
                model, root, hum = waitForBossModel(bossName, 5)
                if not model then
                    -- Boss gone after our death — resume farming
                    Rayfield:Notify({ Title = "Boss Farm", Content = bossName .. " gone after death, resuming...", Duration = 3, Image = 4483362458 })
                    break
                end
            end

            model, root, hum = getBossModel(bossName)
            if not model then
                -- Boss defeated!
                Rayfield:Notify({ Title = "Boss Farm", Content = bossName .. " defeated! Resuming farming...", Duration = 3, Image = 4483362458 })
                break
            end

            snapNearTarget(root, 120)
            flyAbove(root)

            if instantKillMob then
                pcall(function()
                    local _, _, h = getBossModel(bossName)
                    if h then h.Health = 0 end
                end)
                stopFly()
            else
                repeat
                    task.wait(0.1)
                    local _, r = getBossModel(bossName)
                    if r then flyAbove(r) end
                until not getBossModel(bossName) or not specialBossEnabled or not isAlive()
                stopFly()
            end
        end

        stopFly()
        stopNoclip()

        -- Always resume previous farming when done with this boss
        -- Even if specialBoss was toggled off mid-fight, restore what was running before
        if #specialBossQueue > 0 and specialBossEnabled then
            -- More bosses queued — don't resume yet, let the queue handle it
        else
            resumePreviousFarming()
        end
    end

    local function stopSpecialBoss()
        specialBossEnabled = false
        if specialBossThread     then task.cancel(specialBossThread)     specialBossThread     = nil end
        if specialBossConnection then specialBossConnection:Disconnect() specialBossConnection = nil end
        for _, conn in ipairs(specialBossConnections) do conn:Disconnect() end
        specialBossConnections = {}
        specialBossQueue = {}
        stopFly()
        stopNoclip()
        resumeAfterBoss = { mob = false, boss = false, level = false }
    end

    local function addToQueue(bossName)
        for _, q in ipairs(specialBossQueue) do if q == bossName then return end end
        table.insert(specialBossQueue, bossName)
        Rayfield:Notify({ Title = "Boss Queue", Content = bossName .. " queued!", Duration = 3, Image = 4483362458 })
    end

    local function startSpecialBossLoop()
        if specialBossThread then return end
        specialBossEnabled = true
        specialBossQueue   = {}

        local TextChatService = game:GetService("TextChatService")
        if specialBossConnection then specialBossConnection:Disconnect() end
        specialBossConnection = TextChatService.MessageReceived:Connect(function(msg)
            if not specialBossEnabled then return end
            local text = msg.Text or ""
            if not text:find("%[SERVER%]") then return end
            for keyword, bossName in pairs(chatKeywordToBoss) do
                if text:find(keyword) and text:lower():find("spawn") and isSelectedBoss(bossName) then
                    addToQueue(bossName) break
                end
            end
        end)

        -- Scan for bosses already present in workspace when loop starts
        local NPCs = workspace:FindFirstChild("NPCs")
        if NPCs then
            for _, npc in ipairs(NPCs:GetChildren()) do
                if isSelectedBoss(npc.Name) then
                    local hum = npc:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then addToQueue(npc.Name) end
                end
            end
            local conn = NPCs.ChildAdded:Connect(function(npc)
                if specialBossEnabled and isSelectedBoss(npc.Name) then addToQueue(npc.Name) end
            end)
            table.insert(specialBossConnections, conn)
        end

        specialBossThread = task.spawn(function()
            while specialBossEnabled do
                if #specialBossQueue > 0 then
                    fightDetectedBoss(table.remove(specialBossQueue, 1))
                else
                    task.wait(0.2)
                end
            end
        end)
    end

    -- ── Auto Skill ────────────────────────────────────────────────────────────

    local function stopSkill()
        skillEnabled = false
        if skillThread then task.cancel(skillThread) skillThread = nil end
    end

    local function startSkill()
        skillEnabled = true
        skillThread  = task.spawn(function()
            while skillEnabled do
                if not isAlive() then
                    waitForCharacter()
                else
                    for _, skillName in ipairs(selectedSkills) do
                        if not skillEnabled then break end
                        local arg = skillKeys[skillName]
                        if arg then
                            pcall(function() RequestAbility:FireServer(arg) end)
                            task.wait(0.3)
                        end
                    end
                    task.wait(0.5)
                end
            end
        end)
    end

    -- ── Auto Upgrade ──────────────────────────────────────────────────────────

    local function stopUpgrade()
        upgradeEnabled = false
        if upgradeThread then task.cancel(upgradeThread) upgradeThread = nil end
    end

    local function startUpgrade()
        upgradeEnabled = true
        upgradeThread  = task.spawn(function()
            while upgradeEnabled do
                for _, stat in ipairs(selectedStats) do
                    if not upgradeEnabled then break end
                    pcall(function() AllocateStat:FireServer(stat, 1) end)
                    task.wait(0.1)
                end
            end
        end)
    end

    -- ── Farm loop ─────────────────────────────────────────────────────────────

    local function farmLoop(getEnabled, getMobName)
        local lastMob = ""
        while getEnabled() do
            if not isAlive() then
                stopFly()
                waitForCharacter()
                if not getEnabled() then break end
                equipWeapon()
                lastTeleportedMob = ""
                lastMob           = ""
                task.wait(0.5)
            end
            if not getEnabled() then break end

            local mobName = getMobName()
            if mobName and mobName ~= "" then
                if mobName ~= lastMob then
                    lastMob = mobName
                    stopFly()
                    teleportForMob(mobName)
                    task.wait(0.1)
                end
                if not getEnabled() then break end

                local mobs = getAllMobs(mobName)
                if #mobs == 0 then
                    -- No mobs detected — hover in place and keep scanning
                    hoverInPlace()
                    task.wait(0.5)
                else
                    for _, mob in ipairs(mobs) do
                        if not getEnabled() or not isAlive() then break end
                        if getMobName() ~= mobName then break end
                        local root   = mob:FindFirstChild("HumanoidRootPart")
                        local mobHum = mob:FindFirstChildOfClass("Humanoid")
                        if root and mobHum and mobHum.Health > 0 then
                            snapNearTarget(root, 120)
                            flyAbove(root)
                            local t = 0
                            repeat
                                task.wait(0.1)
                                t += 0.1
                                flyAbove(root)
                            until mobHum.Health <= 0 or not getEnabled() or t > 120 or not isAlive() or getMobName() ~= mobName
                            stopFly()
                            task.wait(0.1)
                        end
                    end
                    task.wait(0.1)
                end
            end
            task.wait(0.3)
        end
        stopFly()
    end

    -- ── Mob farm ──────────────────────────────────────────────────────────────

    stopMob = function()
        mobEnabled        = false
        lastTeleportedMob = ""
        resumeAfterBoss.mob = false
        if mobThread then task.cancel(mobThread) mobThread = nil end
        stopFly()
        if not noclipNeeded() then stopNoclip() end
    end

    startMob = function()
        if not mobEnabled then return end
        if autoSummonEnabled then
            autoSummonEnabled = false
            if autoSummonThread then task.cancel(autoSummonThread) autoSummonThread = nil end
        end
        startNoclip()
        mobThread = task.spawn(function()
            while mobEnabled do
                local mobQueue = #selectedMobs > 0 and selectedMobs or {selectedMob}
                if #mobQueue == 0 then task.wait(1) end
                for _, mobName in ipairs(mobQueue) do
                    if not mobEnabled then break end
                    if not handleDeath(mobName) then break end
                    if not mobEnabled then break end
                    teleportForMob(mobName)
                    if not mobEnabled then break end

                    if mobQuestMode == "With Quest" then
                        local quest = getQuestForMob(mobName)
                        if quest and QuestAccept then
                            pcall(function() QuestAccept:FireServer(quest.npc) end)
                            task.wait(0.5)
                            local killCount    = 0
                            local KILLS_NEEDED = 5
                            Rayfield:Notify({ Title = "Auto Mob", Content = "Quest: " .. mobName .. " (0/" .. KILLS_NEEDED .. ")", Duration = 3, Image = 4483362458 })
                            while mobEnabled and killCount < KILLS_NEEDED do
                                if not handleDeath(mobName) then break end
                                if not mobEnabled then break end
                                local mobs = getAllMobs(mobName)
                                if #mobs == 0 then
                                    hoverInPlace()
                                    task.wait(0.5)
                                else
                                    for _, mob in ipairs(mobs) do
                                        if not mobEnabled or killCount >= KILLS_NEEDED then break end
                                        if not handleDeath(mobName) then break end
                                        if killMob(mob) then
                                            killCount += 1
                                            Rayfield:Notify({ Title = "Auto Mob", Content = mobName .. " " .. killCount .. "/" .. KILLS_NEEDED, Duration = 2, Image = 4483362458 })
                                        end
                                    end
                                end
                            end
                            if mobEnabled then
                                Rayfield:Notify({ Title = "Auto Mob", Content = "Quest done! " .. mobName .. " 5/5 → Next mob...", Duration = 4, Image = 4483362458 })
                            end
                        else
                            local mobs = getAllMobs(mobName)
                            for _, mob in ipairs(mobs) do
                                if not mobEnabled then break end
                                killMob(mob)
                            end
                        end
                    else
                        local mobs = getAllMobs(mobName)
                        if #mobs == 0 then
                            hoverInPlace()
                            task.wait(0.5)
                        else
                            for _, mob in ipairs(mobs) do
                                if not mobEnabled then break end
                                if not handleDeath(mobName) then break end
                                killMob(mob)
                            end
                        end
                    end
                    if not mobEnabled then break end
                end
            end
            stopFly()
            stopNoclip()
        end)
    end

    -- ── Boss farm ─────────────────────────────────────────────────────────────

    stopBoss = function()
        bossEnabled = false
        resumeAfterBoss.boss = false
        if bossThread then task.cancel(bossThread) bossThread = nil end
        stopFly()
        lastTeleportedMob = ""
        if not noclipNeeded() then stopNoclip() end
    end

    startBoss = function()
        if not bossEnabled then return end
        startNoclip()
        bossThread = task.spawn(function()
            teleportForMob(selectedBoss)
            farmLoop(function() return bossEnabled end, function() return selectedBoss end)
            bossThread = nil
        end)
    end

    -- ── Auto Level ────────────────────────────────────────────────────────────

    stopLevel = function()
        levelEnabled = false
        resumeAfterBoss.level = false
        if levelThread then task.cancel(levelThread) levelThread = nil end
        stopFly()
        lastTeleportedMob = ""
        if not noclipNeeded() then stopNoclip() end
    end

    startLevel = function()
        if not levelEnabled then return end
        startNoclip()
        levelThread = task.spawn(function()
            while levelEnabled do
                if not isAlive() then
                    stopFly()
                    waitForCharacter()
                    if not levelEnabled then break end
                    equipWeapon()
                    lastTeleportedMob = ""
                    task.wait(0.5)
                end
                if not levelEnabled then break end

                local lvl   = getPlayerLevel()
                local quest = getQuestForLevel(lvl)
                teleportForMob(quest.mob)
                if not levelEnabled then break end

                pcall(function() QuestAccept:FireServer(quest.npc) end)

                local mobs = getAllMobs(quest.mob)
                if #mobs == 0 then
                    task.wait(0.5) -- keep scanning, stay in air
                else
                    local mob    = mobs[1]
                    local root   = mob:FindFirstChild("HumanoidRootPart")
                    local mobHum = mob:FindFirstChildOfClass("Humanoid")
                    if root and mobHum and mobHum.Health > 0 then
                        snapNearTarget(root, 120)
                        flyAbove(root)
                        local t = 0
                        repeat
                            task.wait(0.1)
                            t += 0.1
                            flyAbove(root)
                            if t % 2 == 0 then
                                pcall(function() QuestAccept:FireServer(quest.npc) end)
                            end
                            local newQuest = getQuestForLevel(getPlayerLevel())
                            if newQuest.npc ~= quest.npc then
                                lastTeleportedMob = ""
                                Rayfield:Notify({ Title = "Auto Level", Content = "Level up! → " .. newQuest.mob, Duration = 4, Image = 4483362458 })
                                break
                            end
                        until mobHum.Health <= 0 or not levelEnabled or t > 20 or not isAlive()
                        stopFly()
                        pcall(function() QuestAccept:FireServer(quest.npc) end)
                        task.wait(0.1)
                    end
                end
            end
            stopFly()
        end)
    end

    -- ── Respawn handler ───────────────────────────────────────────────────────

    LocalPlayer.CharacterAdded:Connect(function()
        stopFly()
        if noclipThread then task.cancel(noclipThread) noclipThread = nil end
        task.wait(2)
        equipWeapon()
        if skillEnabled       then startSkill()   end
        if mobEnabled         then startMob()     end
        if bossEnabled        then startBoss()    end
        if levelEnabled       then startLevel()   end
        if upgradeEnabled     then startUpgrade() end
        if noclipNeeded()     then startNoclip()  end
        if specialBossEnabled then
            -- Don't cancel specialBossThread here — fightDetectedBoss handles
            -- death internally via waitForCharacter. Only restart if the thread
            -- has actually died (e.g. crashed), not just because we respawned.
            if not specialBossThread then
                startSpecialBossLoop()
            end
        end
    end)

    -- ╔══════════════════════════════════════════════════════╗
    -- ║                 SAILOR PIECE UI                      ║
    -- ╚══════════════════════════════════════════════════════╝

    windowConfig.Name            = "DRAG HUB | Dungeon"
    windowConfig.LoadingTitle    = "<b>DRAG HUB</b>"
    windowConfig.LoadingSubtitle = "Sailor Piece - Dungeon"

    local Window = Rayfield:CreateWindow(windowConfig)

    -- ── TAB 1: AUTO MOB ───────────────────────────────────────────────────────

    local SPTab = Window:CreateTab("Auto Mob", 4483362458)

    SPTab:CreateSection("🗡 Weapon")

    local function getInventory()
        local tools, seen = {}, {}
        local function addTools(parent)
            if not parent then return end
            for _, obj in pairs(parent:GetChildren()) do
                if obj:IsA("Tool") and not seen[obj.Name] then
                    seen[obj.Name] = true
                    table.insert(tools, obj.Name)
                end
            end
        end
        addTools(LocalPlayer.Backpack)
        addTools(LocalPlayer.Character)
        if #tools == 0 then table.insert(tools, "No tools found") end
        return tools
    end

    inventoryList = getInventory()

    local WeaponDropdown = SPTab:CreateDropdown({
        Name = "Select Weapon", Options = inventoryList,
        CurrentOption = {inventoryList[1]}, MultipleOptions = false, Flag = "WeaponDropdown",
        Callback = function(options)
            selectedWeapon = options[1]
            if selectedWeapon and selectedWeapon ~= "No tools found" then
                equipWeapon(selectedWeapon)
                Rayfield:Notify({ Title = "Weapon", Content = selectedWeapon .. " equipped!", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    SPTab:CreateButton({
        Name = "🔄 Refresh Inventory",
        Callback = function()
            inventoryList = getInventory()
            WeaponDropdown:Refresh(inventoryList)
            Rayfield:Notify({ Title = "Weapon", Content = "Refreshed! " .. #inventoryList .. " tool(s) found.", Duration = 3, Image = 4483362458 })
        end,
    })

    SPTab:CreateSlider({
        Name = "Fly Height (Studs)", Range = {1, 50}, Increment = 1,
        Suffix = " studs", CurrentValue = 10, Flag = "FlyHeightSlider",
        Callback = function(val) FLY_HEIGHT = val end,
    })

    SPTab:CreateDivider()
    SPTab:CreateSection("👊 Mobs")

    local MobFarmToggle = SPTab:CreateToggle({
        Name = "Auto Farm Mob", CurrentValue = false,
        Callback = function(val)
            if val then
                if #selectedMobs == 0 then
                    Rayfield:Notify({ Title = "Auto Farm Mob", Content = "⚠ Select at least one mob from the dropdown first!", Duration = 4, Image = 4483362458 })
                    task.defer(function() MobFarmToggle:Set(false) end)
                    return
                end
                equipWeapon() mobEnabled = true startMob()
                Rayfield:Notify({ Title = "Auto Mob", Content = "Farming: " .. table.concat(selectedMobs, ", "), Duration = 3, Image = 4483362458 })
            else
                mobEnabled = false stopMob()
                Rayfield:Notify({ Title = "Auto Mob", Content = "Mob farm stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    SPTab:CreateDropdown({
        Name = "Select Mob(s)", Options = mobList, CurrentOption = {},
        MultipleOptions = true, Flag = "MobDropdown",
        Callback = function(options)
            selectedMobs = options
            lastTeleportedMob = ""
            if mobEnabled then stopMob() mobEnabled = true startMob() end
            Rayfield:Notify({ Title = "Auto Mob", Content = "Mobs: " .. (#options > 0 and table.concat(options, ", ") or "None"), Duration = 2, Image = 4483362458 })
        end,
    })

    SPTab:CreateDropdown({
        Name = "Quest Mode", Options = {"No Quest", "With Quest"},
        CurrentOption = {"No Quest"}, MultipleOptions = false, Flag = "QuestModeDropdown",
        Callback = function(options)
            mobQuestMode = options[1] or "No Quest"
            if mobEnabled then stopMob() mobEnabled = true startMob() end
            Rayfield:Notify({ Title = "Quest Mode", Content = "Mode: " .. mobQuestMode, Duration = 2, Image = 4483362458 })
        end,
    })

    SPTab:CreateDivider()
    SPTab:CreateSection("💀 Boss")

    local BossFarmToggle = SPTab:CreateToggle({
        Name = "Auto Farm Boss", CurrentValue = false,
        Callback = function(val)
            if val then
                equipWeapon() bossEnabled = true startBoss()
                Rayfield:Notify({ Title = "Auto Boss", Content = "Farming: " .. selectedBoss, Duration = 3, Image = 4483362458 })
            else
                bossEnabled = false stopBoss()
                Rayfield:Notify({ Title = "Auto Boss", Content = "Boss farm stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    SPTab:CreateDropdown({
        Name = "Select Boss", Options = bossList, CurrentOption = {"ThiefBoss"},
        MultipleOptions = false, Flag = "BossDropdown",
        Callback = function(options)
            if options[1] then
                selectedBoss = options[1]
                if bossEnabled then
                    lastTeleportedMob = ""
                    if not bossThread then bossEnabled = true equipWeapon() startBoss() end
                end
                Rayfield:Notify({ Title = "Auto Boss", Content = "Boss: " .. selectedBoss, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    SPTab:CreateDivider()
    SPTab:CreateSection("📈 Upgrade Stats")

    local UpgradeToggle = SPTab:CreateToggle({
        Name = "Auto Upgrade Stat", CurrentValue = false,
        Callback = function(val)
            if val then
                if #selectedStats == 0 then
                    Rayfield:Notify({ Title = "Upgrade Stats", Content = "Select at least one stat first!", Duration = 3, Image = 4483362458 })
                    UpgradeToggle:Set(false) return
                end
                startUpgrade()
                Rayfield:Notify({ Title = "Upgrade Stats", Content = "Upgrading: " .. table.concat(selectedStats, ", "), Duration = 3, Image = 4483362458 })
            else
                stopUpgrade()
                Rayfield:Notify({ Title = "Upgrade Stats", Content = "Upgrade stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    SPTab:CreateDropdown({
        Name = "Select Stats",
        Options = {"Melee", "Defense", "Sword", "Power"},
        CurrentOption = {"Melee"}, MultipleOptions = true, Flag = "StatDropdown",
        Callback = function(options)
            selectedStats = options
            Rayfield:Notify({ Title = "Upgrade Stats", Content = "Stats: " .. (#options > 0 and table.concat(options, ", ") or "None"), Duration = 2, Image = 4483362458 })
        end,
    })

    SPTab:CreateDivider()
    SPTab:CreateSection("⚙ Controls")

    SPTab:CreateButton({
        Name = "Stop All",
        Callback = function()
            mobEnabled = false bossEnabled = false
            skillEnabled = false levelEnabled = false upgradeEnabled = false
            stopMob() stopBoss() stopSkill() stopLevel()
            stopFly() stopUpgrade() stopNoclip() stopSpecialBoss()
            MobFarmToggle:Set(false)  BossFarmToggle:Set(false)
            SkillToggle:Set(false)    UpgradeToggle:Set(false)
            Rayfield:Notify({ Title = "DRAG HUB", Content = "All farming stopped.", Duration = 3, Image = 4483362458 })
        end,
    })


    -- ── TAB: PLAYER ──────────────────────────────────────────────────────────

    local PlayerTab = Window:CreateTab("Player", 4483362458)

    -- ── Remotes ──
    local HakiRemote = nil
    pcall(function()
        HakiRemote = ReplicatedStorage
            :WaitForChild("RemoteEvents", 10)
            :WaitForChild("HakiRemote", 10)
    end)

    local DeathVFX = nil
    pcall(function()
        DeathVFX = ReplicatedStorage
            :WaitForChild("RemoteEvents", 10)
            :WaitForChild("DeathVFX", 10)
    end)

    local ObservationHakiRemote = nil
    pcall(function()
        ObservationHakiRemote = ReplicatedStorage
            :WaitForChild("RemoteEvents", 10)
            :WaitForChild("ObservationHakiRemote", 10)
    end)

    -- ── State ──
    local autoHakiEnabled        = false
    local autoObsHakiEnabled     = false
    local obsHakiThread          = nil
    local obsHakiDeathConnection = nil
    local hakiDeathConnection    = nil

    -- ── Section: Auto M1 ──
    PlayerTab:CreateSection("🥊 Auto M1")

    PlayerTab:CreateToggle({
        Name = "Auto M1 Attack", CurrentValue = false, Flag = "AutoM1Toggle",
        Callback = function(val)
            autoM1Enabled = val
            if val then
                Rayfield:Notify({ Title = "Auto M1", Content = "M1 attack enabled!", Duration = 2, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Auto M1", Content = "M1 attack disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    PlayerTab:CreateDivider()

    -- ── Section: Auto Skill ──
    PlayerTab:CreateSection("✨ Auto Skill")

    local SkillToggle = PlayerTab:CreateToggle({
        Name = "Auto Skill", CurrentValue = false,
        Callback = function(val)
            if val then
                if #selectedSkills == 0 then
                    Rayfield:Notify({ Title = "Auto Skill", Content = "Select at least one skill first!", Duration = 3, Image = 4483362458 })
                    SkillToggle:Set(false) return
                end
                startSkill()
                Rayfield:Notify({ Title = "Auto Skill", Content = "Auto Skill enabled!", Duration = 3, Image = 4483362458 })
            else
                stopSkill()
            end
        end,
    })

    PlayerTab:CreateDropdown({
        Name = "Select Skills",
        Options = {"Z (Skill 1)", "X (Skill 2)", "C (Skill 3)", "V (Skill 4)", "F (Skill 5)"},
        CurrentOption = {}, MultipleOptions = true, Flag = "SkillDropdown",
        Callback = function(options)
            selectedSkills = options
            Rayfield:Notify({ Title = "Auto Skill", Content = "Skills: " .. (#options > 0 and table.concat(options, ", ") or "None"), Duration = 2, Image = 4483362458 })
        end,
    })

    PlayerTab:CreateDivider()

    -- ── Section: Auto Haki ──
    PlayerTab:CreateSection("🔥 Auto Haki")

    PlayerTab:CreateToggle({
        Name = "Auto Haki", CurrentValue = false,
        Callback = function(val)
            autoHakiEnabled = val
            if val then
                -- Activate haki immediately on enable
                pcall(function() HakiRemote:FireServer("Toggle") end)
                -- Connect death handler: fire DeathVFX then re-toggle haki on respawn
                if hakiDeathConnection then hakiDeathConnection:Disconnect() hakiDeathConnection = nil end
                hakiDeathConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                    if not autoHakiEnabled then return end
                    task.wait(1.5)
                    pcall(function() DeathVFX:FireServer(LocalPlayer.Character) end)
                    task.wait(0.5)
                    pcall(function() HakiRemote:FireServer("Toggle") end)
                end)
                Rayfield:Notify({ Title = "Auto Haki", Content = "Haki activated! Will auto re-activate on death.", Duration = 3, Image = 4483362458 })
            else
                autoHakiEnabled = false
                if hakiDeathConnection then hakiDeathConnection:Disconnect() hakiDeathConnection = nil end
                Rayfield:Notify({ Title = "Auto Haki", Content = "Auto Haki disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    PlayerTab:CreateDivider()

    -- ── Section: Auto Observation Haki ──
    PlayerTab:CreateSection("👁 Auto Observation Haki")

    local function stopObsHaki()
        autoObsHakiEnabled = false
        if obsHakiThread then task.cancel(obsHakiThread) obsHakiThread = nil end
        if obsHakiDeathConnection then obsHakiDeathConnection:Disconnect() obsHakiDeathConnection = nil end
    end

    local function startObsHaki()
        if not autoObsHakiEnabled then return end
        if obsHakiThread then task.cancel(obsHakiThread) obsHakiThread = nil end
        obsHakiThread = task.spawn(function()
            while autoObsHakiEnabled do
                pcall(function() ObservationHakiRemote:FireServer("Toggle") end)
                -- Wait 60 seconds, checking every second so death can reset timer
                local waited = 0
                while waited < 60 and autoObsHakiEnabled do
                    task.wait(1)
                    waited += 1
                end
            end
        end)
    end

    PlayerTab:CreateToggle({
        Name = "Auto Observation Haki", CurrentValue = false,
        Callback = function(val)
            if val then
                autoObsHakiEnabled = true
                startObsHaki()
                -- Reset timer and reactivate on death
                if obsHakiDeathConnection then obsHakiDeathConnection:Disconnect() obsHakiDeathConnection = nil end
                obsHakiDeathConnection = LocalPlayer.CharacterAdded:Connect(function()
                    if not autoObsHakiEnabled then return end
                    task.wait(1.5)
                    -- Reset timer by restarting the loop
                    if obsHakiThread then task.cancel(obsHakiThread) obsHakiThread = nil end
                    startObsHaki()
                end)
                Rayfield:Notify({ Title = "Obs Haki", Content = "Auto Observation Haki enabled!", Duration = 3, Image = 4483362458 })
            else
                stopObsHaki()
                Rayfield:Notify({ Title = "Obs Haki", Content = "Auto Observation Haki disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    -- ── TAB 2: TELEPORT ───────────────────────────────────────────────────────

    local TPTab = Window:CreateTab("Teleport", 4483362458)

    TPTab:CreateSection("🌍 Islands")

    local islandList     = { "Starter", "Jungle", "Desert", "Snow", "Sailor", "Shibuya", "HuecoMundo", "Boss", "Dungeon", "Shinjuko", "Slime", "Academy", "Judgement", "SoulSociety" }
    local selectedIsland = "Starter"

    TPTab:CreateDropdown({
        Name = "Select Island", Options = islandList,
        CurrentOption = {"Starter"}, MultipleOptions = false, Flag = "IslandDropdown",
        Callback = function(options)
            selectedIsland = options[1]
            Rayfield:Notify({ Title = "Teleport", Content = "Selected: " .. selectedIsland, Duration = 2, Image = 4483362458 })
        end,
    })

    TPTab:CreateButton({
        Name = "🚀 Teleport",
        Callback = function()
            pcall(function() TeleportRemote:FireServer(selectedIsland) end)
            Rayfield:Notify({ Title = "Teleport", Content = "Teleporting to " .. selectedIsland .. "!", Duration = 3, Image = 4483362458 })
        end,
    })

    TPTab:CreateDivider()
    TPTab:CreateSection("🧑 NPC Teleport")

    local NPCDatabase      = {}
    local selectedNPC      = ""
    local islandLoadThread = nil

    local function getNPCPos(npc)
        if not npc then return nil end
        local hrp = npc:FindFirstChild("HumanoidRootPart")
        if hrp then return hrp.Position end
        if npc.PrimaryPart then return npc.PrimaryPart.Position end
        for _, part in ipairs(npc:GetDescendants()) do
            if part:IsA("BasePart") then return part.Position end
        end
        return nil
    end

    local function getDatabaseNames()
        local list = {}
        for name in pairs(NPCDatabase) do table.insert(list, name) end
        table.sort(list)
        if #list == 0 then table.insert(list, "None") end
        return list
    end

    local function scanAndStoreNPCs()
        local folder = workspace:FindFirstChild("ServiceNPCs")
        if not folder then return end
        for _, npc in ipairs(folder:GetChildren()) do
            if npc:IsA("Model") then
                local pos = getNPCPos(npc)
                if pos then NPCDatabase[npc.Name] = pos end
            end
        end
    end

    -- Don't auto-scan on startup — list starts empty, player uses Load All Islands
    local npcList = getDatabaseNames() -- returns {"None"} since NPCDatabase is empty

    local NPCDropdown = TPTab:CreateDropdown({
        Name = "Select NPC", Options = npcList, CurrentOption = {npcList[1]},
        MultipleOptions = false, Flag = "NPCDropdown",
        Callback = function(options)
            if options[1] and options[1] ~= "None" then
                selectedNPC = options[1]
                Rayfield:Notify({ Title = "NPC Teleport", Content = "Selected: " .. selectedNPC, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    local serviceFolder = workspace:FindFirstChild("ServiceNPCs")
    if serviceFolder then
        serviceFolder.ChildAdded:Connect(function(npc)
            task.wait(0.5)
            if npc:IsA("Model") then
                local pos = getNPCPos(npc)
                if pos then
                    NPCDatabase[npc.Name] = pos
                    NPCDropdown:Refresh(getDatabaseNames(), false)
                end
            end
        end)
        serviceFolder.ChildRemoved:Connect(function()
            NPCDropdown:Refresh(getDatabaseNames(), false)
        end)
    end

    TPTab:CreateButton({
        Name = "🚀 Teleport to NPC",
        Callback = function()
            if selectedNPC == "" or selectedNPC == "None" then
                Rayfield:Notify({ Title = "NPC Teleport", Content = "Select an NPC first!", Duration = 3, Image = 4483362458 })
                return
            end
            local pos = NPCDatabase[selectedNPC]
            if not pos then scanAndStoreNPCs() pos = NPCDatabase[selectedNPC] end
            if pos then
                local c   = LocalPlayer.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
                    Rayfield:Notify({ Title = "NPC Teleport", Content = "Teleported to " .. selectedNPC .. "!", Duration = 3, Image = 4483362458 })
                end
            else
                Rayfield:Notify({ Title = "NPC Teleport", Content = selectedNPC .. " not found. Try Load All Islands.", Duration = 4, Image = 4483362458 })
            end
        end,
    })

    TPTab:CreateButton({
        Name = "🌐 Load All Islands (Auto Scan NPCs)",
        Callback = function()
            if islandLoadThread then
                task.cancel(islandLoadThread) islandLoadThread = nil
                Rayfield:Notify({ Title = "NPC Scan", Content = "Stopped.", Duration = 3, Image = 4483362458 })
                return
            end
            Rayfield:Notify({ Title = "NPC Scan", Content = "Visiting all islands...", Duration = 5, Image = 4483362458 })
            islandLoadThread = task.spawn(function()
                for _, island in ipairs(islandList) do
                    pcall(function() TeleportRemote:FireServer(island) end)
                    task.wait(1)
                    scanAndStoreNPCs()
                    NPCDropdown:Refresh(getDatabaseNames(), false)
                end
                local count = 0
                for _ in pairs(NPCDatabase) do count += 1 end
                Rayfield:Notify({ Title = "NPC Scan", Content = "Done! " .. count .. " NPCs stored.", Duration = 5, Image = 4483362458 })
                islandLoadThread = nil
            end)
        end,
    })

    -- ── TAB 3: BOSS FARM ──────────────────────────────────────────────────────

    local SBTab = Window:CreateTab("Boss Farm", 4483362458)

    SBTab:CreateSection("⚔ Special Bosses")

    SBTab:CreateDropdown({
        Name = "Select Bosses",
        Options = { "AizenBoss", "AlucardBoss", "GojoBoss", "JinwooBoss", "SukunaBoss", "YujiBoss", "YamatoBoss" },
        CurrentOption = {}, MultipleOptions = true, Flag = "SpecialBossDropdown",
        Callback = function(options)
            selectedSpecialBosses = options
            Rayfield:Notify({ Title = "Boss Farm", Content = "Selected: " .. (#options > 0 and table.concat(options, ", ") or "None"), Duration = 2, Image = 4483362458 })
            -- If already running, restart so new selection takes effect immediately
            if specialBossEnabled then
                stopSpecialBoss()
                if #selectedSpecialBosses > 0 then
                    equipWeapon()
                    startSpecialBossLoop()
                end
            end
        end,
    })

    local SpecialBossFarmToggle = SBTab:CreateToggle({
        Name = "Auto Farm Boss", CurrentValue = false,
        Callback = function(val)
            if val then
                if #selectedSpecialBosses == 0 then
                    Rayfield:Notify({ Title = "Boss Farm", Content = "Select at least one boss first!", Duration = 3, Image = 4483362458 })
                    SpecialBossFarmToggle:Set(false) return
                end
                equipWeapon()
                startSpecialBossLoop()
                Rayfield:Notify({ Title = "Boss Farm", Content = "Watching for: " .. table.concat(selectedSpecialBosses, ", "), Duration = 4, Image = 4483362458 })
            else
                stopSpecialBoss()
                Rayfield:Notify({ Title = "Boss Farm", Content = "Boss farm stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    SBTab:CreateDivider()
    SBTab:CreateSection("⚙ Controls")

    SBTab:CreateButton({
        Name = "Stop Boss Farm",
        Callback = function()
            stopSpecialBoss()
            SpecialBossFarmToggle:Set(false)
            Rayfield:Notify({ Title = "Boss Farm", Content = "Stopped.", Duration = 3, Image = 4483362458 })
        end,
    })

    SBTab:CreateDivider()
    SBTab:CreateSection("⚡ Instant Kill")

    SBTab:CreateToggle({
        Name = "⚡ Instant Kill Special Boss", CurrentValue = false,
        Callback = function(val)
            instantKillMob = val
            if val then
                Rayfield:Notify({ Title = "Instant Kill", Content = "Special bosses will be killed instantly!", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Instant Kill", Content = "Instant Kill disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    SBTab:CreateDivider()
    SBTab:CreateSection("🔮 Auto Summon Boss")

    local summonBossData = {
        ["Anos"] = {
            npcPath = "AnosBoss_Normal",
            pos     = Vector3.new(950.100, 1.463, 1378.449),
            remote  = "RequestSpawnAnosBoss",
            folder  = "Remotes",
            args    = function(d) return {"Anos", d} end,
        },
        ["Rimuru"] = {
            npcPath = "RimuruBoss_Normal",
            pos     = Vector3.new(-1363.471, 22.349, 221.351),
            remote  = "RequestSpawnRimuru",
            folder  = "RemoteEvents",
            args    = function(d) return {d} end,
        },
        ["Strongest of Today"] = {
            npcPath = "StrongestofTodayBoss_Normal",
            pos     = Vector3.new(136.511, 5.243, -2431.629),
            remote  = "RequestSpawnStrongestBoss",
            folder  = "Remotes",
            args    = function(d) return {"StrongestToday", d} end,
        },
        ["Strongest in History"] = {
            npcPath = "StrongestinHistoryBoss_Normal",
            pos     = Vector3.new(611.819, 3.668, -2315.373),
            remote  = "RequestSpawnStrongestBoss",
            folder  = "Remotes",
            args    = function(d) return {"StrongestHistory", d} end,
        },
        ["Saber"] = {
            npcPath = "SaberBoss",
            pos     = Vector3.new(776.951, -2.672, -1090.399),
            remote  = "RequestSummonBoss",
            folder  = "Remotes",
            args    = function(_) return {"SaberBoss"} end,
        },
        ["Qinshi"] = {
            npcPath = "QinShiBoss",
            pos     = Vector3.new(776.951, -2.672, -1090.399),
            remote  = "RequestSummonBoss",
            folder  = "Remotes",
            args    = function(_) return {"QinShiBoss"} end,
        },
        ["Ichigo"] = {
            npcPath = "IchigoBoss",
            pos     = Vector3.new(776.951, -2.672, -1090.399),
            remote  = "RequestSummonBoss",
            folder  = "Remotes",
            args    = function(_) return {"IchigoBoss"} end,
        },
        ["Gilgamesh"] = {
            npcPath = "GilgameshBoss",
            pos     = Vector3.new(776.951, -2.672, -1090.399),
            remote  = "RequestSummonBoss",
            folder  = "Remotes",
            args    = function(d) return {"GilgameshBoss", d} end,
        },
        ["TrueAizen"] = {
            npcPath = "TrueAizenBoss_Normal",
            pos     = Vector3.new(-1199.470, 1604.119, 1775.046),
            remote  = "RequestSpawnTrueAizen",
            folder  = "RemoteEvents",
            args    = function(d) return {d} end,
        },
        ["BlessedMaiden"] = {
            npcPath = "BlessedMaidenBoss",
            pos     = Vector3.new(776.951, -2.672, -1090.399),
            remote  = "RequestSummonBoss",
            folder  = "Remotes",
            args    = function(d) return {"BlessedMaidenBoss", d} end,
        },
    }

    local selectedSummonBoss = "Anos"
    local selectedDifficulty = "Normal"
    local summonFarmEnabled  = false
    local summonFarmThread   = nil

    local summonBossNames = {}
    for name in pairs(summonBossData) do table.insert(summonBossNames, name) end
    table.sort(summonBossNames)

    SBTab:CreateDropdown({
        Name = "Select Summon Boss", Options = summonBossNames, CurrentOption = {"Anos"},
        MultipleOptions = false, Flag = "SummonBossDropdown",
        Callback = function(options)
            if options[1] then
                selectedSummonBoss = options[1]
                Rayfield:Notify({ Title = "Summon Boss", Content = "Selected: " .. selectedSummonBoss, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    local function stopAutoSummon()
        autoSummonEnabled = false
        if autoSummonThread then task.cancel(autoSummonThread) autoSummonThread = nil end
    end

    SBTab:CreateToggle({
        Name = "⚡ Auto Summon Boss", CurrentValue = false,
        Callback = function(val)
            if val then
                autoSummonEnabled = true
                autoSummonThread  = task.spawn(function()
                    while autoSummonEnabled do
                        local data = summonBossData[selectedSummonBoss]
                        if data then
                            pcall(function()
                                local remote = ReplicatedStorage:WaitForChild(data.folder, 5):WaitForChild(data.remote, 5)
                                remote:FireServer(unpack(data.args(selectedDifficulty)))
                            end)
                        end
                        task.wait(2)
                    end
                end)
                Rayfield:Notify({ Title = "Auto Summon", Content = "Summoning " .. selectedSummonBoss .. " (" .. selectedDifficulty .. ")", Duration = 3, Image = 4483362458 })
            else
                stopAutoSummon()
                Rayfield:Notify({ Title = "Auto Summon", Content = "Auto summon stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    SBTab:CreateDropdown({
        Name = "Difficulty", Options = {"Normal", "Medium", "Hard", "Extreme"},
        CurrentOption = {"Normal"}, MultipleOptions = false, Flag = "DifficultyDropdown",
        Callback = function(options)
            if options[1] then
                selectedDifficulty = options[1]
                Rayfield:Notify({ Title = "Difficulty", Content = "Set to: " .. selectedDifficulty, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    local function stopSummonFarm()
        summonFarmEnabled = false
        if summonFarmThread then task.cancel(summonFarmThread) summonFarmThread = nil end
        stopFly()
        if not noclipNeeded() then stopNoclip() end
    end

    local function startSummonFarm()
        if not summonFarmEnabled then return end
        startNoclip()
        summonFarmThread = task.spawn(function()
            while summonFarmEnabled do
                local data = summonBossData[selectedSummonBoss]
                if not data then
                    task.wait(1)
                else
                    -- Summon the boss
                    pcall(function()
                        local remote = ReplicatedStorage:WaitForChild(data.folder, 5):WaitForChild(data.remote, 5)
                        remote:FireServer(unpack(data.args(selectedDifficulty)))
                    end)
                    Rayfield:Notify({ Title = "Summon Farm", Content = "Summoning " .. selectedSummonBoss .. "...", Duration = 3, Image = 4483362458 })

                    -- Teleport to spawn area
                    local c   = LocalPlayer.Character
                    local hrp = c and c:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = CFrame.new(data.pos + Vector3.new(0, FLY_HEIGHT, 0)) end
                    task.wait(1)

                    -- Wait for boss to fully load (up to 15s)
                    local bossModel, root, bosHum = nil, nil, nil
                    local waited = 0
                    while waited < 15 and summonFarmEnabled do
                        local npcs = workspace:FindFirstChild("NPCs")
                        if npcs then
                            local m = npcs:FindFirstChild(data.npcPath)
                            if m then
                                local r = m:FindFirstChild("HumanoidRootPart")
                                local h = m:FindFirstChildOfClass("Humanoid")
                                if r and h and h.Health > 0 then
                                    bossModel, root, bosHum = m, r, h
                                    break
                                end
                            end
                        end
                        task.wait(0.5)
                        waited += 0.5
                    end

                    if bossModel and root and bosHum and summonFarmEnabled then
                        snapNearTarget(root, 120)
                        task.wait(0.15)
                        flyAbove(root)

                        local t = 0
                        repeat
                            task.wait(0.1)
                            t += 0.1
                            flyAbove(root)

                            if not isAlive() then
                                stopFly()
                                waitForCharacter()
                                if not summonFarmEnabled then break end
                                equipWeapon()
                                task.wait(0.5)
                                local npcs2 = workspace:FindFirstChild("NPCs")
                                if npcs2 then
                                    local m2 = npcs2:FindFirstChild(data.npcPath)
                                    if m2 then
                                        root   = m2:FindFirstChild("HumanoidRootPart")
                                        bosHum = m2:FindFirstChildOfClass("Humanoid")
                                        if root and bosHum and bosHum.Health > 0 then
                                            snapNearTarget(root, 120)
                                            task.wait(0.15)
                                            flyAbove(root)
                                        end
                                    end
                                end
                            end
                        until not bosHum or bosHum.Health <= 0 or not summonFarmEnabled or t > 120

                        stopFly()
                    end

                    if summonFarmEnabled then
                        Rayfield:Notify({ Title = "Summon Farm", Content = selectedSummonBoss .. " defeated! Re-summoning...", Duration = 3, Image = 4483362458 })
                        task.wait(1)
                    end
                end
            end
            stopFly()
        end)
    end

    SBTab:CreateToggle({
        Name = "⚔ Auto Farm Summoned Boss", CurrentValue = false,
        Callback = function(val)
            if val then
                equipWeapon() summonFarmEnabled = true startSummonFarm()
                Rayfield:Notify({ Title = "Summon Farm", Content = "Farming " .. selectedSummonBoss .. " (" .. selectedDifficulty .. ")", Duration = 3, Image = 4483362458 })
            else
                stopSummonFarm()
                Rayfield:Notify({ Title = "Summon Farm", Content = "Summon farm stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })


    SBTab:CreateDivider()
    SBTab:CreateSection("⚡ Instant Kill")

    local instantKillEnabled    = false
    local instantKillConnections = {}
    local instantKillTracked    = {}

    local function stopInstantKill()
        instantKillEnabled = false
        for _, conn in ipairs(instantKillConnections) do pcall(function() conn:Disconnect() end) end
        instantKillConnections = {}
        instantKillTracked = {}
    end

    local function trackBossForInstantKill(bossModel)
        if instantKillTracked[bossModel] then return end
        instantKillTracked[bossModel] = true

        local humanoid = bossModel:FindFirstChildWhichIsA("Humanoid")
        if not humanoid then return end

        local maxHealth = humanoid.MaxHealth
        if maxHealth <= 0 then return end

        -- Snapshot health RIGHT NOW as the baseline — only count damage WE deal from this point
        local baselineHealth = humanoid.Health
        local triggered = false

        local conn
        conn = humanoid.HealthChanged:Connect(function(currentHealth)
            if triggered then return end
            if not instantKillEnabled then
                triggered = true
                task.defer(function() pcall(function() conn:Disconnect() end) end)
                return
            end
            -- Only measure damage from our baseline snapshot, not from maxHealth
            -- This prevents pre-existing damage from other players triggering it
            if currentHealth >= baselineHealth then
                -- Health went up (regen) — update baseline so we measure from here
                baselineHealth = currentHealth
                return
            end
            local damagePct = ((baselineHealth - currentHealth) / maxHealth) * 100
            if damagePct >= 15 then
                triggered = true
                task.defer(function()
                    pcall(function() humanoid.Health = 0 end)
                    pcall(function() conn:Disconnect() end)
                    instantKillTracked[bossModel] = nil
                end)
            end
        end)
        table.insert(instantKillConnections, conn)
    end

    local function startInstantKill()
        if not instantKillEnabled then return end
        instantKillTracked = {}

        -- Track all existing NPCs
        local NPCs = workspace:FindFirstChild("NPCs")
        if NPCs then
            for _, npc in ipairs(NPCs:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChildWhichIsA("Humanoid") then
                    trackBossForInstantKill(npc)
                end
            end
            -- Watch for new bosses spawning
            local spawnConn = NPCs.ChildAdded:Connect(function(npc)
                if not instantKillEnabled then return end
                task.wait(0.1)
                if npc:IsA("Model") then
                    trackBossForInstantKill(npc)
                end
            end)
            table.insert(instantKillConnections, spawnConn)
        end
    end

    SBTab:CreateToggle({
        Name = "⚡ Instant Kill Boss", CurrentValue = false,
        Callback = function(val)
            if val then
                instantKillEnabled = true
                startInstantKill()
                Rayfield:Notify({ Title = "Instant Kill", Content = "Watching bosses — will kill at 15% damage!", Duration = 3, Image = 4483362458 })
            else
                stopInstantKill()
                Rayfield:Notify({ Title = "Instant Kill", Content = "Instant Kill disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    -- ── TAB 4: AUTO LEVEL ─────────────────────────────────────────────────────

    local LVTab = Window:CreateTab("Auto Level", 4483362458)

    LVTab:CreateSection("⭐ Auto Level")

    local LevelToggle = LVTab:CreateToggle({
        Name = "Auto Farm Level", CurrentValue = false,
        Callback = function(val)
            if val then
                equipWeapon() levelEnabled = true startLevel()
                local quest = getQuestForLevel(getPlayerLevel())
                Rayfield:Notify({ Title = "Auto Level", Content = "Level " .. getPlayerLevel() .. " → " .. quest.mob, Duration = 4, Image = 4483362458 })
            else
                levelEnabled = false stopLevel()
                Rayfield:Notify({ Title = "Auto Level", Content = "Auto Level stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    LVTab:CreateDivider()
    LVTab:CreateSection("⚙ Controls")

    LVTab:CreateButton({
        Name = "Stop Level Farm",
        Callback = function()
            levelEnabled = false stopLevel()
            LevelToggle:Set(false)
            Rayfield:Notify({ Title = "Auto Level", Content = "Level farm stopped.", Duration = 3, Image = 4483362458 })
        end,
    })




    -- ── TAB 5: MISC ──────────────────────────────────────
    local MiscTab = Window:CreateTab("Misc", 4483362458)

    MiscTab:CreateSection("🛒 Merchant")

    local shopItemNames = {
        "Trait Reroll", "Haki Color Reroll", "Race Reroll",
        "Rush Key", "Boss Key", "Dungeon Key", "Clan Reroll",
    }

    -- Items the player wants to buy (multi-select)
    local selectedShopItems = {}
    local autoBuyEnabled    = false
    local autoBuyThread     = nil

    local PurchaseRemote = nil
    pcall(function()
        PurchaseRemote = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("MerchantRemotes", 10)
            :WaitForChild("PurchaseMerchantItem", 10)
    end)

    local GetStockRemote = nil
    pcall(function()
        GetStockRemote = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("MerchantRemotes", 10)
            :WaitForChild("GetMerchantStock", 10)
    end)

    MiscTab:CreateButton({
        Name = "📦 Get Merchant Stock",
        Callback = function()
            local ok, result = pcall(function()
                return GetStockRemote:InvokeServer()
            end)
            if ok and result then
                if type(result) == "table" then
                    local lines = {}
                    for k, v in pairs(result) do
                        table.insert(lines, tostring(k) .. ": " .. tostring(v))
                    end
                    local text = #lines > 0 and table.concat(lines, " | ") or "Empty stock"
                    Rayfield:Notify({ Title = "Merchant Stock", Content = text, Duration = 8, Image = 4483362458 })
                else
                    Rayfield:Notify({ Title = "Merchant Stock", Content = tostring(result), Duration = 6, Image = 4483362458 })
                end
                print("[DRAG HUB] Merchant Stock:", result)
            else
                Rayfield:Notify({ Title = "Merchant Stock", Content = "Failed — are you near a merchant?", Duration = 4, Image = 4483362458 })
            end
        end,
    })

    MiscTab:CreateDivider()
    MiscTab:CreateSection("🛍 Auto Buy")

    MiscTab:CreateDropdown({
        Name = "Select Item(s) to Buy",
        Options = shopItemNames,
        CurrentOption = {}, MultipleOptions = true, Flag = "ShopItemDropdown",
        Callback = function(options)
            selectedShopItems = options
            local names = #options > 0 and table.concat(options, ", ") or "None"
            Rayfield:Notify({ Title = "Auto Buy", Content = "Selected: " .. names, Duration = 2, Image = 4483362458 })
        end,
    })

    local AutoBuyToggle = MiscTab:CreateToggle({
        Name = "Auto Buy", CurrentValue = false,
        Callback = function(val)
            if val then
                if #selectedShopItems == 0 then
                    Rayfield:Notify({ Title = "Auto Buy", Content = "⚠ Select at least one item first!", Duration = 4, Image = 4483362458 })
                    task.defer(function() AutoBuyToggle:Set(false) end)
                    return
                end
                autoBuyEnabled = true
                autoBuyThread = task.spawn(function()
                    while autoBuyEnabled do
                        for _, itemName in ipairs(selectedShopItems) do
                            if not autoBuyEnabled then break end
                            pcall(function()
                                PurchaseRemote:InvokeServer(itemName, 1)
                            end)
                        end
                        -- No wait — buy as fast as the server allows
                    end
                end)
                Rayfield:Notify({ Title = "Auto Buy", Content = "Buying: " .. table.concat(selectedShopItems, ", "), Duration = 3, Image = 4483362458 })
            else
                autoBuyEnabled = false
                if autoBuyThread then task.cancel(autoBuyThread) autoBuyThread = nil end
                Rayfield:Notify({ Title = "Auto Buy", Content = "Auto buy stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })


    MiscTab:CreateDivider()
    MiscTab:CreateSection("⚗ Crafting")

    local autoCraftGrailEnabled = false
    local autoCraftGrailThread  = nil
    local RequestGrailCraft = nil
    pcall(function()
        RequestGrailCraft = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("RequestGrailCraft", 10)
    end)

    MiscTab:CreateToggle({
        Name = "Auto Craft Divine Grail", CurrentValue = false,
        Callback = function(val)
            if val then
                autoCraftGrailEnabled = true
                autoCraftGrailThread = task.spawn(function()
                    while autoCraftGrailEnabled do
                        pcall(function()
                            RequestGrailCraft:InvokeServer("DivineGrail", 1)
                        end)
                        task.wait(0.1)
                    end
                end)
                Rayfield:Notify({ Title = "Auto Craft", Content = "Crafting Divine Grail!", Duration = 3, Image = 4483362458 })
            else
                autoCraftGrailEnabled = false
                if autoCraftGrailThread then task.cancel(autoCraftGrailThread) autoCraftGrailThread = nil end
                Rayfield:Notify({ Title = "Auto Craft", Content = "Divine Grail crafting stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })



    MiscTab:CreateDivider()
    MiscTab:CreateSection("🛡 Anti AFK")

    local antiAfkEnabled    = false
    local antiAfkThread     = nil
    local antiAfkIdleConn   = nil
    local VirtualUser       = game:GetService("VirtualUser")

    local function stopAntiAfk()
        antiAfkEnabled = false
        if antiAfkThread   then task.cancel(antiAfkThread)   antiAfkThread   = nil end
        if antiAfkIdleConn then antiAfkIdleConn:Disconnect() antiAfkIdleConn = nil end
    end

    local function startAntiAfk()
        if not antiAfkEnabled then return end

        -- Method 1: Intercept Roblox's Idled event and simulate right-click to reset idle timer
        if antiAfkIdleConn then antiAfkIdleConn:Disconnect() end
        antiAfkIdleConn = LocalPlayer.Idled:Connect(function()
            if not antiAfkEnabled then return end
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)

        -- Method 2: Every 4-6 minutes, simulate camera nudge + key tap + tiny movement
        -- Randomized timing so it looks human
        antiAfkThread = task.spawn(function()
            while antiAfkEnabled do
                -- Randomize wait between 240-360 seconds (4-6 min)
                local waitTime = math.random(240, 360)
                local elapsed  = 0
                while elapsed < waitTime and antiAfkEnabled do
                    task.wait(1)
                    elapsed += 1
                end
                if not antiAfkEnabled then break end

                -- Simulate a small camera movement
                pcall(function()
                    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(0.05)
                    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)

                -- Simulate a key tap (spacebar — harmless)
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end)

                -- Simulate tiny humanoid movement so server-side position checks don't flag us
                pcall(function()
                    local char = LocalPlayer.Character
                    local hum  = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        hum:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)), true)
                        task.wait(0.1)
                        hum:Move(Vector3.new(0, 0, 0), true)
                    end
                end)
            end
        end)
    end

    MiscTab:CreateToggle({
        Name = "🛡 Anti AFK", CurrentValue = false,
        Callback = function(val)
            if val then
                antiAfkEnabled = true
                startAntiAfk()
                Rayfield:Notify({ Title = "Anti AFK", Content = "Anti AFK enabled — you won't be kicked!", Duration = 4, Image = 4483362458 })
            else
                stopAntiAfk()
                Rayfield:Notify({ Title = "Anti AFK", Content = "Anti AFK disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })

    -- ── TAB 6: AUTO DUNGEON ──────────────────────────────
    local DGTab = Window:CreateTab("Auto Dungeon", 4483362458)

    -- ── Remotes ──
    local RequestDungeonPortal = nil
    pcall(function()
        RequestDungeonPortal = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("RequestDungeonPortal", 10)
    end)

    local DungeonWaveVote = nil
    pcall(function()
        DungeonWaveVote = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("DungeonWaveVote", 10)
    end)

    local DungeonReplayVote = nil
    pcall(function()
        DungeonReplayVote = ReplicatedStorage
            :WaitForChild("Remotes", 10)
            :WaitForChild("DungeonWaveReplayVote", 10)
    end)

    -- ── State ──
    local dungeonList = {
        { name = "Cid",    arg = "CidDungeon"    },
        { name = "Rune",   arg = "RuneDungeon"   },
        { name = "Double", arg = "DoubleDungeon" },
    }
    local dungeonNames        = { "Cid", "Rune", "Double" }
    local selectedDungeon     = "Cid"
    local selectedDungeonDiff = "Easy"
    local dungeonKillEnabled  = false
    local dungeonKillThread   = nil
    local autoReplayEnabled   = false
    local autoReplayThread    = nil

    local function getDungeonArg(name)
        for _, d in ipairs(dungeonList) do
            if d.name == name then return d.arg end
        end
        return nil
    end

    -- ── Section: Join Dungeon ──
    DGTab:CreateSection("🏯 Dungeon")

    DGTab:CreateDropdown({
        Name = "Select Dungeon", Options = dungeonNames,
        CurrentOption = {"Cid"}, MultipleOptions = false, Flag = "DungeonDropdown",
        Callback = function(options)
            if options[1] then
                selectedDungeon = options[1]
                Rayfield:Notify({ Title = "Dungeon", Content = "Selected: " .. selectedDungeon, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    DGTab:CreateButton({
        Name = "🚪 Auto Join Dungeon",
        Callback = function()
            local arg = getDungeonArg(selectedDungeon)
            if arg and RequestDungeonPortal then
                pcall(function() RequestDungeonPortal:FireServer(arg) end)
                Rayfield:Notify({ Title = "Dungeon", Content = "Joining " .. selectedDungeon .. " dungeon...", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Dungeon", Content = "Failed to join dungeon.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    DGTab:CreateButton({
        Name = "⚔ Join Boss Rush",
        Callback = function()
            if RequestDungeonPortal then
                pcall(function() RequestDungeonPortal:FireServer("BossRush") end)
                Rayfield:Notify({ Title = "Dungeon", Content = "Joining Boss Rush...", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Dungeon", Content = "Failed to join Boss Rush.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    DGTab:CreateDivider()

    -- ── Section: Difficulty & Auto Replay ──
    DGTab:CreateSection("⚔ Difficulty & Auto Replay")

    DGTab:CreateDropdown({
        Name = "Select Difficulty",
        Options = { "Easy", "Medium", "Hard", "Extreme" },
        CurrentOption = {"Easy"}, MultipleOptions = false, Flag = "DungeonDiffDropdown",
        Callback = function(options)
            if options[1] then
                selectedDungeonDiff = options[1]
                -- Vote difficulty immediately when changed
                if DungeonWaveVote then
                    pcall(function() DungeonWaveVote:FireServer(selectedDungeonDiff) end)
                end
                Rayfield:Notify({ Title = "Difficulty", Content = "Set to: " .. selectedDungeonDiff, Duration = 2, Image = 4483362458 })
            end
        end,
    })

    local function stopAutoReplay()
        autoReplayEnabled = false
        if autoReplayThread then task.cancel(autoReplayThread) autoReplayThread = nil end
    end

    local function startAutoReplay()
        if not autoReplayEnabled then return end
        autoReplayThread = task.spawn(function()
            while autoReplayEnabled do
                -- Vote difficulty
                if DungeonWaveVote then
                    pcall(function() DungeonWaveVote:FireServer(selectedDungeonDiff) end)
                end
                -- Pay key and vote to replay
                if DungeonReplayVote then
                    pcall(function() DungeonReplayVote:FireServer("sponsor") end)
                end
                task.wait(2)
            end
        end)
    end

    local AutoReplayToggle = DGTab:CreateToggle({
        Name = "🔁 Auto Replay Dungeon", CurrentValue = false,
        Callback = function(val)
            if val then
                autoReplayEnabled = true
                startAutoReplay()
                Rayfield:Notify({ Title = "Auto Replay", Content = "Auto replaying with " .. selectedDungeonDiff .. " difficulty!", Duration = 3, Image = 4483362458 })
            else
                stopAutoReplay()
                Rayfield:Notify({ Title = "Auto Replay", Content = "Auto replay stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    DGTab:CreateDivider()

    -- ── Section: Auto Kill ──
    DGTab:CreateSection("💀 Auto Kill")

    local function stopDungeonKill()
        dungeonKillEnabled = false
        if dungeonKillThread then task.cancel(dungeonKillThread) dungeonKillThread = nil end
        stopFly()
        if not noclipNeeded() then stopNoclip() end
    end

    local function getDungeonEnemies()
        local enemies = {}
        local NPCs = workspace:FindFirstChild("NPCs")
        if not NPCs then return enemies end
        for _, npc in ipairs(NPCs:GetChildren()) do
            if npc:IsA("Model") then
                local hum  = npc:FindFirstChildOfClass("Humanoid")
                local root = npc:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    table.insert(enemies, npc)
                end
            end
        end
        return enemies
    end

    local function startDungeonKill()
        if not dungeonKillEnabled then return end
        startNoclip()
        dungeonKillThread = task.spawn(function()
            while dungeonKillEnabled do
                if not isAlive() then
                    stopFly()
                    waitForCharacter()
                    if not dungeonKillEnabled then break end
                    equipWeapon()
                    task.wait(0.5)
                end

                local enemies = getDungeonEnemies()
                if #enemies == 0 then
                    hoverInPlace()
                    task.wait(0.5) -- keep scanning, stay in air
                else
                    for _, enemy in ipairs(enemies) do
                        if not dungeonKillEnabled or not isAlive() then break end
                        local root   = enemy:FindFirstChild("HumanoidRootPart")
                        local mobHum = enemy:FindFirstChildOfClass("Humanoid")
                        if root and mobHum and mobHum.Health > 0 then
                            snapNearTarget(root, 120)
                            flyAbove(root)
                            if instantKillMob then
                                pcall(function() mobHum.Health = 0 end)
                                stopFly()
                            else
                                local t = 0
                                repeat
                                    task.wait(0.1)
                                    t += 0.1
                                    flyAbove(root)
                                until mobHum.Health <= 0 or not dungeonKillEnabled or t > 30 or not isAlive()
                                stopFly()
                            end
                            task.wait(0.1)
                        end
                    end
                end
            end
            stopFly()
            stopNoclip()
        end)
    end

    local DungeonKillToggle = DGTab:CreateToggle({
        Name = "Auto Kill Enemies", CurrentValue = false,
        Callback = function(val)
            if val then
                equipWeapon()
                dungeonKillEnabled = true
                startDungeonKill()
                Rayfield:Notify({ Title = "Dungeon", Content = "Auto killing dungeon enemies!", Duration = 3, Image = 4483362458 })
            else
                stopDungeonKill()
                Rayfield:Notify({ Title = "Dungeon", Content = "Auto kill stopped.", Duration = 3, Image = 4483362458 })
            end
        end,
    })

    DGTab:CreateDivider()
    DGTab:CreateSection("⚙ Controls")

    DGTab:CreateButton({
        Name = "Stop All Dungeon",
        Callback = function()
            stopDungeonKill()
            stopAutoReplay()
            DungeonKillToggle:Set(false)
            AutoReplayToggle:Set(false)
            Rayfield:Notify({ Title = "Dungeon", Content = "All stopped.", Duration = 3, Image = 4483362458 })
        end,
    })

    DGTab:CreateDivider()
    DGTab:CreateSection("⚡ Instant Kill Boss Rush")

    DGTab:CreateToggle({
        Name = "⚡ Instant Kill Boss Rush", CurrentValue = false,
        Callback = function(val)
            instantKillMob = val
            if val then
                Rayfield:Notify({ Title = "Instant Kill Boss Rush", Content = "Boss Rush enemies will be killed instantly!", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Instant Kill Boss Rush", Content = "Instant Kill disabled.", Duration = 2, Image = 4483362458 })
            end
        end,
    })


else
    Rayfield:Notify({
        Title    = "DRAG HUB",
        Content  = "Unsupported game! Join AFS Endless, Sailor Piece, or the Dungeon.",
        Duration = 6,
        Image    = 4483362458,
    })
end
