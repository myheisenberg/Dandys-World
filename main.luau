local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SERVICE_SLUG = "zynexscripts"
local SAVE_PATH = "DandyWorld_Key.txt"
local DEFAULT_DISCORD = "https://discord.gg/ehbX2MVbTw"
local VSS_URL = "https://vault.pandauth.com/vss/e79d47ef0a959acf"

local PandaAuth = (function()
    local ok, lib = pcall(function()
        local src = game:HttpGet("https://secure.pandauth.com/pv4/lib")
        return loadstring(src)()
    end)
    if ok and type(lib) == "table" and type(lib.configure) == "function" then
        lib.configure({serviceId = SERVICE_SLUG, debug = false, kickOnDetect = false})
        return lib
    end
    return nil
end)()

local discordUrl = DEFAULT_DISCORD
pcall(function()
    local fetched = game:HttpGetAsync("https://raw.githubusercontent.com/myheisenberg/Fluent-Renewed/main/discord.txt")
    if fetched and fetched:find("discord.gg") then
        discordUrl = fetched:match("^%s*(.-)%s*$")
    end
end)

local function CheckWhitelist(key)
    if not key or key == "" then return false end
    key = string.gsub(key, "^%s*(.-)%s*$", "%1")
    if not PandaAuth then return false end
    local ok, res = pcall(function()
        return PandaAuth.validate(key)
    end)
    if ok and res and res.success == true then
        return true
    end
    return false
end

local function GetKeyURL()
    if PandaAuth then
        local ok, url = pcall(function() return PandaAuth.getKeyUrl() end)
        if ok and url and url ~= "" then return url end
    end
    return "https://ads.pandauth.com/getkey/" .. SERVICE_SLUG
end

local function LaunchMainScript()
    loadstring(game:HttpGet(VSS_URL))()
end

