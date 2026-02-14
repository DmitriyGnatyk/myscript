--[[
╔═══════════════════════════════════════════════════════════════╗
║  ██████╗ ██████╗ ███████╗███╗   ███╗██╗██╗  ██╗   ██╗██╗   ██╗
║  ██╔══██╗██╔══██╗██╔════╝████╗ ████║██║██║  ╚██╗ ██╔╝██║   ██║
║  ██████╔╝██████╔╝█████╗  ██╔████╔██║██║██║   ╚████╔╝ ██║   ██║
║  ██╔═══╝ ██╔══██╗██╔══╝  ██║╚██╔╝██║██║██║    ╚██╔╝  ██║   ██║
║  ██║     ██║  ██║███████╗██║ ╚═╝ ██║██║███████╗██║   ╚██████╔╝
║  ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝╚══════╝╚═╝    ╚═════╝ 
║              ULTIMATE HUB v6.0 (МАКСИМАЛЬНО КРУТИЙ)             
║              Товсті повзунки, яскраві теми, RGB ефекти          
║              Відкриття/закриття без багів                        
╚═══════════════════════════════════════════════════════════════╝
--]]

-- ==================== СЕРВІСИ ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==================== ГЛОБАЛЬНИЙ СТАН ====================
_G.UltimateHub = _G.UltimateHub or {}
if _G.UltimateHub.Initialized then
    -- Якщо скрипт вже запущено, просто показуємо/ховаємо
    if _G.UltimateHub.MainMenu then
        _G.UltimateHub.MainMenu.Enabled = not _G.UltimateHub.MainMenu.Enabled
        if _G.UltimateHub.AvatarButton then
            _G.UltimateHub.AvatarButton.Enabled = not _G.UltimateHub.MainMenu.Enabled
        end
    end
    return
end
_G.UltimateHub.Initialized = true
_G.UltimateHub.CurrentTheme = "Graphite"
_G.UltimateHub.MenuOpen = false
_G.UltimateHub.RGBConnection = nil

-- ==================== ЯСКРАВІ ТЕМИ ====================
local themes = {
    Graphite = {
        name = "Графіт",
        bg = Color3.fromRGB(25, 25, 30),
        surface = Color3.fromRGB(40, 40, 45),
        card = Color3.fromRGB(55, 55, 60),
        primary = Color3.fromRGB(0, 200, 255),
        secondary = Color3.fromRGB(255, 100, 200),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(200, 200, 210),
        accent = Color3.fromRGB(255, 200, 100),
        glow = Color3.fromRGB(0, 200, 255),
    },
    DarkBlue = {
        name = "Темно-синя",
        bg = Color3.fromRGB(5, 15, 30),
        surface = Color3.fromRGB(15, 30, 50),
        card = Color3.fromRGB(25, 45, 70),
        primary = Color3.fromRGB(0, 150, 255),
        secondary = Color3.fromRGB(100, 200, 255),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(160, 190, 220),
        accent = Color3.fromRGB(200, 150, 255),
        glow = Color3.fromRGB(0, 100, 255),
    },
    Neon = {
        name = "Неон",
        bg = Color3.fromRGB(0, 0, 0),
        surface = Color3.fromRGB(20, 20, 20),
        card = Color3.fromRGB(40, 40, 40),
        primary = Color3.fromRGB(0, 255, 200),
        secondary = Color3.fromRGB(255, 0, 200),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(200, 200, 200),
        accent = Color3.fromRGB(255, 255, 0),
        glow = Color3.fromRGB(0, 255, 255),
    },
    RGB = {
        name = "RGB Динаміка",
        bg = Color3.fromRGB(0, 0, 0),
        surface = Color3.fromRGB(20, 20, 30),
        card = Color3.fromRGB(40, 35, 50),
        primary = Color3.fromRGB(255, 0, 0),
        secondary = Color3.fromRGB(0, 255, 0),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(200, 200, 220),
        accent = Color3.fromRGB(0, 100, 255),
        glow = Color3.fromRGB(255, 0, 255),
        dynamic = true,
    },
    Sunset = {
        name = "Захід сонця",
        bg = Color3.fromRGB(30, 20, 40),
        surface = Color3.fromRGB(50, 30, 50),
        card = Color3.fromRGB(70, 40, 60),
        primary = Color3.fromRGB(255, 120, 100),
        secondary = Color3.fromRGB(255, 200, 100),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(230, 200, 200),
        accent = Color3.fromRGB(200, 100, 255),
        glow = Color3.fromRGB(255, 100, 150),
    },
    Ocean = {
        name = "Океан",
        bg = Color3.fromRGB(0, 40, 60),
        surface = Color3.fromRGB(0, 60, 90),
        card = Color3.fromRGB(0, 80, 120),
        primary = Color3.fromRGB(0, 200, 200),
        secondary = Color3.fromRGB(100, 255, 200),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(180, 220, 230),
        accent = Color3.fromRGB(255, 200, 100),
        glow = Color3.fromRGB(0, 150, 200),
    }
}

