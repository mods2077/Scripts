
-- Quantum-style startup: wait for game data, choose Pirates from the
-- in-game team-selection screen, then wait for the normal HUD before loading.
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

if not Player then
    error("[Hiru Hub] LocalPlayer chưa sẵn sàng. Hãy chạy lại sau khi vào game.")
end

-- Quantum waits until the player's game data is ready before checking the menu.
repeat
    task.wait()
until game:IsLoaded() and Player:FindFirstChild("DataLoaded")

local PlayerGui = Player:WaitForChild("PlayerGui")

-- Always choose Pirates through the visible team-selection button,
-- not through CommF:SetTeam. This only runs when the selection screen exists.
local TeamMenu = PlayerGui:FindFirstChild("Main (minimal)")
if TeamMenu then
    local ChooseTeam = TeamMenu:WaitForChild("ChooseTeam")
    local Container = ChooseTeam:WaitForChild("Container")
    local PiratesButton = Container:WaitForChild("Pirates")
        :WaitForChild("Frame")
        :WaitForChild("TextButton")

    repeat
        task.wait()
        pcall(function()
            firesignal(PiratesButton.Activated)
        end)
    until not PlayerGui:FindFirstChild("Main (minimal)")
end

-- Continue only after the in-game HUD has appeared, matching Quantum's order.
local MainGui = PlayerGui:WaitForChild("Main")

-- Character lifecycle: refresh character references after every respawn.
-- Feature loops should always resolve the current character rather than retain
-- references to the character that died.
local CurrentCharacter, CurrentHumanoid, CurrentRootPart
local CharacterLifecycleGeneration = 0

local function BindCurrentCharacter(character)
    CharacterLifecycleGeneration += 1
    local generation = CharacterLifecycleGeneration

    CurrentCharacter = character
    CurrentHumanoid = nil
    CurrentRootPart = nil

    if not character then
        return
    end

    local humanoid = character:WaitForChild("Humanoid", 10)
    local rootPart = character:WaitForChild("HumanoidRootPart", 10)

    -- Ignore a late wait from an older character if another respawn occurred.
    if generation ~= CharacterLifecycleGeneration or Player.Character ~= character then
        return
    end

    CurrentHumanoid = humanoid
    CurrentRootPart = rootPart

    -- Publish fresh references for any feature that uses shared character state.
    getgenv().CurrentCharacter = character
    getgenv().CurrentHumanoid = humanoid
    getgenv().CurrentRootPart = rootPart

    if humanoid then
        local camera = workspace.CurrentCamera
        if camera then
            camera.CameraSubject = humanoid
        end
    end
end

Player.CharacterRemoving:Connect(function(character)
    if CurrentCharacter == character then
        CurrentCharacter = nil
        CurrentHumanoid = nil
        CurrentRootPart = nil
        getgenv().CurrentCharacter = nil
        getgenv().CurrentHumanoid = nil
        getgenv().CurrentRootPart = nil
    end
end)

Player.CharacterAdded:Connect(BindCurrentCharacter)
if Player.Character then
    task.spawn(BindCurrentCharacter, Player.Character)
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuideModule = ReplicatedStorage:FindFirstChild("GuideModule")
if GuideModule then
    local success, module = pcall(require, GuideModule)
    if success and module and type(module.ChangeDisplayedNPC) == "function" then
        hookfunction(module.ChangeDisplayedNPC, function() end)
    end
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Util = ReplicatedStorage:WaitForChild("Util", 5)
if Util then
    local CameraShaker = Util:FindFirstChild("CameraShaker")
    if CameraShaker then
        require(CameraShaker):Stop()
    end
end
--============================================================
-- 01. KIỂM TRA SEA / DUNGEON VÀ NHIỆM VỤ
--============================================================
--=============================================================
-- SEA / DUNGEON CHECK
--=============================================================
local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 -- First Sea
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 -- Second Sea
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 -- Third Sea
local DungeonPlaceId = 73902483975735 -- Dungeon

local IsDungeon = game.PlaceId == DungeonPlaceId
repeat
    wait()
until game.Players.LocalPlayer.Character
function CheckQuest(X)
    -- Check whether the tracked quest matches the requested mob.
    -- Called as CheckQuest() with no argument, this keeps the original level/quest setup.
    if X ~= nil then
        local player = game:GetService("Players").LocalPlayer
        local gui = player and player:FindFirstChild("PlayerGui")
        local tracked = gui and gui:FindFirstChild("TrackedQuestFrame")
        local frame = tracked and tracked:FindFirstChild("Frame")
        local header = frame and frame:FindFirstChild("header")
        local outerLabel = header and header:FindFirstChild("textLabel")
        local innerLabel = outerLabel and outerLabel:FindFirstChild("textLabel")
        local text = innerLabel and innerLabel:IsA("TextLabel") and innerLabel.Text or ""

        mob = text ~= "" and string.find(text, tostring(X), 1, true) ~= nil
        return mob
    end

    MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544)
            CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"
            LevelQuest = 1
            NameQuest = "JungleQuest"
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            CFrameMon = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"
            LevelQuest = 2
            NameQuest = "JungleQuest"
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            CFrameMon = CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"
            LevelQuest = 1
            NameQuest = "BuggyQuest1"
            NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
            CFrameMon = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)
        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"
            LevelQuest = 2
            NameQuest = "BuggyQuest1"
            NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
            CFrameMon = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)
        elseif MyLevel >= 60 and MyLevel <= 74 then
            Mon = "Desert Bandit"
            LevelQuest = 1
            NameQuest = "DesertQuest"
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693)
            CFrameMon = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)
        elseif MyLevel >= 75 and MyLevel <= 89 then
            Mon = "Desert Officer"
            LevelQuest = 2
            NameQuest = "DesertQuest"
            NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693)
            CFrameMon = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875)
        elseif MyLevel >= 90 and MyLevel <= 99 then
            Mon = "Snow Bandit"
            LevelQuest = 1
            NameQuest = "SnowQuest"
            NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
            CFrameMon = CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125)
        elseif MyLevel >= 100 and MyLevel <= 119 then
            Mon = "Snowman"
            LevelQuest = 2
            NameQuest = "SnowQuest"
            NameMon = "Snowman"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
            CFrameMon = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625)
        elseif MyLevel >= 120 and MyLevel <= 149 then
            Mon = "Chief Petty Officer"
            LevelQuest = 1
            NameQuest = "MarineQuest2"
            NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625)
        elseif MyLevel >= 150 and MyLevel <= 174 then
            Mon = "Sky Bandit"
            LevelQuest = 1
            NameQuest = "SkyQuest"
            NameMon = "Sky Bandit"
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            CFrameMon = CFrame.new(-4953.20703125, 295.74420166015625, -2899.22900390625)
        elseif MyLevel >= 175 and MyLevel <= 189 then
            Mon = "Dark Master"
            LevelQuest = 2
            NameQuest = "SkyQuest"
            NameMon = "Dark Master"
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            CFrameMon = CFrame.new(-5259.8447265625, 391.3976745605469, -2229.035400390625)
        elseif MyLevel >= 190 and MyLevel <= 209 then
            Mon = "Prisoner"
            LevelQuest = 1
            NameQuest = "PrisonerQuest"
            NameMon = "Prisoner"
            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
            CFrameMon = CFrame.new(5098.9736328125, -0.3204058110713959, 474.2373352050781)
        elseif MyLevel >= 210 and MyLevel <= 249 then
            Mon = "Dangerous Prisoner"
            LevelQuest = 2
            NameQuest = "PrisonerQuest"
            NameMon = "Dangerous Prisoner"
            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
            CFrameMon = CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375)
        elseif MyLevel >= 250 and MyLevel <= 274 then
            Mon = "Toga Warrior"
            LevelQuest = 1
            NameQuest = "ColosseumQuest"
            NameMon = "Toga Warrior"
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
            CFrameMon = CFrame.new(-1820.21484375, 51.68385696411133, -2740.6650390625)
        elseif MyLevel >= 275 and MyLevel <= 299 then
            Mon = "Gladiator"
            LevelQuest = 2
            NameQuest = "ColosseumQuest"
            NameMon = "Gladiator"
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
            CFrameMon = CFrame.new(-1292.838134765625, 56.380882263183594, -3339.031494140625)
        elseif MyLevel >= 300 and MyLevel <= 324 then
            Mon = "Military Soldier"
            LevelQuest = 1
            NameQuest = "MagmaQuest"
            NameMon = "Military Soldier"
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
            CFrameMon = CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875)
        elseif MyLevel >= 325 and MyLevel <= 374 then
            Mon = "Military Spy"
            LevelQuest = 2
            NameQuest = "MagmaQuest"
            NameMon = "Military Spy"
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
            CFrameMon = CFrame.new(-5802.8681640625, 86.26241302490234, 8828.859375)
        elseif MyLevel >= 375 and MyLevel <= 399 then
            Mon = "Fishman Warrior"
            LevelQuest = 1
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Warrior"
            CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625)
            if getgenv().AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif MyLevel >= 400 and MyLevel <= 449 then
            Mon = "Fishman Commando"
            LevelQuest = 2
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Commando"
            CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875)
            if getgenv().AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif MyLevel >= 450 and MyLevel <= 474 then
            Mon = "God's Guard"
            LevelQuest = 1
            NameQuest = "SkyExp1Quest"
            NameMon = "God's Guard"
            CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, 0, 1, -0, 0.0871884301, 0, 0.996191859)
            CFrameMon = CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375)
            if getgenv().AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
            end
        elseif MyLevel >= 475 and MyLevel <= 524 then
            Mon = "Shanda"
            LevelQuest = 2
            NameQuest = "SkyExp1Quest"
            NameMon = "Shanda"
            CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
            CFrameMon = CFrame.new(-7678.48974609375, 5566.40380859375, -497.2156066894531)
            if getgenv().AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
            end
        elseif MyLevel >= 525 and MyLevel <= 549 then
            Mon = "Royal Squad"
            LevelQuest = 1
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Squad"
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875)
        elseif MyLevel >= 550 and MyLevel <= 624 then
            Mon = "Royal Soldier"
            LevelQuest = 2
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Soldier"
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625)
        elseif MyLevel >= 625 and MyLevel <= 649 then
            Mon = "Galley Pirate"
            LevelQuest = 1
            NameQuest = "FountainQuest"
            NameMon = "Galley Pirate"
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
            CFrameMon = CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875)
        elseif MyLevel >= 650 then
            Mon = "Galley Captain"
            LevelQuest = 2
            NameQuest = "FountainQuest"
            NameMon = "Galley Captain"
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
            CFrameMon = CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375)
        end
    elseif World2 then
        if MyLevel >= 700 and MyLevel <= 724 then
            Mon = "Raider"
            LevelQuest = 1
            NameQuest = "Area1Quest"
            NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
            CFrameMon = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)
        elseif MyLevel >= 725 and MyLevel <= 774 then
            Mon = "Mercenary"
            LevelQuest = 2
            NameQuest = "Area1Quest"
            NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
            CFrameMon = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)
        elseif MyLevel >= 775 and MyLevel <= 799 then
            Mon = "Swan Pirate"
            LevelQuest = 1
            NameQuest = "Area2Quest"
            NameMon = "Swan Pirate"
            CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906)
            CFrameMon = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625)
        elseif MyLevel >= 800 and MyLevel <= 874 then
            Mon = "Factory Staff"
            NameQuest = "Area2Quest"
            LevelQuest = 2
            NameMon = "Factory Staff"
            CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
            CFrameMon = CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875)
        elseif MyLevel >= 875 and MyLevel <= 899 then
            Mon = "Marine Lieutenant"
            LevelQuest = 1
            NameQuest = "MarineQuest3"
            NameMon = "Marine Lieutenant"
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            CFrameMon = CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125)
        elseif MyLevel >= 900 and MyLevel <= 949 then
            Mon = "Marine Captain"
            LevelQuest = 2
            NameQuest = "MarineQuest3"
            NameMon = "Marine Captain"
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            CFrameMon = CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625)
        elseif MyLevel >= 950 and MyLevel <= 974 then
            Mon = "Zombie"
            LevelQuest = 1
            NameQuest = "ZombieQuest"
            NameMon = "Zombie"
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
            CFrameMon = CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875)
        elseif MyLevel >= 975 and MyLevel <= 999 then
            Mon = "Vampire"
            LevelQuest = 2
            NameQuest = "ZombieQuest"
            NameMon = "Vampire"
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
            CFrameMon = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625)
        elseif MyLevel >= 1000 and MyLevel <= 1049 then
            Mon = "Snow Trooper"
            LevelQuest = 1
            NameQuest = "SnowMountainQuest"
            NameMon = "Snow Trooper"
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
            CFrameMon = CFrame.new(549.1473388671875, 427.3870544433594, -5563.69873046875)
        elseif MyLevel >= 1050 and MyLevel <= 1099 then
            Mon = "Winter Warrior"
            LevelQuest = 2
            NameQuest = "SnowMountainQuest"
            NameMon = "Winter Warrior"
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
            CFrameMon = CFrame.new(1142.7451171875, 475.6398010253906, -5199.41650390625)
        elseif MyLevel >= 1100 and MyLevel <= 1124 then
            Mon = "Lab Subordinate"
            LevelQuest = 1
            NameQuest = "IceSideQuest"
            NameMon = "Lab Subordinate"
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578)
            CFrameMon = CFrame.new(-5707.4716796875, 15.951709747314453, -4513.39208984375)
        elseif MyLevel >= 1125 and MyLevel <= 1174 then
            Mon = "Horned Warrior"
            LevelQuest = 2
            NameQuest = "IceSideQuest"
            NameMon = "Horned Warrior"
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578)
            CFrameMon = CFrame.new(-6341.36669921875, 15.951770782470703, -5723.162109375)
        elseif MyLevel >= 1175 and MyLevel <= 1199 then
            Mon = "Magma Ninja"
            LevelQuest = 1
            NameQuest = "FireSideQuest"
            NameMon = "Magma Ninja"
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
            CFrameMon = CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375)
        elseif MyLevel >= 1200 and MyLevel <= 1249 then
            Mon = "Lava Pirate"
            LevelQuest = 2
            NameQuest = "FireSideQuest"
            NameMon = "Lava Pirate"
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
            CFrameMon = CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875)
        elseif MyLevel >= 1250 and MyLevel <= 1274 then
            Mon = "Ship Deckhand"
            LevelQuest = 1
            NameQuest = "ShipQuest1"
            NameMon = "Ship Deckhand"
            CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)         
            CFrameMon = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)    
            if getgenv().AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel >= 1275 and MyLevel <= 1299 then
            Mon = "Ship Engineer"
            LevelQuest = 2
            NameQuest = "ShipQuest1"
            NameMon = "Ship Engineer"
            CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)   
            CFrameMon = CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875)   
            if getgenv().AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end             
        elseif MyLevel >= 1300 and MyLevel <= 1324 then
            Mon = "Ship Steward"
            LevelQuest = 1
            NameQuest = "ShipQuest2"
            NameMon = "Ship Steward"
            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)         
            CFrameMon = CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625)      
            if getgenv().AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel >= 1325 and MyLevel <= 1349 then
            Mon = "Ship Officer"
            LevelQuest = 2
            NameQuest = "ShipQuest2"
            NameMon = "Ship Officer"
            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
            CFrameMon = CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625)
            if getgenv().AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel >= 1350 and MyLevel <= 1374 then
            Mon = "Arctic Warrior"
            LevelQuest = 1
            NameQuest = "FrostQuest"
            NameMon = "Arctic Warrior"
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
            CFrameMon = CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125)
            if getgenv().AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-6508.5581054688, 5000.034996032715, -132.83953857422))
            end
        elseif MyLevel >= 1375 and MyLevel <= 1424 then
            Mon = "Snow Lurker"
            LevelQuest = 2
            NameQuest = "FrostQuest"
            NameMon = "Snow Lurker"
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
            CFrameMon = CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375)
        elseif MyLevel >= 1425 and MyLevel <= 1449 then
            Mon = "Sea Soldier"
            LevelQuest = 1
            NameQuest = "ForgottenQuest"
            NameMon = "Sea Soldier"
            CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376)
            CFrameMon = CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125)
        elseif MyLevel >= 1450 then
            Mon = "Water Fighter"
            LevelQuest = 2
            NameQuest = "ForgottenQuest"
            NameMon = "Water Fighter"
            CFrameQuest = CFrame.new(-3054, 240, -10146)
            CFrameMon = CFrame.new(-3291, 252, -10501)
        end
    elseif World3 then
        if MyLevel >= 1500 and MyLevel <= 1524 then
            Mon = "Pirate Millionaire"
            LevelQuest = 1
            NameQuest = "PiratePortQuest"
            NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
            CFrameMon = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
        elseif MyLevel >= 1525 and MyLevel <= 1574 then
            Mon = "Pistol Billionaire"
            LevelQuest = 2
            NameQuest = "PiratePortQuest"
            NameMon = "Pistol Billionaire"
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
            CFrameMon = CFrame.new(-187.3301544189453, 86.23987579345703, 6013.513671875)
        elseif MyLevel >= 1575 and MyLevel <= 1599 then
            Mon = "Dragon Crew Warrior"
            LevelQuest = 1
            NameQuest = "DragonCrewQuest"
            NameMon = "Dragon Crew Warrior"
            CFrameQuest = CFrame.new(6738.96142578125, 127.81645965576172, -713.511474609375)
            CFrameMon = CFrame.new(6920.71435546875, 56.15597152709961, -942.5044555664062)
        elseif MyLevel >= 1600 and MyLevel <= 1624 then 
            Mon = "Dragon Crew Archer"
            NameQuest = "DragonCrewQuest"
            LevelQuest = 2
            NameMon = "Dragon Crew Archer"
            CFrameQuest = CFrame.new(6738.96142578125, 127.81645965576172, -713.511474609375)
            CFrameMon = CFrame.new(6817.91259765625, 484.804443359375, 513.4141235351562)
        elseif MyLevel >= 1625 and MyLevel <= 1649 then
            Mon = "Hydra Enforcer"
            NameQuest = "VenomCrewQuest"
            LevelQuest = 1
            NameMon = "Hydra Enforcer"
            CFrameQuest = CFrame.new(5213.8740234375, 1004.5042724609375, 758.6944580078125)
            CFrameMon = CFrame.new(4584.69287109375, 1002.6435546875, 705.7958984375)
        elseif MyLevel >= 1650 and MyLevel <= 1699 then 
            Mon = "Venomous Assailant"
            NameQuest = "VenomCrewQuest"
            LevelQuest = 2
            NameMon = "Venomous Assailant"
            CFrameQuest = CFrame.new(5213.8740234375, 1004.5042724609375, 758.6944580078125)
            CFrameMon = CFrame.new(4638.78564453125, 1078.94091796875, 881.8002319335938)        
        elseif MyLevel >= 1700 and MyLevel <= 1724 then
            Mon = "Marine Commodore"
            LevelQuest = 1
            NameQuest = "MarineTreeIsland"
            NameMon = "Marine Commodore"
            CFrameQuest = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
            CFrameMon = CFrame.new(2286.0078125, 73.13391876220703, -7159.80908203125)
        elseif MyLevel >= 1725 and MyLevel <= 1774 then
            Mon = "Marine Rear Admiral"
            NameMon = "Marine Rear Admiral"
            NameQuest = "MarineTreeIsland"
            LevelQuest = 2
            CFrameQuest = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
            CFrameMon = CFrame.new(3656.773681640625, 160.52406311035156, -7001.5986328125)
        elseif MyLevel >= 1775 and MyLevel <= 1799 then
            Mon = "Fishman Raider"
            LevelQuest = 1
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Raider"
            CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)   
            CFrameMon = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625)
        elseif MyLevel >= 1800 and MyLevel <= 1824 then
            Mon = "Fishman Captain"
            LevelQuest = 2
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Captain"
            CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)   
            CFrameMon = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625) 
        elseif MyLevel >= 1825 and MyLevel <= 1849 then
            Mon = "Forest Pirate"
            LevelQuest = 1
            NameQuest = "DeepForestIsland"
            NameMon = "Forest Pirate"
            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)
            CFrameMon = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625)
        elseif MyLevel >= 1850 and MyLevel <= 1899 then
            Mon = "Mythological Pirate"
            LevelQuest = 2
            NameQuest = "DeepForestIsland"
            NameMon = "Mythological Pirate"
            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)   
            CFrameMon = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
        elseif MyLevel >= 1900 and MyLevel <= 1924 then
            Mon = "Jungle Pirate"
            LevelQuest = 1
            NameQuest = "DeepForestIsland2"
            NameMon = "Jungle Pirate"
            CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
            CFrameMon = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)
        elseif MyLevel >= 1925 and MyLevel <= 1974 then
            Mon = "Musketeer Pirate"
            LevelQuest = 2
            NameQuest = "DeepForestIsland2"
            NameMon = "Musketeer Pirate"
            CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
            CFrameMon = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375)
        elseif MyLevel >= 1975 and MyLevel <= 1999 then
            Mon = "Reborn Skeleton"
            LevelQuest = 1
            NameQuest = "HauntedQuest1"
            NameMon = "Reborn Skeleton"
            CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            CFrameMon = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
        elseif MyLevel >= 2000 and MyLevel <= 2024 then
            Mon = "Living Zombie"
            LevelQuest = 2
            NameQuest = "HauntedQuest1"
            NameMon = "Living Zombie"
            CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            CFrameMon = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)
        elseif MyLevel >= 2025 and MyLevel <= 2049 then
            Mon = "Demonic Soul"
            LevelQuest = 1
            NameQuest = "HauntedQuest2"
            NameMon = "Demonic Soul"
            CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0) 
            CFrameMon = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)
        elseif MyLevel >= 2050 and MyLevel <= 2074 then
            Mon = "Posessed Mummy"
            LevelQuest = 2
            NameQuest = "HauntedQuest2"
            NameMon = "Posessed Mummy"
            CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)
        elseif MyLevel >= 2075 and MyLevel <= 2099 then
            Mon = "Peanut Scout"
            LevelQuest = 1
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut Scout"
            CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875)
        elseif MyLevel >= 2100 and MyLevel <= 2124 then
            Mon = "Peanut President"
            LevelQuest = 2
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut President"
            CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875)
        elseif MyLevel >= 2125 and MyLevel <= 2149 then
            Mon = "Ice Cream Chef"
            LevelQuest = 1
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Chef"
            CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125)
        elseif MyLevel >= 2150 and MyLevel <= 2199 then
            Mon = "Ice Cream Commander"
            LevelQuest = 2
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Commander"
            CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625)
        elseif MyLevel >= 2200 and MyLevel <= 2224 then
            Mon = "Cookie Crafter"
            LevelQuest = 1
            NameQuest = "CakeQuest1"
            NameMon = "Cookie Crafter"
            CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
            CFrameMon = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)
        elseif MyLevel >= 2225 and MyLevel <= 2249 then
            Mon = "Cake Guard"
            LevelQuest = 2
            NameQuest = "CakeQuest1"
            NameMon = "Cake Guard"
            CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
            CFrameMon = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)
        elseif MyLevel >= 2250 and MyLevel <= 2274 then
            Mon = "Baking Staff"
            LevelQuest = 1
            NameQuest = "CakeQuest2"
            NameMon = "Baking Staff"
            CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
            CFrameMon = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)
        elseif MyLevel >= 2275 and MyLevel <= 2299 then
            Mon = "Head Baker"
            LevelQuest = 2
            NameQuest = "CakeQuest2"
            NameMon = "Head Baker"
            CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
            CFrameMon = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)
        elseif MyLevel >= 2300 and MyLevel <= 2324 then
            Mon = "Cocoa Warrior"
            LevelQuest = 1
            NameQuest = "ChocQuest1"
            NameMon = "Cocoa Warrior"
            CFrameQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
            CFrameMon = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125)
        elseif MyLevel >= 2325 and MyLevel <= 2349 then
            Mon = "Chocolate Bar Battler"
            LevelQuest = 2
            NameQuest = "ChocQuest1"
            NameMon = "Chocolate Bar Battler"
            CFrameQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
            CFrameMon = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375)
        elseif MyLevel >= 2350 and MyLevel <= 2374 then
            Mon = "Sweet Thief"
            LevelQuest = 1
            NameQuest = "ChocQuest2"
            NameMon = "Sweet Thief"
            CFrameQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
            CFrameMon = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625)
        elseif MyLevel >= 2375 and MyLevel <= 2399 then
            Mon = "Candy Rebel"
            LevelQuest = 2
            NameQuest = "ChocQuest2"
            NameMon = "Candy Rebel"
            CFrameQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
            CFrameMon = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625)
        elseif MyLevel >= 2400 and MyLevel <= 2424 then
            Mon = "Candy Pirate"
            LevelQuest = 1
            NameQuest = "CandyQuest1"
            NameMon = "Candy Pirate"
            CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
            CFrameMon = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)
        elseif MyLevel >= 2425 and MyLevel <= 2449 then
            Mon = "Snow Demon"
            LevelQuest = 2
            NameQuest = "CandyQuest1"
            NameMon = "Snow Demon"
            CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
            CFrameMon = CFrame.new(-880.2006225585938, 71.24776458740234, -14538.609375)            
        elseif MyLevel >= 2450 and MyLevel <= 2474 then
            Mon = "Isle Outlaw"
            LevelQuest = 1
            NameQuest = "TikiQuest1"
            NameMon = "Isle Outlaw"
            CFrameQuest = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
            CFrameMon = CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656)
        elseif MyLevel >= 2475 and MyLevel <= 2524 then
            Mon = "Island Boy"
            LevelQuest = 2
            NameQuest = "TikiQuest1"
            NameMon = "Island Boy"
            CFrameQuest = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
            CFrameMon = CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562)
        elseif MyLevel >= 2525 and MyLevel <= 2550 then
            Mon = "Isle Champion"
            LevelQuest = 2
            NameQuest = "TikiQuest2"
            NameMon = "Isle Champion"
            CFrameQuest = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625)
            CFrameMon = CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375)
        elseif MyLevel >= 2550 and MyLevel <= 2574 then
            Mon = "Serpent Hunter"
            LevelQuest = 1
            NameQuest = "TikiQuest3"
            NameMon = "Serpent Hunter"
            CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, 0, 1, -0, 0.308980465, 0, 0.951068401)
            CFrameMon = CFrame.new(-16521.0625, 106.09285, 1488.78467, 0.469467044, 0, 0.882950008, 0, 1, 0, -0.882950008, 0, 0.469467044)
        elseif MyLevel >= 2575 and MyLevel <= 2599 then
            Mon = "Skull Slayer"
            LevelQuest = 2
            NameQuest = "TikiQuest3"
            NameMon = "Skull Slayer"
            CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, 0, 1, -0, 0.308980465, 0, 0.951068401)
            CFrameMon = CFrame.new(-16855.043, 122.457253, 1478.15308, -0.999392271, 0, -0.0348687991, 0, 1, 0, 0.0348687991, 0, -0.999392271)
        elseif MyLevel >= 2600 and MyLevel <= 2624 then
            Mon = "Reef Bandit"
            LevelQuest = 1
            NameQuest = "SubmergedQuest1"
            NameMon = "Reef Bandit"
            CFrameQuest = CFrame.new(10882.264, -2086.322, 10034.226)
            CFrameMon = CFrame.new(10736.6191, -2087.8439, 9338.4882)
        elseif MyLevel >= 2625 and MyLevel <= 2649 then
            Mon = "Coral Pirate"
            LevelQuest = 2
            NameQuest = "SubmergedQuest1"
            NameMon = "Coral Pirate"
            CFrameQuest = CFrame.new(10882.264, -2086.322, 10034.226)
            CFrameMon = CFrame.new(10965.1025, -2158.8842, 9177.2597)
        elseif MyLevel >= 2650 and MyLevel <= 2674 then
            Mon = "Sea Chanter"
            LevelQuest = 1
            NameQuest = "SubmergedQuest2"
            NameMon = "Sea Chanter"
            CFrameQuest = CFrame.new(10882.264, -2086.322, 10034.226)
            CFrameMon = CFrame.new(10621.0342, -2087.844, 10102.0332)
        elseif MyLevel >= 2675 and MyLevel <= 2699 then
            Mon = "Ocean Prophet"
            LevelQuest = 2
            NameQuest = "SubmergedQuest2"
            NameMon = "Ocean Prophet"
            CFrameQuest = CFrame.new(10882.264, -2086.322, 10034.226)
            CFrameMon = CFrame.new(11056.1445, -2001.6717, 10117.4493)
        elseif MyLevel >= 2700 and MyLevel <= 2724 then
            Mon = "High Disciple"
            LevelQuest = 1
            NameQuest = "SubmergedQuest3"
            NameMon = "High Disciple"
            CFrameQuest = CFrame.new(9636.524, -1992.195, 9609.528)
            CFrameMon = CFrame.new(9828.088, -1940.909, 9693.064)
        elseif MyLevel >= 2725 then
            Mon = "Grand Devotee"
            LevelQuest = 2
            NameQuest = "SubmergedQuest3"
            NameMon = "Grand Devotee"
            CFrameQuest = CFrame.new(9636.524, -1992.195, 9609.528)
            CFrameMon = CFrame.new(9557.585, -1928.040, 9859.183)
        end
    end