local function CreateKeyModal(onSuccess)
    if isfile and readfile and isfile(SAVE_PATH) then
        local savedKey = nil
        pcall(function() savedKey = readfile(SAVE_PATH) end)
        if savedKey and savedKey ~= "" then
            if CheckWhitelist(savedKey) then
                onSuccess()
                return
            end
        end
    end

    for _, name in ipairs({"Platoboost_AuthModal", "DandyWorld_AuthModal", "SniperArena_AuthModal", "Zynex_AuthModal"}) do
        local old = (gethui and gethui():FindFirstChild(name)) or CoreGui:FindFirstChild(name)
        if old then old:Destroy() end
        local oldRoblox = CoreGui:FindFirstChild("RobloxGui") and CoreGui.RobloxGui:FindFirstChild(name)
        if oldRoblox then oldRoblox:Destroy() end
    end

    local parent = (gethui and gethui()) or CoreGui:FindFirstChild("RobloxGui") or CoreGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Zynex_AuthModal"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = parent

    local Overlay = Instance.new("TextButton")
    Overlay.Name = "Overlay"
    Overlay.Text = ""
    Overlay.AutoButtonColor = false
    Overlay.Size = UDim2.fromScale(1, 1)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.55
    Overlay.BorderSizePixel = 0
    Overlay.Parent = ScreenGui

    local Card = Instance.new("Frame")
    Card.Name = "Card"
    Card.Size = UDim2.fromOffset(480, 255)
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.Position = UDim2.fromScale(0.5, 0.5)
    Card.BackgroundTransparency = 1
    Card.BorderSizePixel = 0
    Card.Parent = ScreenGui

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.fromScale(0.5, 0.5)
    Shadow.Size = UDim2.new(1, 110, 1, 110)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://8992230677"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(99, 99, 99, 99)
    Shadow.ZIndex = 1
    Shadow.Parent = Card

    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Size = UDim2.fromScale(1, 1)
    Background.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
    Background.BackgroundTransparency = 0.22
    Background.BorderSizePixel = 0
    Background.ZIndex = 2
    Background.Parent = Card

    local BgCorner = Instance.new("UICorner")
    BgCorner.CornerRadius = UDim.new(0, 8)
    BgCorner.Parent = Background

    local GradientFrame = Instance.new("Frame")
    GradientFrame.Name = "Gradient"
    GradientFrame.Size = UDim2.fromScale(1, 1)
    GradientFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GradientFrame.BackgroundTransparency = 0.75
    GradientFrame.BorderSizePixel = 0
    GradientFrame.ZIndex = 3
    GradientFrame.Parent = Background

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 58)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(34, 34, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 28))
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = GradientFrame

    local GradCorner = Instance.new("UICorner")
    GradCorner.CornerRadius = UDim.new(0, 8)
    GradCorner.Parent = GradientFrame

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(75, 75, 85)
    CardStroke.Transparency = 0.5
    CardStroke.Thickness = 1
    CardStroke.Parent = Card

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.fromScale(1, 1)
    Content.BackgroundTransparency = 1
    Content.ZIndex = 5
    Content.Parent = Card

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundTransparency = 1
    Header.Parent = Content

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Text = "Dandy's World Hub"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Position = UDim2.fromOffset(22, 12)
    TitleLabel.Size = UDim2.new(1, -60, 0, 18)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.AutoLocalize = false
    TitleLabel.Parent = Header

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Text = "Key System | Zynex Hub"
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextSize = 12
    SubtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Position = UDim2.fromOffset(22, 31)
    SubtitleLabel.Size = UDim2.new(1, -60, 0, 14)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.AutoLocalize = false
    SubtitleLabel.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Text = "×"
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.TextSize = 22
    CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    CloseBtn.Size = UDim2.fromOffset(32, 32)
    CloseBtn.Position = UDim2.new(1, -42, 0, 10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Header

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 90, 90)}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(180, 180, 190)}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local Body = Instance.new("Frame")
    Body.Name = "Body"
    Body.Size = UDim2.new(1, -44, 0, 100)
    Body.Position = UDim2.fromOffset(22, 58)
    Body.BackgroundTransparency = 1
    Body.Parent = Content

    local InputContainer = Instance.new("Frame")
    InputContainer.Name = "InputContainer"
    InputContainer.Size = UDim2.new(1, 0, 0, 42)
    InputContainer.Position = UDim2.fromOffset(0, 0)
    InputContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    InputContainer.BackgroundTransparency = 0.2
    InputContainer.BorderSizePixel = 0
    InputContainer.Parent = Body

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = InputContainer

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(65, 65, 75)
    InputStroke.Transparency = 0.5
    InputStroke.Thickness = 1
    InputStroke.Parent = InputContainer

    local TextBox = Instance.new("TextBox")
    TextBox.Name = "KeyInput"
    TextBox.Text = ""
    TextBox.PlaceholderText = "Paste your Panda key here..."
    TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 13
    TextBox.TextColor3 = Color3.fromRGB(245, 245, 250)
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.Size = UDim2.new(1, -70, 1, 0)
    TextBox.Position = UDim2.fromOffset(12, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.ClearTextOnFocus = false
    TextBox.AutoLocalize = false
    TextBox.Parent = InputContainer

    TextBox.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 120, 212), Transparency = 0}):Play()
    end)
    TextBox.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(65, 65, 75), Transparency = 0.5}):Play()
    end)

    local PasteBtn = Instance.new("TextButton")
    PasteBtn.Name = "PasteBtn"
    PasteBtn.Text = "Paste"
    PasteBtn.Font = Enum.Font.GothamBold
    PasteBtn.TextSize = 11
    PasteBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
    PasteBtn.Size = UDim2.fromOffset(48, 26)
    PasteBtn.Position = UDim2.new(1, -54, 0.5, -13)
    PasteBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
    PasteBtn.AutoButtonColor = false
    PasteBtn.AutoLocalize = false
    PasteBtn.Parent = InputContainer

    local PasteCorner = Instance.new("UICorner")
    PasteCorner.CornerRadius = UDim.new(0, 4)
    PasteCorner.Parent = PasteBtn

    PasteBtn.MouseEnter:Connect(function()
        TweenService:Create(PasteBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(56, 56, 64)}):Play()
    end)
    PasteBtn.MouseLeave:Connect(function()
        TweenService:Create(PasteBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(42, 42, 48)}):Play()
    end)
    PasteBtn.MouseButton1Click:Connect(function()
        local clip = nil
        pcall(function() clip = getclipboard and getclipboard() end)
        if clip and clip ~= "" then
            TextBox.Text = clip
        end
    end)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Text = "A key is required to access Dandy's World Hub."
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 12
    StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextWrapped = true
    StatusLabel.Position = UDim2.fromOffset(2, 50)
    StatusLabel.Size = UDim2.new(1, -4, 0, 36)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.AutoLocalize = false
    StatusLabel.Parent = Body

    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "Buttons"
    ButtonContainer.Size = UDim2.new(1, -44, 0, 38)
    ButtonContainer.Position = UDim2.fromOffset(22, 195)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.ZIndex = 6
    ButtonContainer.Parent = Content

    local LeftHolder = Instance.new("Frame")
    LeftHolder.Size = UDim2.fromScale(0.35, 1)
    LeftHolder.BackgroundTransparency = 1
    LeftHolder.Parent = ButtonContainer

    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.FillDirection = Enum.FillDirection.Horizontal
    LeftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    LeftLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LeftLayout.Padding = UDim.new(0, 8)
    LeftLayout.Parent = LeftHolder

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Name = "DiscordBtn"
    DiscordBtn.Text = "Discord"
    DiscordBtn.Font = Enum.Font.GothamMedium
    DiscordBtn.TextSize = 13
    DiscordBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
    DiscordBtn.Size = UDim2.fromOffset(80, 34)
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
    DiscordBtn.BackgroundTransparency = 0.2
    DiscordBtn.AutoButtonColor = false
    DiscordBtn.AutoLocalize = false
    DiscordBtn.ZIndex = 7
    DiscordBtn.Parent = LeftHolder

    local DiscordCorner = Instance.new("UICorner")
    DiscordCorner.CornerRadius = UDim.new(0, 4)
    DiscordCorner.Parent = DiscordBtn

    local DiscordStroke = Instance.new("UIStroke")
    DiscordStroke.Color = Color3.fromRGB(75, 75, 82)
    DiscordStroke.Transparency = 0.6
    DiscordStroke.Thickness = 1
    DiscordStroke.Parent = DiscordBtn

    DiscordBtn.MouseEnter:Connect(function()
        TweenService:Create(DiscordBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(56, 56, 64)}):Play()
    end)
    DiscordBtn.MouseLeave:Connect(function()
        TweenService:Create(DiscordBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(42, 42, 48)}):Play()
    end)
    DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(discordUrl)
            StatusLabel.Text = "Discord invite link copied to clipboard!"
            StatusLabel.TextColor3 = Color3.fromRGB(96, 205, 255)
        end
    end)

    local RightHolder = Instance.new("Frame")
    RightHolder.Size = UDim2.fromScale(0.65, 1)
    RightHolder.Position = UDim2.fromScale(0.35, 0)
    RightHolder.BackgroundTransparency = 1
    RightHolder.Parent = ButtonContainer

    local RightLayout = Instance.new("UIListLayout")
    RightLayout.FillDirection = Enum.FillDirection.Horizontal
    RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    RightLayout.Padding = UDim.new(0, 8)
    RightLayout.Parent = RightHolder

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Name = "GetKeyBtn"
    GetKeyBtn.Text = "Get Key"
    GetKeyBtn.Font = Enum.Font.GothamMedium
    GetKeyBtn.TextSize = 13
    GetKeyBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
    GetKeyBtn.Size = UDim2.fromOffset(85, 34)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 54)
    GetKeyBtn.BackgroundTransparency = 0.2
    GetKeyBtn.AutoButtonColor = false
    GetKeyBtn.AutoLocalize = false
    GetKeyBtn.ZIndex = 7
    GetKeyBtn.Parent = RightHolder

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 4)
    GetKeyCorner.Parent = GetKeyBtn

    local GetKeyStroke = Instance.new("UIStroke")
    GetKeyStroke.Color = Color3.fromRGB(75, 75, 82)
    GetKeyStroke.Transparency = 0.6
    GetKeyStroke.Thickness = 1
    GetKeyStroke.Parent = GetKeyBtn

    GetKeyBtn.MouseEnter:Connect(function()
        TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(62, 62, 70)}):Play()
    end)
    GetKeyBtn.MouseLeave:Connect(function()
        TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(48, 48, 54)}):Play()
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        local url = GetKeyURL()
        if setclipboard then
            setclipboard(url)
            StatusLabel.Text = "Key link copied to clipboard! Complete checkpoint in browser."
            StatusLabel.TextColor3 = Color3.fromRGB(96, 205, 255)
        else
            StatusLabel.Text = "Link: " .. url
            StatusLabel.TextColor3 = Color3.fromRGB(240, 200, 80)
        end
    end)

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Name = "VerifyBtn"
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 14
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Size = UDim2.fromOffset(115, 34)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
    VerifyBtn.BackgroundTransparency = 0
    VerifyBtn.AutoButtonColor = false
    VerifyBtn.AutoLocalize = false
    VerifyBtn.ZIndex = 7
    VerifyBtn.Parent = RightHolder

    local VerifyCorner = Instance.new("UICorner")
    VerifyCorner.CornerRadius = UDim.new(0, 4)
    VerifyCorner.Parent = VerifyBtn

    local VerifyStroke = Instance.new("UIStroke")
    VerifyStroke.Color = Color3.fromRGB(96, 205, 255)
    VerifyStroke.Transparency = 0.6
    VerifyStroke.Thickness = 1
    VerifyStroke.Parent = VerifyBtn

    VerifyBtn.MouseEnter:Connect(function()
        TweenService:Create(VerifyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(16, 137, 230)}):Play()
    end)
    VerifyBtn.MouseLeave:Connect(function()
        TweenService:Create(VerifyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 120, 212)}):Play()
    end)

    local verifying = false
    VerifyBtn.MouseButton1Click:Connect(function()
        if verifying then return end
        local entered = TextBox.Text
        if not entered or entered == "" then
            StatusLabel.Text = "Please paste your key into the text field first."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end

        verifying = true
        VerifyBtn.Text = "Checking..."
        StatusLabel.Text = "Validating key with PandaAuth..."
        StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 185)

        task.spawn(function()
            local valid = CheckWhitelist(entered)
            if valid then
                StatusLabel.Text = "Key verified successfully! Loading script..."
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 120)
                if writefile then
                    pcall(function() writefile(SAVE_PATH, entered) end)
                end
                task.wait(0.6)
                ScreenGui:Destroy()
                onSuccess()
            else
                StatusLabel.Text = "Invalid or expired key. Please get a new key."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                VerifyBtn.Text = "Verify Key"
                verifying = false
            end
        end)
    end)

    local dragging, dragInput, dragStart, startPos
    Card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Card.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Card.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

CreateKeyModal(LaunchMainScript)