-- ==================== ВИЗНАЧЕННЯ ПЛАТФОРМИ ====================
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local screenSize = Camera.ViewportSize
local menuWidth = isMobile and math.min(380, screenSize.X - 30) or 450
local menuHeight = isMobile and math.min(650, screenSize.Y - 80) or 580
local cornerRadius = isMobile and 24 or 18

-- ==================== ДОПОМІЖНІ ФУНКЦІЇ ====================
local function getTheme()
    return themes[_G.UltimateHub.CurrentTheme] or themes.Graphite
end

local function safeGetCharacter()
    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        return LocalPlayer.Character, LocalPlayer.Character.Humanoid
    end
    return nil, nil
end

local function notify(title, text, duration, type)
    type = type or "info"
    local gui = Instance.new("ScreenGui")
    gui.Name = "Notification"
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999

    local theme = getTheme()
    local color = type == "success" and theme.primary or type == "error" and Color3.fromRGB(255,80,80) or type == "warning" and Color3.fromRGB(255,200,80) or theme.accent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 90)
    frame.Position = UDim2.new(0.5, -150, 0, -100)
    frame.BackgroundColor3 = theme.surface
    frame.BackgroundTransparency = 0.1
    frame.ClipsDescendants = true
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = frame

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 6, 1, 0)
    line.BackgroundColor3 = color
    line.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -30, 0, 30)
    titleLabel.Position = UDim2.new(0, 25, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = color
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -30, 0, 40)
    textLabel.Position = UDim2.new(0, 25, 0, 40)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = theme.textDim
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame

    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0, 50)}):Play()
    task.wait(duration or 2.5)
    TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, -100)}):Play()
    task.wait(0.3)
    gui:Destroy()
end

-- ==================== RGB ЕФЕКТ ====================
local function startRGBEffect()
    if _G.UltimateHub.RGBConnection then
        _G.UltimateHub.RGBConnection:Disconnect()
    end
    local hue = 0
    _G.UltimateHub.RGBConnection = RunService.Heartbeat:Connect(function(dt)
        hue = (hue + dt * 0.15) % 1
        local color1 = Color3.fromHSV(hue, 1, 1)
        local color2 = Color3.fromHSV((hue + 0.3) % 1, 1, 1)
        local color3 = Color3.fromHSV((hue + 0.6) % 1, 1, 1)
        local theme = getTheme()
        if theme.dynamic then
            theme.primary = color1
            theme.secondary = color2
            theme.accent = color3
            theme.glow = color1
        end
    end)
end