end
function MaterialMon()
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local function shouldRequestEntrance(targetPosition, distanceThreshold)
        local distance = (humanoidRootPart.Position - targetPosition).Magnitude
        if distance >= distanceThreshold then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", targetPosition)
        end
    end
    if World1 then
        if SelectMaterial == "Angel Wings" then
            MMon = { "Shanda", "Royal Squad", "Royal Soldier", "Wysper", "Thunder God" }
            MPos = CFrame.new(-4698, 845, -1912)
            SP = "Default"
            local targetPosition = Vector3.new(-4607.82275, 872.54248, -1667.55688)
            shouldRequestEntrance(targetPosition, 10000)
        elseif SelectMaterial == "Leather + Scrap Metal" then
            MMon = { "Brute", "Pirate" }
            MPos = CFrame.new(-1145, 15, 4350)
            SP = "Default"
        elseif SelectMaterial == "Magma Ore" then
            MMon = { "Military Soldier", "Military Spy", "Magma Admiral" }
            MPos = CFrame.new(-5815, 84, 8820)
            SP = "Default"
        elseif SelectMaterial == "Fish Tail" then
            MMon = { "Fishman Warrior", "Fishman Commando", "Fishman Lord" }
            MPos = CFrame.new(61123, 19, 1569)
            SP = "Default"
            local targetPosition = Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875)
            shouldRequestEntrance(targetPosition, 17000)
        end
    elseif World2 then
        if SelectMaterial == "Leather + Scrap Metal" then
            MMon = { "Marine Captain" }
            MPos = CFrame.new(-2010.5059814453125, 73.00115966796875, -3326.620849609375)
            SP = "Default"
        elseif SelectMaterial == "Magma Ore" then
            MMon = { "Magma Ninja", "Lava Pirate" }
            MPos = CFrame.new(-5428, 78, -5959)
            SP = "Default"
        elseif SelectMaterial == "Ectoplasm" then
            MMon = { "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer" }
            MPos = CFrame.new(911.35827636719, 125.95812988281, 33159.5390625)
            SP = "Default"
            local targetPosition = Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875)
            shouldRequestEntrance(targetPosition, 18000)
        elseif SelectMaterial == "Mystic Droplet" then
            MMon = { "Water Fighter" }
            MPos = CFrame.new(-3385, 239, -10542)
            SP = "Default"
        elseif SelectMaterial == "Radioactive Material" then
            MMon = { "Factory Staff" }
            MPos = CFrame.new(295, 73, -56)
            SP = "Default"
        elseif SelectMaterial == "Vampire Fang" then
            MMon = { "Vampire" }
            MPos = CFrame.new(-6033, 7, -1317)
            SP = "Default"
        end
    elseif World3 then
        if SelectMaterial == "Demonic Wisp" then
            MMon = { "Demonic Soul" }
            MPos = CFrame.new(-9505, 172, 6158)
            SP = "Default"
        elseif SelectMaterial == "Leather + Scrap Metal" then
            MMon = { "Jungle Pirate", "Forest Pirate" }
            MPos = CFrame.new(-11975.78515625, 331.7734069824219, -10620.0302734375)
            SP = "Default"
        elseif SelectMaterial == "Fish Tail" then
            MMon = { "Fishman Raider", "Fishman Captain" }
            MPos = CFrame.new(-10993, 332, -8940)
            SP = "Default"
        elseif SelectMaterial == "Conjured Cocoa" then
            MMon = { "Chocolate Bar Battler", "Cocoa Warrior" }
            MPos = CFrame.new(620.6344604492188, 78.93644714355469, -12581.369140625)
            SP = "Default"
        elseif SelectMaterial == "Dragon Scale" then
            MMon = { "Dragon Crew Warrior" }
            MPos = CFrame.new(6594, 383, 139)
            SP = "Default"
        elseif SelectMaterial == "Gunpowder" then
            MMon = { "Pistol Billionaire" }
            MPos = CFrame.new(-469, 74, 5904)
            SP = "Default"
        elseif SelectMaterial == "Mini Tusk" then
            MMon = { "Mythological Pirate" }
            MPos = CFrame.new(-13545, 470, -6917)
            SP = "Default"
        end
    end
end
local lastHakiTime = 0
local hakiCooldown = 1
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        local currentTime = tick()
        if currentTime - lastHakiTime >= hakiCooldown then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
            lastHakiTime = currentTime
        end
    end
end
local lastUnEquipTime = 0
local unEquipCooldown = 0.5
function UnEquipWeapon(Weapon)
    local currentTime = tick()
    if currentTime - lastUnEquipTime >= unEquipCooldown then
        if game.Players.LocalPlayer.Character:FindFirstChild(Weapon) then
            getgenv().NotAutoEquip = true
            game.Players.LocalPlayer.Character[Weapon].Parent = game.Players.LocalPlayer.Backpack
            getgenv().NotAutoEquip = false
        end
        lastUnEquipTime = currentTime
    end
end
local lastEquipTime = 0
local equipCooldown = 0.5
function EquipWeapon(ToolSe)
    local currentTime = tick()
    if currentTime - lastEquipTime >= equipCooldown then        
        if not getgenv().NotAutoEquip then
            local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
            if tool then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
            end
        end
        lastEquipTime = currentTime
    end
end
function BTPZ(v209)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        rootPart.CFrame = v209
    end
end
local lastTweenTime = 0
local tweenCooldown = 0.5
function fastpos(Pos)
    local currentTime = tick()
    if currentTime - lastTweenTime >= tweenCooldown then
        local Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        local Speed = 170        
        local tween = game:GetService("TweenService"):Create(
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
            { CFrame = Pos }
        )
        tween:Play()
        lastTweenTime = currentTime
    end
end
local lastTPBTime = 0
local tpbCooldown = 0.5
function TPB(pos, boat)
    local currentTime = tick()
    if currentTime - lastTPBTime >= tpbCooldown then
        local tween_s = game:GetService("TweenService")
        local distance = (boat.CFrame.Position - pos.Position).Magnitude
        local speed = getgenv().SpeedBoat
        local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        if distance <= 25 then
            return {Stop = function() end}
        else
            local tween = tween_s:Create(boat, info, {CFrame = pos})
            tween:Play()
            lastTPBTime = currentTime
            return {
                Stop = function()
                    tween:Cancel()
                end
            }
        end
    end
end
local lastEquipTime = 0
local equipCooldown = 0.2
function EquipAllWeapon()
    pcall(function()
        local currentTime = tick()
        if currentTime - lastEquipTime >= equipCooldown then
            for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if v:IsA('Tool') and not (v.Name == "Summon Sea Beast" or v.Name == "Water Body" or v.Name == "Awakening") then
                    local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name)
                    if ToolHumanoid then
                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid)
                    end
                end
            end
            lastEquipTime = currentTime
        end
    end)
end
function CheckNearestTeleporter(aI)
    local MyLevel = game.Players.LocalPlayer.Data.Level.Value
    local vcspos = aI.Position
    local min = math.huge
    local min2 = math.huge
    local y = game.PlaceId
    local World1, World2, World3
    if y == 2753915549 then
        World1 = true
    elseif y == 4442272183 then
        World2 = true
    elseif y == 7449423635 then
        World3 = true
    end
    local TableLocations = {}
    if World3 then
        TableLocations = {
            ["Mansion"] = Vector3.new(-12471, 374, -7551),
            ["Hydra"] = Vector3.new(5659, 1013, -341),
            ["Caslte On The Sea"] = Vector3.new(-5092, 315, -3130),
            ["Floating Turtle"] = Vector3.new(-12001, 332, -8861),
            ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
            ["Temple Of Time"] = Vector3.new(28286, 14897, 103)
        }
    elseif World2 then
        TableLocations = {
            ["Flamingo Mansion"] = Vector3.new(-317, 331, 597),
            ["Flamingo Room"] = Vector3.new(2283, 15, 867),
            ["Cursed Ship"] = Vector3.new(923, 125, 32853),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    elseif World1 then
        TableLocations = {
            ["Sky Island 1"] = Vector3.new(-4652, 873, -1754),
            ["Sky Island 2"] = Vector3.new(-7895, 5547, -380),
            ["Under Water Island"] = Vector3.new(61164, 5, 1820),
            ["Under Water Island Entrace"] = Vector3.new(3865, 5, -1926)
        }
    end
    local TableLocations2 = {}
    for r, v in pairs(TableLocations) do
        TableLocations2[r] = (v - vcspos).Magnitude
    end
    for r, v in pairs(TableLocations2) do
        if v < min then
            min = v
            min2 = v
        end
    end
    local choose
    for r, v in pairs(TableLocations2) do
        if v <= min then
            choose = TableLocations[r]
        end
    end
    local min3 = (vcspos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if min2 <= min3 then
        return choose
    end
end    
function requestEntrance(aJ)
    local args = {"requestEntrance", aJ}
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))    
    local oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local char = game.Players.LocalPlayer.Character.HumanoidRootPart
    char.CFrame = CFrame.new(oldcframe.X, oldcframe.Y + 50, oldcframe.Z)    
    task.wait(0.5)
end   
function topos(Tween_Pos)
    pcall(function()
        if game:GetService("Players").LocalPlayer 
            and game:GetService("Players").LocalPlayer.Character 
            and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") 
            and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
            and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 
            and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart then
            -- Nếu đang ở Submerged Island và đích nằm ngoài đảo,
            -- phải dùng Submarine Transportation để về Tiki Outpost trước.
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local function getLocationName(part)
                local locations = game:GetService("Workspace"):FindFirstChild("_WorldOrigin")
                locations = locations and locations:FindFirstChild("Locations")
                if not locations or not part then
                    return ""
                end
                for _, location in ipairs(locations:GetChildren()) do
                    if location:IsA("BasePart") and location:FindFirstChildWhichIsA("DataModelMesh") then
                        local mesh = location:FindFirstChildWhichIsA("DataModelMesh")
                        if (part.Position - location.Position).Magnitude <= mesh.Scale.X then
                            return location.Name
                        end
                    end
                end
                return ""
            end

            if root and not getgenv()._LeavingSubmerged then
                local currentLocation = getLocationName(root)
                local targetLocation = getLocationName(Tween_Pos)
                if currentLocation:find("Submerged") and not targetLocation:find("Submerged") then
                    getgenv()._LeavingSubmerged = true
                    local exitPosition = CFrame.new(11426, -2155, 9732)
                    local reachedTiki = false

                    -- Dùng chính hàm topos để đi tới NPC; cờ trên ngăn gọi lặp.
                    topos(exitPosition)
                    task.wait(2)

                    local remoteOk, remoteResult = pcall(function()
                        local net = game:GetService("ReplicatedStorage")
                            :WaitForChild("Modules")
                            :WaitForChild("Net")
                        return net:WaitForChild("RF/SubmarineTransportation")
                            :InvokeServer("InitiateTeleport", "Tiki Outpost")
                    end)

                    if not remoteOk then
                        warn("[Hiru Hub] Không thể thoát Submerged Island: " .. tostring(remoteResult))
                    else
                        -- Đợi server chuyển nhân vật ra khỏi vùng Submerged.
                        for _ = 1, 20 do
                            task.wait(0.5)
                            character = player.Character
                            root = character and character:FindFirstChild("HumanoidRootPart")
                            if root and not getLocationName(root):find("Submerged") then
                                reachedTiki = true
                                break
                            end
                        end
                    end

                    getgenv()._LeavingSubmerged = false
                    if not reachedTiki then
                        warn("[Hiru Hub] Chưa thoát được Submerged Island, tạm dừng tween đến đích.")
                        return
                    end
                end
            end

            if not TweenSpeed then
                TweenSpeed = 170
            end
            DefualtY = Tween_Pos.Y
            TargetY = Tween_Pos.Y
            targetCFrameWithDefualtY = CFrame.new(Tween_Pos.X, DefualtY, Tween_Pos.Z)
            targetPos = Tween_Pos.Position
            oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            Distance = (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
            if Distance <= 300 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Tween_Pos
            end
            local aM = CheckNearestTeleporter(Tween_Pos)
            if aM then
                pcall(function()
                    tween:Cancel()
                end)
                requestEntrance(aM)
            end
            b1 = CFrame.new(
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                DefualtY,
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
            )
            IngoreY = true
            if IngoreY and (b1.Position - targetCFrameWithDefualtY.Position).Magnitude > 5 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                    DefualtY,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
                local tweenfunc = {}
                local aN = game:GetService("TweenService")
                local aO = TweenInfo.new(
                    (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude / TweenSpeed,
                    Enum.EasingStyle.Linear
                )
                tween = aN:Create(
                    game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
                    aO,
                    {CFrame = targetCFrameWithDefualtY}
                )
                tween:Play()
                function tweenfunc:Stop()
                    tween:Cancel()
                end
                tween.Completed:Wait()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                    TargetY,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
            else
                local tweenfunc = {}
                local aN = game:GetService("TweenService")
                local aO = TweenInfo.new(
                    (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude / TweenSpeed,
                    Enum.EasingStyle.Linear
                )
                tween = aN:Create(
                    game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
                    aO,
                    {CFrame = Tween_Pos}
                )
                tween:Play()
                function tweenfunc:Stop()
                    tween:Cancel()
                end
                tween.Completed:Wait()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                    TargetY,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
            end
            if not tween then
                return tween
            end
            return tweenfunc
        end
    end)
end
function StopTween(target)
    pcall(function()
        if not target then
            getgenv().StopTween = true            
            if tween then
                tween:Cancel()
                tween = nil
            end            
            local player = game:GetService("Players").LocalPlayer
            local character = player and player.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Anchored = true
                task.wait(0.1)
                humanoidRootPart.CFrame = humanoidRootPart.CFrame
                humanoidRootPart.Anchored = false
            end
            local bodyClip = humanoidRootPart and humanoidRootPart:FindFirstChild("BodyClip")
            if bodyClip then
                bodyClip:Destroy()
            end
            getgenv().StopTween = false
            getgenv().Clip = false
        end
    end)
end
spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().TeleportIsland or 
               getgenv().AutoFarm or 
               getgenv().AutoMaterial or 
               getgenv().MasteryFarm or 
               getgenv().TeleportToFruit or 
               getgenv().AutoNewWorld or 
               getgenv().AutoThirdSea or 
               getgenv().AutoFactory or 
               getgenv().AutoPirateRaid or 
               getgenv().AutoEliteHunter or 
               getgenv().AutoTouchPadHaki or 
               getgenv().AutoRipIndra or 
               getgenv().AutoSoulReaper or 
               getgenv().AutoDoughKing or 
               getgenv().AutoDarkbeard or 
                                                            getgenv().AutoObservationHakiV2 or 
               getgenv().AutoObservation or 
               getgenv().AutoFarmBoss or 
               getgenv().AutoFarmAllBoss or 
               getgenv().Auto_Dungeon or 
               getgenv().SailBoat or 
               getgenv().RelzFishBoat or 
               getgenv().RelzPirateBrigade or 
               getgenv().RelzPirateGrandBrigade or 
               getgenv().AutoCyborg or
               getgenv().AutoGhoul or
               getgenv().QuestTrain_2 or
               getgenv().TeleportMigare or
               getgenv().Tweentohighestpoint or
               getgenv().TeleportToGear or
               getgenv().AutoRainbowHaki or
               getgenv().AutoSkullGuitar or
               getgenv().AutoTushita or
               getgenv().AutoSaber or
               getgenv().TeleportPlayer
            then
                if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local Noclip = Instance.new("BodyVelocity")
                    Noclip.Name = "BodyClip"
                    Noclip.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    Noclip.MaxForce = Vector3.new(100000, 100000, 100000)
                    Noclip.Velocity = Vector3.new(0, 0, 0)
                end
            else
                local bodyClip = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip")
                if bodyClip then
                    bodyClip:Destroy()
                end
            end
        end)
    end
end)
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if getgenv().TeleportIsland or 
               getgenv().AutoFarm or 
               getgenv().AutoMaterial or 
               getgenv().MasteryFarm or 
               getgenv().TeleportToFruit or 
               getgenv().AutoNewWorld or 
               getgenv().AutoThirdSea or 
               getgenv().AutoFactory or 
               getgenv().AutoPirateRaid or 
               getgenv().AutoEliteHunter or 
               getgenv().AutoTouchPadHaki or 
               getgenv().AutoRipIndra or 
               getgenv().AutoSoulReaper or 
               getgenv().AutoDoughKing or 
               getgenv().AutoDarkbeard or 
                                                            getgenv().AutoObservationHakiV2 or 
               getgenv().AutoObservation or 
               getgenv().AutoFarmBoss or 
               getgenv().AutoFarmAllBoss or 
               getgenv().Auto_Dungeon or 
               getgenv().SailBoat or 
               getgenv().RelzFishBoat or 
               getgenv().RelzPirateBrigade or 
               getgenv().RelzPirateGrandBrigade or 
               getgenv().AutoCyborg or
               getgenv().AutoGhoul or
               getgenv().QuestTrain_2 or
               getgenv().TeleportMigare or
               getgenv().Tweentohighestpoint or
               getgenv().TeleportToGear or
               getgenv().AutoRainbowHaki or
               getgenv().AutoSkullGuitar or
               getgenv().AutoTushita or
               getgenv().AutoSaber or
               getgenv().TeleportPlayer
            then
                for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
end)
spawn(function()
    local lastCall = 0
    local callInterval = 1
    while task.wait(0.1) do
        if getgenv().AUTO_KEN and tick() - lastCall >= callInterval then
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                local character = player and player.Character
                if character and character:FindFirstChild("Humanoid") then
                    game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
                end
            end)
            lastCall = tick()
        end
    end
end)
local player = game.Players.LocalPlayer
local function IsEntityAlive(entity)
    if not entity then return false end
    local humanoid = entity:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end
local function GetEnemiesInRange(character, range)
    local enemies = game:GetService("Workspace").Enemies:GetChildren()
    local players = game:GetService("Players"):GetPlayers()
    local targets = {}
    local playerPos = character:GetPivot().Position
    for _, enemy in ipairs(enemies) do
        local rootPart = enemy:FindFirstChild("HumanoidRootPart")
        if rootPart and IsEntityAlive(enemy) then
            local distance = (rootPart.Position - playerPos).Magnitude
            if distance <= range then
                table.insert(targets, enemy)
            end
        end
    end
    for _, otherPlayer in ipairs(players) do
        if otherPlayer ~= player and otherPlayer.Character then
            local rootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart and IsEntityAlive(otherPlayer.Character) then
                local distance = (rootPart.Position - playerPos).Magnitude
                if distance <= range then
                    table.insert(targets, otherPlayer.Character)
                end
            end
        end
    end
    return targets
end
function AttackNoCoolDown()
    local character = player.Character
    if not character then return end
    local equippedWeapon
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            equippedWeapon = item
            break
        end
    end
    if not equippedWeapon then return end
    local enemiesInRange = GetEnemiesInRange(character, 60)
    if equippedWeapon:FindFirstChild("LeftClickRemote") then
        local attackCount = 1  
        for _, enemy in ipairs(enemiesInRange) do
            local rootPart = enemy:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local direction = (rootPart.Position - character:GetPivot().Position).Unit
                equippedWeapon.LeftClickRemote:FireServer(direction, attackCount)
                attackCount = attackCount + 1
            end
        end
    else
        local targets, mainTarget = {}, nil
        for _, enemy in ipairs(enemiesInRange) do
            if not enemy:GetAttribute("IsBoat") then
                local head = enemy:FindFirstChild("Head")
                if head then
                    table.insert(targets, { enemy, head })
                    mainTarget = head
                end
            end
        end
        if mainTarget then
            local storage = game:GetService("ReplicatedStorage")
            local attackEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")
            local hitEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")
            pcall(function()
                attackEvent:FireServer(0.1)
                hitEvent:FireServer(mainTarget, targets)
            end)
        end
    end
end
--============================================================
-- 05. TẢI THƯ VIỆN VÀ KHỞI TẠO FLUENT UI
--============================================================
print("[Hiru Hub] Đang tải thư viện giao diện...")
local uiSourceOk, uiSource = pcall(function()
    return game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")
end)
if not uiSourceOk or type(uiSource) ~= "string" or uiSource == "" then
    error("[Hiru Hub] Không tải được thư viện UI. Kiểm tra mạng hoặc URL thư viện. Chi tiết: " .. tostring(uiSource))
end

local compileOk, uiLoader = pcall(function()
    return loadstring(uiSource)
end)
if not compileOk or type(uiLoader) ~= "function" then
    error("[Hiru Hub] Thư viện UI không biên dịch được: " .. tostring(uiLoader))
end

local runOk, Fluent = pcall(uiLoader)
if not runOk or type(Fluent) ~= "table" or type(Fluent.CreateWindow) ~= "function" then
    error("[Hiru Hub] Thư viện UI chạy lỗi hoặc thiếu CreateWindow: " .. tostring(Fluent))
end

Window = Fluent:CreateWindow({
    Title = "Tiro Hub [Premium] - Blox Fruit",
    SubTitle = "By HeHe",
    TabWidth = 140,
    Size = UDim2.fromOffset(550, 400),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End
})
Shop = Window:AddTab({ Title = "Tab Shop", Icon = "" })
sex = {
    "WildDares",
    "BossBuild",
    "GetPranked",
    "Sub2OfficialNoobie",
    "Sub2Daigrock",
    "Sub2NoobMaster123",
    "Bluxxy",
    "JCWK",
    "Enyu_is_Pro",
    "Sub2Fer999",
    "kittgaming",
    "TheGreatAce",
    "StrawHatMaine",
    "TantaiGaming",
    "Axiore",
    "SUB2GAMERROBOT_EXP1",
    "MagicBus",
    "StarcodeHEO",
    "Sub2CaptainMaui",
    "FIGHT4FRUIT",
    "EARN_FRUITS",
}
Shop:AddButton({
    Title = "Redeem Code",
    Callback = function()
        function RedeemCode(Value)
            game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(Value)
        end
        local delayBetweenRequests = 0.5
        for i, v in pairs(sex) do
            spawn(function()
                RedeemCode(v)
                wait(delayBetweenRequests)
            end)
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF_Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
Shop:AddButton({
    Title = "Teleport Old World",
    Callback = function()
        local success, result = pcall(function()
            return CommF_Remote:InvokeServer("TravelMain")
        end)
        if not success then
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF_Remote = Remotes:WaitForChild("CommF_")
Shop:AddButton({
    Title = "Teleport New World",
    Callback = function()
        local success, result = pcall(function()
            return CommF_Remote:InvokeServer("TravelDressrosa")
        end)
        if not success then            
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF_Remote = Remotes:WaitForChild("CommF_")
Shop:AddButton({
    Title = "Teleport Third Sea",
    Callback = function()
        local success, result = pcall(function()
            return CommF_Remote:InvokeServer("TravelZou")
        end)
        if not success then
        end
    end
})
Shop:AddParagraph({
    Title = "Abilities Shop",
    Content = string.rep("", 0)
})
Shop:AddButton({
	Title = "Skyjump [ $10,000 Beli ]",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
	end
})
Shop:AddButton({
	Title = "Buso Haki [ $25,000 Beli ]",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Buso")
	end
})
Shop:AddButton({
	Title = "Observation haki [ $750,000 Beli ]",
	Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk","Buy")
	end
})
Shop:AddButton({
	Title = "Soru [ $100,000 Beli ]",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Soru")
	end
})
Shop:AddParagraph({
    Title = "Misc Shop",
    Content = string.rep("", 0)
})
Shop:AddButton({
     Title = "Buy Refund Stat (2500F)",
     Callback = function()            
         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","1")
         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2")
     end
})
Shop:AddButton({
     Title = "Buy Reroll Race (3000F)",
     Callback = function()            
         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","1")
	     game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2")
     end
})
Shop:AddButton({
    Title = "Buy Ghoul Race",
    Callback = function()
        local args1 = {[1] = "Ectoplasm", [2] = "BuyCheck", [3] = 4}
        local args2 = {[1] = "Ectoplasm", [2] = "Change", [3] = 4}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args1))        
        wait(0.5)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args2))
    end
})
Shop:AddButton({
    Title = "Buy Cyborg Race (2500F)",
    Callback = function()
        if not isBuying then
            isBuying = true
            local args = {[1] = "CyborgTrainer", [2] = "Buy"}
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))                        
            wait(0.5)
            isBuying = false
        end
    end
})

