-- Exploit UI Library 2026 - Neon Cyber Gradient + Tab System + Drag PC/Mobile
-- Icon: rbxassetid://126349969692217

local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "NeonExploitUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- สร้างหน้าต่างหลัก
function Library:CreateWindow(title)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 520, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = gui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = MainFrame

    -- Gradient Background (cyber neon style)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 10, 60)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 0, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 30, 80))
    }
    UIGradient.Rotation = 45
    UIGradient.Parent = MainFrame

    -- Glow Stroke
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(120, 80, 255)
    UIStroke.Thickness = 2.5
    UIStroke.Transparency = 0.35
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 48)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = MainFrame

    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Size = UDim2.new(0, 32, 0, 32)
    TitleIcon.Position = UDim2.new(0, 16, 0.5, -16)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = "rbxassetid://126349969692217"
    TitleIcon.ImageColor3 = Color3.fromRGB(180, 120, 255)
    TitleIcon.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 60, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "NEON EXECUTE"
    TitleLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
    TitleLabel.TextSize = 20
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Toggle Button (mini circle neon)
    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Size = UDim2.new(0, 38, 0, 38)
    ToggleBtn.Position = UDim2.new(1, -50, 0, 5)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Image = "rbxassetid://7072721035" -- วงกลม glow (หรือเปลี่ยน)
    ToggleBtn.ImageColor3 = Color3.fromRGB(140, 100, 255)
    ToggleBtn.Parent = TitleBar

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1,0)
    ToggleCorner.Parent = ToggleBtn

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(200, 140, 255)
    ToggleStroke.Thickness = 2
    ToggleStroke.Transparency = 0.2
    ToggleStroke.Parent = ToggleBtn

    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 50)
    TabBar.Position = UDim2.new(0, 0, 0, 48)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabBar

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 20)
    UIPadding.PaddingRight = UDim.new(0, 20)
    UIPadding.Parent = TabBar

    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -100)
    ContentFrame.Position = UDim2.new(0, 0, 0, 100)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- Drag Logic (PC + Mobile)
    local dragging, dragInput, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then updateDrag(dragInput) end
    end)

    -- Toggle open/close
    local isOpen = true
    ToggleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,520,0,360)}):Play()
            TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(140,100,255)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,520,0,48)}):Play()
            TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(255,90,100)}):Play()
        end
    end)

    local window = { Tabs = {} }

    -- สร้าง Tab
    function window:CreateTab(name, iconId)
        local TabButton = Instance.new("ImageButton")
        TabButton.Size = UDim2.new(0, 110, 0, 38)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabBar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 12)
        TabCorner.Parent = TabButton

        local TabGradient = Instance.new("UIGradient")
        TabGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 50, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 80, 255))
        }
        TabGradient.Rotation = 90
        TabGradient.Parent = TabButton

        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = Color3.fromRGB(200, 140, 255)
        TabStroke.Thickness = 1.8
        TabStroke.Transparency = 0.5
        TabStroke.Parent = TabButton

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 24, 0, 24)
        Icon.Position = UDim2.new(0, 12, 0.5, -12)
        Icon.BackgroundTransparency = 1
        Icon.Image = iconId and "rbxassetid://" .. iconId or "rbxassetid://126349969692217"
        Icon.ImageColor3 = Color3.fromRGB(255, 240, 255)
        Icon.Parent = TabButton

        local TabText = Instance.new("TextLabel")
        TabText.Size = UDim2.new(1, -50, 1, 0)
        TabText.Position = UDim2.new(0, 46, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = name
        TabText.TextColor3 = Color3.fromRGB(230, 220, 255)
        TabText.TextSize = 15
        TabText.Font = Enum.Font.GothamBold
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabButton

        -- Content สำหรับ tab นี้
        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentFrame

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 10)
        ListLayout.Parent = TabContent

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 16)
        Padding.PaddingRight = UDim.new(0, 16)
        Padding.PaddingTop = UDim.new(0, 12)
        Padding.Parent = TabContent

        -- เก็บ tab
        local tab = { Content = TabContent }

        function tab:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 42)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 30, 90)
            Btn.BorderSizePixel = 0
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(240, 230, 255)
            Btn.TextSize = 16
            Btn.Font = Enum.Font.GothamSemibold
            Btn.Parent = TabContent

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 10)
            BtnCorner.Parent = Btn

            local BtnGradient = Instance.new("UIGradient")
            BtnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 60, 200)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
            }
            BtnGradient.Parent = Btn

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Color3.fromRGB(220, 160, 255)
            BtnStroke.Thickness = 1.4
            BtnStroke.Transparency = 0.4
            BtnStroke.Parent = Btn

            -- Hover + Click effect
            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(70, 50, 140)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.25), {Transparency = 0.1}):Play()
            end)

            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 30, 90)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.25), {Transparency = 0.4}):Play()
            end)

            Btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)

            return Btn
        end

        -- Switch tab เมื่อกด
        local function selectThisTab()
            for _, otherTab in pairs(window.Tabs) do
                otherTab.Content.Visible = false
                TweenService:Create(otherTab.Button, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play() -- reset
            end
            TabContent.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.3,
                BackgroundColor3 = Color3.fromRGB(80, 50, 180)
            }):Play()
        end

        TabButton.MouseButton1Click:Connect(selectThisTab)

        table.insert(window.Tabs, {Button = TabButton, Content = TabContent})

        -- Tab แรกให้เปิดเลย
        if #window.Tabs == 1 then
            selectThisTab()
        end

        return tab
    end

    return window
end

return Library
