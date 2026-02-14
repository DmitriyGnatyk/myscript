--[[
╔═══════════════════════════════════════════════════════════════╗
║  ██████╗ ██████╗ ███████╗███╗   ███╗██╗██╗  ██╗   ██╗██╗   ██╗
║  ██╔══██╗██╔══██╗██╔════╝████╗ ████║██║██║  ╚██╗ ██╔╝██║   ██║
║  ██████╔╝██████╔╝█████╗  ██╔████╔██║██║██║   ╚████╔╝ ██║   ██║
║  ██╔═══╝ ██╔══██╗██╔══╝  ██║╚██╔╝██║██║██║    ╚██╔╝  ██║   ██║
║  ██║     ██║  ██║███████╗██║ ╚═╝ ██║██║███████╗██║   ╚██████╔╝
║  ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝╚══════╝╚═╝    ╚═════╝ 
║              УНІВЕРСАЛЬНИЙ ХАБ v4.0 (АДАПТИВНИЙ)                 
║              Оптимізовано під ПК та ТЕЛЕФОН                     
║              З профілем гравця та 30+ функціями                 
╚═══════════════════════════════════════════════════════════════╝
--]]

-- ==================== СЕРВІСИ ТА ЗМІННІ ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ==================== КОЛЬОРОВА ТЕМА ====================
local colors = {
    bg = Color3.fromRGB(10, 10, 20),        -- Темно-синій
    surface = Color3.fromRGB(25, 25, 40),    -- Трохи світліший
    card = Color3.fromRGB(40, 40, 60),       -- Картковий
    primary = Color3.fromRGB(100, 150, 255), -- Світло-синій
    secondary = Color3.fromRGB(200, 100, 255),-- Фіолетовий
    success = Color3.fromRGB(100, 255, 150),  -- Зелений
    warning = Color3.fromRGB(255, 200, 80),  -- Жовтий
    error = Color3.fromRGB(255, 80, 120),    -- Червоний
    text = Color3.fromRGB(255, 255, 255),    -- Білий
    textDim = Color3.fromRGB(180, 180, 200),  -- Світло-сірий
}

-- ==================== ВИЗНАЧЕННЯ ПЛАТФОРМИ ====================
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local screenSize = Camera.ViewportSize
local isSmallScreen = screenSize.X < 600 or screenSize.Y < 600

-- Налаштування розмірів залежно від платформи
local menuWidth = isMobile and math.min(380, screenSize.X - 40) or 450
local menuHeight = isMobile and math.min(650, screenSize.Y - 80) or 550
local cornerRadius = isMobile and 24 or 16
local spacing = isMobile and 12 or 8

-- ==================== ДОПОМІЖНІ ФУНКЦІЇ ====================
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

    local color = type == "success" and colors.success or type == "error" and colors.error or type == "warning" and colors.warning or colors.primary

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 90)
    frame.Position = UDim2.new(0.5, -150, 0, -100)
    frame.BackgroundColor3 = colors.surface
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
    textLabel.TextColor3 = colors.textDim
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame

    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0, 50)}):Play()
    
    task.wait(duration or 3)
    
    TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, -100)}):Play()
    task.wait(0.3)
    gui:Destroy()
end

