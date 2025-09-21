local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/ItsBlawda/whoamii/refs/heads/master/MYGUI.lua'))()
Library.Theme = "Dark"
local Flags = Library.Flags

local Window = Library:Window({
    Text = "GitHUB"
})

local BringItems = Window:Tab({ 
    Text = "Bring Items" 
})

local TPPlace = Window:Tab({ 
    Text = "Teleportation" 
})

local bring = BringItems:Section({ 
    Text = "Bring"
})

local TP = TPPlace:Section({ 
    Text = "Campfire"
})


local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local itemsFolder = workspace:WaitForChild("items")

local itemNames = {
    "Bolt",
    "broken Fan",
    "Broken Microwave",
    "Coal",
    "Fuel Canister",
    "Old Flashlight",
    "Old Radio",
    "Log"
}

local selectedItem = itemNames[1]
local toggleOn = false

bring:Dropdown({ 
    Text = "Choose Item",
    List = itemNames,
    Default = itemNames[1],
    ChangeTextOnPick = true,
    Flag = "ItemChoice",
    Callback = function(option)
        selectedItem = option
    end
})

bring:Toggle({
    Text = "Bring Item",
    Default = false,
    Callback = function(Value)
        toggleOn = Value
        if Value and selectedItem then
            local item = itemsFolder:FindFirstChild(selectedItem)
            if item then
                if item:IsA("BasePart") then
                    item.CFrame = root.CFrame * CFrame.new(2,0,-2)
                elseif item:IsA("Model") and item.PrimaryPart then
                    item:SetPrimaryPartCFrame(root.CFrame * CFrame.new(2,0,-2))
                end
            end
        end
    end
})



local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local campfire = workspace.Map.Campground:WaitForChild("MainFire")

TP:Button({
    Text = "TP Campfire",
    Callback = function()
        if campfire and campfire:IsA("BasePart") then
            root.CFrame = campfire.CFrame * CFrame.new(0,5,0)
        elseif campfire and campfire.PrimaryPart then
            root.CFrame = campfire.PrimaryPart.CFrame * CFrame.new(0,5,0)
        end
    end
})

