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

print("対象のタワーディフェンス（メインまたはテレポート先）を検出しました。自動化を実行します！")


-- 1. テレポートしたとき（別のゲームやサーバーへ飛んだとき）に自動でこのスクリプトを再実行させる予約
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/naoton0369-dot/tower/main/main.lua"))()
    end)
end)


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
                            print("エレベーターに移動しました！")
                            break 
                        end
                    else
                        print("今はロビーではないので待機中です...")
                    end
                    
                    task.wait(2)
                end
            end)
        else
            print("Auto JoinがOFFになりました")
        end
    end    
})

OrionLib:Init()