-- // Exploit UI Library v1.0 - Cool Gradient Style
-- // Support PC + Mobile Drag, Minimize Button, Tabs, ImageButton
-- // Usage: loadstring(game:HttpGet("your_link"))()

local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- // Config สีเท่ ๆ (gradient dark cyberpunk vibe)
local Theme = {
    Accent = Color3.fromRGB(0, 255, 200),
    Dark = Color3.fromRGB(10, 10, 25),
    Darker = Color3.fromRGB(5, 5, 15),
    Text = Color3.fromRGB(220, 220, 255),
    Gradient1 = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 60)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 80, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 150))
    }
}

-- // สร้าง ScreenGui
function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ExploitUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 520, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
    MainFrame.BackgroundColor3 = Theme.Dark
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Gradient Background
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = Theme.Gradient1
    UIGradient.Rotation = 45
    UIGradient.Parent = MainFrame

    -- Corner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Stroke glow
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Theme.Accent
    UIStroke.Transparency = 0.4
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame

    -- Title Bar (สำหรับ drag)
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0.03, 0, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "Exploit Hub"
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 20
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Minimize / Close Button (ImageButton)
    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
    MinimizeButton.Position = UDim2.new(1, -38, 0.5, -14)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Image = "rbxassetid://126349969692217"  -- เปลี่ยนเป็น ID ที่ต้องการ หรือใช้ icon วงกลม -
    MinimizeButton.ImageColor3 = Theme.Accent
    MinimizeButton.Parent = TitleBar

    local CloseButton = Instance.new("ImageButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -70, 0.5, -14)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Image = "rbxassetid://7072721035"  -- icon X ปิด (หรือใช้ของตัวเอง)
    CloseButton.ImageColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.Parent = TitleBar

    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0.22, 0, 1, -45)
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.BackgroundTransparency = 0.3
    TabContainer.BackgroundColor3 = Theme.Darker
    TabContainer.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 8)
    TabList.Parent = TabContainer

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(0.78, 0, 1, -45)
    ContentContainer.Position = UDim2.new(0.22, 0, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    -- // Drag Logic (PC + Mobile)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        MainFrame.Position = newPos
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
            update(input)
        end
    end)

    -- Minimize Toggle
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 520, 0, 45)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 520, 0, 380)}):Play()
        end
    end)

    -- Close
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local window = {}
    local currentTab = nil

    function window:CreateTab(name)
        local TabButton = Instance.new("ImageButton")
        TabButton.Size = UDim2.new(1, -16, 0, 40)
        TabButton.BackgroundTransparency = 0.4
        TabButton.BackgroundColor3 = Theme.Dark
        TabButton.ImageTransparency = 0.6
        TabButton.Image = "rbxassetid://126349969692217"  -- icon tab (หรือเปลี่ยน)
        TabButton.ImageColor3 = Theme.Accent
        TabButton.Parent = TabContainer

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabButton

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -50, 1, 0)
        TabLabel.Position = UDim2.new(0, 45, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = Theme.Text
        TabLabel.TextSize = 16
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        local UIPaddingContent = Instance.new("UIPadding")
        UIPaddingContent.PaddingTop = UDim.new(0, 12)
        UIPaddingContent.PaddingLeft = UDim.new(0, 12)
        UIPaddingContent.PaddingRight = UDim.new(0, 12)
        UIPaddingContent.Parent = TabContent

        local UIList = Instance.new("UIListLayout")
        UIList.Padding = UDim.new(0, 10)
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        UIList.Parent = TabContent

        TabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            TabContent.Visible = true
            currentTab = TabContent

            -- Highlight tab
            for _, btn in TabContainer:GetChildren() do
                if btn:IsA("ImageButton") then
                    TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.4}):Play()
                end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
        end)

        local tab = {}

        function tab:Button(text, callback)
            local Btn = Instance.new("ImageButton")
            Btn.Size = UDim2.new(1, 0, 0, 42)
            Btn.BackgroundColor3 = Theme.Dark
            Btn.ImageTransparency = 1
            Btn.Parent = TabContent

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 10)
            BtnCorner.Parent = Btn

            local BtnLabel = Instance.new("TextLabel")
            BtnLabel.Size = UDim2.new(1, 0, 1, 0)
            BtnLabel.BackgroundTransparency = 1
            BtnLabel.Text = text
            BtnLabel.TextColor3 = Theme.Text
            BtnLabel.Font = Enum.Font.Gotham
            BtnLabel.TextSize = 15
            BtnLabel.Parent = Btn

            Btn.MouseButton1Click:Connect(callback or function() end)

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 60)}):Play()
            end)

            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Dark}):Play()
            end)

            return Btn
        end

        function tab:Toggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Parent = TabContent

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.8, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 15
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 44, 0, 24)
            Indicator.Position = UDim2.new(1, -54, 0.5, -12)
            Indicator.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(60, 60, 70)
            Indicator.Parent = ToggleFrame

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = Indicator

            local state = default or false

            local function updateToggle()
                TweenService:Create(Indicator, TweenInfo.new(0.3), {
                    BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60, 60, 70)
                }):Play()
                if callback then callback(state) end
            end

            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    state = not state
                    updateToggle()
                end
            end)

            updateToggle()

            return { Toggle = function(v) state = v updateToggle() end }
        end

        function tab:Dropdown(text, options, callback)
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 42)
            DropFrame.BackgroundColor3 = Theme.Dark
            DropFrame.Parent = TabContent

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 10)
            DropCorner.Parent = DropFrame

            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(0.7, 0, 1, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = text
            DropLabel.TextColor3 = Theme.Text
            DropLabel.TextSize = 15
            DropLabel.Parent = DropFrame

            local Selected = Instance.new("TextLabel")
            Selected.Size = UDim2.new(0.3, -10, 0.8, 0)
            Selected.Position = UDim2.new(0.7, 5, 0.1, 0)
            Selected.BackgroundColor3 = Theme.Darker
            Selected.Text = options[1] or "..."
            Selected.TextColor3 = Theme.Accent
            Selected.TextSize = 14
            Selected.Parent = DropFrame

            local SelectedCorner = Instance.new("UICorner")
            SelectedCorner.CornerRadius = UDim.new(0, 8)
            SelectedCorner.Parent = Selected

            -- Dropdown logic (simple version)
            local listVisible = false
            local List = Instance.new("ScrollingFrame")
            List.Size = UDim2.new(0.3, -10, 0, 0)
            List.Position = UDim2.new(0.7, 5, 1, 5)
            List.BackgroundColor3 = Theme.Darker
            List.Visible = false
            List.CanvasSize = UDim2.new(0,0,0,0)
            List.Parent = DropFrame

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Padding = UDim.new(0, 4)
            ListLayout.Parent = List

            for _, opt in ipairs(options) do
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 30)
                Btn.BackgroundTransparency = 1
                Btn.Text = opt
                Btn.TextColor3 = Theme.Text
                Btn.Parent = List

                Btn.MouseButton1Click:Connect(function()
                    Selected.Text = opt
                    List.Visible = false
                    listVisible = false
                    if callback then callback(opt) end
                end)
            end

            List.CanvasSize = UDim2.new(0,0,0, #options * 34)

            Selected.MouseButton1Click:Connect(function()
                listVisible = not listVisible
                List.Visible = listVisible
                List.Size = UDim2.new(0.3, -10, 0, math.min(#options * 34, 140))
            end)

            return { Set = function(v) Selected.Text = v end }
        end

        return tab
    end

    -- Auto open first tab if exist
    if #TabContainer:GetChildren() > 0 then
        TabContainer:GetChildren()[1]:InputBegan:Fire(Enum.UserInputType.MouseButton1)
    end

    return window
end

return Library
