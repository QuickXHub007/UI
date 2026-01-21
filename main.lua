-- UI Library Exploit สไตล์ 2025-2026 (Drag PC+Mobile + Toggle Button)
-- ใช้ loadstring(game:HttpGet("..."))()

local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "ExploitUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- สร้าง Frame หลัก (หน้าต่างที่ลากได้)
function Library:CreateWindow(title)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 480, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = gui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(60, 160, 255)
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.4
    Stroke.Parent = MainFrame

    -- Title Bar (ส่วนที่ลากได้ + ปุ่ม Toggle)
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 42)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "Exploit UI"
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- ปุ่ม Toggle (เปิด/ปิดทั้ง UI) แบบ ImageButton + ลากได้
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Size = UDim2.new(0, 36, 0, 36)
    ToggleButton.Position = UDim2.new(1, -48, 0, 3)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Image = "rbxassetid://7072718362" -- icon วงกลมมีเส้น (หรือเปลี่ยนเป็นของตัวเอง)
    ToggleButton.ImageColor3 = Color3.fromRGB(100, 180, 255)
    ToggleButton.Parent = TitleBar

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton

    -- ตัวแปรสถานะ
    local isOpen = true
    local dragging, dragInput, dragStart, startPos

    -- ฟังก์ชัน Drag (รองรับทั้ง Mouse + Touch)
    local function updateInput(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        MainFrame.Position = newPos
    end

    local function onInputBegan(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
            input.UserInputType == Enum.UserInputType.Touch) 
            and (input:GetFocusedTextBox() == nil) then
            
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end

    TitleBar.InputBegan:Connect(onInputBegan)
    ToggleButton.InputBegan:Connect(onInputBegan)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            updateInput(dragInput)
        end
    end)

    -- ปุ่ม Toggle เปิด/ปิด UI
    ToggleButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0,480,0,320)}):Play()
            ToggleButton.ImageColor3 = Color3.fromRGB(100, 180, 255)
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0,480,0,42)}):Play()
            ToggleButton.ImageColor3 = Color3.fromRGB(255, 80, 80)
        end
    end)

    -- Container สำหรับใส่ปุ่ม/เนื้อหา
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -50)
    Content.Position = UDim2.new(0, 0, 0, 50)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.FillDirection = Enum.FillDirection.Vertical
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = Content

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 14)
    Padding.PaddingRight = UDim.new(0, 14)
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.Parent = Content

    local window = {}

    -- ฟังก์ชันสร้างปุ่ม
    function window:Button(text, callback)
        local Button = Instance.new("ImageButton")
        Button.Size = UDim2.new(1, 0, 0, 38)
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        Button.BorderSizePixel = 0
        Button.ImageTransparency = 1
        Button.AutoButtonColor = false
        Button.Parent = Content

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = Button

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(80, 80, 120)
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.6
        btnStroke.Parent = Button

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(210, 210, 230)
        Label.TextSize = 15
        Label.Font = Enum.Font.GothamSemibold
        Label.Parent = Button

        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(55, 55, 75)}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.25), {Transparency = 0.3}):Play()
        end)

        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.25), {Transparency = 0.6}):Play()
        end)

        Button.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)

        return Button
    end

    return window
end

return Library
