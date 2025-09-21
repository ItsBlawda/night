local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

GUI:CreateMain({
    Name = "Github",
    title = "Github GUI",
    ToggleUI = "K",
    WindowIcon = "home",

    Theme = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(50, 50, 60),
        NavBackground = Color3.fromRGB(20, 20, 30)
    },
    Blur = { Enable = false, value = 0.2 },
    Config = { Enabled = false }
})

local main = GUI:CreateTab("Main", "home")
GUI:CreateSection({ parent = main, text = "Bring Section" })

local Bring = GUI:CreateTab("Bring", "home")
GUI:CreateSection({ parent = Bring, text = "Bring Section" })

-- Safe references
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:FindFirstChild("HumanoidRootPart")
local itemsFolder = workspace:FindFirstChild("Items")
local scrapper = workspace:FindFirstChild("Map") and workspace.Map.Campground:FindFirstChild("Scrapper")
local mainFire = workspace:FindFirstChild("Map") and workspace.Map.Campground:FindFirstChild("MainFire")

-- =========================
-- Bring Method
-- =========================

local lastBringTarget = nil
local bringTarget = "Player"

GUI:CreateDropdown({
    parent = main,
    text = "Select Bring Method",
    options = {"Player", "Scrapper", "MainFire"},
    callback = function(selected)
        if selected ~= lastBringTarget then
            bringTarget = selected
            lastBringTarget = selected
            GUI:CreateNotify({
                title = "Bring Method",
                text = "Items will now be brought to: " .. selected
            })
        end
    end
})


local function getBringCFrame()
    if bringTarget == "Scrapper" and scrapper then
        return scrapper.CFrame * CFrame.new(0,5,0)
    elseif bringTarget == "MainFire" and mainFire then
        return mainFire.CFrame * CFrame.new(0,5,0)
    elseif root then
        return root.CFrame * CFrame.new(0,5,0)
    end
    return CFrame.new()
end

local function bringItem(name)
    if not itemsFolder then return end
    local item = itemsFolder:FindFirstChild(name)
    if not item then return end

    local targetCFrame = getBringCFrame()
    if item:IsA("BasePart") then
        item.CFrame = targetCFrame
    elseif item:IsA("Model") and item.PrimaryPart then
        item:SetPrimaryPartCFrame(targetCFrame)
    end
end

-- =========================
-- Bring Buttons
-- =========================
GUI:CreateButton({
    parent = Bring,
    text = "Metal Items",
    callback = function()
        bringItem("Old Flashlight")
        bringItem("Old Radio")
        bringItem("broken Fan")
        bringItem("Bolt")
    end
})

GUI:CreateButton({
    parent = Bring,
    text = "Wood Items",
    callback = function()
        bringItem("Log")
    end
})

GUI:CreateButton({
    parent = Bring,
    text = "Gear Items",
    callback = function()
        bringItem("Coal")
    end
})

-- =========================
-- Auto Scrap Metal
-- =========================
local metalItems = {
    "Bolt", "Sheet Metal", "Broken Microwave",
    "Broken Radio", "Metal Chair", "Washing Machine"
}

local autoScrap = false

local function scrapItems()
    if not itemsFolder then return end
    for _, name in ipairs(metalItems) do
        bringItem(name)
    end

    local allGone = true
    for _, name in ipairs(metalItems) do
        if itemsFolder:FindFirstChild(name) then
            allGone = false
            break
        end
    end

    if allGone then
        GUI:CreateNotify({ title = "Scrapper", text = "All metal items have been scrapped!" })
    end
end

