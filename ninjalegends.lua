getgenv().autoSwing = false
getgenv().autoSwordBuy = false
getgenv().autoBeltBuy = false
getgenv().autoSell = false
getgenv().autoBuyRanks = false
getgenv().eggFarming = false


function getPlayer()
    return game.Players.LocalPlayer
end

function getBestIsland()
    local islands = game:GetService("Workspace").islandUnlockParts:GetChildren()
    return islands[#islands]
end

function swingKatana()
    spawn(function()
        local player = getPlayer()
        local firstItem = player.Backpack:GetChildren()[1]
        player.Character.Humanoid:EquipTool(firstItem)
        
        while autoSwing do
            game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana")
            wait()
        end
    end)
end

function buySwords()
    spawn(function() 
        while autoSwordBuy do
            local args = {
                [1] = "buyAllSwords",
                [2] = "Blazing Vortex Island"
            }
            game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(unpack(args))
            wait(5)
        end
    end)
end


function buyBelts()
    spawn(function() 
        while autoBeltBuy do
            local args = {
                [1] = "buyAllBelts",
                [2] = "Blazing Vortex Island"
            }

            game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(unpack(args))
            wait(60)
        end
    end)
end

function sell()
    spawn(function()
        local sellAreas = game:GetService("Workspace").sellAreaCircles:GetChildren()
        local bestSellArea = sellAreas[#sellAreas]
        local playerhead = game.Players.LocalPlayer.Character.Head

        while autoSell do
            firetouchinterest(playerhead, bestSellArea.circleInner, 1)
            wait(0.1)
            firetouchinterest(playerhead, bestSellArea.circleInner, 0)
            wait(1)
        end
    end)
end

function buyRanks()
    spawn(function()
        while autoBuyRanks do
            local player = getPlayer()
            local playerCoins = player.Coins.Value
            local ranks = game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren()
    
            for i, rank in ipairs(ranks) do
                if rank.price.Value <= playerCoins then
                    local args = {
                        [1] = "buyRank",
                        [2] = tostring(rank)
                    }
                    
                    game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(unpack(args))
                end
            end
    
            wait(5)
        end
    end)
end


function teleportTo(positionCFrame)
    local player = getPlayer()
    if player.Character then
        player.Character.HumanoidRootPart.CFrame = positionCFrame
    end
end


function teleportToWorld(world) 
    local possibleWorld = game:GetService("Workspace").islandUnlockParts[world]
    if possibleWorld then
        teleportTo(possibleWorld.CFrame)    
    end
end


function unlockAllWorlds()
    local worlds = game:GetService("Workspace").islandUnlockParts:GetChildren()
    local playerhead = game.Players.LocalPlayer.Character.Head
    for i, world in ipairs(worlds) do
        firetouchinterest(playerhead, world, 0)
    end
end

function openAllChests()
    local playerHead = game.Players.LocalPlayer.Character.Head
    local workspaceObjects = game:GetService("Workspace"):GetChildren()

    for i, v in pairs(workspaceObjects) do
        local chestPath
        local chestName = v.Name
        
        if string.find(chestName:lower(), "chest") then
            chestName = chestName:gsub("%s+", "")
            chestName = chestName:sub(1,1):lower()..chestName:sub(2)
            chestPath = game:GetService("Workspace")[chestName].circleInner
            print(chestName)
            firetouchinterest(playerHead, chestPath, 0)
        end
    end
    
    local chests = game:GetService("ReplicatedStorage").chestRewards:GetChildren()
    for i, chest in ipairs(chests) do
        game:GetService("ReplicatedStorage").rEvents.checkChestRemote:InvokeServer(chest.Name)
        wait(1)
    end
end

function eggFarm()
    spawn(function ()
        local unwantedPets = {"Thunder Strike Falcon", "Dawn Horizon Birdie", "Eternal Abyss Wyvern", "Rising Divine Dragon"}
        local petsFolder = game:GetService("Players").LocalPlayer.petsFolder
        

        while eggFarming do
            
            for i, petType in pairs(petsFolder:GetChildren()) do
                for i, pet in pairs(petType:GetChildren()) do
                    for i, unwantedPet in pairs(unwantedPets) do
                        if pet.Name == unwantedPet then
                            local args = {
                                [1] = "sellPet",
                                [2] = pet
                            }
    
                            game:GetService("ReplicatedStorage").rEvents.sellPetEvent:FireServer(unpack(args))
                            
                            wait(0.1)
                        end
                    end
                end
            end

            game:GetService("ReplicatedStorage").rEvents.autoEvolveRemote:InvokeServer("autoEvolvePets")

            wait(3)
        end
    end)
end

function unlockGamepasses()
    local gamepasses = game:GetService("ReplicatedStorage").gamepassIds:GetChildren()

    for i, gamepass in pairs(gamepasses) do
        gamepassClone = gamepass:Clone()
        gamepassClone.Parent = game.Players.LocalPlayer.ownedGamepasses
    end
end



local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua')))()

local w = library:CreateWindow("Glatinis' Ninja GUI")

local b = w:CreateFolder("Farming")
local c = w:CreateFolder("Teleports")
local d = w:CreateFolder("Exploits")

b:DestroyGui()


b:Toggle("Auto Swing", function(bool)
    getgenv().autoSwing = bool
    print("Auto Swing is: ", bool)

    if bool then
        swingKatana()
    end
end)

b:Toggle("Auto Sell", function(bool)
    getgenv().autoSell = bool
    print("Auto Sell is: ", bool)

    if bool then
        sell()
    end
end)

b:Toggle("Auto Buy Swords", function(bool)
    getgenv().autoSwordBuy = bool
    print("Auto Sword Buy is: ", bool)

    if bool then
        buySwords()
    end
end)

b:Toggle("Auto Buy Belts", function(bool)
    getgenv().autoBeltBuy = bool
    print("Auto Belt Buy is: ", bool)

    if bool then
        buyBelts()
    end
end)

b:Toggle("Auto Buy Ranks", function(bool)
    getgenv().autoBuyRanks = bool
    print("Auto Rank Buy is: ", bool)

    if bool then
        buyRanks()
    end
end)

-- b:Toggle("Egg Farm", function(bool)
--     getgenv().eggFarming = bool
--     print("Auto Egg Farming is: ", bool)

--     if bool then
--         eggFarm()
--     end
-- end)


local worlds = game:GetService("Workspace").islandUnlockParts:GetChildren()
for i, world in ipairs(worlds) do
    worlds[i] = tostring(world)
end

local selectedWorld

c:Dropdown("Island", worlds, true, function(value)
    selectedWorld = value
    print(value)
end)

c:Button("TP To Selected", function()
    if selectedWorld then
        teleportToWorld(selectedWorld)
    end
end)

c:Button("Unlock All Islands", function()
    unlockAllWorlds()
end)


d:Button("Open All Chests", function()
    openAllChests()
end)

d:Button("Unlock All Gamepasses", function()
    unlockGamepasses()
end)