-- Fighting Style Shop: Tween den NPC truoc, sau do moi gui lenh mua.
local MeleeRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
local MeleeChoices = {
    ["Dark Step (V1)"] = "BuyBlackLeg",
    ["Electric (V1)"] = "BuyElectro",
    ["Water Kung Fu (V1)"] = "BuyFishmanKarate",
    ["Dragon Breath (V1)"] = "DragonClaw",
    ["Superhuman"] = "BuySuperhuman",
    ["Death Step"] = "BuyDeathStep",
    ["Sharkman Karate"] = "BuySharkmanKarate",
    ["Electric Claw"] = "BuyElectricClaw",
    ["Dragon Talon"] = "BuyDragonTalon",
    ["Godhuman"] = "BuyGodhuman"
}
local MeleeNPCNames = {
    ["Dark Step (V1)"] = {"Dark Step Teacher"},
    ["Electric (V1)"] = {"Mad Scientist"},
    ["Water Kung Fu (V1)"] = {"Water Kung-fu Teacher", "Water Kung Fu Teacher"},
    ["Dragon Breath (V1)"] = {"Sabi"},
    ["Superhuman"] = {"Martial Arts Master"},
    ["Death Step"] = {"Phoeyu, the Reformed", "Phoeyu"},
    ["Sharkman Karate"] = {"Sharkman Teacher", "Daigrock, the Sharkman"},
    ["Electric Claw"] = {"Previous Hero"},
    ["Dragon Talon"] = {"Uzoth"},
    ["Godhuman"] = {"Ancient Monk"}
}
local SelectedMelee = "Godhuman"
local AutoBuyMelee = false
local MeleeBusy = false

Shop:AddParagraph({
    Title = "Fighting Style Shop",
    Content = "Có 4 võ V1 và các võ nâng cấp. Dark Step, Electric, Water Kung Fu dùng lệnh mua trực tiếp sau khi Tween đến NPC; Dragon Breath dùng hai bước BlackbeardReward tại Sabi. Combat là võ mặc định, không cần mua. Máy chủ vẫn kiểm tra điều kiện."
})

local MeleeDropdown = Shop:AddDropdown("SelectMeleeStyle", {
    Title = "Chọn võ cần mua",
    Values = {"Dark Step (V1)", "Electric (V1)", "Water Kung Fu (V1)", "Dragon Breath (V1)", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman"},
    Multi = false,
    Default = "Godhuman"
})
MeleeDropdown:OnChanged(function(Value)
    if MeleeChoices[Value] then
        SelectedMelee = Value
    end
end)

local function FindMeleeNPC(style)
    local names = MeleeNPCNames[style]
    if not names then return nil, nil end

    local searchRoots = {workspace}
    local replicatedNPCs = game:GetService("ReplicatedStorage"):FindFirstChild("NPCs")
    if replicatedNPCs then
        table.insert(searchRoots, replicatedNPCs)
    end

    for _, npcName in ipairs(names) do
        for _, rootFolder in ipairs(searchRoots) do
            local npc = rootFolder:FindFirstChild(npcName, true)
            if npc then
                local npcRoot = npc:FindFirstChild("HumanoidRootPart", true)
                    or npc.PrimaryPart
                    or npc:FindFirstChildWhichIsA("BasePart", true)
                if npcRoot then
                    return npc, npcRoot
                end
            end
        end
    end
    return nil, nil
end

local function GoToMeleeNPC(style)
    local npc, npcRoot = FindMeleeNPC(style)
    if not npc or not npcRoot then
        return false, "Không tìm thấy NPC " .. tostring((MeleeNPCNames[style] or {"?"})[1]) .. " ở khu vực hiện tại."
    end

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        return false, "Không tìm thấy nhân vật để Tween."
    end

    if (root.Position - npcRoot.Position).Magnitude > 10 then
        topos(npcRoot.CFrame * CFrame.new(0, 0, -4))
    end

    character = player.Character
    root = character and character:FindFirstChild("HumanoidRootPart")
    if not root or (root.Position - npcRoot.Position).Magnitude > 18 then
        return false, "Chưa đến gần NPC, hủy lệnh mua để tránh mua từ xa."
    end

    task.wait(0.35)
    return true, npc.Name
end

local function TryBuySelectedMelee()
    if MeleeBusy then
        return false, "Đang xử lý yêu cầu mua võ."
    end

    local command = MeleeChoices[SelectedMelee]
    if not command then
        return false, "Chưa chọn võ hợp lệ."
    end

    MeleeBusy = true
    local ok, result = pcall(function()
        local arrived, npcResult = GoToMeleeNPC(SelectedMelee)
        if not arrived then
            return "NPC_ERROR:" .. tostring(npcResult)
        end

        -- Cac Melee V1 dung lenh mua truc tiep sau khi da Tween den NPC.
        -- Khong goi command,true cho V1 vi cac lenh nay khong dung buoc kiem tra do.
        if SelectedMelee == "Dark Step (V1)"
            or SelectedMelee == "Electric (V1)"
            or SelectedMelee == "Water Kung Fu (V1)" then
            return MeleeRemote:InvokeServer(command)
        end

        -- Dragon Breath (V1) mua qua Sabi bang hai buoc BlackbeardReward.
        if SelectedMelee == "Dragon Breath (V1)" then
            local first = MeleeRemote:InvokeServer("BlackbeardReward", "DragonClaw", "1")
            task.wait(0.35)
            local second = MeleeRemote:InvokeServer("BlackbeardReward", "DragonClaw", "2")
            return tostring(first) .. " / " .. tostring(second)
        end

        -- Electric Claw can khoi dong hoi thoai/thu thach voi Previous Hero truoc.
        if SelectedMelee == "Electric Claw" then
            local startResult = MeleeRemote:InvokeServer("BuyElectricClaw", "Start")
            task.wait(0.35)
            if startResult == nil then
                return "Đã đến Previous Hero và gửi yêu cầu bắt đầu thử thách Electric Claw. Hoàn thành thử thách rồi chạy mua lại."
            end
        end

        local canBuy = MeleeRemote:InvokeServer(command, true)
        if canBuy == 1 or canBuy == "1" or canBuy == true then
            return MeleeRemote:InvokeServer(command)
        end
        return canBuy
    end)
    MeleeBusy = false

    if not ok then
        warn("[Hiru Hub] Mua " .. SelectedMelee .. " thất bại: " .. tostring(result))
        return false, "Lỗi khi Tween/gọi NPC: " .. tostring(result)
    end

    if type(result) == "string" and result:sub(1, 10) == "NPC_ERROR:" then
        return false, result:sub(11)
    end
    return true, tostring(result)
end

Shop:AddButton({
    Title = "Tween đến NPC và mua võ",
    Callback = function()
        local style = SelectedMelee
        local ok, result = TryBuySelectedMelee()
        if ok then
            print("[Hiru Hub] " .. style .. ": " .. result)
        else
            warn("[Hiru Hub] " .. result)
        end
    end
})

local AutoMeleeToggle = Shop:AddToggle("AutoBuyMeleeToggle", {
    Title = "Tự động Tween và mua võ",
    Description = "Mỗi lần bật sẽ Tween đến NPC của võ đã chọn rồi mới kiểm tra/mua.",
    Default = false
})
AutoMeleeToggle:OnChanged(function(Value)
    AutoBuyMelee = Value
    if Value then
        task.spawn(function()
            while AutoBuyMelee do
                local style = SelectedMelee
                local ok, result = TryBuySelectedMelee()
                if not ok then
                    warn("[Hiru Hub] Auto Buy Melee: " .. tostring(result))
                else
                    print("[Hiru Hub] Auto Buy " .. style .. ": " .. tostring(result))
                end
                task.wait(5)
            end
        end)
    end
end)

Server = Window:AddTab({ Title = "Tab Status And Server", Icon = "" })
Time = Server:AddParagraph({
    Title = "Time Zone",
    Content = ""
})
function UpdateOS()
    local date = os.date("*t")
    local hour = (date.hour) % 24
    local ampm = hour < 12 and "AM" or "PM"
    local timezone = string.format("%02i:%02i:%02i %s", ((hour - 1) % 12) + 1, date.min, date.sec, ampm)
    local datetime = string.format("%02d/%02d/%04d", date.day, date.month, date.year)    
    local LocalizationService = game:GetService("LocalizationService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local name = player.Name
    local result, code    
    if not getgenv().countryRegionCode then
        result, code = pcall(function()
            return LocalizationService:GetCountryRegionForPlayerAsync(player)
        end)
        if result then
            getgenv().countryRegionCode = code
        else
            getgenv().countryRegionCode = "Unknown"
        end
    else
        code = getgenv().countryRegionCode
    end
    Time:SetDesc(datetime.." - "..timezone.." [ " .. code .. " ]")
end
spawn(function()
    while true do
        UpdateOS()
        wait(1)
    end
end)
Timmessss = Server:AddParagraph({
    Title = "Time",
    Content = ""
})
function UpdateTime()
    local GameTime = math.floor(workspace.DistributedGameTime + 0.5)
    local Hour = math.floor(GameTime / (60^2)) % 24
    local Minute = math.floor(GameTime / (60^1)) % 60
    local Second = math.floor(GameTime / (60^0)) % 60
    Timmessss:SetDesc(Hour.." Hour (h) "..Minute.." Minute (m) "..Second.." Second (s) ")
end
spawn(function()
    while true do
        UpdateTime()
        wait(1)
    end
end)
-- Thông tin trạng thái hiển thị trong tab Server.
MobCakePrince = Server:AddParagraph({
    Title = "Dimension Killed",
    Content = ""
})
spawn(function()
    while wait(1) do
        local cakePrince = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
        local killStatus = "Cake Prince: ✅️"
        if string.len(cakePrince) >= 86 then
            local killCount = string.sub(cakePrince, 39, 41)
            killStatus = "Kill: " .. killCount
        end
        MobCakePrince:SetDesc(killStatus)
    end
end)
CheckRip = Server:AddParagraph({
    Title = "Rip_Indra",
    Content = "Status: "
})
spawn(function()
    local previousStatus = ""
    while wait(1) do
        local currentStatus = game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") and '✅️' or '❌️'
        if currentStatus ~= previousStatus then
            CheckRip:SetDesc("Status: " .. currentStatus)
            previousStatus = currentStatus
        end
    end
end)
CheckDoughKing = Server:AddParagraph({
    Title = "Dough King",
    Content = "Status: "
})
spawn(function()
    local previousStatus = ""
    while wait(1) do
        local currentStatus = game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") and '✅️' or '❌️'
        if currentStatus ~= previousStatus then
            CheckDoughKing:SetDesc("Status: " .. currentStatus)
            previousStatus = currentStatus
        end
    end
end)
EliteHunter = Server:AddParagraph({
    Title = "Elite Hunter",
    Content = "Status: "
})
spawn(function()
    local previousStatus = ""
    while wait(1) do
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban")) and '✅️' or '❌️'
        local progress = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress")
        if currentStatus ~= previousStatus then
            EliteHunter:SetDesc("Status: " .. currentStatus .. " | Killed: " .. progress)
            previousStatus = currentStatus
        end
    end
end)
FM = Server:AddParagraph({
    Title = "Full Moon",
    Content = ""
})
task.spawn(function()
    while task.wait(1) do
        local moonTextureId = game:GetService("Lighting").Sky.MoonTextureId
        local moonStatus = "Moon: 0/5"
        if moonTextureId == "http://www.roblox.com/asset/?id= 71977049625552" then
            moonStatus = "Moon: 5/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149052" then
            moonStatus = "Moon: 4/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id= 71977049625552" then
            moonStatus = "Moon: 3/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id= 71977049625552" then
            moonStatus = "Moon: 2/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id= 71977049625552" then
            moonStatus = "Moon: 1/5"
        end
        FM:SetDesc(moonStatus)
    end
end)
LegendarySword = Server:AddParagraph({
    Title = "Legendary Sword",
    Content = "Status: "
})
spawn(function()
    local previousStatus = ""
    while wait(1) do
        local swordStatus = "Not Found Legend Swords"
        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1") then
            swordStatus = "Shisui"
        elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2") then
            swordStatus = "Wando"
        elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3") then
            swordStatus = "Saddi"
        end
        LegendarySword:SetDesc(swordStatus)
    end
end)
StatusBone = Server:AddParagraph({
    Title = "Bone",
    Content = ""
})
spawn(function()
    while wait(1) do
        StatusBone:SetDesc("You Have: " .. tostring(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")) .. " Bones")
    end
end)	        
local TeleportService = game:GetService("TeleportService")

-- Dùng chung cơ chế ServerBrowser cho Hop và Rejoin.
local function TeleportWithServerBrowser(serverId)
    if type(serverId) ~= "string" or serverId == "" then
        warn("[Hiru Hub] ServerId không hợp lệ.")
        return false
    end

    local serverBrowser = ReplicatedStorage:FindFirstChild("__ServerBrowser")
    if not serverBrowser then
        warn("[Hiru Hub] Không tìm thấy ReplicatedStorage.__ServerBrowser.")
        return false
    end

    local success, result = pcall(function()
        return serverBrowser:InvokeServer("teleport", serverId)
    end)

    if not success then
        warn("[Hiru Hub] Không thể chuyển server:", result)
        return false
    end

    return true
end

local lastRejoinTime = 0
Server:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        if tick() - lastRejoinTime < 3 then
            return
        end
        lastRejoinTime = tick()

        -- Rejoin lại đúng instance hiện tại.
        TeleportWithServerBrowser(game.JobId)
    end
})

local lastHopTime = 0
local isHopping = false

local function Hop()
    if isHopping or tick() - lastHopTime < 3 then
        return
    end

    isHopping = true
    lastHopTime = tick()

    task.spawn(function()
        local success, result = pcall(function()
            local url = "https://games.roblox.com/v1/games/"
                .. tostring(game.PlaceId)
                .. "/servers/Public?sortOrder=Asc&limit=100"

            local response = game:HttpGet(url)
            local data = HttpService:JSONDecode(response)

            if not data or type(data.data) ~= "table" then
                error("API không trả về danh sách server hợp lệ.")
            end

            local availableServers = {}
            for _, server in ipairs(data.data) do
                if server.id
                    and tonumber(server.playing)
                    and tonumber(server.maxPlayers)
                    and tonumber(server.playing) < tonumber(server.maxPlayers)
                    and server.id ~= game.JobId then
                    table.insert(availableServers, tostring(server.id))
                end
            end

            if #availableServers == 0 then
                error("Không tìm thấy server công khai còn chỗ.")
            end

            local randomServer = availableServers[math.random(1, #availableServers)]
            warn("[Hiru Hub] Đang chuyển sang server khác...")
            if not TeleportWithServerBrowser(randomServer) then
                error("ServerBrowser không chấp nhận yêu cầu chuyển server.")
            end
        end)

        if not success then
            warn("[Hiru Hub] Hop Server thất bại:", result)
        end

        isHopping = false
    end)
end

Server:AddButton({
    Title = "Hop Server",
    Callback = function()
        Hop()
    end
})


Input = Server:AddInput("Input", {
     Title = "Input Job Id",
     Default = "",
     Placeholder = "Paste Job Id",
     Numeric = false,
     Finished = false,
     Callback = function(Value)
         getgenv().Job = Value
     end
})    
Toggle = Server:AddToggle("Toggle", {Title = "Spam Join", Default = false })
Toggle:OnChanged(function(Value)
getgenv().Join = Value
end)
spawn(function()
    local lastTeleportTime = 0
    local teleportCooldown = 1    
    while task.wait() do
        if getgenv().Join and tick() - lastTeleportTime >= teleportCooldown then
            lastTeleportTime = tick()
            TeleportWithServerBrowser(tostring(getgenv().Job or ""))
        end
    end
end)
local lastTeleportTime = 0
local teleportCooldown = 5
Server:AddButton({
    Title = "Join Server",
    Callback = function()
        if tick() - lastTeleportTime >= teleportCooldown then
            lastTeleportTime = tick()
            TeleportWithServerBrowser(tostring(getgenv().Job or ""))        
        end
    end
})
local lastCopyTime = 0
local copyCooldown = 2
Server:AddButton({
    Title = "Copy JobId",
    Callback = function()
        if tick() - lastCopyTime >= copyCooldown then
            lastCopyTime = tick()
            setclipboard(tostring(game.JobId))
            print("JobId Copied!")
        else
            print("Please try again in a moment!")
        end
    end
})
--============================================================
-- 08. TAB LOCAL PLAYER
--============================================================
LGa = Window:AddTab({ Title = "Tab Local Player", Icon = "" })
LGa:AddButton({
    Title = "Stop Tween",
    Callback = function()
        StopTween()
    end
})
LGa:AddButton({
    Title = "Open Title",
    Callback = function()
        local args = {"getTitles"}
        local success, result = pcall(function()
            return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end)
        if success then
            game.Players.LocalPlayer.PlayerGui.Main.Titles.Visible = true
        end
    end
})
local lastButtonPressTime = 0
local buttonCooldown = 2
LGa:AddButton({
    Title = "Open Color",
    Callback = function()
        if tick() - lastButtonPressTime >= buttonCooldown then
            lastButtonPressTime = tick()
            local colorsGui = game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Colors")
            if colorsGui then
                colorsGui.Visible = true
            end
        end
    end
})
LGa:AddButton({
    Title = "Boost FPS",
    Callback = function()
        FPSBooster()
    end
})
function FPSBooster()
    local decalsyeeted = true
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain    
    sethiddenproperty(l, "Technology", 2)
    sethiddenproperty(t, "Decoration", false)
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"    
    local function optimizePart(v)
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 10385902758728957
        end
    end    
    for i, v in pairs(w:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") or v:IsA("MeshPart") then
            optimizePart(v)
        end
    end
    for i, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
end
PointStats = PointStats or 1
StatsMode = StatsMode or nil
getgenv().AutoStats = getgenv().AutoStats or false

Dropdown = LGa:AddDropdown("Dropdown", {
    Title = "Select Stats",
    Values = {"Melee", "Defense", "Sword", "Gun", "Fruit"},
    Multi = false,
})
Dropdown:SetValue("")
Dropdown:OnChanged(function(Value)
    StatsMode = Value
end)

-- AutoStats theo cơ chế QuantumOnyx:
-- Chỉ cộng khi còn điểm, giới hạn số điểm cộng theo điểm đang có.
task.spawn(function()
    local statTypes = {
        Melee = "Melee",
        Defense = "Defense",
        Sword = "Sword",
        Gun = "Gun",
        Fruit = "Demon Fruit"
    }

    while task.wait(0.3) do
        if getgenv().AutoStats then
            local player = Players.LocalPlayer
            local data = player and player:FindFirstChild("Data")
            local points = data and data:FindFirstChild("Points")
            local selectedStat = statTypes[StatsMode]
            local requestedPoints = tonumber(PointStats) or 1

            if points and selectedStat and points.Value > 0 and requestedPoints > 0 then
                local amount = math.clamp(requestedPoints, 1, points.Value)
                pcall(function()
                    CommF:InvokeServer("AddPoint", selectedStat, amount)
                end)
            end
        end
    end
end)

Slider = LGa:AddSlider("Slider", {
        Title = "Point Stats",
        Description = "",
        Default = 1,
        Min = 1,
        Max = 1000,
        Rounding = 0,
        Callback = function(value)
        PointStats = value
    end
})
Toggle = LGa:AddToggle("Toggle", { Title = "Auto Stats", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoStats = Value
end)
local canChangeTeam = true
local debounceTime = 2
LGa:AddButton({
    Title = "Change Team To Pirates",
    Callback = function()
        if not canChangeTeam then
            return
        end
        canChangeTeam = false
        task.wait(debounceTime)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        end)
        canChangeTeam = true
    end
})
local canChangeTeam = true
local debounceTime = 2
LGa:AddButton({
    Title = "Change Team To Marines",
    Callback = function()
        if not canChangeTeam then
            return
        end
        canChangeTeam = false
        task.wait(debounceTime)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
        end)
        canChangeTeam = true
    end
})
Toggle = LGa:AddToggle("Toggle", { Title = "Auto Summon Cake Prince", Description = "When you attack 500 monsters, you will automatically summon Cake Prince", Default = true })
Toggle:OnChanged(function(Value)
    getgenv().AutoSpawnCP = Value
end)
local lastSpawnTime = 0
local spawnCooldown = 1
spawn(function() 
    while task.wait() do
        if getgenv().AutoSpawnCP and tick() - lastSpawnTime >= spawnCooldown then
            lastSpawnTime = tick()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
        end
    end
end)
Toggle = LGa:AddToggle("Toggle", {Title = "Black Screen", Default = false })
Toggle:OnChanged(function(Value)
	getgenv().StartBlackScreen = Value
end)
local lastUpdateTime = 0
local updateCooldown = 0.5
spawn(function()
    while task.wait() do
        if tick() - lastUpdateTime >= updateCooldown then
            lastUpdateTime = tick()
            if getgenv().StartBlackScreen then
                game:GetService("Players").LocalPlayer.PlayerGui.Main.Blackscreen.Size = UDim2.new(500, 0, 500, 500)
            else
                game:GetService("Players").LocalPlayer.PlayerGui.Main.Blackscreen.Size = UDim2.new(1, 0, 500, 500)
            end
        end
    end
end)
Toggle = LGa:AddToggle("Toggle", {Title = "White Screen", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().WhiteScreen = Value
    if getgenv().WhiteScreen == true then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    elseif getgenv().WhiteScreen == false then
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
end)
Toggle = LGa:AddToggle("Toggle", {Title = "Hide Mob", Default = false })
Toggle:OnChanged(function(Value)
     getgenv().HideMob = Value		
end)
spawn(function()
    while task.wait() do
        if getgenv().HideMob then
            pcall(function()
                for i, v in pairs(game:GetService("Workspace").Enemies:GetDescendants()) do
                    if v.ClassName == "MeshPart" then
                        v.Transparency = 1
                    end
                end
                for i, v in pairs(game:GetService("Workspace").Enemies:GetDescendants()) do
                    if v.Name == "Head" then
                        v.Transparency = 1
                    end
                end
                for i, v in pairs(game:GetService("Workspace").Enemies:GetDescendants()) do
                    if v.ClassName == "Accessory" then
                        v.Handle.Transparency = 1
                    end
                end
                for i, v in pairs(game:GetService("Workspace").Enemies:GetDescendants()) do
                    if v.ClassName == "Decal" then
                        v.Transparency = 1
                    end
                end
            end)
        end
    end
end)
Toggle = LGa:AddToggle("Toggle", {Title = "Remove Dame Text", Default = true })
Toggle:OnChanged(function(Value)
    getgenv().RemoveText = Value
    game:GetService("ReplicatedStorage").Assets.GUI.DamageCounter.Enabled = not getgenv().RemoveText
end)
Toggle = LGa:AddToggle("Toggle", {Title = "Remove Notification", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().RemoveNotification = Value
    game.Players.LocalPlayer.PlayerGui.Notifications.Enabled = not getgenv().RemoveNotification
end)
Toggle = LGa:AddToggle("Toggle", {Title = "Auto Rejoin On Kick", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoRejoinKick = Value
    if Value then
        getgenv().rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
            if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
                TeleportWithServerBrowser(game.JobId)
            end
        end)
    else
        if getgenv().rejoin then
            getgenv().rejoin:Disconnect()
            getgenv().rejoin = nil
        end
    end
end)
LGa:AddButton({
    Title = "Rain Fruit",
    Callback = function()
        local fruitObjects = game:GetObjects("rbxassetid://14759368201")[1]:GetChildren()
        local maxFruits = 10
        local count = 0
        for i, v in pairs(fruitObjects) do
            if count >= maxFruits then break end
            count = count + 1
            v.Parent = game.Workspace.Map
            v:MoveTo(game.Players.LocalPlayer.Character.PrimaryPart.Position + Vector3.new(math.random(-50, 50), 100, math.random(-50, 50)))            
            local fruitAnimationController = v.Fruit:FindFirstChild("AnimationController")
            if fruitAnimationController then
                local idleAnimation = fruitAnimationController:FindFirstChild("Idle")
                if idleAnimation then
                    idleAnimation:Play()
                end
            end
            v.Handle.Touched:Connect(function(otherPart)
                if otherPart.Parent == game.Players.LocalPlayer.Character then
                    v.Parent = game.Players.LocalPlayer.Backpack
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                end
            end)
        end
    end
})
if World1 then
    Dropdown = LGa:AddDropdown("Dropdown", {
        Title = "Select Island",
        Values = {
            "WindMill", "Marine", "Middle Town", "Jungle", "Pirate Village", 
            "Desert", "Snow Island", "MarineFord", "Colosseum", "Sky Island 1", 
            "Sky Island 2", "Sky Island 3", "Prison", "Magma Village", 
            "Under Water Island", "Fountain City", "Shank Room", "Mob Island"
        },
        Multi = false,
        Default = false,
    })
    Dropdown:SetValue("0.15")
    Dropdown:OnChanged(function(Value)
        getgenv().SelectIsland = Value
    end)
end
if World2 then
    Dropdown = LGa:AddDropdown("Dropdown", {
        Title = "Select Island",
        Values = {
            "The Cafe", "Frist Spot", "Dark Area", "Flamingo Mansion", "Flamingo Room", 
            "Green Zone", "Factory", "Colossuim", "Zombie Island", "Two Snow Mountain", 
            "Punk Hazard", "Cursed Ship", "Ice Castle", "Forgotten Island", 
            "Ussop Island", "Mini Sky Island"
        },
        Multi = false,
        Default = false,
    })
    Dropdown:SetValue("0.15")
    Dropdown:OnChanged(function(Value)
        getgenv().SelectIsland = Value
    end)
end
if World3 then
    Dropdown = LGa:AddDropdown("Dropdown", {
        Title = "Select Island",
        Values = {
            "Mansion", "Port Town", "Great Tree", "Castle On The Sea", "MiniSky", 
            "Hydra Island", "Floating Turtle", "Haunted Castle", "Ice Cream Island", 
            "Peanut Island", "Cake Island", "Cocoa Island", "Candy Island", "Tiki Outpost",
            "Submerged Island"
        },
        Multi = false,
        Default = false,
    })
    Dropdown:SetValue("0.15")
    Dropdown:OnChanged(function(Value)
        getgenv().SelectIsland = Value
    end)
end    
Toggle = LGa:AddToggle("Toggle", {Title = "Teleport Island", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().TeleportIsland = Value
    if getgenv().TeleportIsland == true then
        repeat task.wait()
            if getgenv().SelectIsland == "WindMill" then
                topos(CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594))
            elseif getgenv().SelectIsland == "Marine" then
                topos(CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156))
            elseif getgenv().SelectIsland == "Middle Town" then
                topos(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
            elseif getgenv().SelectIsland == "Jungle" then
                topos(CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754))
            elseif getgenv().SelectIsland == "Pirate Village" then
                topos(CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969))
            elseif getgenv().SelectIsland == "Desert" then
                topos(CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688))
            elseif getgenv().SelectIsland == "Snow Island" then
                topos(CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469))
            elseif getgenv().SelectIsland == "MarineFord" then
                topos(CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313))
            elseif getgenv().SelectIsland == "Colosseum" then
                topos(CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969))
            elseif getgenv().SelectIsland == "Sky Island 1" then
                topos(CFrame.new(-4869.1025390625, 733.46051025391, -2667.0180664063))
            elseif getgenv().SelectIsland == "Sky Island 2" then  
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.82275, 872.54248, -1667.55688))
            elseif getgenv().SelectIsland == "Sky Island 3" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
            elseif getgenv().SelectIsland == "Prison" then
                topos(CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656))
            elseif getgenv().SelectIsland == "Magma Village" then
                topos(CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875))
            elseif getgenv().SelectIsland == "Under Water Island" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            elseif getgenv().SelectIsland == "Fountain City" then
                topos(CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813))
            elseif getgenv().SelectIsland == "Shank Room" then
                topos(CFrame.new(-1442.16553, 29.8788261, -28.3547478))
            elseif getgenv().SelectIsland == "Mob Island" then
                topos(CFrame.new(-2850.20068, 7.39224768, 5354.99268))
            elseif getgenv().SelectIsland == "The Cafe" then
                topos(CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828))
            elseif getgenv().SelectIsland == "Frist Spot" then
                topos(CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375))
            elseif getgenv().SelectIsland == "Dark Area" then
                topos(CFrame.new(3780.0302734375, 22.652164459229, -3498.5859375))
            elseif getgenv().SelectIsland == "Flamingo Mansion" then
                topos(CFrame.new(-483.73370361328, 332.0383605957, 595.32708740234))
            elseif getgenv().SelectIsland == "Flamingo Room" then
                topos(CFrame.new(2284.4140625, 15.152037620544, 875.72534179688))
            elseif getgenv().SelectIsland == "Green Zone" then
                topos(CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344))
            elseif getgenv().SelectIsland == "Factory" then
                topos(CFrame.new(424.12698364258, 211.16171264648, -427.54049682617))
            elseif getgenv().SelectIsland == "Colossuim" then
                topos(CFrame.new(-1503.6224365234, 219.7956237793, 1369.3101806641))
            elseif getgenv().SelectIsland == "Zombie Island" then
                topos(CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094))
            elseif getgenv().SelectIsland == "Two Snow Mountain" then
                topos(CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938))
            elseif getgenv().SelectIsland == "Punk Hazard" then
                topos(CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125))
            elseif getgenv().SelectIsland == "Cursed Ship" then
                topos(CFrame.new(923.40197753906, 125.05712890625, 32885.875))
            elseif getgenv().SelectIsland == "Ice Castle" then
                topos(CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188))
            elseif getgenv().SelectIsland == "Forgotten Island" then
                topos(CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875))
            elseif getgenv().SelectIsland == "Ussop Island" then
                topos(CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781))
            elseif getgenv().SelectIsland == "Mini Sky Island" then
                topos(CFrame.new(-288.74060058594, 49326.31640625, -35248.59375))
            elseif getgenv().SelectIsland == "Great Tree" then
                topos(CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625))
            elseif getgenv().SelectIsland == "Castle On The Sea" then
                topos(CFrame.new(-5074.45556640625, 314.5155334472656, -2991.054443359375))
            elseif getgenv().SelectIsland == "MiniSky" then
                topos(CFrame.new(-260.65557861328, 49325.8046875, -35253.5703125))
            elseif getgenv().SelectIsland == "Port Town" then
                topos(CFrame.new(-95, 11, 5455))
            elseif getgenv().SelectIsland == "Hydra Island" then
                topos(CFrame.new(5433, 1062, 290))
            elseif getgenv().SelectIsland == "Floating Turtle" then
                topos(CFrame.new(-13274.528320313, 531.82073974609, -7579.22265625))
            elseif getgenv().SelectIsland == "Mansion" then
                topos(CFrame.new(-12551, 337, -7476))
            elseif getgenv().SelectIsland == "Haunted Castle" then
                topos(CFrame.new(-9516, 142, 5537))
            elseif getgenv().SelectIsland == "Ice Cream Island" then
                topos(CFrame.new(-874, 66, -10915))
            elseif getgenv().SelectIsland == "Peanut Island" then
                topos(CFrame.new(-2062.7475585938, 50.473892211914, -10232.568359375))
            elseif getgenv().SelectIsland == "Cake Island" then
                topos(CFrame.new(-1884.7747802734375, 19.327526092529297, -11666.8974609375))
            elseif getgenv().SelectIsland == "Cocoa Island" then
                topos(CFrame.new(87.94276428222656, 73.55451202392578, -12319.46484375))
            elseif getgenv().SelectIsland == "Candy Island" then
                topos(CFrame.new(-1014.4241943359375, 149.11068725585938, -14555.962890625))
            elseif getgenv().SelectIsland == "Tiki Outpost" then
                topos(CFrame.new(-16101.1885, 12.8422165, 380.942291, 0.194113985, 1.39194061e-08, -0.980978966, -9.82904691e-09, 1, 1.22443504e-08, 0.980978966, 7.26528837e-09, 0.194113985))
            elseif getgenv().SelectIsland == "Submerged Island" then
                -- Tween đến Submarine Worker trước, sau đó mới yêu cầu xuống đảo.
                local SubmarineWorkerCFrame = CFrame.new(-16267.8, 25.4, 1373.2)
                local character = game:GetService("Players").LocalPlayer.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")

                if root then
                    topos(SubmarineWorkerCFrame)

                    -- Chỉ nói chuyện khi đã tween đến gần NPC.
                    character = game:GetService("Players").LocalPlayer.Character
                    root = character and character:FindFirstChild("HumanoidRootPart")
                    if root and (root.Position - SubmarineWorkerCFrame.Position).Magnitude <= 80
                        and getgenv().TeleportIsland then
                        task.wait(1)

                        local net = game:GetService("ReplicatedStorage")
                            :WaitForChild("Modules")
                            :WaitForChild("Net")
                        local speakRemote = net:WaitForChild("RF/SubmarineWorkerSpeak")

                        local ok, result = pcall(function()
                            return speakRemote:InvokeServer("TravelToSubmergedIsland")
                        end)

                        if not ok then
                            warn("[Hiru Hub] Không thể nói chuyện với Submarine Worker: " .. tostring(result))
                        end

                        -- Tránh lặp lệnh và tween ngược lại NPC sau khi server đưa xuống đảo.
                        task.wait(4)
                        getgenv().TeleportIsland = false
                    end
                end
            end
        until not getgenv().TeleportIsland
    end
