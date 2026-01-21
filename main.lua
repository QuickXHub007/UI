-- // Exploit UI Library - Custom Drag PC+Mobile + Gradient + ImageButton + Tab System
-- // Designed to look cool with gradients & icons

local Library = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuickXHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = gui

-- Main Window Frame (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Gradient for cool look
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 0, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 0, 80))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title Bar (สำหรับ Drag)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Cool Exploit Hub"
TitleLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = TitleBar

-- Close / Toggle Button (ImageButton)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 28, 0, 28)
ToggleButton.Position = UDim2.new(1, -38, 0, 6)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = "rbxassetid://126349969692217"  -- ไอคอนที่คุณให้มา (ถ้าใช้ไม่ได้เปลี่ยนได้)
ToggleButton.ImageColor3 = Color3.fromRGB(200, 180, 255)
ToggleButton.Parent = TitleBar

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 8)
TabLayout.Parent = TabContainer

-- Content Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -80)
ContentFrame.Position = UDim2.new(0, 0, 0, 80)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Variables
local tabs = {}
local currentTab = nil
local dragging, dragInput, dragStart, startPos
local uiVisible = true

-- // Drag Function (PC + Mobile)
local function updateInput(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(MainFrame, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {Position = newPos}):Play()
end

TitleBar.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and uiVisible then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Toggle UI (กดปุ่ม ImageButton เพื่อเปิด/ปิด)
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    if uiVisible then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = startPos or MainFrame.Position}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -240, 1.5, 0)}):Play()
        wait(0.3)
        MainFrame.Visible = false
    end
end)

-- // Create Tab
function Library:CreateTab(name, iconId)
    local tabButton = Instance.new("ImageButton")
    tabButton.Size = UDim2.new(0, 100, 0, 32)
    tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tabButton.AutoButtonColor = false
    tabButton.Image = iconId and "rbxassetid://" .. iconId or ""
    tabButton.ImageTransparency = iconId and 0 or 1
    tabButton.Parent = TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton
    
    local tabGradient = Instance.new("UIGradient")
    tabGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 60, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 140))
    }
    tabGradient.Parent = tabButton
    
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, 0, 1, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = name
    tabLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    tabLabel.Font = Enum.Font.GothamSemibold
    tabLabel.TextSize = 14
    tabLabel.Parent = tabButton
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 4
    tabContent.Visible = false
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Parent = ContentFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = tabContent
    
    tabContent.ChildAdded:Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Tab Switch
    local function showTab()
        if currentTab then
            currentTab.Content.Visible = false
            currentTab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        end
        tabContent.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(70, 40, 140)
        currentTab = {Button = tabButton, Content = tabContent}
    end
    
    tabButton.MouseButton1Click:Connect(showTab)
    
    -- Auto select first tab
    if not currentTab then showTab() end
    
    local tabAPI = {}
    
    function tabAPI:CreateButton(text, callback)
        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(1, -20, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.AutoButtonColor = false
        btn.Parent = tabContent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn
        
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new(Color3.fromRGB(90, 60, 180), Color3.fromRGB(50, 30, 100))
        grad.Parent = btn
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230, 230, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 15
        lbl.Parent = btn
        
        btn.MouseButton1Click:Connect(callback or function() end)
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 60, 140)}):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
        end)
        
        return btn
    end
    
    function tabAPI:CreateToggle(text, default, callback)
        local toggle = Instance.new("ImageButton")
        toggle.Size = UDim2.new(1, -20, 0, 38)
        toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        toggle.AutoButtonColor = false
        toggle.Parent = tabContent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = toggle
        
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new(Color3.fromRGB(90, 60, 180), Color3.fromRGB(50, 30, 100))
        grad.Parent = toggle
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230, 230, 255)
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 15
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = toggle
        
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 24, 0, 24)
        indicator.Position = UDim2.new(1, -34, 0.5, -12)
        indicator.BackgroundColor3 = default and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 50, 50)
        indicator.Parent = toggle
        
        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(1, 0)
        indCorner.Parent = indicator
        
        local state = default or false
        
        local function update()
            TweenService:Create(indicator, TweenInfo.new(0.25), {
                BackgroundColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 50, 50)
            }):Play()
            if callback then callback(state) end
        end
        
        toggle.MouseButton1Click:Connect(function()
            state = not state
            update()
        end)
        
        if default then update() end
        
        return {Toggle = toggle, Set = function(v) state = v update() end}
    end
    
    function tabAPI:CreateDropdown(text, options, callback)
        local drop = Instance.new("ImageButton")
        drop.Size = UDim2.new(1, -20, 0, 38)
        drop.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        drop.AutoButtonColor = false
        drop.Parent = tabContent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = drop
        
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new(Color3.fromRGB(90, 60, 180), Color3.fromRGB(50, 30, 100))
        grad.Parent = drop
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230, 230, 255)
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 15
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = drop
        
        local selected = options[1] or "None"
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.3, -10, 1, 0)
        valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = selected
        valueLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextSize = 14
        valueLabel.Parent = drop
        
        -- Dropdown logic (simple version - expand for full dropdown list)
        drop.MouseButton1Click:Connect(function()
            -- คุณสามารถเพิ่ม logic แสดง list ได้ที่นี่ (เช่น popup frame)
            -- ตัวอย่างง่ายๆ: cycle ไปเรื่อยๆ
            local idx = table.find(options, selected) or 1
            idx = (idx % #options) + 1
            selected = options[idx]
            valueLabel.Text = selected
            if callback then callback(selected) end
        end)
        
        return {Dropdown = drop, Set = function(v) selected = v valueLabel.Text = v end}
    end
    
    return tabAPI
end

-- // Loadstring ตัวอย่างการใช้งาน
-- loadstring(game:HttpGet("your_link_here"))()

return Library