-- ==================== ПРЕЛОАДЕР ====================
local function showLoader()
    local loaderGui = Instance.new("ScreenGui")
    loaderGui.Name = "Loader"
    loaderGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    loaderGui.ResetOnSpawn = false
    loaderGui.IgnoreGuiInset = true
    loaderGui.DisplayOrder = 1000

    local theme = getTheme()
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.bg
    bg.BackgroundTransparency = 0
    bg.Parent = loaderGui

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 350, 0, 100)
    logo.Position = UDim2.new(0.5, -175, 0.4, -50)
    logo.BackgroundTransparency = 1
    logo.Text = "ULTIMATE HUB"
    logo.TextColor3 = theme.primary
    logo.TextSize = 42
    logo.Font = Enum.Font.GothamBlack
    logo.TextTransparency = 0.3
    logo.Parent = bg

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0, 350, 0, 30)
    subtitle.Position = UDim2.new(0.5, -175, 0.5, 10)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Завантаження..."
    subtitle.TextColor3 = theme.textDim
    subtitle.TextSize = 20
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextTransparency = 0.3
    subtitle.Parent = bg

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, 280, 0, 8)
    barBg.Position = UDim2.new(0.5, -140, 0.6, 20)
    barBg.BackgroundColor3 = theme.surface
    barBg.Parent = bg
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = theme.primary
    fill.Parent = barBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local start = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local progress = math.min((tick() - start) / 2, 1) -- 2 сек
        fill.Size = UDim2.new(progress, 0, 1, 0)
        logo.TextTransparency = 0.2 + 0.3 * math.sin(tick() * 6)
        if progress >= 1 then
            conn:Disconnect()
            TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(logo, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(subtitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(barBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            loaderGui:Destroy()
        end
    end)
end

-- ==================== СТВОРЕННЯ АВАТАРКИ ====================
local function createAvatarButton()
    local avatarGui = Instance.new("ScreenGui")
    avatarGui.Name = "HubAvatar"
    avatarGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    avatarGui.ResetOnSpawn = false
    avatarGui.IgnoreGuiInset = true
    avatarGui.DisplayOrder = 100
    avatarGui.Enabled = false
    _G.UltimateHub.AvatarButton = avatarGui

    local theme = getTheme()
    local btnSize = 70
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, btnSize, 0, btnSize)
    btn.Position = UDim2.new(0, 25, 1, -btnSize-30)
    btn.BackgroundColor3 = theme.surface
    btn.BackgroundTransparency = 0.2
    btn.Image = ""
    btn.Parent = avatarGui

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 18)
    btnCorner.Parent = btn

    -- Тінь
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 15, 1, 15)
    shadow.Position = UDim2.new(0, -7, 0, -7)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13170652177"
    shadow.ImageColor3 = Color3.new(0,0,0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10,10,118,118)
    shadow.Parent = btn

    -- Завантаження аватарки
    task.spawn(function()
        local success, thumbnail = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100)
        end)
        if success and thumbnail then
            btn.Image = thumbnail
        else
            btn.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        end
    end)

    -- Перетягування
    local dragging = false
    local dragStart
    local btnStartPos

    local function updateDrag(input)
        if not dragging then return end
        local delta = input.Position - dragStart
        local newPosX = btnStartPos.X.Offset + delta.X
        local newPosY = btnStartPos.Y.Offset + delta.Y
        newPosX = math.clamp(newPosX, 10, screenSize.X - btnSize - 10)
        newPosY = math.clamp(newPosY, 10, screenSize.Y - btnSize - 10)
        btn.Position = UDim2.new(0, newPosX, 0, newPosY)
    end

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            btnStartPos = btn.Position
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input, processed)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            updateDrag(input)
        end
    end)

    -- Клік по аватарці відкриває меню
    btn.MouseButton1Click:Connect(function()
        avatarGui.Enabled = false
        if _G.UltimateHub.MainMenu then
            _G.UltimateHub.MainMenu.Enabled = true
        else
            createMainMenu()
        end
    end)

    return avatarGui
end