end)
--============================================================
-- 09. TAB SETTING FARM / TỐI ƯU
--============================================================
Settings = Window:AddTab({ Title = "Setting Farm", Icon = "" })
Dropdown = Settings:AddDropdown("DropdownFarm", {
    Title = "Select Weapon",
    Values = {"Melee","Sword","Blox Fruit"},
    Multi = false,
})
Dropdown:SetValue("Melee")
Dropdown:OnChanged(function(value)
    getgenv().SelectWeapon = value
end)
task.spawn(function()
    local lastWeapon = nil
    while task.wait(0.5) do
        pcall(function()
            if getgenv().SelectWeapon == lastWeapon then
                return
            end
            lastWeapon = getgenv().SelectWeapon
            local weaponFound = nil
            for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if v.ToolTip == getgenv().SelectWeapon then
                    weaponFound = v.Name
                    break
                end
            end
            if weaponFound then
                getgenv().SelectWeapon = weaponFound
            end
        end)
    end
end)
Toggle = Settings:AddToggle("Toggle", {Title = "Auto Turn On Buso", Default = true })
Toggle:OnChanged(function(Value)
    getgenv().AUTOHAKI = Value
end)

-- Ken Haki toggle in Setting Farm
getgenv().AUTO_KEN = false
Toggle = Settings:AddToggle("AutoKenHaki", {
    Title = "Auto Turn On Ken Haki",
    Default = false
})
Toggle:OnChanged(function(Value)
    getgenv().AUTO_KEN = Value
end)
spawn(function()
    local canUseHaki = true
    local debounceTime = 2
    while task.wait(0.1) do
        if getgenv().AUTOHAKI then
            if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") and canUseHaki then
                canUseHaki = false
                local args = {
                    [1] = "Buso"
                }
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end)
                wait(debounceTime)
                canUseHaki = true
            end
        end
    end
end)
Toggle = Settings:AddToggle("Toggle", { Title = "Auto Turn On Race V4", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoTurnOnV4 = Value
end)
task.spawn(function()
    local lastCheckTime = 0
    while true do
        task.wait(0.1)
        if getgenv().AutoTurnOnV4 then
            local currentTime = tick()
            if currentTime - lastCheckTime >= 0.5 then
                lastCheckTime = currentTime
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("RaceEnergy") and
                   character.RaceEnergy.Value >= 1 and
                   not character.RaceTransformed.Value then
                    local be = game:GetService("VirtualInputManager")
                    be:SendKeyEvent(true, "Y", false, game)
                    task.wait(0.1)
                    be:SendKeyEvent(false, "Y", false, game)
                end
            end
        end
    end
end)

-- Auto Hop Server: tự chuyển sang server khác mỗi 30 phút.
-- Sử dụng Hop() có sẵn, vốn chuyển server thông qua ReplicatedStorage.__ServerBrowser.
getgenv().AutoHopEvery30Minutes = false

Toggle = Settings:AddToggle("Toggle", {
    Title = "Auto Hop Server (30 Minutes)",
    Default = false
})
Toggle:OnChanged(function(Value)
    getgenv().AutoHopEvery30Minutes = Value
end)

task.spawn(function()
    local interval = 30 * 60
    local elapsed = 0

    while task.wait(1) do
        if getgenv().AutoHopEvery30Minutes then
            elapsed = elapsed + 1

            if elapsed >= interval then
                elapsed = 0
                if type(Hop) == "function" then
                    Hop()
                else
                    warn("[Hiru Hub] Hop() chưa sẵn sàng.")
                end
            end
        else
            -- Tắt rồi bật lại sẽ bắt đầu đếm đủ 30 phút mới.
            elapsed = 0
        end
    end
end)

Toggle = Settings:AddToggle("Toggle", {Title = "Auto Turn On Race V3", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoTurnOnV3 = Value
end)
task.spawn(function()
    local prevState = false    
    while true do
        task.wait(0.1)        
        pcall(function()
            if getgenv().AutoTurnOnV3 ~= prevState then
                if getgenv().AutoTurnOnV3 then
                    game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
                end
                prevState = getgenv().AutoTurnOnV3
            end
        end)
    end
end)
local Toggle = Settings:AddToggle("Toggle", {Title = "Auto Set Spawn Point", Default = false })
local lastSetState = false
Toggle:OnChanged(function(Value)
    getgenv().Set = Value
    if Value ~= lastSetState then
        lastSetState = Value
        if Value then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
            end)
        end
    end
end)
Toggle = Settings:AddToggle("Toggle", {Title = "Anti AFK", Default = true })
Toggle:OnChanged(function(Value)
    getgenv().AntiAFK = Value 
end)
task.spawn(function()
    while true do
        if getgenv().AntiAFK then
            local vu = game:GetService("VirtualUser")
            local player = game:GetService("Players").LocalPlayer
            player.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
        game:GetService("RunService").Heartbeat:wait()
    end
end)
getgenv().FastAttack = false
Toggle = Settings:AddToggle("Toggle", {Title = "Fast Attack", Default = true})
local FastAttackTask
local function FastAttackLoop()
    while getgenv().FastAttack do
        if type(AttackNoCoolDown) == "function" then
            AttackNoCoolDown()
        end
        task.wait(0.1)
    end
end
Toggle:OnChanged(function(Value)
    getgenv().FastAttack = Value
    if Value and not FastAttackTask then
        FastAttackTask = task.spawn(FastAttackLoop)
    end
    if not Value and FastAttackTask then
        FastAttackTask = nil
    end
end)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

Toggle = Settings:AddToggle("Toggle", {Title = "Bring Mob", Default = true})
Toggle:OnChanged(function(Value)
    getgenv().BringMonster = Value
    if not Value then
        for _, mob in ipairs(CollectionService:GetTagged("BnnQuantumBringTag")) do
            pcall(function() CollectionService:RemoveTag(mob, "BnnQuantumBringTag") end)
        end
    end
end)

local BringCache = {}
local BringScanAt = 0
local SimulationUpdateAt = 0
local BringTag = "BnnQuantumBringTag"
getgenv().BringMonsterRadius = getgenv().BringMonsterRadius or 350

local function GetMobRoot(model)
    return model and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart)
end

local function IsAliveMob(model)
    local humanoid = model and model:FindFirstChildOfClass("Humanoid")
    local root = GetMobRoot(model)
    return humanoid and humanoid.Health > 0 and root, humanoid, root
end

local function IsNearOtherPlayer(position)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - position).Magnitude <= 55 then
                return true
            end
        end
    end
    return false
end

-- Each tagged mob is pulled toward the current farm target using BodyPosition.
CollectionService:GetInstanceAddedSignal(BringTag):Connect(function(mob)
    task.spawn(function()
        local humanoid = mob and mob:FindFirstChildOfClass("Humanoid")
        local root = GetMobRoot(mob)
        if not humanoid or not root then
            pcall(function() CollectionService:RemoveTag(mob, BringTag) end)
            return
        end

        local mover = root:FindFirstChild("BnnBringBodyPosition")
        if not mover then
            mover = Instance.new("BodyPosition")
            mover.Name = "BnnBringBodyPosition"
            mover.MaxForce = Vector3.new(1000000, 1000000, 1000000)
            mover.P = 8000
            mover.D = 600
            mover.Position = root.Position
            mover.Parent = root
        end

        local expiresAt = tick() + 25
        local lostTargetCount = 0
        while getgenv().BringMonster and mob.Parent and root.Parent
            and humanoid.Health > 0 and CollectionService:HasTag(mob, BringTag)
            and tick() < expiresAt do
            local character = LocalPlayer.Character
            local playerRoot = character and character:FindFirstChild("HumanoidRootPart")
            local cachedTarget = BringCache[mob.Name]
            local radius = tonumber(getgenv().BringMonsterRadius) or 350

            if playerRoot and cachedTarget and (playerRoot.Position - root.Position).Magnitude <= radius + 50 then
                for _, part in ipairs(mob:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                mover.Position = cachedTarget.Position
                lostTargetCount = 0
            else
                lostTargetCount += 1
            end

            if lostTargetCount > 15 then break end
            task.wait(0.04)
        end

        pcall(function()
            if mover and mover.Parent then mover:Destroy() end
            if CollectionService:HasTag(mob, BringTag) then
                CollectionService:RemoveTag(mob, BringTag)
            end
            for _, part in ipairs(mob:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end)
    end)
end)

-- Scan mobs with the same name as the active target and group them at PosMon.
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not getgenv().BringMonster or not getgenv().StartMagnet or not PosMon then
                return
            end

            local now = tick()
            if now - BringScanAt < 0.25 then return end
            BringScanAt = now

            local character = LocalPlayer.Character
            local playerRoot = character and character:FindFirstChild("HumanoidRootPart")
            local enemies = Workspace:FindFirstChild("Enemies")
            local targetName = MonFarm or Mon
            if not playerRoot or not enemies or not targetName then return end

            local targetModel, targetRoot
            for _, mob in ipairs(enemies:GetChildren()) do
                if mob.Name == targetName then
                    local alive, _, root = IsAliveMob(mob)
                    if alive and root then
                        targetModel, targetRoot = mob, root
                        break
                    end
                end
            end
            if not targetModel or not targetRoot then return end

            local targetCFrame = typeof(PosMon) == "CFrame" and PosMon or targetRoot.CFrame
            BringCache[targetName] = targetCFrame
            local radius = math.clamp(tonumber(getgenv().BringMonsterRadius) or 350, 100, 500)

            if now - SimulationUpdateAt > 3 then
                SimulationUpdateAt = now
                pcall(function()
                    sethiddenproperty(LocalPlayer, "SimulationRadius", radius + 50)
                    sethiddenproperty(LocalPlayer, "MaxSimulationRadius", radius + 50)
                end)
            end

            local tagged = CollectionService:GetTagged(BringTag)
            for _, mob in ipairs(tagged) do
                local alive = IsAliveMob(mob)
                if not mob.Parent or not alive then
                    pcall(function() CollectionService:RemoveTag(mob, BringTag) end)
                end
            end
            if #CollectionService:GetTagged(BringTag) >= 8 then return end

            local nearbyPlayers = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local otherCharacter = player.Character
                    local otherRoot = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
                    if otherRoot then table.insert(nearbyPlayers, otherRoot.Position) end
                end
            end

            local added = 0
            for _, mob in ipairs(enemies:GetChildren()) do
                if mob ~= targetModel and mob.Name == targetName
                    and not CollectionService:HasTag(mob, BringTag) then
                    local alive, humanoid, root = IsAliveMob(mob)
                    if alive and humanoid and root then
                        local position = root.Position
                        local inRange = (position - targetRoot.Position).Magnitude <= radius
                            and (position - playerRoot.Position).Magnitude <= radius
                        local nearPlayer = false
                        if inRange then
                            for _, otherPosition in ipairs(nearbyPlayers) do
                                if (position - otherPosition).Magnitude <= 55 then
                                    nearPlayer = true
                                    break
                                end
                            end
                        end
                        if inRange and not nearPlayer then
                            CollectionService:AddTag(mob, BringTag)
                            added += 1
                            if added >= 4 then break end
                        end
                    end
                end
            end
        end)
    end
end)

Slider = Settings:AddSlider("Slider", {
     Title = "Farm Distance",
     Default = 15,
     Min = 0,
     Max = 30,
     Rounding = 5,
     Callback = function(Value)
         PosY = Value
    end
})
Toggle = Settings:AddToggle("Toggle", {Title = "Auto Reduce Lag Farm Safely", Default = true })
Toggle:OnChanged(function(Value)
    getgenv().ReduceLag = Value
end)
spawn(function()
    while wait(0.1) do
        if getgenv().ReduceLag then
            for i, v in pairs(game.Workspace["_WorldOrigin"]:GetChildren()) do
                if v and (v.Name == "CurvedRing" or v.Name == "SlashHit" or v.Name == "SwordSlash" or v.Name == "SlashTail" or v.Name == "Sounds") then
                    pcall(function()
                        v:Destroy()
                    end)
                end
            end
        end
    end
end)
Toggle = Settings:AddToggle("Toggle", {Title = "Anti Cheat Farming", Description = "This feature helps you Farm safely without being detected", Default = true })
Toggle:OnChanged(function(Value)
    getgenv().ResetFlags = Value
end)
spawn(function()
    while task.wait(5) do
        pcall(function()
            if getgenv().ResetFlags then
                local player = game:GetService("Players").LocalPlayer                
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("LocalScript") then
                        local scriptsToRemove = {
                            "General", "Shiftlock", "FallDamage", "4444", 
                            "CamBob", "JumpCD", "Looking", "Run"
                        }
                        if table.find(scriptsToRemove, v.Name) then
                            v:Destroy()
                        end
                    end
                end
                for _, v in pairs(player.PlayerScripts:GetDescendants()) do
                    if v:IsA("LocalScript") then
                        local scriptsToRemove = {
                            "RobloxMotor6DBugFix", "Clans", "Codes", "CustomForceField",
                            "MenuBloodSp", "PlayerList"
                        }
                        if table.find(scriptsToRemove, v.Name) then
                            v:Destroy()
                        end
                    end
                end
            end
        end)
    end
end)
--============================================================
-- 10. TAB FARMING: FARM LEVEL
--============================================================
Main = Window:AddTab({ Title = "Tab Farming", Icon = "" })
Dropdown = Main:AddDropdown("DropdownFarm", {
    Title = "Farm",
    Values = {"Farm Level", "Farm Bone", "Farm Katakuri"},
    Multi = false,
})
Dropdown:SetValue("Farm Level")
Dropdown:OnChanged(function(Value)
FarmMode = Value
end)

-- Một toggle chung cho nhận nhiệm vụ Farm Bone và Farm Cake.
-- Tắt toggle thì hai chế độ vẫn farm nếu đã có đúng quest, nhưng không tự nhận quest mới.
local BoneCakeQuestToggle = Main:AddToggle("BoneCakeQuestToggle", {
    Title = "Accept Bone / Cake Farm Quest",
    Default = false,
})
BoneCakeQuestToggle:OnChanged(function(Value)
    getgenv().AutoAcceptBoneCakeQuest = Value
end)

-- Giữ khoảng cách farm cố định: đúng 17 studs theo trục Y, không bật nhảy.
local FarmJumpSettings = setmetatable({}, {__mode = "k"})
local function SetFarmNoJump(humanoid, enabled)
    if not humanoid then return end
    if enabled then
        if not FarmJumpSettings[humanoid] then
            FarmJumpSettings[humanoid] = {
                JumpPower = humanoid.JumpPower,
                JumpHeight = humanoid.JumpHeight,
                JumpingEnabled = humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)
            }
        end
        humanoid.Jump = false
        humanoid.JumpPower = 0
        humanoid.JumpHeight = 0
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    else
        local old = FarmJumpSettings[humanoid]
        if old then
            humanoid.JumpPower = old.JumpPower
            humanoid.JumpHeight = old.JumpHeight
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, old.JumpingEnabled)
            FarmJumpSettings[humanoid] = nil
        end
    end
end

local function FarmAtExactHeight(enemyRoot, humanoid)
    local player = game:GetService("Players").LocalPlayer
    local character = player and player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root or not enemyRoot or not enemyRoot.Parent or not humanoid then return end

    SetFarmNoJump(humanoid, true)
    local targetCFrame = CFrame.new(enemyRoot.Position + Vector3.new(0, 17, 0))
    topos(targetCFrame)

    -- Chốt vị trí sau tween để không bị lực nhảy/va chạm đẩy cao lên.
    if root.Parent and enemyRoot.Parent then
        root.CFrame = targetCFrame
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        humanoid.Jump = false
    end
end

-- FARM AURA: chọn quái còn sống gần người chơi nhất và đứng cao hơn quái 17 studs.
local FarmAuraToggle = Main:AddToggle("FarmAura", {
    Title = "Farm Aura (Nearest Mob)",
    Default = false,
})
FarmAuraToggle:OnChanged(function(Value)
    getgenv().FarmAura = Value
end)

task.spawn(function()
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    while task.wait(0.12) do
        if getgenv().FarmAura and not getgenv().AutoFarm then
            pcall(function()
                local character = LocalPlayer.Character
                local playerRoot = character and character:FindFirstChild("HumanoidRootPart")
                local enemies = Workspace:FindFirstChild("Enemies")
                if not playerRoot or not enemies then
                    return
                end

                local nearest, nearestRoot, nearestHumanoid
                local nearestDistance = 1200

                for _, enemy in ipairs(enemies:GetChildren()) do
                    local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                    local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                    if humanoid and enemyRoot and humanoid.Health > 0 then
                        local distance = (enemyRoot.Position - playerRoot.Position).Magnitude
                        if distance < nearestDistance then
                            nearest = enemy
                            nearestRoot = enemyRoot
                            nearestHumanoid = humanoid
                            nearestDistance = distance
                        end
                    end
                end

                if nearest and nearest.Parent and nearestHumanoid.Health > 0 then
                    AutoHaki()
                    if getgenv().SelectWeapon then
                        EquipWeapon(getgenv().SelectWeapon)
                    end

                    -- Luôn giữ đúng 17 studs và khóa nhảy trong lúc farm.
                    local farmHumanoid = character:FindFirstChildOfClass("Humanoid")
                    FarmAtExactHeight(nearestRoot, farmHumanoid)

                    if type(AttackNoCoolDown) == "function" then
                        AttackNoCoolDown()
                    end
                end
            end)
        end
    end
end)

-- Submerged Island: chỉ kích hoạt phần di chuyển này khi đang bật Farm Level.
-- Không thay đổi các chế độ farm khác hoặc cơ chế topos/thoát đảo hiện có.
local SubmergedWorkerCFrame = CFrame.new(-16267.8, 25.4, 1373.2)
local function IsPlayerUnderwater()
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    return World3 and root ~= nil and root.Position.Y < -500
end