-- ==================== ПРЕЛОАДЕР (ДОВГИЙ ТА ПЛАВНИЙ) ====================
local function showLoader()
    local loaderGui = Instance.new("ScreenGui")
    loaderGui.Name = "Loader"
    loaderGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    loaderGui.ResetOnSpawn = false
    loaderGui.IgnoreGuiInset = true
    loaderGui.DisplayOrder = 1000

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = colors.bg
    bg.BackgroundTransparency = 0
    bg.Parent = loaderGui

    -- Логотип з анімацією
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 400, 0, 100)
    logo.Position = UDim2.new(0.5, -200, 0.3, -50)
    logo.BackgroundTransparency = 1
    logo.Text = "PREMIUM HUB"
    logo.TextColor3 = colors.primary
    logo.TextSize = 50
    logo.Font = Enum.Font.GothamBlack
    logo.TextTransparency = 0.5
    logo.Parent = bg

    -- Підзаголовок, що змінюється
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0, 400, 0, 30)
    subtitle.Position = UDim2.new(0.5, -200, 0.4, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Ініціалізація..."
    subtitle.TextColor3 = colors.textDim
    subtitle.TextSize = 20
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextTransparency = 0.5
    subtitle.Parent = bg

    -- Прогрес-бар
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 300, 0, 6)
    progressBar.Position = UDim2.new(0.5, -150, 0.5, -3)
    progressBar.BackgroundColor3 = colors.surface
    progressBar.Parent = bg

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(1, 0)
    progressCorner.Parent = progressBar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = colors.primary
    fill.Parent = progressBar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    -- Список повідомлень для зміни
    local messages = {
        "Завантаження модулів...",
        "Підключення до сервера...",
        "Ініціалізація інтерфейсу...",
        "Налаштування функцій...",
        "Майже готово...",
        "Запуск..."
    }

    -- Анімація
    local duration = 10 -- Секунд
    local startTime = tick()
    local messageIndex = 1
    local connection

    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        
        -- Прогрес-бар
        fill.Size = UDim2.new(progress, 0, 1, 0)
        
        -- Зміна повідомлень кожні 1.5 секунди
        if math.floor(elapsed / 1.5) + 1 > messageIndex then
            messageIndex = math.min(messageIndex + 1, #messages)
            subtitle.Text = messages[messageIndex]
            
            -- Анімація тексту
            TweenService:Create(subtitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
            task.wait(0.1)
            TweenService:Create(subtitle, TweenInfo.new(0.3), {TextTransparency = 0.5}):Play()
        end
        
        -- Пульсація логотипу
        logo.TextTransparency = 0.3 + 0.2 * math.sin(elapsed * 3)
        
        if progress >= 1 then
            connection:Disconnect()
            -- Плавне зникнення
            TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(logo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(subtitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(progressBar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            task.wait(0.5)
            loaderGui:Destroy()
        end
    end)

    return loaderGui
end

-- ==================== ОСНОВНЕ МЕНЮ ====================
local function createMainMenu()
    local menuGui = Instance.new("ScreenGui")
    menuGui.Name = "PremiumHub"
    menuGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    menuGui.ResetOnSpawn = false
    menuGui.IgnoreGuiInset = true
    menuGui.DisplayOrder = 100

    -- Затемнений фон (для мобільної версії клік по ньому закриває)
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.Parent = menuGui
    overlay.Visible = isMobile -- на ПК фон не затемнюємо

    -- Головний контейнер
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, menuWidth, 0, menuHeight)
    container.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2)
    container.BackgroundColor3 = colors.bg
    container.ClipsDescendants = true
    container.Parent = menuGui

    -- Заокруглення
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = container

    -- Тінь
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13170652177"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = container

    -- ========== ВЕРХНЯ ПАНЕЛЬ З ПРОФІЛЕМ ==========
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 80)
    header.BackgroundColor3 = colors.surface
    header.Parent = container

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, cornerRadius)
    headerCorner.Parent = header

    -- Маска для нижніх кутів
    local mask = Instance.new("Frame")
    mask.Size = UDim2.new(1, 0, 0, cornerRadius)
    mask.Position = UDim2.new(0, 0, 1, -cornerRadius)
    mask.BackgroundColor3 = colors.surface
    mask.BorderSizePixel = 0
    mask.Parent = header

    -- Аватарка
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 50, 0, 50)
    avatar.Position = UDim2.new(0, 15, 0.5, -25)
    avatar.BackgroundColor3 = colors.card
    avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100)
    avatar.Parent = header

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 12)
    avatarCorner.Parent = avatar

    -- Ім'я гравця
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -100, 0, 30)
    nameLabel.Position = UDim2.new(0, 75, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = LocalPlayer.Name
    nameLabel.TextColor3 = colors.text
    nameLabel.TextSize = 20
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = header

    -- DisplayName (якщо є)
    local displayLabel = Instance.new("TextLabel")
    displayLabel.Size = UDim2.new(1, -100, 0, 20)
    displayLabel.Position = UDim2.new(0, 75, 0, 40)
    displayLabel.BackgroundTransparency = 1
    displayLabel.Text = "@" .. (LocalPlayer.DisplayName or LocalPlayer.Name)
    displayLabel.TextColor3 = colors.textDim
    displayLabel.TextSize = 14
    displayLabel.Font = Enum.Font.Gotham
    displayLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayLabel.Parent = header

    -- Кнопка закриття
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -50, 0.5, -20)
    closeBtn.BackgroundColor3 = colors.surface
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = colors.textDim
    closeBtn.TextSize = 24
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = closeBtn

    -- ========== ВКЛАДКИ ==========
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, 50)
    tabContainer.Position = UDim2.new(0, 10, 0, 90)
    tabContainer.BackgroundColor3 = colors.surface
    tabContainer.Parent = container

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 12)
    tabCorner.Parent = tabContainer

    -- Контейнер для контенту (з скролом)
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -160)
    contentFrame.Position = UDim2.new(0, 10, 0, 150)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = isMobile and 6 or 4
    contentFrame.ScrollBarImageColor3 = colors.primary
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, spacing)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = contentFrame

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    -- ========== ФУНКЦІЇ ДЛЯ СТВОРЕННЯ ЕЛЕМЕНТІВ ==========
    local function createCard(title, description, buttonText, callback)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -10, 0, 90)
        card.BackgroundColor3 = colors.card
        card.Parent = contentFrame

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 12)
        cardCorner.Parent = card

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -110, 0, 25)
        titleLabel.Position = UDim2.new(0, 15, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = colors.text
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = card

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -110, 0, 35)
        descLabel.Position = UDim2.new(0, 15, 0, 35)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = description
        descLabel.TextColor3 = colors.textDim
        descLabel.TextSize = 13
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = card

        local actionBtn = Instance.new("TextButton")
        actionBtn.Size = UDim2.new(0, 80, 0, 40)
        actionBtn.Position = UDim2.new(1, -95, 0.5, -20)
        actionBtn.BackgroundColor3 = colors.primary
        actionBtn.Text = buttonText
        actionBtn.TextColor3 = colors.text
        actionBtn.TextSize = 14
        actionBtn.Font = Enum.Font.GothamBold
        actionBtn.AutoButtonColor = false
        actionBtn.Parent = card

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 12)
        btnCorner.Parent = actionBtn

        actionBtn.MouseButton1Click:Connect(function()
            TweenService:Create(actionBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 76, 0, 36)}):Play()
            task.wait(0.1)
            TweenService:Create(actionBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 80, 0, 40)}):Play()
            local success, err = pcall(callback)
            if not success then
                notify("Помилка", tostring(err), 2, "error")
            end
        end)

        return card
    end

    local function createToggle(text, description, default, callback)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -10, 0, 80)
        card.BackgroundColor3 = colors.card
        card.Parent = contentFrame

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 12)
        cardCorner.Parent = card

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -80, 0, 25)
        titleLabel.Position = UDim2.new(0, 15, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = text
        titleLabel.TextColor3 = colors.text
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = card

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -80, 0, 30)
        descLabel.Position = UDim2.new(0, 15, 0, 35)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = description
        descLabel.TextColor3 = colors.textDim
        descLabel.TextSize = 13
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = card

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 50, 0, 30)
        toggleBtn.Position = UDim2.new(1, -65, 0.5, -15)
        toggleBtn.BackgroundColor3 = default and colors.success or colors.surface
        toggleBtn.Text = ""
        toggleBtn.AutoButtonColor = false
        toggleBtn.Parent = card

        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleBtn

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 24, 0, 24)
        circle.Position = default and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
        circle.BackgroundColor3 = colors.text
        circle.Parent = toggleBtn

        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = circle

        local state = default

        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            local targetPos = state and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
            local targetColor = state and colors.success or colors.surface

            TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            
            local success, err = pcall(function() callback(state) end)
            if not success then
                notify("Помилка", tostring(err), 2, "error")
            end
        end)

        return card
    end

    local function createSlider(text, min, max, default, unit, callback)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -10, 0, 100)
        card.BackgroundColor3 = colors.card
        card.Parent = contentFrame

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 12)
        cardCorner.Parent = card

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -100, 0, 25)
        titleLabel.Position = UDim2.new(0, 15, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = text
        titleLabel.TextColor3 = colors.text
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = card

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 70, 0, 25)
        valueLabel.Position = UDim2.new(1, -85, 0, 10)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default) .. unit
        valueLabel.TextColor3 = colors.primary
        valueLabel.TextSize = 16
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = card

        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -30, 0, 8)
        sliderBg.Position = UDim2.new(0, 15, 0, 55)
        sliderBg.BackgroundColor3 = colors.surface
        sliderBg.Parent = card

        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(1, 0)
        sliderCorner.Parent = sliderBg

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = colors.primary
        fill.Parent = sliderBg

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill

        local value = default
        local dragging = false

        local function updateSlider(input)
            local absPos = sliderBg.AbsolutePosition
            local absSize = sliderBg.AbsoluteSize.X
            local pos = isMobile and input.Position or Vector2.new(input.Position.X, input.Position.Y)
            local relative = math.clamp((pos.X - absPos.X) / absSize, 0, 1)
            value = min + (max - min) * relative
            fill.Size = UDim2.new(relative, 0, 1, 0)
            valueLabel.Text = math.floor(value * 10) / 10 .. unit
            callback(value)
        end

        if isMobile then
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)

            sliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.TouchMoved:Connect(function(input, processed)
                if dragging and not processed then
                    updateSlider(input)
                end
            end)
        else
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)

            sliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
        end

        return card
    end

    -- ========== НАБІР ФУНКЦІЙ ==========
    local function getCharacter()
        return safeGetCharacter()
    end

    -- Глобальні змінні для станів
    local flyEnabled = false
    local flyConnection = nil
    local noclipEnabled = false
    local noclipConnection = nil
    local espEnabled = false
    local espConnection = nil
    local aimbotEnabled = false
    local aimbotConnection = nil
    local autoFarmEnabled = false
    local autoFarmConnection = nil

    -- Функції
    local function toggleFly(state)
        flyEnabled = state
        local char, hum = getCharacter()
        if not char then return end
        if state then
            hum.PlatformStand = true
            if flyConnection then flyConnection:Disconnect() end
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyEnabled or not char then 
                    if flyConnection then flyConnection:Disconnect() end
                    return 
                end
                local moveDir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                
                if moveDir.Magnitude > 0 then
                    char:SetPrimaryPartCFrame(char.PrimaryPart.CFrame + moveDir.Unit * 0.7)
                end
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            if hum then hum.PlatformStand = false end
        end
    end

    local function toggleNoclip(state)
        noclipEnabled = state
        local char = LocalPlayer.Character
        if not char then return end
        if state then
            if noclipConnection then noclipConnection:Disconnect() end
            noclipConnection = RunService.Stepped:Connect(function()
                if not noclipEnabled or not char then 
                    if noclipConnection then noclipConnection:Disconnect() end
                    return 
                end
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() end
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end

    local function toggleESP(state)
        espEnabled = state
        if state then
            if espConnection then espConnection:Disconnect() end
            espConnection = RunService.Stepped:Connect(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("ESP_Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESP_Highlight"
                        highlight.FillColor = colors.primary
                        highlight.OutlineColor = colors.secondary
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = player.Character
                    end
                end
            end)
        else
            if espConnection then espConnection:Disconnect() end
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("ESP_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end

    local function toggleAimbot(state)
        aimbotEnabled = state
        if state then
            if aimbotConnection then aimbotConnection:Disconnect() end
            aimbotConnection = RunService.Heartbeat:Connect(function()
                if not aimbotEnabled then return end
                local closestPlayer = nil
                local shortestDistance = math.huge
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                        local headPos = player.Character.Head.Position
                        local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                        if onScreen then
                            local mousePos = UserInputService:GetMouseLocation()
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if distance < shortestDistance and distance < 100 then
                                shortestDistance = distance
                                closestPlayer = player
                            end
                        end
                    end
                end
                if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
                    local headPos = closestPlayer.Character.Head.Position
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, headPos)
                end
            end)
        else
            if aimbotConnection then aimbotConnection:Disconnect() end
        end
    end

    local function toggleAutoFarm(state)
        autoFarmEnabled = state
        if state then
            if autoFarmConnection then autoFarmConnection:Disconnect() end
            autoFarmConnection = RunService.Heartbeat:Connect(function()
                if not autoFarmEnabled then return end
                -- Автоматичне збирання найближчих предметів (приклад)
                local char = LocalPlayer.Character
                if not char then return end
                local root = char.PrimaryPart
                if not root then return end
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Part") and obj:FindFirstChild("ClickDetector") then
                        local dist = (obj.Position - root.Position).Magnitude
                        if dist < 20 then
                            local click = obj:FindFirstChild("ClickDetector")
                            if click then
                                click:Fire(root)
                            end
                        end
                    end
                end
            end)
        else
            if autoFarmConnection then autoFarmConnection:Disconnect() end
        end
    end

    -- ========== ВКЛАДКИ ==========
    local tabs = {"main", "movement", "combat", "visual", "misc", "world"}
    local tabNames = {"ГОЛ", "РУХ", "БІЙ", "ЗІР", "ІНШЕ", "СВІТ"}
    local tabIcons = {"🏠", "⚡", "⚔️", "👁️", "⚙️", "🌍"}
    local tabButtons = {}
    local tabWidth = (menuWidth - 20 - (#tabs - 1) * 5) / #tabs

    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, tabWidth, 0, 36)
        btn.Position = UDim2.new(0, 5 + (i-1) * (tabWidth + 5), 0, 7)
        btn.BackgroundColor3 = (i == 1) and colors.primary or colors.surface
        btn.Text = tabIcons[i] .. " " .. tabNames[i]
        btn.TextColor3 = colors.text
        btn.TextSize = isMobile and 12 or 14
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.Parent = tabContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            for j, otherBtn in ipairs(tabButtons) do
                TweenService:Create(otherBtn, TweenInfo.new(0.2), {BackgroundColor3 = colors.surface}):Play()
            end
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = colors.primary}):Play()
            
            -- Очищаємо контент
            for _, v in ipairs(contentFrame:GetChildren()) do
                if v:IsA("Frame") then
                    v:Destroy()
                end
            end

            -- Заповнюємо відповідно до табу
            if tab == "main" then
                -- Головна з інформацією
                local infoCard = Instance.new("Frame")
                infoCard.Size = UDim2.new(1, -10, 0, 150)
                infoCard.BackgroundColor3 = colors.card
                infoCard.Parent = contentFrame

                local infoCorner = Instance.new("UICorner")
                infoCorner.CornerRadius = UDim.new(0, 12)
                infoCorner.Parent = infoCard

                local title = Instance.new("TextLabel")
                title.Size = UDim2.new(1, -20, 0, 30)
                title.Position = UDim2.new(0, 10, 0, 10)
                title.BackgroundTransparency = 1
                title.Text = "Premium Hub v4.0"
                title.TextColor3 = colors.primary
                title.TextSize = 22
                title.Font = Enum.Font.GothamBold
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Parent = infoCard

                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -20, 0, 80)
                desc.Position = UDim2.new(0, 10, 0, 50)
                desc.BackgroundTransparency = 1
                desc.Text = "Адаптивне меню з 30+ функціями.\nАвтор: Ваш покірний слуга\nДля тестування на власних серверах."
                desc.TextColor3 = colors.textDim
                desc.TextSize = 14
                desc.Font = Enum.Font.Gotham
                desc.TextWrapped = true
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Parent = infoCard

                createCard("Очистити інвентар", "Викинути всі інструменти", "CLEAR", function()
                    local char = LocalPlayer.Character
                    if char then
                        for _, tool in ipairs(char:GetChildren()) do
                            if tool:IsA("Tool") then
                                tool.Parent = nil
                            end
                        end
                        notify("Інвентар", "Очищено", 1, "success")
                    end
                end)

                createCard("Респавн", "Переродити персонажа", "RESPAWN", function()
                    LocalPlayer.Character:BreakJoints()
                    notify("Респавн", "Персонаж відроджується", 1)
                end)

            elseif tab == "movement" then
                createSlider("Швидкість ходьби", 16, 500, 50, "", function(val)
                    local _, hum = getCharacter()
                    if hum then hum.WalkSpeed = val end
                end)
                createSlider("Сила стрибка", 50, 500, 100, "", function(val)
                    local _, hum = getCharacter()
                    if hum then hum.JumpPower = val end
                end)
                createSlider("Гравітація", 0, 500, 196.2, "", function(val)
                    Workspace.Gravity = val
                end)
                createToggle("Політ", "Літати по карті", false, toggleFly)
                createToggle("NoClip", "Проходити крізь стіни", false, toggleNoclip)
                createCard("Телепорт на курсор", "Перенестись туди, куди дивишся", "TP", function()
                    local char = LocalPlayer.Character
                    if char and char.PrimaryPart then
                        local ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
                        local params = RaycastParams.new()
                        params.FilterType = Enum.RaycastFilterType.Blacklist
                        params.FilterDescendantsInstances = {char}
                        local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
                        local pos = result and result.Position or ray.Origin + ray.Direction * 100
                        char:SetPrimaryPartCFrame(CFrame.new(pos + Vector3.new(0, 3, 0)))
                        notify("Телепорт", "Переміщено", 1, "success")
                    end
                end)

            elseif tab == "combat" then
                createToggle("Безсмертя", "Невразливість", false, function(state)
                    local _, hum = getCharacter()
                    if hum then
                        if state then
                            hum.MaxHealth = math.huge
                            hum.Health = math.huge
                        else
                            hum.MaxHealth = 100
                            hum.Health = 100
                        end
                    end
                end)
                createToggle("Aimbot", "Автонаведення на голову", false, toggleAimbot)
                createToggle("Авто-удар", "Автоматично бити найближчого", false, function(state)
                    -- Це залежить від гри, тут заглушка
                    notify("Інфо", "Працює тільки в іграх з інструментами", 2)
                end)
                createCard("Вбити всіх (тест)", "Не працює в реальних іграх", "KILL", function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            player.Character:BreakJoints()
                        end
                    end
                    notify("Тест", "Всі гравці знищені", 2, "warning")
                end)

            elseif tab == "visual" then
                createToggle("ESP", "Підсвічування гравців", false, toggleESP)
                createSlider("Огляд (FOV)", 50, 120, 90, "", function(val)
                    Camera.FieldOfView = val
                end)
                createToggle("X-Ray (стіни)", "Бачити крізь стіни (експерим.)", false, function(state)
                    for _, part in ipairs(Workspace:GetDescendants()) do
                        if part:IsA("BasePart") and part.Transparency < 0.5 then
                            if state then
                                part.LocalTransparencyModifier = 0.7
                            else
                                part.LocalTransparencyModifier = 0
                            end
                        end
                    end
                end)
                createCard("Змінити колір гравця", "Зробити себе яскравим", "COLOR", function()
                    local char = LocalPlayer.Character
                    if char then
                        for _, part in ipairs(char:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.BrickColor = BrickColor.new("Bright red")
                            end
                        end
                    end
                end)

            elseif tab == "misc" then
                createToggle("Авто-ферма", "Автоматичне збирання предметів", false, toggleAutoFarm)
                createCard("Інфо про гру", "Назва та місце", "INFO", function()
                    local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
                    notify("Гра: " .. productInfo.Name, "ID: " .. game.PlaceId, 3)
                end)
                createCard("Копіювати ID гри", "У буфер обміну", "COPY", function()
                    setclipboard and setclipboard(tostring(game.PlaceId)) or notify("Помилка", "Функція не підтримується", 1, "error")
                end)
                createCard("Перезавантажити гру", "Швидкий рестарт", "RESTART", function()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)

            elseif tab == "world" then
                createSlider("Час доби", 0, 24, 12, "h", function(val)
                    Lighting.ClockTime = val
                end)
                createSlider("Яскравість", 0, 5, 1, "", function(val)
                    Lighting.Brightness = val
                end)
                createSlider("Туман", 0, 100, 0, "%", function(val)
                    Lighting.FogEnd = val * 100
                end)
                createCard("Дощ", "Увімкнути дощ", "RAIN", function()
                    Lighting:SetMinutesAfterMidnight(12)
                    local rain = Instance.new("ParticleEmitter")
                    -- Складніше, можна просто змінити погоду
                    notify("Погода", "Дощ увімкнено (імітація)", 1)
                end)
            end
        end)

        table.insert(tabButtons, btn)
    end

    -- Анімація появи
    container.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, menuWidth, 0, menuHeight)}):Play()

    -- Закриття
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        if overlay then
            TweenService:Create(overlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        end
        task.wait(0.3)
        menuGui:Destroy()
    end)

    if isMobile then
        overlay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                closeBtn.MouseButton1Click:Fire()
            end
        end)
    end

    -- Гаряча клавіша для закриття/відкриття (F4)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.F4 then
            menuGui.Enabled = not menuGui.Enabled
        end
    end)

    return menuGui
end

-- ==================== ЗАПУСК ====================
local function init()
    repeat task.wait() until LocalPlayer and LocalPlayer.Character
    task.wait(1)
    
    -- Показуємо прелоадер (10 секунд)
    local loader = showLoader()
    task.wait(10) -- Чекаємо завершення прелоадера (але він сам закриється через 10 сек)
    
    -- Створюємо меню
    local menu = createMainMenu()
    
    notify("Premium Hub", "Меню завантажено! Натисніть F4 щоб приховати", 3, "success")
end

local success, err = pcall(init)
if not success then
    warn("Помилка: " .. tostring(err))
end