-- ==================== СТВОРЕННЯ МЕНЮ ====================
local function createMainMenu()
    local menuGui = Instance.new("ScreenGui")
    menuGui.Name = "UltimateHubMenu"
    menuGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    menuGui.ResetOnSpawn = false
    menuGui.IgnoreGuiInset = true
    menuGui.DisplayOrder = 200
    menuGui.Enabled = true
    _G.UltimateHub.MainMenu = menuGui

    local theme = getTheme()

    -- Затемнений фон для мобільних
    local overlay
    if isMobile then
        overlay = Instance.new("Frame")
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.new(0,0,0)
        overlay.BackgroundTransparency = 0.6
        overlay.Parent = menuGui
        overlay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                -- Закриваємо меню, показуємо аватарку
                menuGui.Enabled = false
                if _G.UltimateHub.AvatarButton then
                    _G.UltimateHub.AvatarButton.Enabled = true
                end
            end
        end)
    end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, menuWidth, 0, menuHeight)
    container.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2)
    container.BackgroundColor3 = theme.bg
    container.ClipsDescendants = true
    container.Parent = menuGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = container

    -- Тінь
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 25, 1, 25)
    shadow.Position = UDim2.new(0, -12, 0, -12)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13170652177"
    shadow.ImageColor3 = Color3.new(0,0,0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10,10,118,118)
    shadow.Parent = container

    -- Верхня панель
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 80)
    header.BackgroundColor3 = theme.surface
    header.Parent = container

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, cornerRadius)
    headerCorner.Parent = header

    -- Маска
    local mask = Instance.new("Frame")
    mask.Size = UDim2.new(1, 0, 0, cornerRadius)
    mask.Position = UDim2.new(0, 0, 1, -cornerRadius)
    mask.BackgroundColor3 = theme.surface
    mask.BorderSizePixel = 0
    mask.Parent = header

    -- Аватарка в заголовку
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 50, 0, 50)
    avatar.Position = UDim2.new(0, 15, 0.5, -25)
    avatar.BackgroundColor3 = theme.card
    avatar.Image = ""
    avatar.Parent = header
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 12)
    avatarCorner.Parent = avatar
    task.spawn(function()
        local success, thumb = pcall(function() return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100) end)
        if success then avatar.Image = thumb end
    end)

    -- Ім'я
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -120, 0, 30)
    nameLabel.Position = UDim2.new(0, 75, 0, 15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = LocalPlayer.Name
    nameLabel.TextColor3 = theme.text
    nameLabel.TextSize = 20
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = header

    local displayLabel = Instance.new("TextLabel")
    displayLabel.Size = UDim2.new(1, -120, 0, 20)
    displayLabel.Position = UDim2.new(0, 75, 0, 45)
    displayLabel.BackgroundTransparency = 1
    displayLabel.Text = "@" .. (LocalPlayer.DisplayName or LocalPlayer.Name)
    displayLabel.TextColor3 = theme.textDim
    displayLabel.TextSize = 14
    displayLabel.Font = Enum.Font.Gotham
    displayLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayLabel.Parent = header

    -- Кнопка закриття
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 45, 0, 45)
    closeBtn.Position = UDim2.new(1, -55, 0.5, -22)
    closeBtn.BackgroundColor3 = theme.surface
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = theme.textDim
    closeBtn.TextSize = 26
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function()
        menuGui.Enabled = false
        if _G.UltimateHub.AvatarButton then
            _G.UltimateHub.AvatarButton.Enabled = true
        end
    end)

    -- Вкладки
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, 48)
    tabContainer.Position = UDim2.new(0, 10, 0, 90)
    tabContainer.BackgroundColor3 = theme.surface
    tabContainer.Parent = container
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 14)
    tabCorner.Parent = tabContainer

    -- Контейнер контенту
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -160)
    contentFrame.Position = UDim2.new(0, 10, 0, 150)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = isMobile and 8 or 6
    contentFrame.ScrollBarImageColor3 = theme.primary
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = contentFrame
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)

    -- ========== ЕЛЕМЕНТИ ІНТЕРФЕЙСУ ==========
    local function createCard(title, desc, btnText, callback)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -10, 0, 90)
        card.BackgroundColor3 = theme.card
        card.Parent = contentFrame
        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 16)
        cardCorner.Parent = card

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -100, 0, 30)
        titleLabel.Position = UDim2.new(0, 15, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = theme.text
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = card

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -100, 0, 35)
        descLabel.Position = UDim2.new(0, 15, 0, 40)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = theme.textDim
        descLabel.TextSize = 13
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = card

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 0, 40)
        btn.Position = UDim2.new(1, -95, 0.5, -20)
        btn.BackgroundColor3 = theme.primary
        btn.Text = btnText
        btn.TextColor3 = theme.text
        btn.TextSize = 15
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.Parent = card
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 12)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 76, 0, 36)}):Play()
            task.wait(0.1)
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 80, 0, 40)}):Play()
            local ok, err = pcall(callback)
            if not ok then notify("Помилка", tostring(err), 2, "error") end
        end)
    end

    local function createToggle(text, desc, default, callback)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -10, 0, 80)
        card.BackgroundColor3 = theme.card
        card.Parent = contentFrame
        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 16)
        cardCorner.Parent = card

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -80, 0, 30)
        titleLabel.Position = UDim2.new(0, 15, 0, 8)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = text
        titleLabel.TextColor3 = theme.text
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = card

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -80, 0, 25)
        descLabel.Position = UDim2.new(0, 15, 0, 38)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = theme.textDim
        descLabel.TextSize = 13
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = card

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 60, 0, 32)
        toggleBtn.Position = UDim2.new(1, -75, 0.5, -16)
        toggleBtn.BackgroundColor3 = default and theme.primary or theme.surface
        toggleBtn.Text = ""
        toggleBtn.AutoButtonColor = false
        toggleBtn.Parent = card
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleBtn

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 26, 0, 26)
        circle.Position = default and UDim2.new(1, -30, 0.5, -13) or UDim2.new(0, 4, 0.5, -13)
        circle.BackgroundColor3 = theme.text
        circle.Parent = toggleBtn
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = circle

        local state = default
        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            local targetPos = state and UDim2.new(1, -30, 0.5, -13) or UDim2.new(0, 4, 0.5, -13)
            local targetColor = state and theme.primary or theme.surface
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            local ok, err = pcall(function() callback(state) end)
            if not ok then notify("Помилка", tostring(err), 2, "error") end
        end)
    end

    local function createSlider(text, min, max, default, unit, callback)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -10, 0, 120)
        card.BackgroundColor3 = theme.card
        card.Parent = contentFrame
        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 16)
        cardCorner.Parent = card

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -30, 0, 30)
        titleLabel.Position = UDim2.new(0, 15, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = text
        titleLabel.TextColor3 = theme.text
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = card

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 80, 0, 30)
        valueLabel.Position = UDim2.new(1, -100, 0, 10)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default) .. unit
        valueLabel.TextColor3 = theme.primary
        valueLabel.TextSize = 18
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = card

        -- Товстий слайдер (20px замість 6px)
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -40, 0, 20)
        sliderBg.Position = UDim2.new(0, 20, 0, 60)
        sliderBg.BackgroundColor3 = theme.surface
        sliderBg.Parent = card
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 10)
        sliderCorner.Parent = sliderBg

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        fill.BackgroundColor3 = theme.primary
        fill.Parent = sliderBg
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 10)
        fillCorner.Parent = fill

        -- Кружечок для зручності
        local handle = Instance.new("Frame")
        handle.Size = UDim2.new(0, 28, 0, 28)
        handle.Position = UDim2.new(fill.Size.X.Scale, -14, 0.5, -14)
        handle.BackgroundColor3 = theme.primary
        handle.Parent = fill
        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(1, 0)
        handleCorner.Parent = handle

        local val = default
        local dragging = false

        local function update(input)
            local absPos = sliderBg.AbsolutePosition
            local absSize = sliderBg.AbsoluteSize.X
            local pos = input.Position
            local rel = math.clamp((pos.X - absPos.X) / absSize, 0, 1)
            val = min + (max-min) * rel
            fill.Size = UDim2.new(rel, 0, 1, 0)
            handle.Position = UDim2.new(rel, -14, 0.5, -14)
            valueLabel.Text = math.floor(val*10)/10 .. unit
            callback(val)
        end

        if isMobile then
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)
            sliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.TouchMoved:Connect(function(input, proc)
                if dragging and not proc then update(input) end
            end)
        else
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)
            sliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
        end
    end

    -- ========== ФУНКЦІЇ ==========
    local flyConn, noclipConn, espConn, aimConn, farmConn = nil,nil,nil,nil,nil
    local function toggleFly(state)
        local char, hum = safeGetCharacter()
        if not char then return end
        if state then
            hum.PlatformStand = true
            if flyConn then flyConn:Disconnect() end
            flyConn = RunService.Heartbeat:Connect(function()
                if not state or not char then flyConn:Disconnect() return end
                local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
                if move.Magnitude > 0 then
                    char:SetPrimaryPartCFrame(char.PrimaryPart.CFrame + move.Unit * 0.7)
                end
            end)
        else
            if flyConn then flyConn:Disconnect() end
            if hum then hum.PlatformStand = false end
        end
    end

    local function toggleNoclip(state)
        local char = LocalPlayer.Character
        if not char then return end
        if state then
            if noclipConn then noclipConn:Disconnect() end
            noclipConn = RunService.Stepped:Connect(function()
                if not state or not char then noclipConn:Disconnect() return end
                for _,p in ipairs(char:GetChildren()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
            if char then
                for _,p in ipairs(char:GetChildren()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end
    end

    local function toggleESP(state)
        if state then
            if espConn then espConn:Disconnect() end
            espConn = RunService.Stepped:Connect(function()
                for _,pl in ipairs(Players:GetPlayers()) do
                    if pl~=LocalPlayer and pl.Character and not pl.Character:FindFirstChild("ESP_Highlight") then
                        local h = Instance.new("Highlight")
                        h.Name = "ESP_Highlight"
                        h.FillColor = theme.primary
                        h.OutlineColor = theme.secondary
                        h.FillTransparency = 0.5
                        h.Parent = pl.Character
                    end
                end
            end)
        else
            if espConn then espConn:Disconnect() end
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl.Character then
                    local h = pl.Character:FindFirstChild("ESP_Highlight")
                    if h then h:Destroy() end
                end
            end
        end
    end

    local function toggleAimbot(state)
        if state then
            if aimConn then aimConn:Disconnect() end
            aimConn = RunService.Heartbeat:Connect(function()
                if not state then return end
                local closest, dist = nil, math.huge
                for _,pl in ipairs(Players:GetPlayers()) do
                    if pl~=LocalPlayer and pl.Character and pl.Character:FindFirstChild("Head") then
                        local headPos = pl.Character.Head.Position
                        local sp, onScr = Camera:WorldToViewportPoint(headPos)
                        if onScr then
                            local mousePos = UserInputService:GetMouseLocation()
                            local d = (Vector2.new(sp.X,sp.Y) - mousePos).Magnitude
                            if d < dist and d < 150 then
                                dist = d
                                closest = pl
                            end
                        end
                    end
                end
                if closest then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, closest.Character.Head.Position)
                end
            end)
        else
            if aimConn then aimConn:Disconnect() end
        end
    end

    local function toggleAutoFarm(state)
        if state then
            if farmConn then farmConn:Disconnect() end
            farmConn = RunService.Heartbeat:Connect(function()
                if not state then return end
                local char = LocalPlayer.Character
                if not char then return end
                local root = char.PrimaryPart
                if not root then return end
                for _,obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Part") and obj:FindFirstChild("ClickDetector") then
                        if (obj.Position - root.Position).Magnitude < 25 then
                            obj.ClickDetector:Fire(root)
                        end
                    end
                end
            end)
        else
            if farmConn then farmConn:Disconnect() end
        end
    end

    -- ========== ВКЛАДКИ ==========
    local tabs = {"main", "move", "combat", "visual", "misc", "world", "theme"}
    local tabNames = {"ГОЛ", "РУХ", "БІЙ", "ЗІР", "ІНШЕ", "СВІТ", "ТЕМА"}
    local tabIcons = {"🏠", "⚡", "⚔️", "👁️", "⚙️", "🌍", "🎨"}
    local tabWidth = math.max(48, (menuWidth-40)/#tabs)

    local tabButtons = {}
    for i,tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, tabWidth-2, 0, 36)
        btn.Position = UDim2.new(0, 6 + (i-1)*(tabWidth+2), 0, 6)
        btn.BackgroundColor3 = (i==1) and theme.primary or theme.surface
        btn.Text = tabIcons[i] .. " " .. tabNames[i]
        btn.TextColor3 = theme.text
        btn.TextSize = isMobile and 12 or 14
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.Parent = tabContainer
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            for _,b in ipairs(tabButtons) do
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = theme.surface}):Play()
            end
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.primary}):Play()
            for _,v in ipairs(contentFrame:GetChildren()) do
                if v:IsA("Frame") then v:Destroy() end
            end

            if tab == "main" then
                createCard("Інформація", "Ultimate Hub v6.0\n6 тем, товсті слайдери", "OK", function() notify("Хаб", "Працює!",1) end)
                createCard("Очистити інвентар", "Викинути всі інструменти", "CLEAR", function()
                    if LocalPlayer.Character then
                        for _,t in ipairs(LocalPlayer.Character:GetChildren()) do
                            if t:IsA("Tool") then t.Parent = nil end
                        end
                        notify("Інвентар","Очищено",1,"success")
                    end
                end)
                createCard("Респавн", "Переродити персонажа", "RESPAWN", function()
                    LocalPlayer.Character:BreakJoints()
                    notify("Респавн","Персонаж відроджується",1)
                end)
            elseif tab == "move" then
                createSlider("Швидкість",16,500,50,"", function(v) local _,h=safeGetCharacter() if h then h.WalkSpeed=v end end)
                createSlider("Стрибки",50,500,100,"", function(v) local _,h=safeGetCharacter() if h then h.JumpPower=v end end)
                createSlider("Гравітація",0,500,196.2,"", function(v) Workspace.Gravity=v end)
                createToggle("Політ","Літати по карті",false,toggleFly)
                createToggle("NoClip","Крізь стіни",false,toggleNoclip)
                createCard("Телепорт на курсор","Переміститись туди, куди дивишся","TP", function()
                    local char = LocalPlayer.Character
                    if char and char.PrimaryPart then
                        local mpos = UserInputService:GetMouseLocation()
                        local ray = Camera:ScreenPointToRay(mpos.X, mpos.Y)
                        local params = RaycastParams.new()
                        params.FilterDescendantsInstances = {char}
                        local res = Workspace:Raycast(ray.Origin, ray.Direction*1000, params)
                        local pos = res and res.Position or ray.Origin + ray.Direction*100
                        char:SetPrimaryPartCFrame(CFrame.new(pos+Vector3.new(0,3,0)))
                        notify("Телепорт","Переміщено",1,"success")
                    end
                end)
            elseif tab == "combat" then
                createToggle("Безсмертя","Невразливість",false, function(s)
                    local _,h=safeGetCharacter()
                    if h then h.MaxHealth = s and math.huge or 100; h.Health = s and math.huge or 100 end
                end)
                createToggle("Aimbot","Автонаведення",false,toggleAimbot)
                createToggle("Авто-удар","Автоматична атака",false,function(s)
                    notify("Інфо","Працює тільки зі зброєю",2)
                end)
                createCard("Вбити всіх (тест)","Для тестування","KILL", function()
                    for _,p in ipairs(Players:GetPlayers()) do
                        if p~=LocalPlayer and p.Character then p.Character:BreakJoints() end
                    end
                    notify("Тест","Всі вбиті",2,"warning")
                end)
            elseif tab == "visual" then
                createToggle("ESP","Підсвічування гравців",false,toggleESP)
                createSlider("FOV",50,120,90,"", function(v) Camera.FieldOfView=v end)
                createToggle("X-Ray","Бачити крізь стіни",false, function(s)
                    for _,p in ipairs(Workspace:GetDescendants()) do
                        if p:IsA("BasePart") and p.Transparency<0.5 then
                            p.LocalTransparencyModifier = s and 0.7 or 0
                        end
                    end
                end)
                createCard("Змінити колір","Зробити себе яскравим","COLOR", function()
                    local char = LocalPlayer.Character
                    if char then
                        for _,p in ipairs(char:GetChildren()) do
                            if p:IsA("BasePart") then p.BrickColor = BrickColor.new("Bright red") end
                        end
                    end
                end)
            elseif tab == "misc" then
                createToggle("Авто-ферма","Автозбір предметів",false,toggleAutoFarm)
                createCard("Інфо про гру","Назва та ID","INFO", function()
                    local ok,info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
                    if ok then notify("Гра: "..info.Name,"ID: "..game.PlaceId,3) end
                end)
                createCard("Копіювати ID","У буфер обміну","COPY", function()
                    if setclipboard then setclipboard(tostring(game.PlaceId)); notify("Скопійовано","",1,"success") end
                end)
                createCard("Перезавантажити гру","Швидкий рестарт","RESTART", function()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)
            elseif tab == "world" then
                createSlider("Час доби",0,24,12,"h", function(v) Lighting.ClockTime=v end)
                createSlider("Яскравість",0,5,1,"", function(v) Lighting.Brightness=v end)
                createSlider("Туман",0,100,0,"%", function(v) Lighting.FogEnd=v*100 end)
                createCard("Дощ","Імітація дощу","RAIN", function()
                    Lighting:SetMinutesAfterMidnight(12)
                    notify("Погода","Дощ увімкнено",1)
                end)
            elseif tab == "theme" then
                for name, data in pairs(themes) do
                    createCard(data.name, "Активувати тему", "ВИБРАТИ", function()
                        _G.UltimateHub.CurrentTheme = name
                        if name == "RGB" then
                            startRGBEffect()
                        else
                            if _G.UltimateHub.RGBConnection then
                                _G.UltimateHub.RGBConnection:Disconnect()
                                _G.UltimateHub.RGBConnection = nil
                            end
                        end
                        menuGui:Destroy()
                        _G.UltimateHub.MainMenu = nil
                        createMainMenu()
                        notify("Тема", "Змінено на " .. data.name, 1, "success")
                    end)
                end
            end
        end)
        table.insert(tabButtons, btn)
    end

    -- Анімація появи
    container.Size = UDim2.new(0,0,0,0)
    TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, menuWidth, 0, menuHeight)}):Play()

    return menuGui
end

-- ==================== ЗАПУСК ====================
local function init()
    repeat task.wait() until LocalPlayer and LocalPlayer.Character
    task.wait(0.5)

    showLoader()
    task.wait(2)

    createAvatarButton()
    createMainMenu()

    notify("Ultimate Hub", "Меню відкрито. Закрий — з'явиться аватарка", 2, "success")
end

local s,e = pcall(init)
if not s then
    warn("Помилка: "..tostring(e))
end

-- Гаряча клавіша F4
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.F4 then
        if _G.UltimateHub.MainMenu and _G.UltimateHub.MainMenu.Enabled then
            _G.UltimateHub.MainMenu.Enabled = false
            if _G.UltimateHub.AvatarButton then
                _G.UltimateHub.AvatarButton.Enabled = true
            end
        elseif _G.UltimateHub.AvatarButton and not _G.UltimateHub.MainMenu.Enabled then
            _G.UltimateHub.MainMenu.Enabled = true
            _G.UltimateHub.AvatarButton.Enabled = false
        end
    end
end)