local function TravelToSubmergedForLevelFarm()
    if not getgenv().AutoFarm or not World3 or IsPlayerUnderwater() then
        return IsPlayerUnderwater()
    end

    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    topos(SubmergedWorkerCFrame)
    task.wait(0.25)

    character = Player.Character
    root = character and character:FindFirstChild("HumanoidRootPart")
    if not getgenv().AutoFarm or not root
        or (root.Position - SubmergedWorkerCFrame.Position).Magnitude > 80 then
        return false
    end

    local ok, err = pcall(function()
        ReplicatedStorage:WaitForChild("Modules")
            :WaitForChild("Net"):WaitForChild("RF/SubmarineWorkerSpeak")
            :InvokeServer("TravelToSubmergedIsland")
    end)
    if not ok then
        warn("[Hiru Hub] Không thể đi Submerged Island: " .. tostring(err))
        return false
    end

    for _ = 1, 20 do
        task.wait(0.25)
        if IsPlayerUnderwater() then
            return true
        end
        if not getgenv().AutoFarm then break end
    end
    return IsPlayerUnderwater()
end

spawn(function()
    while task.wait(0.25) do
        if getgenv().AutoFarm and FarmMode == "Farm Level" then
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not root then
                    getgenv().StartMagnet = false
                    return
                end

                -- Level 2600+ ở Sea 3: vào Submerged Island bằng NPC trước.
                -- Khi đã ở dưới đảo, tiếp tục dùng nguyên luồng nhận quest/đánh quái cũ.
                if World3 and player.Data and player.Data:FindFirstChild("Level")
                    and player.Data.Level.Value >= 2600 and not IsPlayerUnderwater() then
                    getgenv().StartMagnet = false
                    TravelToSubmergedForLevelFarm()
                    return
                end

                -- Cập nhật nhiệm vụ phù hợp với level hiện tại.
                CheckQuest()
                local targetMob = NameMon
                if not targetMob or not CFrameQuest or not CFrameMon then
                    getgenv().StartMagnet = false
                    return
                end

                local playerGui = player:FindFirstChild("PlayerGui")
                local mainQuest = playerGui and playerGui:FindFirstChild("Main")
                    and playerGui.Main:FindFirstChild("Quest")
                local questVisible = CheckQuest(targetMob)

                -- CHẶNG 1: Chưa có đúng nhiệm vụ thì bay về NPC và nhận nhiệm vụ.
                if not questVisible then
                    getgenv().StartMagnet = false

                    if mainQuest and mainQuest.Visible then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                        task.wait(0.25)
                    end

                    local distance = (root.Position - CFrameQuest.Position).Magnitude
                    topos(CFrameQuest)

                    -- Chỉ nhận nhiệm vụ khi đã tới gần NPC.
                    task.wait(0.2)
                    character = player.Character
                    root = character and character:FindFirstChild("HumanoidRootPart")
                    if root and (root.Position - CFrameQuest.Position).Magnitude <= 25
                        and not CheckQuest(targetMob) then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                            "StartQuest", NameQuest, LevelQuest
                        )
                        task.wait(0.6)
                    end
                    return
                end

                -- CHẶNG 2: Đã nhận đúng nhiệm vụ, bay tới khu vực quái.
                local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")
                local target = nil
                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                        if enemy.Name == Mon and humanoid and enemyRoot and humanoid.Health > 0 then
                            target = enemy
                            break
                        end
                    end
                end

                if target then
                    local humanoid = target:FindFirstChildOfClass("Humanoid")
                    local enemyRoot = target:FindFirstChild("HumanoidRootPart")
                    if humanoid and enemyRoot then
                        repeat
                            task.wait(0.1)
                            if not getgenv().AutoFarm or not CheckQuest(targetMob) then
                                break
                            end

                            AutoHaki()
                            EquipWeapon(getgenv().SelectWeapon)
                            PosMon = enemyRoot.CFrame
                            -- Đứng chính xác 17 studs phía trên quái, không nhảy lên.
                            local playerHumanoid = character:FindFirstChildOfClass("Humanoid")
                            FarmAtExactHeight(enemyRoot, playerHumanoid)
                            enemyRoot.CanCollide = false
                            humanoid.WalkSpeed = 0

                            local head = target:FindFirstChild("Head")
                            if head then
                                head.CanCollide = false
                            end

                            getgenv().StartMagnet = true
                            sethiddenproperty(player, "SimulationRadius", math.huge)
                        until not getgenv().AutoFarm
                            or not target.Parent
                            or humanoid.Health <= 0
                            or not CheckQuest(targetMob)
                    end
                else
                    -- Chưa thấy quái: tới điểm farm và đợi quái xuất hiện.
                    getgenv().StartMagnet = false
                    topos(CFrameMon)
                end

                -- CHẶNG 3: Khi nhiệm vụ hoàn tất, vòng lặp quay lại CHẶNG 1
                -- để bay về NPC nhận nhiệm vụ tiếp theo.
                if not CheckQuest(targetMob) then
                    getgenv().StartMagnet = false
                end
            end)
        else
            getgenv().StartMagnet = false
        end
    end
end)
local Bone = {
    ["Reborn Skeleton"] = CFrame.new(-8769.58984, 142.13063, 6055.27637),
    ["Living Zombie"] = CFrame.new(-10156.4531, 138.652481, 5964.5752),
    ["Demonic Soul"] = CFrame.new(-9525.17188, 172.13063, 6152.30566),
    ["Posessed Mummy"] = CFrame.new(-9570.88281, 5.81831884, 6187.86279)
}
spawn(function()
    while task.wait(0.2) do
        if getgenv().BonesBring then
            pcall(function()
                for _, v in ipairs(game.Workspace.Enemies:GetChildren()) do
                    if Bone[v.Name] and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                        v.HumanoidRootPart.CFrame = Bone[v.Name]
                        v.Head.CanCollide = false
                        v.Humanoid.Sit = false
                        v.Humanoid:ChangeState(11)
                        task.wait(0.1)
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Humanoid.JumpPower = 0
                        v.Humanoid.WalkSpeed = 0
                        local animator = v.Humanoid:FindFirstChild("Animator")
                        if animator then
                            animator:Destroy()
                        end
                        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                    end
                end
            end)
        end
    end
end)
--============================================================
-- 11. LOGIC FARM BONE VÀ FARM CAKE
--============================================================
--==================================================
-- FARM BONE / FARM CAKE (logic adapted from quantum.txt)
--==================================================

local FarmCombatOffset = CFrame.new(0, 25, 0)
local BoneMobNames = {
    ["Reborn Skeleton"] = true,
    ["Living Zombie"] = true,
    ["Demonic Soul"] = true,
    ["Posessed Mummy"] = true
}
local CakeMobNames = {
    ["Head Baker"] = true,
    ["Baking Staff"] = true,
    ["Cake Guard"] = true,
    ["Cookie Crafter"] = true
}

BonePos = CFrame.new(-9506.234375, 172.130615234375, 6117.0771484375)

local function GetFarmEnemy(nameList)
    local enemiesFolder = game:GetService("Workspace"):FindFirstChild("Enemies")
    if not enemiesFolder then
        return nil
    end

    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if nameList[enemy.Name] and humanoid and root and humanoid.Health > 0 then
            return enemy
        end
    end
    return nil
end

local function EnsureSpecialFarmQuest(questName, questIndex, questMob, questPosition)
    if CheckQuest(questMob) then
        return true
    end

    getgenv().StartMagnet = false
    getgenv().BonesBring = false
    getgenv().CakeBring = false

    -- Khi toggle tắt: không tự di chuyển tới NPC, không bỏ nhiệm vụ khác,
    -- và tuyệt đối không gọi StartQuest cho Farm Bone / Farm Cake.
    if not getgenv().AutoAcceptBoneCakeQuest then
        -- Toggle nhận nhiệm vụ đang tắt: bỏ qua bước NPC/StartQuest,
        -- nhưng vẫn cho phép vòng farm Bone/Cake tiếp tục đánh quái.
        return true
    end

    local player = game:GetService("Players").LocalPlayer
    local playerGui = player and player:FindFirstChild("PlayerGui")
    local mainGui = playerGui and playerGui:FindFirstChild("Main")
    local questGui = mainGui and mainGui:FindFirstChild("Quest")

    if questGui and questGui.Visible then
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
        end)
        task.wait(0.25)
    end

    local character = player and player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        return false
    end

    if (root.Position - questPosition.Position).Magnitude > 8 then
        topos(questPosition)
        return false
    end

    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
            "StartQuest",
            questName,
            questIndex
        )
    end)
    task.wait(0.35)
    return CheckQuest(questMob)
end

-- Bone: nhận HauntedQuest2 (Demonic Soul), đánh các quái trong BonesList,
-- nếu hết quái thì quay về khu vực chờ spawn.
spawn(function()
    while task.wait(0.15) do
        if FarmMode == "Farm Bone" and getgenv().AutoFarm and World3 then
            pcall(function()
                local questPosition = CFrame.new(-9517, 172, 6078)
                if not EnsureSpecialFarmQuest("HauntedQuest2", 1, "Demonic Soul", questPosition) then
                    return
                end

                local enemy = GetFarmEnemy(BoneMobNames)
                if enemy then
                    local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    getgenv().CakeBring = false

                    repeat
                        task.wait(0.1)
                        if not getgenv().AutoFarm or FarmMode ~= "Farm Bone" then
                            break
                        end
                        if not enemy.Parent or not humanoid or humanoid.Health <= 0 then
                            break
                        end

                        AutoHaki()
                        EquipWeapon(getgenv().SelectWeapon)
                        root.CanCollide = false
                        humanoid.WalkSpeed = 0
                        local head = enemy:FindFirstChild("Head")
                        if head then
                            head.CanCollide = false
                        end
                        getgenv().BonesBring = true
                        topos(root.CFrame * FarmCombatOffset)
                    until not getgenv().AutoFarm or FarmMode ~= "Farm Bone"
                        or not enemy.Parent or humanoid.Health <= 0

                    getgenv().BonesBring = false
                else
                    getgenv().BonesBring = false
                    UnEquipWeapon(getgenv().SelectWeapon)
                    topos(BonePos)
                end
            end)
        elseif FarmMode ~= "Farm Bone" then
            getgenv().BonesBring = false
        end
    end
end)

local Cake = {
    ["Cookie Crafter"] = CFrame.new(-2333.28052, 37.8239059, -12093.2861),
    ["Cake Guard"] = CFrame.new(-1575.56433, 37.8238907, -12416.2529),
    ["Baking Staff"] = CFrame.new(-1872.35742, 37.8239517, -12899.4248),
    ["Head Baker"] = CFrame.new(-2223.1416, 53.5283203, -12854.752)
}
spawn(function()
    while task.wait(0.2) do
        if getgenv().CakeBring then
            pcall(function()
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if Cake[v.Name] then
                        local targetCFrame = Cake[v.Name]
                        if targetCFrame then
                            v.HumanoidRootPart.CFrame = targetCFrame
                        end
                        v.Head.CanCollide = false
                        v.Humanoid.Sit = false
                        v.Humanoid:ChangeState(11)
                        task.wait(0.1)
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Humanoid.JumpPower = 0
                        v.Humanoid.WalkSpeed = 0
                        if v.Humanoid:FindFirstChild('Animator') then
                            v.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                    end
                end
            end)
        end
    end
end)
-- Cake: kiểm tra Cake Prince, gọi spawner theo chu kỳ,
-- nhận CakeQuest1 (Cookie Crafter), farm bốn loại quái Cake.
local lastCakeSpawnerCheck = 0
local lastCakeSpawnerText = ""

spawn(function()
    while task.wait(0.15) do
        if FarmMode == "Farm Katakuri" and getgenv().AutoFarm and World3 then
            pcall(function()
                local enemiesFolder = game:GetService("Workspace"):FindFirstChild("Enemies")
                local cakePrince = enemiesFolder and enemiesFolder:FindFirstChild("Cake Prince")

                -- Ưu tiên xử lý Cake Prince nếu boss đã xuất hiện.
                if cakePrince then
                    local bossHumanoid = cakePrince:FindFirstChildOfClass("Humanoid")
                    local bossRoot = cakePrince:FindFirstChild("HumanoidRootPart")
                    if bossHumanoid and bossRoot and bossHumanoid.Health > 0 then
                        getgenv().CakeBring = false
                        local player = game:GetService("Players").LocalPlayer
                        if player:GetAttribute("CurrentLocation") ~= "Dimensional Shift" then
                            topos(CFrame.new(-2168, 84, -12397))
                            task.wait(1)
                            return
                        end

                        repeat
                            task.wait(0.1)
                            if not getgenv().AutoFarm or FarmMode ~= "Farm Katakuri" then
                                break
                            end
                            if not cakePrince.Parent or bossHumanoid.Health <= 0 then
                                break
                            end

                            AutoHaki()
                            EquipWeapon(getgenv().SelectWeapon)
                            bossRoot.CanCollide = false
                            bossHumanoid.WalkSpeed = 0
                            topos(bossRoot.CFrame * FarmCombatOffset)
                        until not getgenv().AutoFarm or FarmMode ~= "Farm Katakuri"
                            or not cakePrince.Parent or bossHumanoid.Health <= 0
                        return
                    end
                end

                -- Hỏi trạng thái spawner mỗi 4 giây, tránh gọi remote liên tục.
                if tick() - lastCakeSpawnerCheck >= 4 then
                    lastCakeSpawnerCheck = tick()
                    local ok, result = pcall(function()
                        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                    end)
                    if ok and type(result) == "string" then
                        lastCakeSpawnerText = result
                    end
                end

                if string.find(lastCakeSpawnerText, "open the portal now", 1, true) then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                    end)
                    task.wait(1)
                    return
                end

                local questPosition = CFrame.new(-2021, 38, -12029)
                if not EnsureSpecialFarmQuest("CakeQuest1", 1, "Cookie Crafter", questPosition) then
                    return
                end

                local enemy = GetFarmEnemy(CakeMobNames)
                if enemy then
                    local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    getgenv().BonesBring = false

                    repeat
                        task.wait(0.1)
                        if not getgenv().AutoFarm or FarmMode ~= "Farm Katakuri" then
                            break
                        end
                        if not enemy.Parent or not humanoid or humanoid.Health <= 0 then
                            break
                        end

                        AutoHaki()
                        EquipWeapon(getgenv().SelectWeapon)
                        root.CanCollide = false
                        humanoid.WalkSpeed = 0
                        local head = enemy:FindFirstChild("Head")
                        if head then
                            head.CanCollide = false
                        end
                        getgenv().CakeBring = true
                        topos(root.CFrame * FarmCombatOffset)
                    until not getgenv().AutoFarm or FarmMode ~= "Farm Katakuri"
                        or not enemy.Parent or humanoid.Health <= 0

                    getgenv().CakeBring = false
                else
                    getgenv().CakeBring = false
                    UnEquipWeapon(getgenv().SelectWeapon)
                    topos(CFrame.new(-2304, 228, -12240))
                end
            end)
        elseif FarmMode ~= "Farm Katakuri" then
            getgenv().CakeBring = false
        end
    end
end)

--============================================================
-- 12. FARM MATERIAL VÀ MASTERY
--============================================================
Toggle = Main:AddToggle("Toggle", { Title = "Start Farm", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoFarm = Value
    StopTween(getgenv().AutoFarm)
end)

Main:AddParagraph({
    Title = "Farming Material",
    Content = string.rep("", 0)
})

local MaterialList = {}
if World1 then
    MaterialList = {"Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail"}
elseif World2 then
    MaterialList = {"Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet", "Magma Ore", "Vampire Fang"}
elseif World3 then
    MaterialList = {"Leather + Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk"}
end

MaterialListMon = Main:AddDropdown("MaterialListMon", {
    Title = "Select Material",
    Values = MaterialList,
    Multi = false
})
MaterialListMon:OnChanged(function(Value)
    getgenv().SelectMaterial = Value
    SelectMaterial = Value
end)

Toggle = Main:AddToggle("Toggle", {Title = "Farm Material", Default = false})
Toggle:OnChanged(function(Value)
    getgenv().AutoMaterial = Value
    if not Value then
        getgenv().StartMagnet = false
        StopTween()
    end
end)

-- Quantum-style material farm:
-- 1) Resolve the selected material to its enemy list for the current Sea.
-- 2) Find a living enemy from that list and attack it.
-- 3) If no enemy is alive, move to the spawn of the first enemy.
-- This script uses its existing MaterialMon data and movement/combat helpers.
local function QuantumMaterialGetEnemies(enemyNames)
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then
        return nil
    end

    for _, enemyName in ipairs(enemyNames) do
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            if enemy.Name == enemyName and humanoid and root and humanoid.Health > 0 then
                return enemy
            end
        end
    end

    return nil
end

local function QuantumMaterialMobsNextSpawn(enemyName)
    local worldOrigin = workspace:FindFirstChild("_WorldOrigin")
    local spawnFolder = worldOrigin and worldOrigin:FindFirstChild("EnemySpawns")
    local character = game:GetService("Players").LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not spawnFolder or not root then
        if MPos then
            topos(MPos)
        end
        return
    end

    local nearestSpawn, nearestDistance
    for _, spawnPoint in ipairs(spawnFolder:GetChildren()) do
        if string.find(spawnPoint.Name, enemyName, 1, true) then
            local distance = (root.Position - spawnPoint.Position).Magnitude
            if not nearestDistance or distance < nearestDistance then
                nearestSpawn = spawnPoint
                nearestDistance = distance
            end
        end
    end

    if nearestSpawn then
        topos(nearestSpawn.CFrame * CFrame.new(0, 25, 1))
    elseif MPos then
        topos(MPos)
    end
end

local function QuantumMaterialAttack(enemy)
    local humanoid = enemy and enemy:FindFirstChildOfClass("Humanoid")
    local root = enemy and enemy:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root or humanoid.Health <= 0 then
        return
    end

    repeat
        task.wait(0.1)
        if not getgenv().AutoMaterial then
            break
        end

        local character = game:GetService("Players").LocalPlayer.Character
        local playerRoot = character and character:FindFirstChild("HumanoidRootPart")
        if not playerRoot or not enemy.Parent or humanoid.Health <= 0 then
            break
        end

        AutoHaki()
        EquipWeapon(getgenv().SelectWeapon)
        root.CanCollide = false
        local head = enemy:FindFirstChild("Head")
        if head then
            head.CanCollide = false
        end
        humanoid.WalkSpeed = 0

        -- Keep the same above-target combat position used by the existing hub.
        topos(root.CFrame * CFrame.new(0, 25, 1))
        getgenv().StartMagnet = true
        MonFarm = enemy.Name
        PosMon = root.CFrame
    until not getgenv().AutoMaterial or not enemy.Parent or humanoid.Health <= 0

    UnEquipWeapon(getgenv().SelectWeapon)
end

task.spawn(function()
    while task.wait(0.15) do
        if getgenv().AutoMaterial then
            pcall(function()
                local selectedMaterial = getgenv().SelectMaterial
                if not selectedMaterial then
                    return
                end

                SelectMaterial = selectedMaterial
                MaterialMon()

                local enemyNames = MMon
                if type(enemyNames) ~= "table" or #enemyNames == 0 then
                    return
                end

                local enemy = QuantumMaterialGetEnemies(enemyNames)
                if enemy then
                    QuantumMaterialAttack(enemy)
                else
                    QuantumMaterialMobsNextSpawn(enemyNames[1])
                end
            end)
        end
    end
end)

Main:AddParagraph({
     Title = "Mastery Farm",
     Content = string.rep("", 0)
})
Slider = Main:AddSlider("Slider", {
     Title = "Select Health [ % ]",
     Default = 30,
     Min = 0,
     Max = 100,
     Rounding = 5,
     Callback = function(Value)
         getgenv().Kill_At = Value
    end
})
Dropdown = Main:AddDropdown("DropdownFarm", {
    Title = "Select Method Farm Mastery",
    Values = {"Blox Fruit", "Gun"},
    Multi = false,
})
Dropdown:SetValue("Blox Fruit")
Dropdown:OnChanged(function(Value)
FarmMode2 = Value
end)
spawn(function()
    while task.wait() do
        if FarmMode2 == "Blox Fruit" and getgenv().MasteryFarm then
            pcall(function()
                QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    UseSkill = false
                    Skillaimbot = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    UseSkill = false
                    CheckQuest()
                    repeat task.wait()
                        topos(CFrameQuest)
                    until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not getgenv().MasteryFarm
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                        wait(0.1)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        HealthMs = v.Humanoid.MaxHealth * getgenv().Kill_At / 100
                                        repeat task.wait()
                                            if v.Humanoid.Health <= HealthMs then
                                                AutoHaki()
                                                EquipWeapon(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value)
                                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                                                v.HumanoidRootPart.CanCollide = false
                                                PosMonMasteryFruit = v.HumanoidRootPart.CFrame
                                                MonFarm = v.Name
                                                PosMon = v.HumanoidRootPart.CFrame
                                                v.Humanoid.WalkSpeed = 0
                                                v.Head.CanCollide = false
                                                UseSkill = true
                                                Skillaimbot = true
                                            else
                                                UseSkill = false
                                                Skillaimbot = false
                                                AutoHaki()
                                                EquipWeapon(getgenv().SelectWeapon)
                                                MonFarm = v.Name
                                                PosMon = v.HumanoidRootPart.CFrame
                                                topos(v.HumanoidRootPart.CFrame * Pos)
                                                v.HumanoidRootPart.CanCollide = false
                                                PosMonMasteryFruit = v.HumanoidRootPart.CFrame
                                                v.Humanoid.WalkSpeed = 0
                                                v.Head.CanCollide = false
                                            end
                                            getgenv().StartMagnet = true
                                        until not getgenv().MasteryFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        UseSkill = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        topos(CFrameMon)
                        UseSkill = false
                        Skillaimbot = false
                        Mob = game:GetService("ReplicatedStorage"):FindFirstChild(Mon)

                        if Mob then
                            topos(Mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 10))
                        else
                            if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame.Y <= 1 then
                                game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true
                                task.wait()
                                game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = false
                            end
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while task.wait() do
        if UseSkill then
            pcall(function()
                CheckQuest()
                for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value) then
                        MasBF = game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].Level.Value
                    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value) then
                        MasBF = game:GetService("Players").LocalPlayer.Backpack[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].Level.Value
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value) then
                        if getgenv().SkillZ then
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
                        end
                        if getgenv().SkillX then
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
                        end
                        if getgenv().SkillC then
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "C", false, game)
                        end
                        if getgenv().SkillV then
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "V", false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "V", false, game)
                        end
                        if getgenv().SkillF then
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        pcall(function()
            if UseSkill then
                for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Notifications:GetChildren()) do
                    if v.Name == "NotificationTemplate" then
                        if string.find(v.Text, "Skill locked!") then
                            v:Destroy()
                        end
                    end
                end
            end
        end)
    end)
end)
spawn(function()
    pcall(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if UseSkill then
                local args = {
                    [1] = PosMonMasteryFruit.Position
                }
                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].RemoteEvent:FireServer(unpack(args))
            end
        end)
    end)
end)    
spawn(function()
    pcall(function()
        while task.wait() do
            if FarmMode2 == "Gun" and getgenv().MasteryFarm then
                QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then                      
                    Skillaimbot = false          
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    CheckQuest()
                        topos(CFrameQuest)
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                        task.wait(1.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        pcall(function()
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == Mon then
                                    repeat task.wait()
                                        if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                            HealthMin = v.Humanoid.MaxHealth * getgenv().Kill_At/100
                                            if v.Humanoid.Health <= HealthMin then
                                                EquipWeapon(SelectWeaponGun)
                                                Skillaimbot = true
                                                AimSkill = v.Engine.CFrame * CFrame.new(0, -15, 0)
                                                AimBotSkillPosition = AimSkill.Position
                                                MonFarm = v.Name                
                                                PosMon = v.HumanoidRootPart.CFrame
                                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0,0,10))
                                                v.Humanoid.WalkSpeed = 0
                                                v.HumanoidRootPart.CanCollide = false
                                                v.HumanoidRootPart.Size = Vector3.new(2,2,1)
                                                v.Head.CanCollide = false                                                
                                                local args = {
                                                    [1] = v.HumanoidRootPart.Position,
                                                    [2] = v.HumanoidRootPart
                                                }
                                                game:GetService("Players").LocalPlayer.Character[SelectWeaponGun].RemoteFunctionShoot:InvokeServer(unpack(args))
                                                task.wait(.1)
                                                game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                                                game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                                                task.wait(.1)
                                                game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                                                game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                                            else
                                                AutoHaki()
                                                EquipWeapon(getgenv().SelectWeapon)
                                                MonFarm = v.Name                
                                                PosMon = v.HumanoidRootPart.CFrame
                                                v.Humanoid.WalkSpeed = 0
                                                v.HumanoidRootPart.CanCollide = false
                                                v.Head.CanCollide = false    
                                                topos(v.HumanoidRootPart.CFrame * Pos)
                                                game:GetService'VirtualUser':CaptureController()
                                                game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                            end
                                            getgenv().StartMagnet = true 
                                            PosMonMasteryGun = v.HumanoidRootPart.CFrame
                                        else
                                            getgenv().StartMagnet = true 
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                        end
                                    until v.Humanoid.Health <= 0 or not getgenv().MasteryFarm or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                end
                            end
                        end)
                    else
                       topos(CFrameMon)
                        Mob = game:GetService("ReplicatedStorage"):FindFirstChild(Mon) 
                        if Mob then
                            topos(Mob.HumanoidRootPart.CFrame * CFrame.new(0,0,10))
                        else
                            if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame.Y <= 1 then
                                game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true
                                task.wait()
                                game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = false
                            end
                        end
                    end 
                end
            end
        end
    end)
