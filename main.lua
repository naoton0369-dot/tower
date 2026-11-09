local MAIN_PLACE_ID = 1794233209885

local currentPlaceId = game.PlaceId
local success, gameInfo = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(currentPlaceId)
end)

local isTargetGame = false

if currentPlaceId == MAIN_PLACE_ID then
    isTargetGame = true
elseif success and gameInfo then
    local rootId = gameInfo.UniverseId
    local mainSuccess, mainInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(MAIN_PLACE_ID)
    end)
    if mainSuccess and mainInfo and mainInfo.UniverseId == rootId then
        isTargetGame = true
    end
end

if not isTargetGame then
    return
end

local queueFunc = syn and syn.queue_on_teleport or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
if queueFunc then
    queueFunc([[
        task.wait(3)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/naoton0369-dot/tower/main/main.lua"))()
    ]])
end

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "Cameraman Tower Defence", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "CameramanTD_Config"
})

local FarmTab = Window:MakeTab({
	Name = "Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

_G.AutoJoinRunning = false

FarmTab:AddToggle({
    Name = "Auto Join",
    Default = false,
    Save = true,
    Callback = function(Value)
        _G.AutoJoinRunning = Value
        if Value then
            task.spawn(function()
                while _G.AutoJoinRunning do
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local rootPart = character:WaitForChild("HumanoidRootPart")
                    
                    local elevators = game.Workspace:FindFirstChild("Elevators")
                    if elevators then
                        local elevator17 = elevators:FindFirstChild("Elevator17")
                        if elevator17 and elevator17:FindFirstChild("BasePart") then
                            rootPart.CFrame = elevator17.BasePart.CFrame + Vector3.new(0, 5, 0)
                            break 
                        end
                    end
                    
                    task.wait(2)
                end
            end)
        else
        end
    end    
})

OrionLib:Init()
