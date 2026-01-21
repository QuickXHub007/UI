-- [ UI Library - Modern Exploit GUI ] --
-- Drag PC + Mobile + Toggle Icon + Tabs + Gradient + ImageButton

local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernExploitUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui") -- หรือ game.Players.LocalPlayer:WaitForChild("PlayerGui") ถ้าไม่ใช่ exploit

-- สร้าง Toggle Button (Icon ลอย ๆ Drag ได้)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "Toggle"
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0.02, 0, 0.85, 0)
ToggleButton.BackgroundTransparency = 0.4
ToggleButton.Image = "rbxassetid://126349969692217" -- ไอคอนตามที่ขอ
ToggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleGradient = Instance.new("UIGradient")
ToggleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 160, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 80, 255))
}
ToggleGradient.Rotation = 45
ToggleGradient.Parent = ToggleButton

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 40, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 50))
}
MainGradient.Rotation = -45
MainGradient.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 120, 255)
MainStroke.Transparency = 0.6
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Title Bar (สำหรับ Drag)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "Title"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Modern Exploit UI"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "Tabs"
TabContainer.Size = UDim2.new(0, 140, 1, -45)
TabContainer.Position = UDim2.new(0, 0, 0, 45)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 8)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "Content"
ContentContainer.Size = UDim2.new(1, -150, 1, -55)
ContentContainer.Position = UDim2.new(0, 150, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- ฟังก์ชัน Drag (รองรับทั้ง Mouse + Touch)
local function makeDraggable(frame, dragArea)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        TweenService:Create(frame, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {Position = newPos}):Play()
    end

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- ทำให้ MainFrame Drag ได้ (ใช้ TitleBar)
makeDraggable(MainFrame, TitleBar)

-- ทำให้ ToggleButton Drag ได้ด้วย
makeDraggable(ScreenGui, ToggleButton) -- ใช้ ScreenGui เป็น parent แต่ drag ตัว Toggle

-- Toggle GUI
local guiVisible = false

ToggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    MainFrame.Visible = guiVisible
    
    if guiVisible then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end
end)

-- Tab System
function Library:CreateTab(name, iconId)
    local TabButton = Instance.new("ImageButton")
    TabButton.Size = UDim2.new(1, -10, 0, 50)
    TabButton.Position = UDim2.new(0, 5, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    TabButton.AutoButtonColor = false
    TabButton.Image = iconId or ""
    TabButton.ImageTransparency = iconId and 0 or 1
    TabButton.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    local TabGradient = Instance.new("UIGradient")
    TabGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 70))
    }
    TabGradient.Parent = TabButton
    
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -60, 1, 0)
    TabLabel.Position = UDim2.new(0, 55, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = name
    TabLabel.TextColor3 = Color3.fromRGB(200, 200, 240)
    TabLabel.TextSize = 15
    TabLabel.Font = Enum.Font.GothamSemibold
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = name.."Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.Parent = ContentContainer
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 10)
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Parent = TabContent
    
    -- Tab Switch
    local function showTab()
        for _, content in pairs(ContentContainer:GetChildren()) do
            if content:IsA("Frame") then
                content.Visible = false
            end
        end
        TabContent.Visible = true
        
        -- Highlight tab
        for _, btn in pairs(TabContainer:GetChildren()) do
            if btn:IsA("ImageButton") then
                TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
            end
        end
        TweenService:Create(TabButton, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(60, 100, 200)}):Play()
    end
    
    TabButton.MouseButton1Click:Connect(showTab)
    
    -- Auto open first tab
    if #ContentContainer:GetChildren() <= 1 then
        showTab()
    end
    
    local tab = {}
    
    function tab:CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -20, 0, 40)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(220, 220, 255)
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 14
        Button.Parent = TabContent
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = Button
        
        local BtnGradient = Instance.new("UIGradient")
        BtnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 140, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 80, 220))
        }
        BtnGradient.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            if callback then callback() end
            -- Ripple effect สั้น ๆ
            local ripple = Instance.new("Frame")
            ripple.Size = UDim2.new(0,0,0,0)
            ripple.Position = UDim2.new(0.5,0,0.5,0)
            ripple.AnchorPoint = Vector2.new(0.5,0.5)
            ripple.BackgroundColor3 = Color3.fromRGB(255,255,255)
            ripple.BackgroundTransparency = 0.7
            ripple.ZIndex = 10
            ripple.Parent = Button
            local rippleCorner = Instance.new("UICorner")
            rippleCorner.CornerRadius = UDim.new(1,0)
            rippleCorner.Parent = ripple
            
            TweenService:Create(ripple, TweenInfo.new(0.6), {
                Size = UDim2.new(2,0,2,0),
                BackgroundTransparency = 1
            }):Play()
            game.Debris:AddItem(ripple, 0.7)
        end)
        
        return Button
    end
    
    -- เพิ่มฟังก์ชันอื่น ๆ ได้ เช่น Toggle, Slider ฯลฯ
    
    return tab
end

return Library