end)
spawn(function()
    pcall(function()
        if getgenv().MasteryFarm then
            while task.wait() do
                for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA("Tool") then
                        if v:FindFirstChild("RemoteFunctionShoot") then
                            SelectWeaponGun = v.Name
                        end
                    end
                end
            end
        end
    end)
end)
local plr = game:GetService("Players").LocalPlayer
spawn(function()
     pcall(function()
         while task.wait() do
            for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do  
                if v:IsA("Tool") then
                    if v:FindFirstChild("RemoteFunctionShoot") then 
                        SelectWeaponGun = v.Name
                    end
                end
            end
        end
    end)
end)
Toggle = Main:AddToggle("Toggle", { Title = "Auto Farm Mastery", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().MasteryFarm = Value
    StopTween(getgenv().MasteryFarm)
end)
--============================================================
-- 13. TAB STACK FARM
--============================================================
Stack = Window:AddTab({ Title = "Tab Stack Farm", Icon = "" })
-- Teleport To Fruit đã được chuyển sang Tab Farming Other.\nToggle = Stack:AddToggle("Toggle", {Title = "Auto New World", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoNewWorld = Value
    StopTween(getgenv().AutoNewWorld)
end)
spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoNewWorld and World1 then
            spawn(function()
                local player = game:GetService("Players").LocalPlayer
                local workspace = game:GetService("Workspace")
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local myLevel = player.Data.Level.Value
                if myLevel >= 700 and World1 then
                    local iceDoor = workspace.Map.Ice.Door
                    if iceDoor.CanCollide == false and iceDoor.Transparency == 1 then
                        local cframe1 = CFrame.new(4849.29883, 5.65138149, 719.611877)
                        repeat
                            topos(cframe1)
                            task.wait(0.1)
                        until (cframe1.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 3 or not getgenv().AutoNewWorld
                        task.wait(1.1)
                        replicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
                        task.wait(0.1)
                        EquipWeapon("Key")
                        local targetCFrame = CFrame.new(1347.7124, 37.3751602, -1325.6488)
                        repeat
                            topos(targetCFrame)
                            task.wait(0.1)
                        until (targetCFrame.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 3 or not getgenv().AutoNewWorld
                        task.wait(0.1)
                    else
                        if workspace.Enemies:FindFirstChild("Ice Admiral [Lv. 700] [Boss]") then
                            for _, v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == "Ice Admiral" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                    local oldCFrameSecond = v.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait(0.05)
                                        AutoHaki()
                                        EquipWeapon(getgenv().SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false
                                        v.HumanoidRootPart.CFrame = oldCFrameSecond
                                        topos(v.HumanoidRootPart.CFrame * Pos)
                                    until not getgenv().AutoNewWorld or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        else
                            if replicatedStorage:FindFirstChild("Ice Admiral") then
                                topos(replicatedStorage:FindFirstChild("Ice Admiral").HumanoidRootPart.CFrame * CFrame.new(5, 10, 7))
                            else
                                replicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
                            end
                        end
                    end
                end
            end)
        end
    end
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Auto Third World", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoThirdSea = Value
    StopTween(getgenv().AutoThirdSea)
end)
spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoThirdSea and World2 then
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local workspaceEnemies = game:GetService("Workspace").Enemies
                if player.Data.Level.Value >= 1500 and World2 then
                    getgenv().AutoFarm = false
                    if replicatedStorage.Remotes["CommF_"]:InvokeServer("ZQuestProgress", "General") == 0 then
                        topos(CFrame.new(-1926.322, 12.82, 1738.309))                        
                        if (CFrame.new(-1926.322, 12.82, 1738.309).Position - player.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                            task.wait(1.1)
                            replicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                        end
                        task.wait(1.3)
                        if workspaceEnemies:FindFirstChild("rip_indra [Lv. 1500] [Boss]") then
                            for _, v in pairs(workspaceEnemies:GetChildren()) do
                                if v.Name == "rip_indra" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    local oldCFrameThird = v.HumanoidRootPart.CFrame                                    
                                    repeat
                                        task.wait(0.05)
                                        AutoHaki()
                                        EquipWeapon(getgenv().SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * Pos)
                                        v.HumanoidRootPart.CFrame = oldCFrameThird                                              
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        replicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")                                        
                                    until not getgenv().AutoThirdSea or v.Humanoid.Health <= 0 or not v.Parent
                                end
                            end
                        elseif not workspaceEnemies:FindFirstChild("rip_indra") and 
                               (CFrame.new(-26880.934, 22.849, 473.19).Position - player.Character.HumanoidRootPart.Position).Magnitude <= 1000 then
                            topos(CFrame.new(-26880.934, 22.849, 473.19))
                        end
                    end
                end
            end)
        end
    end
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Auto Factory", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoFactory = Value
    StopTween(getgenv().AutoFactory)
end)
task.spawn(function()
    while task.wait(0.1) do
        if not getgenv().AutoFactory or not World2 then
            continue
        end
        local enemies = game:GetService("Workspace").Enemies
        local coreEnemy = enemies:FindFirstChild("Core")
        if coreEnemy and coreEnemy.Humanoid.Health > 0 then
            repeat
                task.wait(0.1)
                AutoHaki()
                EquipWeapon(getgenv().SelectWeapon)
                topos(coreEnemy.HumanoidRootPart.CFrame)
            until coreEnemy.Humanoid.Health <= 0 or not getgenv().AutoFactory
        else
            topos(CFrame.new(448.46756, 199.356781, -441.389252))
        end
    end
end)
Toggle = Stack:AddToggle("Toggle", { Title = "Auto Pirate Raid", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoPirateRaid = Value
    StopTween(getgenv().AutoPirateRaid)
end)
task.spawn(function()
    while task.wait(0.1) do
        if not getgenv().AutoPirateRaid or not World3 then
            continue
        end
        pcall(function()
            local CFrameBoss = CFrame.new(-5496.17432, 313.768921, -2841.53027)
            local player = game.Players.LocalPlayer
            local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")            
            if not humanoidRootPart then return end
            local distanceToBoss = (CFrame.new(-5539.311, 313.801, -2972.372).Position - humanoidRootPart.Position).Magnitude
            if distanceToBoss <= 500 then
                for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if getgenv().AutoPirateRaid and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local enemyDistance = (enemy.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                        if enemyDistance < 2000 then
                            repeat task.wait(0.1)
                                AutoHaki()
                                EquipWeapon(getgenv().SelectWeapon)
                                enemy.HumanoidRootPart.CanCollide = false
                                topos(enemy.HumanoidRootPart.CFrame * Pos)
                                getgenv().StartMagnet = true
                            until enemy.Humanoid.Health <= 0 or not enemy.Parent or not getgenv().AutoPirateRaid
                        end
                    end
                end
            else
                UnEquipWeapon(getgenv().SelectWeapon)
                topos(CFrame.new(-5122, 315, -2963))
            end
        end)
    end
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Auto Elite Hunter", Default = false })
Toggle:OnChanged(function(Value)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
    getgenv().AutoEliteHunter = Value
    StopTween(getgenv().AutoEliteHunter)
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Hop Server Elite Hunter", Description = "Find New Elite Hunter Server", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoEliteHunterHop = Value
end)
spawn(function()
    while task.wait(0.3) do
        if getgenv().AutoEliteHunter and World3 then
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                local playerGui = player:FindFirstChild("PlayerGui")
                local mainGui = playerGui and playerGui:FindFirstChild("Main")
                local questGui = mainGui and mainGui:FindFirstChild("Quest")
                local titleObject = questGui and questGui:FindFirstChild("Container")
                    and questGui.Container:FindFirstChild("QuestTitle")
                    and questGui.Container.QuestTitle:FindFirstChild("Title")
                local questTitle = titleObject and titleObject.Text or ""
                local eliteNames = {"Diablo", "Deandre", "Urban"}
                local trackedEliteQuest = false
                for _, eliteName in ipairs(eliteNames) do
                    if CheckQuest(eliteName) then
                        trackedEliteQuest = true
                        break
                    end
                end
                local questActive = (questGui and questGui.Visible == true) or trackedEliteQuest
                if questActive then
                    local foundEnemy = false                    
                    for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if table.find(eliteNames, enemy.Name) and 
                           enemy:FindFirstChild("Humanoid") and 
                           enemy:FindFirstChild("HumanoidRootPart") and 
                           enemy.Humanoid.Health > 0 then                            
                            foundEnemy = true
                            repeat
                                task.wait(0.2)
                                AutoHaki()
                                EquipWeapon(getgenv().SelectWeapon)
                                if enemy:FindFirstChild("HumanoidRootPart") then
                                    enemy.HumanoidRootPart.CanCollide = false
                                    enemy.Humanoid.WalkSpeed = 0
                                    topos(enemy.HumanoidRootPart.CFrame * Pos)
                                end
                            until not getgenv().AutoEliteHunter or enemy.Humanoid.Health <= 0 or not enemy.Parent
                            break
                        end
                    end
                    if not foundEnemy then
                        for _, name in pairs(eliteNames) do
                            local enemy = game:GetService("ReplicatedStorage"):FindFirstChild(name)
                            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                                topos(enemy.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                                break
                            end
                        end
                    end
                else
                    local response = game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("EliteHunter")
                    if getgenv().AutoEliteHunterHop and response == "I don't have anything for you right now. Come back later." then
                        Hop()
                    end
                end
            end)
        end
    end
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Auto Touch Pad Haki", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoTouchPadHaki = Value
    StopTween(getgenv().AutoTouchPadHaki)
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            if getgenv().AutoTouchPadHaki and World3 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("activateColor", "Winter Sky")
                task.wait(0.5)
                local target1 = CFrame.new(-5420.16602, 1084.9657, -2666.8208)
                repeat
                    topos(target1)
                    task.wait(0.2)
                until getgenv().StopTween == true or getgenv().AutoTouchPadHaki == false or
                    (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - target1.Position).Magnitude <= 10
                task.wait(0.5)                
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("activateColor", "Pure Red")
                task.wait(0.5)
                local target2 = CFrame.new(-5414.41357, 309.865753, -2212.45776)
                repeat
                    topos(target2)
                    task.wait(0.2)
                until getgenv().StopTween == true or getgenv().AutoTouchPadHaki == false or
                    (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - target2.Position).Magnitude <= 10
                task.wait(0.5)                
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("activateColor", "Snow White")
                task.wait(0.5)
                local target3 = CFrame.new(-4971.47559, 331.565765, -3720.02954)
                repeat
                    topos(target3)
                    task.wait(0.2)
                until getgenv().StopTween == true or getgenv().AutoTouchPadHaki == false or
                    (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - target3.Position).Magnitude <= 10
                task.wait(0.5)               
                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 600))
                task.wait(1)
                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 600))
            end
        end)
    end
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Auto Rip Indra", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoRipIndra = Value
    StopTween(getgenv().AutoRipIndra)
end)
spawn(function()
    pcall(function()
        while task.wait(1) do
            if getgenv().AutoRipIndra and World3 then
                local enemies = game:GetService("Workspace").Enemies
                local player = game:GetService("Players").LocalPlayer                
                if enemies:FindFirstChild("rip_indra True Form") or enemies:FindFirstChild("rip_indra") then
                    for _, v in pairs(enemies:GetChildren()) do
                        if (v.Name == "rip_indra True Form" or v.Name == "rip_indra") and v.Humanoid.Health > 0 and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            repeat
                                task.wait(0.3)
                                pcall(function()
                                    AutoHaki()
                                    EquipWeapon(getgenv().SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    topos(v.HumanoidRootPart.CFrame * Pos)
                                end)
                            until getgenv().AutoRipIndra == false or v.Humanoid.Health <= 0
                        end
                    end
                elseif player.Backpack:FindFirstChild("God's Chalice") or player.Character:FindFirstChild("God's Chalice") then
                    repeat
                        task.wait(0.3)
                        topos(CFrame.new(-5563.75048828125, 320.4276123046875, -2662.509521484375))
                        EquipWeapon("God's Chalice")
                    until not (player.Backpack:FindFirstChild("God's Chalice") or player.Character:FindFirstChild("God's Chalice"))
                elseif game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") then
                    local ripIndraTrueForm = game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form")
                    topos(ripIndraTrueForm.HumanoidRootPart.CFrame * Pos)
                end
            end
        end
    end)
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Auto Soul Reaper", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoSoulReaper = Value
    StopTween(getgenv().AutoSoulReaper)
end)
spawn(function()
    while true do
        if getgenv().AutoSoulReaper and World3 then
            pcall(function()
                local workspaceEnemies = game:GetService("Workspace").Enemies
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local player = game:GetService("Players").LocalPlayer
                local backpack = player.Backpack
                local character = player.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if workspaceEnemies:FindFirstChild("Soul Reaper") then
                    for _, v in pairs(workspaceEnemies:GetChildren()) do
                        if string.find(v.Name, "Soul Reaper") then
                            repeat 
                                task.wait(0.1)
                                AutoHaki()
                                EquipWeapon(getgenv().SelectWeapon)
                                topos(v.HumanoidRootPart.CFrame * Pos)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.Transparency = 1
                            until v.Humanoid.Health <= 0 or not getgenv().AutoSoulReaper
                        end
                    end
                elseif backpack:FindFirstChild("Hallow Essence") or character:FindFirstChild("Hallow Essence") then
                    local targetPosition = CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)
                    repeat
                        topos(targetPosition)
                        task.wait(0.1)
                    until (targetPosition.Position - humanoidRootPart.Position).Magnitude <= 8
                    EquipWeapon("Hallow Essence")
                else
                    local soulReaper = replicatedStorage:FindFirstChild("Soul Reaper")
                    if soulReaper then
                        topos(soulReaper.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Auto Pray", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoPray = Value
    StopTween(getgenv().AutoPray)
end)
spawn(function()
    while wait(0.5) do
        if getgenv().AutoPray and World3 then    
            local targetPos = CFrame.new(-8652.99707, 143.450119, 6170.50879)
            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - targetPos.Position).magnitude > 5 then
                topos(targetPos)
                wait(0.5)
            end
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent", 1)
            end)
        end
    end
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Auto Try Luck", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoTryLuck = Value
    StopTween(getgenv().AutoTryLuck)  
end)
spawn(function()
    while wait(0.5) do
        if getgenv().AutoTryLuck and World3 then    
            local targetPos = CFrame.new(-8652.99707, 143.450119, 6170.50879)
            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - targetPos.Position).magnitude > 5 then
                topos(targetPos)
                wait(0.5)
            end
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
        end
    end
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Auto Dough King", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoDoughKing = Value
    StopTween(getgenv().AutoDoughKing)
end)
spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if getgenv().AutoDoughKing and StartCakegetgenv().StartMagnet and 
                   (v.Name == "Cookie Crafter" or v.Name == "Cake Guard" or v.Name == "Baking Staff" or v.Name == "Head Baker") and 
                   (v.HumanoidRootPart.Position - POSCAKE.Position).magnitude <= 300 then
                    v.HumanoidRootPart.CFrame = POSCAKE
                    v.HumanoidRootPart.CanCollide = false
                    if v.Humanoid:FindFirstChild("Animator") then
                        v.Humanoid.Animator:Destroy()
                    end
                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                end
            end
        end)
    end)
end)
spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoDoughKing and World3 then
            pcall(function()
                if game.Players.LocalPlayer.Backpack:FindFirstChild("God's Chalice") or 
                   game.Players.LocalPlayer.Character:FindFirstChild("God's Chalice") then
                    if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SweetChaliceNpc"), "Where") then
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "Notification",
                            Text = "Not Have Enough Material",
                            Icon = "http://www.roblox.com/asset/?id=",
                            Duration = 2.5
                        })
                    else
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SweetChaliceNpc")
                    end
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Sweet Chalice") or 
                       game.Players.LocalPlayer.Character:FindFirstChild("Sweet Chalice") then
                    if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"), 
                                   "Do you want to open the portal now?") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                    else
                        if game.Workspace.Enemies:FindFirstChild("Baking Staff") or 
                           game.Workspace.Enemies:FindFirstChild("Head Baker") or 
                           game.Workspace.Enemies:FindFirstChild("Cake Guard") or 
                           game.Workspace.Enemies:FindFirstChild("Cookie Crafter") then
                            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do  
                                if (v.Name == "Baking Staff" or v.Name == "Head Baker" or 
                                    v.Name == "Cake Guard" or v.Name == "Cookie Crafter") and 
                                    v.Humanoid.Health > 0 then
                                    repeat
                                        task.wait(0.05)
                                        AutoHaki()
                                        EquipWeapon(getgenv().SelectWeapon)
                                        StartCakegetgenv().StartMagnet = true
                                        POSCAKE = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * Pos)
                                    until getgenv().AutoDoughKing == false or 
                                          game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince") or 
                                          not v.Parent or 
                                          v.Humanoid.Health <= 0
                                end
                            end
                        else
                            StartCakegetgenv().StartMagnet = false
                            topos(CFrame.new(-1820.063, 210.748, -12297.496))
                        end
                    end
                elseif game.ReplicatedStorage:FindFirstChild("Dough King") or 
                       game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do 
                            if v.Name == "Dough King" then
                                repeat
                                    task.wait(0.05)
                                    AutoHaki()
                                    EquipWeapon(getgenv().SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    topos(v.HumanoidRootPart.CFrame * Pos)
                                until getgenv().AutoDoughKing == false or 
                                      not v.Parent or 
                                      v.Humanoid.Health <= 0
                            end    
                        end    
                    else
                        topos(CFrame.new(-2009.280, 4532.972, -14937.308))
                    end
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Red Key") or 
                       game.Players.LocalPlayer.Character:FindFirstChild("Red Key") then
                    local args = {
                        [1] = "CakeScientist",
                        [2] = "Check"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                else
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                        if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Diablo") or 
                           string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Deandre") or 
                           string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Urban") then
                            if game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Urban") then
                                for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v.Name == "Diablo" or v.Name == "Deandre" or v.Name == "Urban" then
                                        if v:FindFirstChild("Humanoid") and 
                                           v:FindFirstChild("HumanoidRootPart") and 
                                           v.Humanoid.Health > 0 then
                                            repeat
                                                task.wait(0.05)
                                                AutoHaki()
                                                EquipWeapon(getgenv().SelectWeapon)    
                                                v.HumanoidRootPart.CanCollide = false
                                                v.Humanoid.WalkSpeed = 0
                                                topos(v.HumanoidRootPart.CFrame * Pos)                                                    
                                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                            until getgenv().AutoDoughKing == false or 
                                                  v.Humanoid.Health <= 0 or 
                                                  not v.Parent or 
                                                  game.Players.LocalPlayer.Backpack:FindFirstChild("God's Chalice") or 
                                                  game.Players.LocalPlayer.Character:FindFirstChild("God's Chalice")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
Toggle = Stack:AddToggle("Toggle", {Title = "Auto Darkbeard", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoDarkbeard = Value
    StopTween(getgenv().AutoDarkbeard)
end)
spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoDarkbeard and World2 then
            pcall(function()
                local enemies = game:GetService("Workspace").Enemies
                local player = game:GetService("Players").LocalPlayer
                if enemies:FindFirstChild("Darkbeard") then
                    for _, v in pairs(enemies:GetChildren()) do
                        if v.Name == "Darkbeard" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait(0.05)
                                AutoHaki()
                                EquipWeapon(getgenv().SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0           
                                topos(v.HumanoidRootPart.CFrame * Pos)
                            until not getgenv().AutoDarkbeard or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                elseif player.Backpack:FindFirstChild("Fist of Darkness") or player.Character:FindFirstChild("Fist of Darkness") then
                    repeat
                        task.wait(0.1)
                        topos(CFrame.new(3778.584, 15.791, -3499.404))
                        EquipWeapon("Fist of Darkness")
                    until not getgenv().AutoDarkbeard
                elseif game:GetService("ReplicatedStorage"):FindFirstChild("Darkbeard") then
                    topos(game:GetService("ReplicatedStorage"):FindFirstChild("Darkbeard").HumanoidRootPart.CFrame * Pos)
                end
            end)
        end
    end
end)
--============================================================
-- 14. TAB FARMING OTHER
--============================================================
Other = Window:AddTab({ Title = "Tab Farming Other", Icon = "" })
Other:AddParagraph({
    Title = "Farm Chest",
    Content = "Tự tìm rương gần nhất và tween đến rương."
})
local ToggleChest = Other:AddToggle("ToggleChest", {Title = "Auto Chest", Default = false })
ToggleChest:OnChanged(function(Value)
    getgenv().AutoFarmChest = Value
    if not Value then StopTween() end
end)

task.spawn(function()
    local CollectionService = game:GetService("CollectionService")
    while task.wait(0.2) do
        if getgenv().AutoFarmChest then
            pcall(function()
                local character = Player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local closest, closestDistance = nil, math.huge
                for _, chest in ipairs(CollectionService:GetTagged("_ChestTagged")) do
                    if chest:IsA("BasePart") and chest.Parent and chest:GetAttribute("IsDisabled") ~= true then
                        local distance = (chest.Position - root.Position).Magnitude
                        if distance < closestDistance then
                            closest, closestDistance = chest, distance
                        end
                    end
                end
                if closest then topos(closest.CFrame * CFrame.new(0, 3, 2)) end
            end)
        end
    end
end)

local StopChestToggle = Other:AddToggle("StopChestToggle", {
    Title = "Stop Chest If Have God's Chalice / Fist",
    Default = false
})
StopChestToggle:OnChanged(function(Value)
    getgenv().StopChest = Value
end)
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().StopChest and getgenv().AutoFarmChest then
            local backpack, character = Player:FindFirstChild("Backpack"), Player.Character
            local names = {"God's Chalice", "Fist of Darkness", "Sweet Chalice"}
            for _, name in ipairs(names) do
                if (backpack and backpack:FindFirstChild(name)) or (character and character:FindFirstChild(name)) then
                    getgenv().AutoFarmChest = false
                    ToggleChest:Set(false)
                    StopTween()
                    break
                end
            end
        end
    end
end)

Other:AddParagraph({
    Title = "Teleport Fruit",
    Content = "Chỉ tween đến trái ác quỷ đang xuất hiện trong Workspace."
})
local FruitToggle = Other:AddToggle("FruitToggle", {Title = "Teleport To Fruit", Default = false})
FruitToggle:OnChanged(function(Value)
    getgenv().TeleportToFruit = Value
    if not Value then StopTween() end
end)
task.spawn(function()
    while task.wait(0.25) do
        if getgenv().TeleportToFruit then
            pcall(function()
                local character = Player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local closest, closestDistance = nil, math.huge
                for _, fruit in ipairs(workspace:GetChildren()) do
                    if fruit:IsA("Model") and fruit.Name:find("Fruit") then
                        local handle = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            local distance = (handle.Position - root.Position).Magnitude
                            if distance < closestDistance then
                                closest, closestDistance = handle, distance
                            end
                        end
                    end
                end
                if closest then topos(closest.CFrame) end
            end)
        end
    end
end)

Other:AddParagraph({
    Title = "Berry Farm",
    Content = "Dò BerryBush, tween đến Berry và gọi RF/ClaimBerry khi ở gần."
})
local BerryToggle = Other:AddToggle("BerryToggle", {Title = "Auto Collect Berries", Default = false})
BerryToggle:OnChanged(function(Value)
    getgenv().AutoBerrySafe = Value
    if not Value then StopTween() end
end)
task.spawn(function()
    local CollectionService = game:GetService("CollectionService")
    local Net = ReplicatedStorage:WaitForChild("Remotes")
    while task.wait(0.25) do
        if getgenv().AutoBerrySafe then
            pcall(function()
                local character = Player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local bestParent, bestKey, bestCFrame
                local bestDistance = math.huge
                for _, bush in ipairs(CollectionService:GetTagged("BerryBush")) do
                    local parent = bush.Parent
                    if parent and parent:IsDescendantOf(workspace) then
                        local baseCFrame = parent:GetAttribute("CFrame")
                        if typeof(baseCFrame) ~= "CFrame" and parent:IsA("Model") then
                            baseCFrame = parent:GetPivot()
                        end
                        if typeof(baseCFrame) == "CFrame" then
                            for key, value in pairs(bush:GetAttributes()) do
                                if key:sub(1, 12) == "_BerryCFrame" and type(value) == "string" and #value > 0 then
                                    local offset = parent:GetAttribute(key)
                                    if typeof(offset) == "CFrame" then
                                        local berryCFrame = baseCFrame:ToWorldSpace(offset)
                                        local distance = (berryCFrame.Position - root.Position).Magnitude
                                        if distance < bestDistance then
                                            bestParent, bestKey, bestCFrame = parent, key, berryCFrame
                                            bestDistance = distance
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if bestParent and bestKey and bestCFrame then
                    topos(bestCFrame)
                    if (bestCFrame.Position - root.Position).Magnitude <= 60 then
                        local claim = Net:FindFirstChild("RF/ClaimBerry")
                        if claim then claim:InvokeServer(bestParent.Name, bestKey) end
                    end
                end
            end)
        end
    end
end)
Other:AddParagraph({
     Title = "Farm Observation",
     Content = string.rep("", 0)
})
ObservationRange = Other:AddParagraph({
    Title = "Observation Level",
    Content = ""
})
spawn(function()
    local lastValue = game:GetService("Players").LocalPlayer.VisionRadius.Value
    while wait(0.1) do
        pcall(function()
            local currentValue = game:GetService("Players").LocalPlayer.VisionRadius.Value
            if currentValue ~= lastValue then
                ObservationRange:SetDesc("Observation Range Level: " .. math.floor(currentValue))
                lastValue = currentValue
            end
        end)
    end
end)
Toggle = Other:AddToggle("Toggle", {Title = "Auto UP Observation V2", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoObservationHakiV2 = Value
    StopTween(getgenv().AutoObservationHakiV2)
end)    
spawn(function()
    local lastUpdateTime = tick()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().AutoObservationHakiV2 and World3 then
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    if tick() - lastUpdateTime >= 1 then
                        topos(CFrame.new(-12444.78515625, 332.40396118164, -7673.1806640625))
                        lastUpdateTime = tick()
                    end
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                    task.wait(1)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
                else
                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Defeat 50 Forest Pirates") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Forest Pirate") then
                            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Forest Pirate" then
                                    repeat
                                        if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                                        end
                                        EquipWeapon(getgenv().SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * Pos)
                                        PosHee = v.HumanoidRootPart.CFrame
                                        v.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    until getgenv().AutoObservationHakiV2 == false or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text == "Defeat Captain Elephant (0/1)" then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant") then
                            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Captain Elephant" then
                                    repeat
                                        if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                                        end
                                        EquipWeapon(getgenv().SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * Pos)
                                        if sethiddenproperty then
                                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                        end
                                        v.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    until getgenv().AutoObservationHakiV2 == false or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    end
                end
                if game.Players.LocalPlayer.Backpack:FindFirstChild("Banana") and 
                    game.Players.LocalPlayer.Backpack:FindFirstChild("Apple") and 
                    game.Players.LocalPlayer.Backpack:FindFirstChild("Pineapple") then
                    if tick() - lastUpdateTime >= 1 then
                        topos(CFrame.new(-12444.78515625, 332.40396118164, -7673.1806640625))
                        lastUpdateTime = tick()
                    end
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Fruit Bowl") or 
                        game.Players.LocalPlayer.Character:FindFirstChild("Fruit Bowl") then
                    if tick() - lastUpdateTime >= 1 then
                        topos(CFrame.new(-10920.125, 624.20275878906, -10266.995117188))
                        lastUpdateTime = tick()
                    end
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk2", "Start")
                    task.wait(1)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk2", "Buy")
                end
            end
        end)
    end
end)
spawn(function()
    local lastUpdate = tick()
    while true do
        task.wait(0.1)
        pcall(function()
            if getgenv().AutoObservationHakiV2 and World3 then
                if sethiddenproperty then
                    if tick() - lastUpdate >= 1 then
                        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                        lastUpdate = tick()
                    end
                end
            end
        end)
    end
end)
spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            if getgenv().AutoObservationHakiV2 and World3 then
                local character = game:GetService("Players").LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    local humanoid = character.Humanoid
                    if humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
                        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    end
                end
            end
        end)
    end)