GUI:CreateToggle({
    parent = main,
    text = "Auto Scrap Metal",
    default = false,
    callback = function(Value)
        autoScrap = Value
        if autoScrap then
            task.spawn(function()
                while autoScrap do
                    scrapItems()
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- =========================
-- Auto Bring Food
-- =========================
local foodItems = { "Carrot", "Apple", "Berry" }
local autoFood = false

local function bringFood()
    if not itemsFolder then return end
    local allMissing = true
    for _, name in ipairs(foodItems) do
        local item = itemsFolder:FindFirstChild(name)
        if item then
            allMissing = false
            bringItem(name)
        else
            GUI:CreateNotify({ title = "Food Finder", text = name .. " not found." })
        end
    end
    if allMissing then
        GUI:CreateNotify({ title = "Food Finder", text = "No food items found in workspace." })
    end
end

GUI:CreateToggle({
    parent = main,
    text = "Auto Bring Food",
    default = false,
    callback = function(Value)
        autoFood = Value
        if autoFood then
            task.spawn(function()
                while autoFood do
                    bringFood()
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- =========================
-- Auto Fuel
-- =========================
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local itemsFolder = workspace:WaitForChild("Items")
local mainFire = workspace.Map.Campground:WaitForChild("MainFire")

local fuelItems = {
    "Coal",
    "Log",
    "Stick",
    "Plank",
    "Wood Scrap"
}

local autoFuel = false

local function fuelFire()
    local found = false
    for _, name in ipairs(fuelItems) do
        local item = itemsFolder:FindFirstChild(name)
        if item then
            found = true
            if item:IsA("BasePart") then
                item.CFrame = mainFire.CFrame * CFrame.new(0,5,0)
            elseif item:IsA("Model") and item.PrimaryPart then
                item:SetPrimaryPartCFrame(mainFire.CFrame * CFrame.new(0,5,0))
            end
        end
    end
    if not found then
        GUI:CreateNotify({
            title = "Auto Fuel",
            text = "No fuel items found in workspace."
        })
    end
end

GUI:CreateToggle({
    parent = main,
    text = "Auto Fuel Fire",
    default = false,
    callback = function(Value)
        autoFuel = Value
        if autoFuel then
            task.spawn(function()
                while autoFuel do
                    fuelFire()
                    task.wait(2)
                end
            end)
        end
    end
})


-- =========================
-- Teleport Section
-- =========================
local teleport = GUI:CreateTab("Teleport", "home")
GUI:CreateSection({ parent = teleport, text = "Teleport Section" })

GUI:CreateButton({
    parent = teleport,
    text = "TP Campfire",
    callback = function()
        if root and mainFire then
            if mainFire:IsA("BasePart") then
                root.CFrame = mainFire.CFrame * CFrame.new(0,5,0)
            elseif mainFire.PrimaryPart then
                root.CFrame = mainFire.PrimaryPart.CFrame * CFrame.new(0,5,0)
            end
        else
            GUI:CreateNotify({ title = "Teleport", text = "Campfire not found." })
        end
    end
})


local esp = GUI:CreateTab("ESP", "home")

GUI:CreateSection({ 
    parent = esp, 
    text = "ESP Section" 
})





local playerTab = GUI:CreateTab("Local Player", "home")
GUI:CreateSection({ 
    parent = playerTab, 
    text = "Local Player Section" 
})

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Save original speeds
local originalWalk = humanoid.WalkSpeed
local originalJump = humanoid.JumpPower

local runSpeed = 50   -- default faster run
local jumpPower = 150 -- default higher jump
local movementEnabled = false

-- Slider: WalkSpeed
GUI:CreateSlider({
    parent = playerTab,
    text = "Run Speed",
    min = 16,
    max = 200,
    default = runSpeed,
    function(value)
        runSpeed = value
        if movementEnabled then
            humanoid.WalkSpeed = runSpeed
        end
    end
})

-- Slider: JumpPower
GUI:CreateSlider({
    parent = playerTab,
    text = "Jump Power",
    min = 50,
    max = 300,
    default = jumpPower,
    function(value)
        jumpPower = value
        if movementEnabled then
            humanoid.JumpPower = jumpPower
        end
    end
})

-- Toggle movement system
GUI:CreateToggle({
    parent = playerTab,
    text = "Enable Custom Movement",
    default = false,
    callback = function(Value)
        movementEnabled = Value
        if movementEnabled then
            humanoid.WalkSpeed = runSpeed
            humanoid.JumpPower = jumpPower
        else
            humanoid.WalkSpeed = originalWalk
            humanoid.JumpPower = originalJump
        end
    end
})
