-- Neon Exploit UI 2026 - Gradient + Tabs + Toggle + Dropdown + Resizable + Dynamic Title
-- Drag PC/Mobile + Toggle open/close

local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local gui = Instance.new("ScreenGui")
gui.Name = "NeonExploitUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- ดึงชื่อเกมจาก asset ID 10110028480
local windowTitle = "NEON EXECUTE"
pcall(function()
    local info = MarketplaceService:GetProductInfo(10110028480)
    if info and info.Name then
        windowTitle = info.Name  -- เช่น "[REVIVAL!!] ULTRA: the Game" หรืออะไรก็ตามที่ asset นี้เป็น
    end
end)

function Library:CreateWindow(customTitle)
    local titleToUse = customTitle or windowTitle

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 540, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -270, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = gui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 18)
    UICorner.Parent = MainFrame

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 10, 70)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 0, 140)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 40, 100))
    }
    UIGradient.Rotation = 35
    UIGradient.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(140, 100, 255)
    UIStroke.Thickness = 2.8
    UIStroke.Transparency = 0.3
    UIStroke.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = MainFrame

    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Size = UDim2.new(0, 36, 0, 36)
    TitleIcon.Position = UDim2.new(0, 14, 0.5, -18)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = "rbxassetid://126349969692217"
    TitleIcon.ImageColor3 = Color3.fromRGB(190, 130, 255)
    TitleIcon.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 60, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = titleToUse
    TitleLabel.TextColor3 = Color3.fromRGB(230, 210, 255)
    TitleLabel.TextSize = 21
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
    ToggleBtn.Position = UDim2.new(1, -52, 0, 5)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Image = "rbxassetid://7072721035"
    ToggleBtn.ImageColor3 = Color3.fromRGB(150, 110, 255)
    ToggleBtn.Parent = TitleBar

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1,0)
    ToggleCorner.Parent = ToggleBtn

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(210, 150, 255)
    ToggleStroke.Thickness = 2.2
    ToggleStroke.Transparency = 0.15
    ToggleStroke.Parent = ToggleBtn

    -- Tab Bar + Content
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 54)
    TabBar.Position = UDim2.new(0, 0, 0, 50)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 10)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabLayout.Parent = TabBar

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -110)
    ContentFrame.Position = UDim2.new(0, 0, 0, 104)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- Resizer (มุมขวาล่าง)
    local Resizer = Instance.new("ImageButton")
    Resizer.Size = UDim2.new(0, 24, 0, 24)
    Resizer.Position = UDim2.new(1, -24, 1, -24)
    Resizer.BackgroundTransparency = 1
    Resizer.Image = "rbxassetid://7072725342" -- icon ลากมุม (หรือเปลี่ยน)
    Resizer.ImageColor3 = Color3.fromRGB(180, 140, 255)
    Resizer.ZIndex = 10
    Resizer.Parent = MainFrame

    local resizing, resizeStart, startSize
    Resizer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = MainFrame.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newWidth = math.clamp(startSize.X.Offset + delta.X, 400, 900)
            local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 300, 700)
            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    -- Drag Logic (เหมือนเดิม แต่เพิ่มบน TitleBar)
    local dragging, dragInput, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then updateDrag(dragInput) end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)

    -- Toggle UI
    local isOpen = true
    ToggleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = MainFrame.Size}):Play() -- คงขนาดเดิม
            TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(150,110,255)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 50)}):Play()
            TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(255, 100, 110)}):Play()
        end
    end)

    local window = { Tabs = {} }

    function window:CreateTab(name, iconId)
        local TabButton = Instance.new("ImageButton")
        TabButton.Size = UDim2.new(0, 120, 0, 42)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 25, 70)
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabBar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 14)
        TabCorner.Parent = TabButton

        local TabGradient = Instance.new("UIGradient")
        TabGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 60, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 110, 255))
        }
        TabGradient.Parent = TabButton

        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = Color3.fromRGB(220, 160, 255)
        TabStroke.Thickness = 1.6
        TabStroke.Transparency = 0.45
        TabStroke.Parent = TabButton

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 26, 0, 26)
        Icon.Position = UDim2.new(0, 12, 0.5, -13)
        Icon.BackgroundTransparency = 1
        Icon.Image = iconId and "rbxassetid://" .. tostring(iconId) or "rbxassetid://126349969692217"
        Icon.ImageColor3 = Color3.fromRGB(255, 245, 255)
        Icon.Parent = TabButton

        local TabText = Instance.new("TextLabel")
        TabText.Size = UDim2.new(1, -50, 1, 0)
        TabText.Position = UDim2.new(0, 48, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = name
        TabText.TextColor3 = Color3.fromRGB(235, 225, 255)
        TabText.TextSize = 15
        TabText.Font = Enum.Font.GothamBold
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabButton

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(160, 120, 255)
        TabContent.Parent = ContentFrame

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 12)
        ListLayout.Parent = TabContent

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 18)
        Padding.PaddingRight = UDim.new(0, 18)
        Padding.PaddingTop = UDim.new(0, 14)
        Padding.Parent = TabContent

        local tab = { Content = TabContent, Button = TabButton }

        function tab:Toggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 44)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 30, 80)
            ToggleFrame.Parent = TabContent

            local TogCorner = Instance.new("UICorner")
            TogCorner.CornerRadius = UDim.new(0, 12)
            TogCorner.Parent = ToggleFrame

            local TogGradient = Instance.new("UIGradient")
            TogGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 50, 160)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 220))
            }
            TogGradient.Parent = ToggleFrame

            local TogLabel = Instance.new("TextLabel")
            TogLabel.Size = UDim2.new(0.7, 0, 1, 0)
            TogLabel.BackgroundTransparency = 1
            TogLabel.Text = text
            TogLabel.TextColor3 = Color3.fromRGB(240, 230, 255)
            TogLabel.TextSize = 16
            TogLabel.Font = Enum.Font.GothamSemibold
            TogLabel.TextXAlignment = Enum.TextXAlignment.Left
            TogLabel.Parent = ToggleFrame

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 48, 0, 24)
            Indicator.Position = UDim2.new(1, -60, 0.5, -12)
            Indicator.BackgroundColor3 = default and Color3.fromRGB(100, 255, 140) or Color3.fromRGB(255, 80, 80)
            Indicator.Parent = ToggleFrame

            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(1,0)
            IndCorner.Parent = Indicator

            local enabled = default

            local function updateToggle()
                TweenService:Create(Indicator, TweenInfo.new(0.3), {
                    BackgroundColor3 = enabled and Color3.fromRGB(100, 255, 140) or Color3.fromRGB(255, 80, 80),
                    Position = UDim2.new(1, enabled and -60 or -100, 0.5, -12)
                }):Play()
                if callback then callback(enabled) end
            end

            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    enabled = not enabled
                    updateToggle()
                end
            end)

            if default then updateToggle() end -- init

            return ToggleFrame
        end

        function tab:Dropdown(text, options, default, callback)
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 44)
            DropFrame.BackgroundColor3 = Color3.fromRGB(40, 30, 80)
            DropFrame.Parent = TabContent

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 12)
            DropCorner.Parent = DropFrame

            local DropGradient = Instance.new("UIGradient")
            DropGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 60, 180)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 100, 240))
            }
            DropGradient.Parent = DropFrame

            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(0.5, 0, 1, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = text
            DropLabel.TextColor3 = Color3.fromRGB(240, 230, 255)
            DropLabel.TextSize = 16
            DropLabel.Font = Enum.Font.GothamSemibold
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.Parent = DropFrame

            local Selected = Instance.new("TextLabel")
            Selected.Size = UDim2.new(0.45, 0, 0, 36)
            Selected.Position = UDim2.new(0.53, 0, 0.5, -18)
            Selected.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
            Selected.Text = default or options[1]
            Selected.TextColor3 = Color3.fromRGB(220, 210, 255)
            Selected.TextSize = 15
            Selected.Font = Enum.Font.Gotham
            Selected.Parent = DropFrame

            local SelCorner = Instance.new("UICorner")
            SelCorner.CornerRadius = UDim.new(0, 10)
            SelCorner.Parent = Selected

            local DropList = Instance.new("Frame")
            DropList.Size = UDim2.new(0.45, 0, 0, 0)
            DropList.Position = UDim2.new(0.53, 0, 1, 8)
            DropList.BackgroundColor3 = Color3.fromRGB(25, 15, 50)
            DropList.Visible = false
            DropList.Parent = DropFrame

            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 10)
            ListCorner.Parent = DropList

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Padding = UDim.new(0, 4)
            ListLayout.Parent = DropList

            for _, opt in ipairs(options) do
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 32)
                Btn.BackgroundTransparency = 1
                Btn.Text = opt
                Btn.TextColor3 = Color3.fromRGB(230, 220, 255)
                Btn.TextSize = 15
                Btn.Font = Enum.Font.Gotham
                Btn.Parent = DropList

                Btn.MouseButton1Click:Connect(function()
                    Selected.Text = opt
                    DropList.Visible = false
                    DropList.Size = UDim2.new(0.45, 0, 0, 0)
                    if callback then callback(opt) end
                end)

                Btn.MouseEnter:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                end)

                Btn.MouseLeave:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 220, 255)}):Play()
                end)
            end

            Selected.MouseButton1Click:Connect(function()
                DropList.Visible = not DropList.Visible
                if DropList.Visible then
                    local itemCount = math.min(#options, 6)
                    TweenService:Create(DropList, TweenInfo.new(0.3), {Size = UDim2.new(0.45, 0, 0, itemCount * 36 + 8)}):Play()
                else
                    TweenService:Create(DropList, TweenInfo.new(0.3), {Size = UDim2.new(0.45, 0, 0, 0)}):Play()
                end
            end)

            return DropFrame
        end

        -- Button (เหมือนเดิม แต่ปรับให้เข้ากับ theme ใหม่)
        function tab:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 46)
            Btn.BackgroundColor3 = Color3.fromRGB(50, 35, 100)
            Btn.BorderSizePixel = 0
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(245, 235, 255)
            Btn.TextSize = 17
            Btn.Font = Enum.Font.GothamBold
            Btn.Parent = TabContent

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 12)
            BtnCorner.Parent = Btn

            local BtnGradient = Instance.new("UIGradient")
            BtnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 70, 220)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 120, 255))
            }
            BtnGradient.Parent = Btn

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Color3.fromRGB(230, 170, 255)
            BtnStroke.Thickness = 1.5
            BtnStroke.Transparency = 0.35
            BtnStroke.Parent = Btn

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(80, 60, 160)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.25), {Transparency = 0.1}):Play()
            end)

            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(50, 35, 100)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.25), {Transparency = 0.35}):Play()
            end)

            Btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)

            return Btn
        end

        -- Tab switch
        local function selectTab()
            for _, t in pairs(window.Tabs) do
                t.Content.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            end
            TabContent.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.35), {
                BackgroundTransparency = 0.25,
                BackgroundColor3 = Color3.fromRGB(100, 70, 220)
            }):Play()
        end

        TabButton.MouseButton1Click:Connect(selectTab)

        table.insert(window.Tabs, tab)

        if #window.Tabs == 1 then selectTab() end

        return tab
    end

    return window
end

return Library