end)
spawn(function()
    pcall(function()
        game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(0.1)
            if getgenv().AutoObservationHakiV2 and getgenv().StartMagnet then
                local enemies = game.Workspace.Enemies:GetChildren()
                for i, v in ipairs(enemies) do
                    if v.Name == "Forest Pirate" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local humanoidRootPart = v.HumanoidRootPart
                        if humanoidRootPart.CanCollide ~= false then
                            humanoidRootPart.CanCollide = false
                        end
                        if humanoidRootPart.Size ~= Vector3.new(50, 50, 50) then
                            humanoidRootPart.Size = Vector3.new(50, 50, 50)
                        end
                        if humanoidRootPart.CFrame ~= PosHee then
                            humanoidRootPart.CFrame = PosHee
                        end
                    end
                end
            end
        end)
    end)
end)
spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            if getgenv().AutoObservationHakiV2 and getgenv().StartMagnet then
                CheckQuest()
                local enemies = game.Workspace.Enemies:GetChildren()
                for i, v in ipairs(enemies) do
                    if v.Name == Ms and v:FindFirstChild("Humanoid") then
                        local humanoid = v.Humanoid
                        if humanoid.Health > 0 then
                            humanoid:ChangeState(11)
                            task.wait(0.1)
                            humanoid:ChangeState(14)
                        end
                    end
                end
            end
        end)
    end)
end)
Toggle = Other:AddToggle("Toggle", {Title = "Farm Observation", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoObservation = Value
    StopTween(getgenv().AutoObservation)
end)
spawn(function()
    pcall(function()
        while task.wait(0.1) do
            if getgenv().AutoObservation then
                if game:GetService("Players").LocalPlayer.VisionRadius.Value >= 5000 then
                    Alert:create("You Have Max Points")
                    task.wait(1)
                else
                    local enemyName, spawnPos
                    local player = game:GetService("Players").LocalPlayer
                    local workspaceEnemies = game:GetService("Workspace").Enemies
                    local gui = player.PlayerGui.ScreenGui
                    if World2 then
                        enemyName = "Lava Pirate [Lv. 1200]"
                        spawnPos = CFrame.new(-5478.39209, 15.9775667, -5246.9126)
                    elseif World1 then
                        enemyName = "Galley Captain"
                        spawnPos = CFrame.new(5533.29785, 88.1079102, 4852.3916)
                    elseif World3 then
                        enemyName = "Venomous Assailant"
                        spawnPos = CFrame.new(4638.78564453125, 1078.94091796875, 881.8002319335938)
                    end
                    local enemy = workspaceEnemies:FindFirstChild(enemyName)
                    if enemy then
                        if gui:FindFirstChild("ImageLabel") then
                            repeat
                                task.wait(0.1)
                                player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
                            until not getgenv().AutoObservation or not gui:FindFirstChild("ImageLabel")
                        else
                            repeat
                                task.wait(0.1)
                                player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
                                if not gui:FindFirstChild("ImageLabel") and getgenv().AutoObservation_Hop then
                                    Hop()
                                end
                            until not getgenv().AutoObservation or gui:FindFirstChild("ImageLabel")
                        end
                    else
                        topos(spawnPos)
                    end
                end
            end
        end
    end)
end)
Other:AddParagraph({
     Title = "Auto Boss",
     Content = string.rep("", 0)
})
if World1 then
    tableBoss = {
        "The Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral", 
        "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", 
        "Wysper", "Thunder God", "Cyborg", "Saber Expert"
    }
elseif World2 then
    tableBoss = {
        "Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", 
        "Cursed Captain", "Darkbeard", "Order", "Awakened Ice Admiral", "Tide Keeper"
    }
elseif World3 then
    tableBoss = {
        "Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", 
        "Beautiful Pirate", "rip_indra True Form", "Longma", "Soul Reaper", 
        "Cake Queen", "Cake Prince", "Dough King"
    }
end
Dropdown = Other:AddDropdown("Dropdown", {
    Title = "Select Boss",
    Values = tableBoss,
    Multi = false,
})
Dropdown:OnChanged(function(Value)
    getgenv().SelectBoss = Value
end)
Toggle = Other:AddToggle("Toggle", {Title = "Auto Kill Boss", Default = getgenv().AutoFarmBoss })
Toggle:OnChanged(function(Value)
    getgenv().AutoFarmBoss = Value
    StopTween(getgenv().AutoFarmBoss)
end)
spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoFarmBoss then
            pcall(function()
                local workspaceEnemies = game:GetService("Workspace").Enemies
                local selectBoss = getgenv().SelectBoss
                local selectWeapon = getgenv().SelectWeapon
                local boss = workspaceEnemies:FindFirstChild(selectBoss)
                if boss then
                    for _, v in pairs(workspaceEnemies:GetChildren()) do
                        if v.Name == selectBoss and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            local humanoid = v.Humanoid
                            local humanoidRootPart = v.HumanoidRootPart
                            if humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(getgenv().SelectWeapon)
                                    if humanoidRootPart.CanCollide then
                                        humanoidRootPart.CanCollide = false
                                    end
                                    if humanoid.WalkSpeed ~= 0 then
                                        humanoid.WalkSpeed = 0
                                    end
                                    if humanoidRootPart.Size ~= Vector3.new(80, 80, 80) then
                                        humanoidRootPart.Size = Vector3.new(80, 80, 80)
                                    end
                                    topos(humanoidRootPart.CFrame * Pos)
                                until not getgenv().AutoFarmBoss or not v.Parent or humanoid.Health <= 0
                            end
                        end
                    end
                else
                    local replicatedBoss = game:GetService("ReplicatedStorage"):FindFirstChild(selectBoss)
                    if replicatedBoss then
                        topos(replicatedBoss.HumanoidRootPart.CFrame * CFrame.new(5, 10, 7))
                    end
                end
            end)
        end
    end
end)
Toggle = Other:AddToggle("Toggle", {Title = "Auto Kill All Boss", Default = false })
Toggle:OnChanged(function(Value)    
    getgenv().AutoFarmAllBoss = Value
    StopTween(getgenv().AutoFarmAllBoss)    
end)
spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoFarmAllBoss then
            pcall(function()
                for i, boss in pairs(tableBoss) do
                    if game:GetService("Workspace").Enemies:FindFirstChild(boss) then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == boss then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(getgenv().SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                        topos(v.HumanoidRootPart.CFrame * Pos)
                                    until not getgenv().AutoFarmAllBoss or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild(boss) then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild(boss).HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                        end
                    end
                end
            end)
        end
    end
end)
--============================================================
-- 15. TAB FRUIT AND RAID
--============================================================
Blog = Window:AddTab({ Title = "Tab Fruit And Raid", Icon = "" })
Toggle = Blog:AddToggle("Toggle", {Title = "Random Devil Fruit", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().RandomFruit = Value
end)
spawn(function()
     while task.wait(0.2) do
         if getgenv().RandomFruit then
              game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy")
          end 
     end
end)
Toggle = Blog:AddToggle("Toggle", {Title = "Auto Store Fruit", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoStoreFruit = Value
end)    
spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoStoreFruit then
            pcall(function()
                if getgenv().AutoStoreFruit then
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    local backpack = player.Backpack
                    local fruits = {
                        {"Rocket Fruit", "Rocket-Rocket"},
                        {"Spin Fruit", "Spin-Spin"},
                        {"Blade Fruit", "Blade-Blade"},
                        {"Spring Fruit", "Spring-Spring"},
                        {"Bomb Fruit", "Bomb-Bomb"},
                        {"Smoke Fruit", "Smoke-Smoke"},
                        {"Spike Fruit", "Spike-Spike"},
                        {"Flame Fruit", "Flame-Flame"},
                        {"Falcon Fruit", "Falcon-Falcon"},
                        {"Ice Fruit", "Ice-Ice"},
                        {"Sand Fruit", "Sand-Sand"},
                        {"Dark Fruit", "Dark-Dark"},
                        {"Diamond Fruit", "Diamond-Diamond"},
                        {"Light Fruit", "Light-Light"},
                        {"Rubber Fruit", "Rubber-Rubber"},
                        {"Barrier Fruit", "Barrier-Barrier"},
                        {"Ghost Fruit", "Ghost-Ghost"},
                        {"Magma Fruit", "Magma-Magma"},
                        {"Quake Fruit", "Quake-Quake"},
                        {"Buddha Fruit", "Buddha-Buddha"},
                        {"Love Fruit", "Love-Love"},
                        {"Spider Fruit", "Spider-Spider"},
                        {"Sound Fruit", "Sound-Sound"},
                        {"Phoenix Fruit", "Phoenix-Phoenix"},
                        {"Portal Fruit", "Portal-Portal"},
                        {"Rumble Fruit", "Rumble-Rumble"},
                        {"Pain Fruit", "Pain-Pain"},
                        {"Blizzard Fruit", "Blizzard-Blizzard"},
                        {"Gravity Fruit", "Gravity-Gravity"},
                        {"Mammoth Fruit", "Mammoth-Mammoth"},
                        {"T-Rex Fruit", "T-Rex-T-Rex"},
                        {"Dough Fruit", "Dough-Dough"},
                        {"Shadow Fruit", "Shadow-Shadow"},
                        {"Venom Fruit", "Venom-Venom"},
                        {"Gas Fruit", "Gas-Gas"},
                        {"Control Fruit", "Control-Control"},
                        {"Spirit Fruit", "Spirit-Spirit"},
                        {"Leopard Fruit", "Leopard-Leopard"},
                        {"Yeti Fruit", "Yeti-Yeti"},
                        {"Kitsune Fruit", "Kitsune-Kitsune"},
                        {"Dragon Fruit", "Dragon-Dragon"},
                    }
                    for _, fruit in ipairs(fruits) do
                        local fruitName, serverName = fruit[1], fruit[2]
                        if character:FindFirstChild(fruitName) or backpack:FindFirstChild(fruitName) then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", serverName, backpack:FindFirstChild(fruitName))
                        end
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)
FruitList = {
  "Rocket-Rocket",
  "Spin-Spin",
  "Blade-Blade",
  "Spring-Spring",
  "Bomb-Bomb",
  "Smoke-Smoke",
  "Spike-Spike",
  "Flame-Flame",
  "Falcon-Falcon",
  "Ice-Ice",
  "Sand-Sand",
  "Dark-Dark",
  "Diamond-Diamond",
  "Light-Light",
  "Rubber-Rubber",
  "Barrier-Barrier",
  "Ghost-Ghost",
  "Magma-Magma",
  "Quake-Quake",
  "Buddha-Buddha",
  "Love-Love",
  "Spider-Spider",
  "Sound-Sound",
  "Phoenix-Phoenix",
  "Portal-Portal",
  "Rumble-Rumble",
  "Pain-Pain",
  "Blizzard-Blizzard",
  "Gravity-Gravity",
  "T-Rex-T-Rex",
  "Mammoth-Mammoth",
  "Dough-Dough",
  "Shadow-Shadow",
  "Venom-Venom",
  "Gas-Gas",
  "Control-Control",
  "Spirit-Spirit",
  "Leopard-Leopard",
  "Yeti-Yeti",
  "Kitsune-Kitsune",
  "Dragon-Dragon"
 }
Dropdown = Blog:AddDropdown("Dropdown", {
    Title = "Blox Fruit Sniper Shop",
    Values = FruitList,
    Multi = false,
})
Dropdown:OnChanged(function(Value)
    getgenv().SelectFruit = Value
end)    
Toggle = Blog:AddToggle("Toggle", {Title = "Buy Blox Fruit Sniper Shop", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AutoBuyFruitSniper = Value
end)
spawn(function()
    pcall(function()
        while task.wait(1) do
            if getgenv().AutoBuyFruitSniper then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", getgenv().SelectFruit)
            end
        end
    end)
end)
Blog:AddParagraph({
    Title = "Raids",
    Content = string.rep("", 0)
})
Dropdown = Blog:AddDropdown("Dropdown", {
    Title = "Select Raid",
    Values = {
        "Dark", "Sand", "Magma", "Rumble", "Flame", 
        "Ice", "Light", "Quake", "Buddha", "Spider", 
        "Phoenix", "Dough"
    },
    Multi = false,
})
Dropdown:OnChanged(function(Value)
    getgenv().SelectChip = Value
end)
Toggle = Blog:AddToggle("Toggle", {Title = "Get Fruit In Inventory Low Beli", Default = false})
Toggle:OnChanged(function(Value)
    getgenv().AutoGetFruit = Value
end)
spawn(function()
    while task.wait(.1) do
        pcall(function()
            if getgenv().AutoGetFruit then
                local fruits = {"Rocket-Rocket", "Spin-Spin", "Chop-Chop", "Spring-Spring", "Bomb-Bomb", "Smoke-Smoke", 
                                "Spike-Spike", "Flame-Flame", "Falcon-Falcon", "Ice-Ice", "Sand-Sand", "Dark-Dark", 
                                "Ghost-Ghost", "Diamond-Diamond", "Light-Light", "Rubber-Rubber", "Barrier-Barrier"}

                for _, fruit in ipairs(fruits) do
                    local args = {
                        [1] = "LoadFruit",
                        [2] = fruit
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end
            end
        end)
    end
end)
Toggle = Blog:AddToggle("Toggle", {Title = "Auto Raid", Default = false})
Toggle:OnChanged(function(Value)
    getgenv().Auto_Dungeon = Value
end)
spawn(function()
    while task.wait(1) do
        if getgenv().Auto_Dungeon then
            if not game.Players.LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible == false then
                local islands = {"Island 5", "Island 4", "Island 3", "Island 2", "Island 1"}
                for _, island in ipairs(islands) do
                    local location = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild(island)
                    if location then
                        topos(location.CFrame * CFrame.new(0, 70, 100))
                        break
                    end
                end
            end
        end
    end
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            if getgenv().Auto_Dungeon then
                if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == false then
                    local specialMicrochip = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Special Microchip") 
                                            or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Special Microchip")
                    if specialMicrochip then
                        if World2 then
                            fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                        elseif World3 then
                            fireclickdetector(game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait(1) do
        if getgenv().Auto_Dungeon then
            for i, v in pairs(game.Workspace.Enemies:GetDescendants()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    pcall(function()
                        repeat task.wait(.001)
                            v.Humanoid.Health = 0
                            v.HumanoidRootPart.CanCollide = false
                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                        until not getgenv().Auto_Dungeon or not v.Parent or v.Humanoid.Health <= 0
                    end)
                end
            end
        end
    end
end)
spawn(function()
    while task.wait(1) do
        if getgenv().Auto_Dungeon then
            pcall(function()
                local args = {
                    [1] = "RaidsNpc",
                    [2] = "Select",
                    [3] = getgenv().SelectChip
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end)
        end
    end
end)
spawn(function()
    while wait(1) do
        pcall(function()
            if getgenv().Auto_Dungeon then
                if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == false then
                    local specialMicrochip = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Special Microchip") 
                                            or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Special Microchip")
                    if specialMicrochip then
                        if World2 then
                            fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                        elseif World3 then
                            fireclickdetector(game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
                        end
                    end
                end
            end
        end)
    end
end)
Toggle = Blog:AddToggle("Toggle", {Title = "Auto Awaken Fruit", Default = false})
Toggle:OnChanged(function(Value)
    getgenv().AutoAwaken = Value
end)
spawn(function()
    pcall(function()
        while wait(1) do
            if getgenv().AutoAwaken then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awakener", "Check")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awakener", "Awaken")
            end
        end
    end)
end)
--============================================================
-- 16. TAB GET ITEMS AND BUY
--============================================================
GetItemsBuy = Window:AddTab({ Title = "Tab Get Items And Buy", Icon = "" })
Toggle = GetItemsBuy:AddToggle("Toggle", {Title = "Auto Trade Bone", Default = false})
Toggle:OnChanged(function(Value)
    getgenv().AutoTradeBone = Value
end)
spawn(function()
    local canSendRequest = true
    local debounceTime = 1
    while task.wait(0.5) do
        if getgenv().AutoTradeBone and World3 and canSendRequest then
            canSendRequest = false
            local args = {
                [1] = "Bones",
                [2] = "Buy",
                [3] = 1,
                [4] = 1
            }
            local commF = game:GetService("ReplicatedStorage").Remotes.CommF_
            if commF then
                local success, result = pcall(function()
                    commF:InvokeServer(unpack(args))
                end)
                if not success then
                end
            end
            wait(debounceTime)
            canSendRequest = true
        end
    end
end)
Toggle = GetItemsBuy:AddToggle("Toggle", {Title = "Auto Buy Legendary Sword", Default = false})
Toggle:OnChanged(function(Value)
    getgenv().AutoBuyLegendarySword = Value
end)
spawn(function()
    local lastCallTime = 0
    while task.wait(1) do
        if getgenv().AutoBuyLegendarySword and World2 then
            local currentTime = tick()            
            if currentTime - lastCallTime >= 2 then
                lastCallTime = currentTime                
                pcall(function()
                    local args1 = { "LegendarySwordDealer", "1" }
                    local args2 = { "LegendarySwordDealer", "2" }
                    local args3 = { "LegendarySwordDealer", "3" }                    
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args1))
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args2))
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args3))                    
                end)
            end
        end
    end
end)
Toggle = GetItemsBuy:AddToggle("Toggle", {
    Title = "Auto Buy Haki Color",
    Default = false })
Toggle:OnChanged(function(Value)
    getgenv().Auto_Buy_Enchancement = Value
end)
spawn(function()
    local lastCallTime = 0
    while true do
        if getgenv().Auto_Buy_Enchancement then
            local currentTime = tick()
            if currentTime - lastCallTime >= 2 then
                lastCallTime = currentTime
                local args = {
                    [1] = "ColorsDealer",
                    [2] = "2"
                }
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end)
            end
        end
        wait(0.1)
    end
end)
local isHopping = false
Toggle = GetItemsBuy:AddToggle("Toggle", {
    Title = "Hop Server [ Haki color or Legendary Sword]",
    Default = false
})
Toggle:OnChanged(function(state)
    isHopping = state
    if isHopping then
        Hop()
    end
end)
Toggle = GetItemsBuy:AddToggle("Toggle", {Title = "Auto Get Rainbow Haki", Default = false})
Toggle:OnChanged(function(Value)
    getgenv().AutoRainbowHaki = Value
end)
spawn(function()
    pcall(function()
        while task.wait(0.2) do
            if getgenv().AutoRainbowHaki and World3 then
                local player = game:GetService("Players").LocalPlayer
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local questGui = player.PlayerGui.Main.Quest
                if not hrp then continue end                
                if not questGui.Visible then
                    local targetPos = Vector3.new(-11892.0703125, 930.57672119141, -8760.1591796875)
                    if (targetPos - hrp.Position).Magnitude > 30 then
                        topos(CFrame.new(targetPos))
                    else
                        task.wait(1.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HornedMan", "Bet")
                    end
                else
                    local questTitle = questGui.Container.QuestTitle.Title.Text
                    local enemyNames = {
                        ["Stone"] = Vector3.new(-1175, 53, 6811),
                        ["Island Empress"] = Vector3.new(5887, 1019, -114),
                        ["Kilo Admiral"] = Vector3.new(3014, 509, -7354),
                        ["Captain Elephant"] = Vector3.new(-13485.0283, 331.709259, -8012.4873),
                        ["Beautiful Pirate"] = Vector3.new(5377, 22, -62)
                    }
                    for enemyName, teleportPos in pairs(enemyNames) do
                        if string.find(questTitle, enemyName) then
                            local enemy = game:GetService("Workspace").Enemies:FindFirstChild(enemyName)
                            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                                local oldCFrame = enemy.HumanoidRootPart.CFrame
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(getgenv().SelectWeapon)
                                    topos(enemy.HumanoidRootPart.CFrame * Pos)
                                    enemy.HumanoidRootPart.CanCollide = false
                                    enemy.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    enemy.HumanoidRootPart.CFrame = oldCFrame
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                until not getgenv().AutoRainbowHaki or enemy.Humanoid.Health <= 0 or not enemy.Parent or not questGui.Visible
                            else
                                topos(CFrame.new(teleportPos))
                            end
                            break
                        end
                    end
                end
            end
        end
    end)
end)
Toggle = GetItemsBuy:AddToggle("Toggle", {Title = "Auto Skull Guitar", Default = false})
Toggle:OnChanged(function(Value)
    getgenv().AutoSkullGuitar = Value
end)
spawn(function()
    while task.wait() do
        if getgenv().AutoSkullGuitar then
            pcall(function()
                if not GetWeaponInventory("Skull Guitar") then
                    local player = game:GetService("Players").LocalPlayer
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local targetPos = Vector3.new(-9681.458, 6.139, 6341.372)
                        if (targetPos - hrp.Position).Magnitude <= 5000 then
                            local skeletonMachine = game:GetService("Workspace").NPCs:FindFirstChild("Skeleton Machine")
                            if skeletonMachine then
                                game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("soulGuitarBuy", true)
                            else
                                local hauntedCastle = game:GetService("Workspace").Map:FindFirstChild("Haunted Castle")
                                if hauntedCastle and hauntedCastle.Candle1.Transparency == 0 then
                                    local placard1 = hauntedCastle:FindFirstChild("Placard1")
                                    if placard1 and placard1.Left.Part.Transparency == 0 then
                                        Quest2 = true
                                        topos(CFrame.new(-8762.691, 176.847, 6171.308))
                                        task.wait(1)
                                        for i = 7, 1, -1 do
                                            local placard = hauntedCastle:FindFirstChild("Placard" .. i)
                                            if placard and placard:FindFirstChild("Left") and placard.Left:FindFirstChild("ClickDetector") then
                                                fireclickdetector(placard.Left.ClickDetector)
                                                task.wait(0.5)
                                            end
                                        end
                                    end
                                elseif hauntedCastle and hauntedCastle.Tablet and hauntedCastle.Tablet:FindFirstChild("Segment1") then
                                    local labPuzzle = hauntedCastle:FindFirstChild("Lab Puzzle")
                                    if labPuzzle and labPuzzle.ColorFloor.Model.Part1:FindFirstChild("ClickDetector") then
                                        Quest4 = true
                                        topos(CFrame.new(-9553.599, 65.623, 6041.588))
                                        task.wait(1)
                                        local partsToClick = {3, 4, 4, 4, 6, 6, 8, 10, 10, 10}
                                        for _, num in ipairs(partsToClick) do
                                            local part = labPuzzle.ColorFloor.Model:FindFirstChild("Part" .. num)
                                            if part and part:FindFirstChild("ClickDetector") then
                                                topos(part.CFrame)
                                                task.wait(1)
                                                fireclickdetector(part.ClickDetector)
                                                task.wait(0.5)
                                            end
                                        end
                                    else
                                        Quest3 = true
                                    end
                                else
                                    local ghost = game:GetService("Workspace").NPCs:FindFirstChild("Ghost")
                                    if ghost then
                                        game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("GuitarPuzzleProgress", "Ghost")
                                    end
                                    local enemies = game.Workspace:FindFirstChild("Enemies")
                                    if enemies and enemies:FindFirstChild("Living Zombie") then
                                        for _, enemy in pairs(enemies:GetChildren()) do
                                            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy.Name == "Living Zombie" then
                                                AutoHaki()
                                                EquipWeapon(getgenv().SelectWeapon)
                                                enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                                enemy.HumanoidRootPart.Transparency = 1
                                                enemy.Humanoid.JumpPower = 0
                                                enemy.Humanoid.WalkSpeed = 0
                                                enemy.HumanoidRootPart.CanCollide = false
                                                enemy.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 20, 0)                                                
                                                topos(CFrame.new(-10160.787, 138.662, 5955.031))
                                                task.wait(0.5)
                                                local virtualUser = game:GetService("VirtualUser")
                                                virtualUser:CaptureController()
                                                virtualUser:Button1Down(Vector2.new(1280, 672))
                                            end
                                        end
                                    else
                                        topos(CFrame.new(-10160.787, 138.662, 5955.031))
                                    end
                                end
                            end
                        end
                    end
                elseif string.find(game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("gravestoneEvent", 2), "Error") then
                    topos(CFrame.new(-8653.206, 140.985, 6160.033))
                elseif string.find(game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("gravestoneEvent", 2), "Nothing") then
                    topos("Wait Full Moon")
                else
                    game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("gravestoneEvent", 2, true)
                end
            end)
        end
    end
end)
Toggle = GetItemsBuy:AddToggle("Toggle", {Title = "Auto Tushita", Default = false})
Toggle:OnChanged(function(Value)
    getgenv().AutoTushita = Value
end)
spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoTushita and World3 then
            pcall(function()
                local enemies = game:GetService("Workspace").Enemies
                local longma = enemies:FindFirstChild("Longma")
                local player = game.Players.LocalPlayer
                local character = player.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                if longma and hrp then
                    for _, enemy in pairs(enemies:GetChildren()) do
                        if enemy.Name == "Longma" and enemy.Parent and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                            local humanoid = enemy.Humanoid
                            local rootPart = enemy.HumanoidRootPart
                            if humanoid.Health > 0 then
                                if not character:FindFirstChild("Haki") then
                                    AutoHaki()
                                end
                                if getgenv().SelectWeapon and not character:FindFirstChild(getgenv().SelectWeapon) then
                                    EquipWeapon(getgenv().SelectWeapon)
                                end
                                repeat
                                    task.wait(0.1)
                                    rootPart.CanCollide = false
                                    humanoid.WalkSpeed = 0
                                    if (rootPart.Position - hrp.Position).Magnitude > 5 then
                                        topos(rootPart.CFrame * Pos)
                                    end
                                    pcall(function()
                                        sethiddenproperty(player, "SimulationRadius", math.huge)
                                    end)
                                until not getgenv().AutoTushita or not enemy.Parent or humanoid.Health <= 0
                            end
                        end
                    end
                else
                    topos(CFrame.new(-10238.876, 389.791, -9549.794))
                    local storedLongma = game:GetService("ReplicatedStorage"):FindFirstChild("Longma")
                    if storedLongma and storedLongma:FindFirstChild("HumanoidRootPart") then
                        TP(storedLongma.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                    end
                end
            end)
        end
    end
end)
Toggle = GetItemsBuy:AddToggle("Toggle", {Title = "Auto Saber", Default = false})
Toggle:OnChanged(function(Value)
    getgenv().AutoSaber = Value
end)
spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoSaber and game.Players.LocalPlayer.Data.Level.Value >= 200 then
            pcall(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local jungle = game:GetService("Workspace").Map.Jungle
                local desert = game:GetService("Workspace").Map.Desert
                local relicPos = CFrame.new(-1404.91, 29.97, 3.80)                
                if jungle.Final.Part.Transparency == 0 then
                    if jungle.QuestPlates.Door.Transparency == 0 then
                        local saberPos = CFrame.new(-1612.55, 36.97, 148.71)
                        if (saberPos.Position - hrp.Position).Magnitude <= 100 then
                            for i = 1, 5 do
                                local plate = jungle.QuestPlates:FindFirstChild("Plate" .. i)
                                if plate and plate:FindFirstChild("Button") then
                                    hrp.CFrame = plate.Button.CFrame
                                    task.wait(0.5)
                                end
                            end
                        else
                            topos(saberPos)
                        end
                    else
                        if desert.Burn.Part.Transparency == 0 then
                            if player.Backpack:FindFirstChild("Torch") or char:FindFirstChild("Torch") then
                                EquipWeapon("Torch")
                                topos(CFrame.new(1114.61, 5.04, 4350.22))
                            else
                                topos(CFrame.new(-1610.00, 11.50, 164.00))
                            end
                        else
                            local commF = game:GetService("ReplicatedStorage").Remotes.CommF_
                            if commF:InvokeServer("ProQuestProgress", "SickMan") ~= 0 then
                                commF:InvokeServer("ProQuestProgress", "GetCup")
                                task.wait(0.1)
                                EquipWeapon("Cup")
                                task.wait(0.1)
                                commF:InvokeServer("ProQuestProgress", "FillCup", char:FindFirstChild("Cup"))
                                task.wait(0.1)
                                commF:InvokeServer("ProQuestProgress", "SickMan")
                            else
                                if commF:InvokeServer("ProQuestProgress", "RichSon") == nil then
                                    commF:InvokeServer("ProQuestProgress", "RichSon")
                                elseif commF:InvokeServer("ProQuestProgress", "RichSon") == 0 then
                                    local mobLeader = game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader")
                                    if not mobLeader then
                                        mobLeader = game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader")
                                    end                                    
                                    if mobLeader then
                                        topos(mobLeader.HumanoidRootPart.CFrame)
                                        repeat
                                            task.wait()
                                            AutoHaki()
                                            EquipWeapon(getgenv().SelectWeapon)
                                            mobLeader.HumanoidRootPart.CanCollide = false
                                            mobLeader.Humanoid.WalkSpeed = 0
                                            topos(mobLeader.HumanoidRootPart.CFrame)
                                            game:GetService("VirtualUser"):CaptureController()
                                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                            sethiddenproperty(player, "SimulationRadius", math.huge)
                                        until mobLeader.Humanoid.Health <= 0 or not getgenv().AutoSaber
                                    end
                                elseif commF:InvokeServer("ProQuestProgress", "RichSon") == 1 then
                                    commF:InvokeServer("ProQuestProgress", "RichSon")
                                    task.wait(0.1)
                                    EquipWeapon("Relic")
                                    task.wait(0.1)
                                    topos(relicPos)
                                end
                            end
                        end
                    end
                else
                    local saberExpert = game:GetService("Workspace").Enemies:FindFirstChild("Saber Expert")
                    if not saberExpert then
                        saberExpert = game:GetService("ReplicatedStorage"):FindFirstChild("Saber Expert")
                    end                    
                    if saberExpert then
                        repeat
                            task.wait()
                            EquipWeapon(getgenv().SelectWeapon)
                            topos(saberExpert.HumanoidRootPart.CFrame)
                            saberExpert.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            saberExpert.HumanoidRootPart.Transparency = 1
                            saberExpert.Humanoid.JumpPower = 0
                            saberExpert.Humanoid.WalkSpeed = 0
                            saberExpert.HumanoidRootPart.CanCollide = false
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        until saberExpert.Humanoid.Health <= 0 or not getgenv().AutoSaber                        
                        if saberExpert.Humanoid.Health <= 0 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
                        end
                    end
                end
            end)
        end
    end
end)
--============================================================
-- 17. TAB ESP
--============================================================
ESP = Window:AddTab({ Title = "Tab ESP", Icon = "" })
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local IslandESP = false
local updateConnection
function UpdateIslandESP()
    if not player or not player.Character or not player.Character:FindFirstChild("Head") then return end
    local headPosition = player.Character.Head.Position
    local locations = game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()
    for _, v in ipairs(locations) do
        if v.Name ~= "Sea" then
            if IslandESP then
                local bill = v:FindFirstChild("NameEsp")
                if not bill then
                    bill = Instance.new("BillboardGui")
                    bill.Name = "NameEsp"
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v
                    bill.AlwaysOnTop = true
                    bill.Parent = v
                    local name = Instance.new("TextLabel", bill)
                    name.Font = Enum.Font.GothamBold
                    name.TextSize = 14
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = Enum.TextYAlignment.Top
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 255, 255)
                    name.Parent = bill
                end                
                local textLabel = bill:FindFirstChildOfClass("TextLabel")
                if textLabel then
                    local distance = (headPosition - v.Position).Magnitude / 3
                    textLabel.Text = string.format("%s\n%d Distance", v.Name, math.floor(distance + 0.5))
                end
            else
                local existingBill = v:FindFirstChild("NameEsp")
                if existingBill then
                    existingBill:Destroy()
                end
            end
        end
    end
end
Toggle = ESP:AddToggle("Toggle", {Title = "ESP Island", Default = false })
Toggle:OnChanged(function(Value)
    IslandESP = Value
    if IslandESP then
        if not updateConnection then
            updateConnection = RunService.Heartbeat:Connect(UpdateIslandESP)
        end
    else
        if updateConnection then
            updateConnection:Disconnect()
            updateConnection = nil
        end
        for _, v in ipairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
            local existingBill = v:FindFirstChild("NameEsp")
            if existingBill then
                existingBill:Destroy()
            end
        end
    end
end)
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local DevilFruitESP = false
local updateConnection
local Number = math.random(1, 1000000)
function UpdateDevilChams()
    if not player or not player.Character or not player.Character:FindFirstChild("Head") then return end
    local headPosition = player.Character.Head.Position
    for _, v in ipairs(game.Workspace:GetChildren()) do
        pcall(function()
            if v:IsA("Model") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                local handle = v.Handle
                if DevilFruitESP then
                    local bill = handle:FindFirstChild("NameEsp" .. Number)
                    if not bill then
                        bill = Instance.new("BillboardGui")
                        bill.Name = "NameEsp" .. Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = handle
                        bill.AlwaysOnTop = true
                        bill.Parent = handle
                        local name = Instance.new("TextLabel", bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.TextSize = 14
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = Enum.TextYAlignment.Top
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 255, 255)
                        name.Parent = bill
                    end
                    local textLabel = bill:FindFirstChildOfClass("TextLabel")
                    if textLabel then
                        local distance = (headPosition - handle.Position).Magnitude / 3
                        textLabel.Text = string.format("%s\n%d Distance", v.Name, math.floor(distance + 0.5))
                    end
                else
                    local existingBill = handle:FindFirstChild("NameEsp" .. Number)
                    if existingBill then
                        existingBill:Destroy()
                    end
                end
            end
        end)
    end
end
Toggle = ESP:AddToggle("Toggle", {Title = "ESP Fruit", Default = false })
Toggle:OnChanged(function(Value)
    DevilFruitESP = Value
    if DevilFruitESP then
        if not updateConnection then
            updateConnection = RunService.Heartbeat:Connect(UpdateDevilChams)
        end
    else
        if updateConnection then
            updateConnection:Disconnect()
            updateConnection = nil
        end
        for _, v in ipairs(game.Workspace:GetChildren()) do
            if v:IsA("Model") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                local handle = v.Handle
                local existingBill = handle:FindFirstChild("NameEsp" .. Number)
                if existingBill then
                    existingBill:Destroy()
                end
            end
        end
    end
end)
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local ESPPlayer = false
local updateConnection
local Number = math.random(1, 1000000)
function UpdatePlayerChams()
    if not player or not player.Character or not player.Character:FindFirstChild("Head") then return end
    local headPosition = player.Character.Head.Position
    for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
        pcall(function()
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") then
                local head = v.Character.Head
                local humanoid = v.Character.Humanoid
                local bill = head:FindFirstChild("NameEsp" .. Number)
                if ESPPlayer then
                    if not bill then
                        bill = Instance.new("BillboardGui")
                        bill.Name = "NameEsp" .. Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = head
                        bill.AlwaysOnTop = true
                        bill.Parent = head
                        local name = Instance.new("TextLabel", bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.TextSize = 14
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = Enum.TextYAlignment.Top
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.Parent = bill
                    end
                    local textLabel = bill:FindFirstChildOfClass("TextLabel")
                    if textLabel then
                        local distance = math.floor((headPosition - head.Position).Magnitude / 3 + 0.5)
                        local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100 + 0.5)
                        textLabel.Text = string.format("%s\n%d Distance\nHealth: %d%%", v.Name, distance, healthPercent)
                        if v.Team == player.Team then
                            textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                        else
                            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                else
                    if bill then
                        bill:Destroy()
                    end
                end
            end
        end)
    end
end
Toggle = ESP:AddToggle("Toggle", {Title = "ESP Player", Default = false })
Toggle:OnChanged(function(Value)
    ESPPlayer = Value
    if ESPPlayer then
        if not updateConnection then
            updateConnection = RunService.Heartbeat:Connect(UpdatePlayerChams)
        end
    else
        if updateConnection then
            updateConnection:Disconnect()
            updateConnection = nil
        end
        for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                local head = v.Character.Head
                local existingBill = head:FindFirstChild("NameEsp" .. Number)
                if existingBill then
                    existingBill:Destroy()
                end
            end
        end
    end
end)
--============================================================

-- Berry ESP
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local BerryESPEnabled = false
local ChestESPEnabled = false
local BerryESPConnection
local ChestESPConnection
local BerryESPFolder = Instance.new("Folder")
BerryESPFolder.Name = "Hiru_Berry_ESP"
BerryESPFolder.Parent = Workspace
local BerryESPObjects = {}
local BerryColors = {
    ["Yellow Star Berry"] = Color3.fromRGB(255, 220, 50),
    ["Red Cherry Berry"] = Color3.fromRGB(255, 65, 65),
    ["Purple Jelly Berry"] = Color3.fromRGB(190, 80, 255),
    ["Pink Pig Berry"] = Color3.fromRGB(255, 130, 180),
    ["Blue Icicle Berry"] = Color3.fromRGB(80, 210, 255),
    ["Green Toad Berry"] = Color3.fromRGB(65, 235, 95),
    ["Orange Berry"] = Color3.fromRGB(255, 145, 35),
    ["White Cloud Berry"] = Color3.fromRGB(240, 240, 255)
}

local function MakeWorldESP(part, labelText, color, espName)
    if not part or not part:IsA("BasePart") then return end
    local gui = part:FindFirstChild(espName)
    if not gui then
        gui = Instance.new("BillboardGui")
        gui.Name = espName
        gui.Adornee = part
        gui.Size = UDim2.new(0, 180, 0, 42)
        gui.StudsOffset = Vector3.new(0, 2, 0)
        gui.AlwaysOnTop = true
        gui.LightInfluence = 0
        gui.Parent = part

        local text = Instance.new("TextLabel")
        text.Name = "Label"
        text.BackgroundTransparency = 1
        text.Size = UDim2.new(1, 0, 1, 0)
        text.Font = Enum.Font.GothamBold
        text.TextSize = 13
        text.TextStrokeTransparency = 0.25
        text.TextWrapped = true
        text.Parent = gui
    end
    local text = gui:FindFirstChild("Label")
    if text then
        local char = player.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
        local distance = root and math.floor((root.Position - part.Position).Magnitude) or 0
        text.Text = labelText .. "\n" .. distance .. " studs"
        text.TextColor3 = color
    end
end

local function GetBerryName(instance)
    local prompt = instance:FindFirstChildWhichIsA("ProximityPrompt", true)
    local name = prompt and prompt.ActionText
    if not name or name == "" or name == "ProximityPrompt" then
        name = instance.Name
    end
    if not BerryColors[name] then
        for berryName in pairs(BerryColors) do
            if string.find(string.lower(name), string.lower(berryName), 1, true) then
                return berryName
            end
        end
    end
    if name == "" or #name <= 1 or name == "BerryBush" then
        return "Berry"
    end
    return name
end

local function UpdateBerryESP()
    if not BerryESPEnabled then return end
    local seen = {}
    for _, bush in ipairs(CollectionService:GetTagged("BerryBush")) do
        if bush and bush.Parent then
            for _, child in ipairs(bush:GetChildren()) do
                if child:IsA("Model") or child:IsA("BasePart") then
                    local part = child:IsA("BasePart") and child or
                        child:FindFirstChildWhichIsA("BasePart", true) or child.PrimaryPart
                    if part then
                        seen[part] = true
                        local berryName = GetBerryName(child)
                        MakeWorldESP(part, berryName, BerryColors[berryName] or Color3.fromRGB(255, 105, 180), "HiruBerryESP")
                    end
                end
            end
        end
    end

    -- Hiển thị cả Berry đã rơi trong Workspace.
    for _, item in ipairs(Workspace:GetChildren()) do
        if item:IsA("Tool") and (BerryColors[item.Name] or string.find(item.Name, "Berry")) then
            local handle = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
            if handle then
                seen[handle] = true
                MakeWorldESP(handle, "Dropped " .. item.Name, BerryColors[item.Name] or Color3.fromRGB(255, 105, 180), "HiruBerryESP")
            end
        end
    end

    -- Dọn ESP của Berry đã biến mất.
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") and obj.Name == "HiruBerryESP" then
            local adornee = obj.Adornee
            if not adornee or not adornee.Parent then
                obj:Destroy()
            end
        end
    end
end

local function ClearBerryESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") and obj.Name == "HiruBerryESP" then
            obj:Destroy()
        end
    end
    if BerryESPFolder then
        for _, obj in ipairs(BerryESPFolder:GetChildren()) do obj:Destroy() end
    end
end

local function UpdateChestESP()
    if not ChestESPEnabled then return end
    local chestModels = Workspace:FindFirstChild("ChestModels")
    if not chestModels then
        local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
        chestModels = worldOrigin and worldOrigin:FindFirstChild("ChestModels")
    end
    if not chestModels then return end

    for _, chest in ipairs(chestModels:GetChildren()) do
        local root = chest:FindFirstChild("RootPart") or chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart", true)
        if root then
            local lowerName = string.lower(chest.Name)
            local label, color
            if string.find(lowerName, "silver", 1, true) then
                label, color = "Silver Chest", Color3.fromRGB(210, 210, 220)
            elseif string.find(lowerName, "gold", 1, true) then
                label, color = "Gold Chest", Color3.fromRGB(255, 215, 0)
            elseif string.find(lowerName, "diamond", 1, true) then
                label, color = "Diamond Chest", Color3.fromRGB(0, 230, 255)
            else
                label, color = "Chest", Color3.fromRGB(255, 255, 255)
            end
            MakeWorldESP(root, label, color, "HiruChestESP")
        end
    end
end

local function ClearChestESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") and obj.Name == "HiruChestESP" then
            obj:Destroy()
        end
    end
end

local BerryToggle = ESP:AddToggle("HiruBerryESPToggle", {
    Title = "ESP Berry",
    Default = false
})
BerryToggle:OnChanged(function(Value)
    BerryESPEnabled = Value
    if Value then
        if not BerryESPConnection then
            local elapsed = 0
            BerryESPConnection = RunService.Heartbeat:Connect(function(dt)
                elapsed = elapsed + dt
                if elapsed >= 0.5 then
                    elapsed = 0
                    UpdateBerryESP()
                end
            end)
        end
    else
        if BerryESPConnection then
            BerryESPConnection:Disconnect()
            BerryESPConnection = nil
        end
        ClearBerryESP()
    end
end)

local ChestToggle = ESP:AddToggle("HiruChestESPToggle", {
    Title = "ESP Chest",
    Default = false
})
ChestToggle:OnChanged(function(Value)
    ChestESPEnabled = Value
    if Value then
        if not ChestESPConnection then
            local elapsed = 0
            ChestESPConnection = RunService.Heartbeat:Connect(function(dt)
                elapsed = elapsed + dt
                if elapsed >= 0.5 then
                    elapsed = 0
                    UpdateChestESP()
                end
            end)
        end
    else
        if ChestESPConnection then
            ChestESPConnection:Disconnect()
            ChestESPConnection = nil
        end
        ClearChestESP()
    end
end)

-- 18. TAB PVP
--============================================================
PVP = Window:AddTab({ Title = "Tab PVP", Icon = "" })
local Playerslist = {}
for i, player in ipairs(game.Players:GetPlayers()) do
    Playerslist[i] = player.Name
end    
Dropdown = PVP:AddDropdown("Dropdown", {
     Title = "Select Player PVP",
     Values = Playerslist,
     Multi = false,
     Default = false,
})
Dropdown:OnChanged(function(Value)
   getgenv().SelectPlayer = Value
end)
Toggle = PVP:AddToggle("MyToggle", {
    Title = "Teleport Player",
    Default = false
})
Toggle:OnChanged(function(Value)
    getgenv().TeleportPlayer = Value
    if getgenv().TeleportPlayer then
        task.spawn(function()
            while getgenv().TeleportPlayer do
                local player = game:GetService("Players"):FindFirstChild(getgenv().SelectPlayer)
                if player and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        topos(hrp.CFrame)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)
Toggle = PVP:AddToggle("Toggle", {Title = "Auto Aimbot", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().Aimbot = Value
end)        
spawn(function()
    pcall(function()
        while task.wait(0.1) do
            if getgenv().Aimbot and getgenv().SelectPlayer then
                local player = game.Players:FindFirstChild(getgenv().SelectPlayer)
                local localPlayer = game.Players.LocalPlayer
                local character = localPlayer.Character
                local tool = character and character:FindFirstChildOfClass("Tool")
                if player and player.Character and tool then
                    local remoteEvent = tool:FindFirstChild("RemoteEvent")
                    local mousePos = tool:FindFirstChild("MousePos")
                    local target = player.Character:FindFirstChild("HumanoidRootPart")
                    if remoteEvent and mousePos and target then
                        remoteEvent:FireServer(target.Position)
                    end
                end
            end
        end
    end)
end)
Toggle = PVP:AddToggle("Toggle", {Title = "Auto Aimbot Gun", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().AimbotGun = Value
end)        
spawn(function()
    while task.wait(0.1) do
        if getgenv().AimbotGun and SelectWeaponGun then
            local player = game:GetService("Players").LocalPlayer
            local character = player and player.Character
            local weapon = character and character:FindFirstChild(SelectWeaponGun)
            local targetPlayer = game:GetService("Players"):FindFirstChild(getgenv().SelectPlayer)
            local targetCharacter = targetPlayer and targetPlayer.Character
            local targetHumanoidRootPart = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
            if weapon and targetHumanoidRootPart then
                pcall(function()
                    weapon.Cooldown.Value = 0
                    local args = {
                        [1] = targetHumanoidRootPart.Position,
                        [2] = targetHumanoidRootPart
                    }
                    weapon.RemoteFunctionShoot:InvokeServer(unpack(args))
                    local virtualUser = game:GetService("VirtualUser")
                    virtualUser:Button1Down(Vector2.new(1280, 672))
                end)
            end
        end
    end
end)
Toggle = PVP:AddToggle("Toggle", {Title = "Safe Modes", Default = false })
Toggle:OnChanged(function(Value)
    getgenv().SafeMode = Value
end)
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().SafeMode then
                local CharacterPlayer = game.Players.LocalPlayer.Character
                if CharacterPlayer and CharacterPlayer:FindFirstChild("Humanoid") and CharacterPlayer:FindFirstChild("HumanoidRootPart") then
                    local HealthMinPlayer = CharacterPlayer.Humanoid.MaxHealth * (getgenv().Safe / 100)
                    if CharacterPlayer.Humanoid.Health <= HealthMinPlayer then
                        while getgenv().SafeMode and CharacterPlayer.Humanoid.Health <= HealthMinPlayer do
                            task.wait(0.1)
                            CharacterPlayer.HumanoidRootPart.CFrame = CharacterPlayer.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0)
                        end
                    end
                end
            end
        end)
    end
end)
Slider = PVP:AddSlider("Slider", {
    Title = "Safe Mode At",
    Default = 30,
    Min = 0,
    Max = 100,
    Rounding = 5,
    Callback = function(Value)
        getgenv().Safe = Value
    end
})
Toggle = PVP:AddToggle("Toggle", { Title = "Walk On Water", Default = true })
Toggle:OnChanged(function(Value)
    getgenv().WalkWater = Value    
    local waterPlane = game:GetService("Workspace").Map["WaterBase-Plane"]
    if getgenv().WalkWater then
        waterPlane.Size = Vector3.new(1000, 112, 1000)
    else
        waterPlane.Size = Vector3.new(1000, 80, 1000)
    end
end)
Toggle = PVP:AddToggle("Toggle", {Title = "No Clip", Default = false })
Toggle:OnChanged(function(v)
    getgenv().NoClip = v
    if getgenv().NoClipConnection then getgenv().NoClipConnection:Disconnect() end
    if v then
        getgenv().NoClipConnection = game:GetService("RunService").Stepped:Connect(function()
            for _, p in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    else
        for _, p in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
getgenv().WalkSpeed = 16
Toggle = PVP:AddToggle("Toggle", {
    Title = "Change WalkSpeed",
    Default = false
})
local SpeedConnection
local SpeedCharacterConnection
local function ApplySpeed()
    if not Toggle.Value then return end
    local Character = Player.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = getgenv().WalkSpeed
            if SpeedConnection then
                SpeedConnection:Disconnect()
            end
            SpeedConnection = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if Toggle.Value then
                    Humanoid.WalkSpeed = getgenv().WalkSpeed
                end
            end)
        end
    end
end
Toggle:OnChanged(function(Value)
    if Value then
        ApplySpeed()
        if SpeedCharacterConnection then
            SpeedCharacterConnection:Disconnect()
        end
        SpeedCharacterConnection = Player.CharacterAdded:Connect(function()
            task.wait(0.25)
            ApplySpeed()
        end)
    else
        if SpeedConnection then
            SpeedConnection:Disconnect()
            SpeedConnection = nil
        end
        if SpeedCharacterConnection then
            SpeedCharacterConnection:Disconnect()
            SpeedCharacterConnection = nil
        end
        local Character = Player.Character
        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = 16
            end
        end
    end
end)
Input = PVP:AddInput("Input", {
     Title = "Input WalkSpeed",
     Default = 100,
     Placeholder = "Input",
     Numeric = true,
     Finished = true,
     Callback = function(Value)
         getgenv().WalkSpeed = Value
     end
})
print("--[[ImageButton]]--")
local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local existingGui = playerGui:FindFirstChild("CustomScreenGui")
if existingGui then
    existingGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomScreenGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

local Button = Instance.new("ImageButton")
Button.Name = "CustomButton"
Button.Parent = ScreenGui
Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.10615778, 0, 0.16217947, 0)
Button.Size = UDim2.new(0, 60, 0, 60)
Button.Draggable = true
Button.Image = "rbxassetid://43590276951914"

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Button

local VirtualInputManager = game:GetService("VirtualInputManager")
Button.MouseButton1Click:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.End, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.End, false, game)
end)

print("--[[Hop Server If You Meet Game Admin]]--")
local targetPlayers = {
    ["red_game43"] = true,
    ["rip_indra"] = true,
    ["Axiore"] = true,
    ["Polkster"] = true,
    ["wenlocktoad"] = true,
    ["Daigrock"] = true,
    ["toilamvidamme"] = true,
    ["oofficialnoobie"] = true,
    ["Uzoth"] = true,
    ["Azarth"] = true,
    ["arlthmetic"] = true,
    ["Death_King"] = true,
    ["Lunoven"] = true,
    ["TheGreateAced"] = true,
    ["rip_fud"] = true,
    ["drip_mama"] = true,
    ["layandikit12"] = true,
    ["Hingoi"] = true
}
spawn(function()
    while true do
        wait(1)
        for _, v in pairs(game.Players:GetPlayers()) do
            if targetPlayers[v.Name] then
                Hop()
                break
            end
        end
    end
end)


