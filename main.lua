
-- [[ ============================================================================================= ]]
-- [[                                                                                               ]]
-- [[                                  CHRISSHUB V2 - REMODELACIÓN SUPREMA                          ]]
-- [[                                                                                               ]]
-- [[                                  DEVELOPED BY: SASWARE32                                      ]]
-- [[                                  STYLE: BLUE NEON FUTURISTIC                                  ]]
-- [[                                  VERSION: 3.0.0 (FULL DETALLES)                               ]]
-- [[                                                                                               ]]
-- [[ ============================================================================================= ]]

-- [[ 1. SERVICIOS Y VARIABLES GLOBALES ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [[ 2. TABLA DE CONFIGURACIÓN Y ESTADOS ]]
local CH_DATA = {
    Toggles = {
        Noclip = false,
        InfJump = false,
        WalkSpeed = false,
        Aimbot = false,
        KillAura = false,
        TPSheriff = false,
        ESP_Murd = false,
        ESP_Sheriff = false,
        ESP_Inno = false,
        Traces = false
    },
    Colors = {
        MainBlue = Color3.fromRGB(0, 170, 255),
        NeonPurple = Color3.fromRGB(180, 0, 255),
        SuccessGreen = Color3.fromRGB(0, 255, 100),
        ErrorRed = Color3.fromRGB(255, 50, 50),
        WarningYellow = Color3.fromRGB(255, 255, 0),
        SkyBlue = Color3.fromRGB(0, 255, 255)
    },
    Keys = {
        "CHKEY_2964173850", "CHKEY_8317642950", "CHKEY_5729184630",
        "CHKEY_9463825170", "CHKEY_1857396240", "CHKEY_7248163950",
        "CHKEY_3692581740", "CHKEY_6159274830", "CHKEY_4836917250",
        "CHKEY_8527419630", "CHKEY_2769318450", "CHKEY_9148526730",
        "CHKEY_5382761940", "CHKEY_7615928340", "CHKEY_3974182650"
    }
}

-- [[ 3. SISTEMA DE NOTIFICACIONES CUSTOM ]]
local function Notify(text, color)
    local NotificationFrame = Instance.new("ScreenGui", CoreGui)
    local Msg = Instance.new("TextLabel", NotificationFrame)
    Msg.Size = UDim2.new(0, 250, 0, 40)
    Msg.Position = UDim2.new(1, -260, 0.9, 0)
    Msg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Msg.TextColor3 = color
    Msg.Text = text
    Msg.Font = Enum.Font.GothamBold
    Msg.TextSize = 14
    Instance.new("UICorner", Msg)
    local Stroke = Instance.new("UIStroke", Msg)
    Stroke.Color = color
    Stroke.Thickness = 1
    
    TweenService:Create(Msg, TweenInfo.new(0.5), {Position = UDim2.new(1, -260, 0.85, 0)}):Play()
    task.wait(3)
    TweenService:Create(Msg, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    task.delay(0.5, function() NotificationFrame:Destroy() end)
end

-- [[ 4. MOTORES DE COMBATE (CÓDIGO ANTERIOR REUTILIZADO) ]]

local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- Kill Aura Original
task.spawn(function()
    while task.wait() do
        if CH_DATA.Toggles.KillAura and GetRole(lp) == "Murderer" and lp.Character:FindFirstChild("Knife") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 40 then
                        firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 0)
                        firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 1)
                    end
                end
            end
        end
    end
end)

-- Aimbot Fijo (Detecta Asesino)
RunService.RenderStepped:Connect(function()
    if CH_DATA.Toggles.Aimbot then
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if GetRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                target = p.Character.Head
                break
            end
        end
        if target then
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, target.Position), 0.1)
        end
    end
    
    if CH_DATA.Toggles.WalkSpeed then lp.Character.Humanoid.WalkSpeed = 50 end
    if CH_DATA.Toggles.Noclip then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Inf Jump Original
UserInputService.JumpRequest:Connect(function()
    if CH_DATA.Toggles.InfJump and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

-- [[ 5. MOTOR DE ESP Y TRACES (AUTO-LIMPIEZA) ]]
local activeVisuals = {}

local function CreateESP(p)
    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Transparency = 1
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = CoreGui
    
    activeVisuals[p.Name] = {Line = line, High = highlight}

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local role = GetRole(p)
            local root = p.Character.HumanoidRootPart
            local pos, onScreen = camera:WorldToViewportPoint(root.Position)
            
            -- Lógica de Colores
            local col = Color3.new(1,1,1)
            local visible = false
            if role == "Murderer" and CH_DATA.Toggles.ESP_Murd then col = Color3.new(1,0,0); visible = true
            elseif role == "Sheriff" and CH_DATA.Toggles.ESP_Sheriff then col = Color3.new(0,0.5,1); visible = true
            elseif role == "Innocent" and CH_DATA.Toggles.ESP_Inno then col = Color3.new(0,1,0); visible = true end
            
            highlight.Enabled = visible
            highlight.Adornee = p.Character
            highlight.FillColor = col
            highlight.OutlineColor = Color3.new(1,1,1)
            
            if CH_DATA.Toggles.Traces and onScreen and visible then
                line.Visible = true
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = col
            else
                line.Visible = false
            end
        else
            -- Limpieza automática si muere o sale
            line.Visible = false
            highlight.Enabled = false
            if not Players:FindFirstChild(p.Name) then
                line:Remove()
                highlight:Destroy()
                connection:Disconnect()
            end
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do if v ~= lp then CreateESP(v) end end
Players.PlayerAdded:Connect(function(v) if v ~= lp then CreateESP(v) end end)

-- [[ 6. SISTEMA DE KEY (MORADO NEÓN) ]]
local function ShowKeySystem()
    local KeyGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", KeyGui)
    Frame.Size = UDim2.new(0, 350, 0, 250)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
    Instance.new("UICorner", Frame)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = CH_DATA.Colors.NeonPurple
    Stroke.Thickness = 2

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "AUTHENTICATION SYSTEM"
    Title.TextColor3 = CH_DATA.Colors.NeonPurple
    Title.Font = "GothamBold"
    Title.BackgroundTransparency = 1

    local Input = Instance.new("TextBox", Frame)
    Input.Size = UDim2.new(0.8, 0, 0, 45)
    Input.Position = UDim2.new(0.1, 0, 0.4, 0)
    Input.PlaceholderText = "Enter license..."
    Input.Text = ""
    Input.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
    Input.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", Frame)
    Verify.Size = UDim2.new(0.8, 0, 0, 45)
    Verify.Position = UDim2.new(0.1, 0, 0.7, 0)
    Verify.BackgroundColor3 = CH_DATA.Colors.NeonPurple
    Verify.Text = "LOGIN"
    Verify.TextColor3 = Color3.new(1,1,1)
    Verify.Font = "GothamBold"
    Instance.new("UICorner", Verify)

    Verify.MouseButton1Click:Connect(function()
        if table.find(CH_DATA.Keys, Input.Text) then
            Verify.Text = "Verifying key..."
            Verify.BackgroundColor3 = CH_DATA.Colors.WarningYellow
            -- Efecto parpadeante
            task.spawn(function()
                for i = 1, 6 do
                    Verify.TextTransparency = (i % 2 == 0) and 0 or 1
                    task.wait(0.5)
                end
            end)
            task.wait(3)
            KeyGui:Destroy()
            StartIntro()
        else
            Verify.Text = "Incorrect key"
            Verify.BackgroundColor3 = CH_DATA.Colors.ErrorRed
            task.wait(2)
            Verify.Text = "LOGIN"
            Verify.BackgroundColor3 = CH_DATA.Colors.NeonPurple
        end
    end)
end

-- [[ 7. INTRO: LETRAS CAYENDO Y EXPLOSIÓN ]]
function StartIntro()
    local IntroGui = Instance.new("ScreenGui", CoreGui)
    local Canvas = Instance.new("Frame", IntroGui)
    Canvas.Size = UDim2.new(1,0,1,0)
    Canvas.BackgroundTransparency = 1

    local fullText = "CHRISSHUB V2"
    local labels = {}

    for i = 1, #fullText do
        local char = string.sub(fullText, i, i)
        local l = Instance.new("TextLabel", Canvas)
        l.Text = char
        l.Size = UDim2.new(0, 50, 0, 50)
        l.Position = UDim2.new(0.3 + (i*0.04), 0, -0.2, 0)
        l.TextColor3 = Color3.fromRGB(0, 255, 100)
        l.Font = "Code"
        l.TextSize = 60
        l.BackgroundTransparency = 1
        table.insert(labels, l)
        TweenService:Create(l, TweenInfo.new(1, Enum.EasingStyle.Bounce), {Position = UDim2.new(0.3 + (i*0.04), 0, 0.45, 0)}):Play()
        task.wait(0.1)
    end

    task.wait(2)
    -- Efecto Bomba Verde
    for _, l in pairs(labels) do
        TweenService:Create(l, TweenInfo.new(0.5), {TextSize = 200, TextTransparency = 1, TextColor3 = Color3.new(1,1,1)}):Play()
    end
    task.wait(0.6)
    IntroGui:Destroy()
    BuildFuturisticMenu()
end

-- [[ 8. MENÚ AZUL NEÓN FUTURISTA ]]
function BuildFuturisticMenu()
    local MainGui = Instance.new("ScreenGui", CoreGui)
    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 450, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(5, 10, 15)
    Instance.new("UICorner", MainFrame)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = CH_DATA.Colors.MainBlue
    Stroke.Thickness = 3

    -- Header
    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundTransparency = 1
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "CHRISSHUB V2 - SUPREME"
    Title.TextColor3 = CH_DATA.Colors.MainBlue
    Title.Font = "GothamBlack"
    Title.TextXAlignment = "Left"
    Title.BackgroundTransparency = 1

    local Close = Instance.new("TextButton", Header)
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0, 5)
    Close.Text = "X"
    Close.TextColor3 = CH_DATA.Colors.ErrorRed
    Close.BackgroundTransparency = 1
    
    -- Apartados
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 100, 1, -50)
    Sidebar.Position = UDim2.new(0, 10, 0, 45)
    Sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame", MainFrame)
    PageContainer.Size = UDim2.new(1, -130, 1, -60)
    PageContainer.Position = UDim2.new(0, 120, 0, 50)
    PageContainer.BackgroundTransparency = 1

    local pages = {}
    local function CreateTab(name)
        local p = Instance.new("ScrollingFrame", PageContainer)
        p.Size = UDim2.new(1, 0, 1, 0)
        p.BackgroundTransparency = 1
        p.Visible = false
        p.CanvasSize = UDim2.new(0,0,1.5,0)
        p.ScrollBarThickness = 2
        local list = Instance.new("UIListLayout", p); list.Padding = UDim.new(0, 8)
        
        local b = Instance.new("TextButton", Sidebar)
        b.Size = UDim2.new(1, 0, 0, 40)
        b.Text = name
        b.BackgroundColor3 = Color3.fromRGB(15, 25, 35)
        b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(pages) do v.Visible = false end
            p.Visible = true
        end)
        pages[name] = p
        return p
    end

    local mainTab = CreateTab("MAIN")
    local espTab = CreateTab("ESP")
    local combatTab = CreateTab("COMBAT")
    mainTab.Visible = true

    -- Función para botones rectangulares (Estilo Imagen 3)
    local function AddFunction(parent, text, tKey)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.95, 0, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        btn.Text = "  " .. text
        btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        btn.TextXAlignment = "Left"
        btn.Font = "GothamBold"
        Instance.new("UICorner", btn)
        local s = Instance.new("UIStroke", btn); s.Color = Color3.fromRGB(40, 40, 50); s.Thickness = 2

        btn.MouseButton1Click:Connect(function()
            CH_DATA.Toggles[tKey] = not CH_DATA.Toggles[tKey]
            local state = CH_DATA.Toggles[tKey]
            
            -- Feedback Visual Botón
            btn.BackgroundColor3 = state and CH_DATA.Colors.SuccessGreen or CH_DATA.Colors.ErrorRed
            task.delay(5, function() btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25) end)
            
            -- Notificación
            local statusText = state and "ACTIVATED" or "DEACTIVATED"
            local statusCol = state and CH_DATA.Colors.SuccessGreen or CH_DATA.Colors.ErrorRed
            Notify(text .. " " .. statusText, statusCol)
        end)
    end

    -- Contenido MAIN
    AddFunction(mainTab, "NOCLIP", "Noclip")
    AddFunction(mainTab, "INFINITY JUMP", "InfJump")
    AddFunction(mainTab, "SPEED HACK", "WalkSpeed")
    local TikTok = Instance.new("TextLabel", mainTab)
    TikTok.Size = UDim2.new(1,0,0,30); TikTok.Text = "Follow me on TikTok: sasware32 😏"; TikTok.TextColor3 = CH_DATA.Colors.MainBlue; TikTok.BackgroundTransparency = 1

    -- Contenido ESP
    AddFunction(espTab, "ESP MURDERER", "ESP_Murd")
    AddFunction(espTab, "ESP SHERIFF", "ESP_Sheriff")
    AddFunction(espTab, "ESP INNOCENT", "ESP_Inno")
    AddFunction(espTab, "TRACES (LINES)", "Traces")

    -- Contenido COMBAT
    AddFunction(combatTab, "AIMBOT (FIXED)", "Aimbot")
    AddFunction(combatTab, "KILL AURA", "KillAura")
    
    -- TP SHERIFF ESPECIAL
    local TPBtn = Instance.new("TextButton", combatTab)
    TPBtn.Size = UDim2.new(0.95, 0, 0, 45)
    TPBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); TPBtn.Text = "  TELEPORT SHERIFF"
    TPBtn.TextColor3 = Color3.new(0.8,0.8,0.8); TPBtn.TextXAlignment = "Left"; TPBtn.Font = "GothamBold"
    Instance.new("UICorner", TPBtn)
    
    TPBtn.MouseButton1Click:Connect(function()
        TPBtn.BackgroundColor3 = CH_DATA.Colors.SuccessGreen
        Notify("TELEPORTING...", CH_DATA.Colors.SkyBlue)
        task.wait(3)
        for _, p in pairs(Players:GetPlayers()) do
            if GetRole(p) == "Sheriff" and p.Character then
                lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                Notify("TELEPORT SUCCESSFUL", CH_DATA.Colors.SuccessGreen)
                break
            end
        end
        task.wait(2)
        TPBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    end)

    -- Círculo CH-HUB
    local Floating = Instance.new("TextButton", MainGui)
    Floating.Size = UDim2.new(0, 60, 0, 60)
    Floating.Position = UDim2.new(0, 20, 0.5, 0)
    Floating.BackgroundColor3 = CH_DATA.Colors.MainBlue
    Floating.Text = "CH-HUB"
    Floating.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Floating).CornerRadius = UDim.new(1, 0)
    Floating.Visible = false

    Close.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        Floating.Visible = true
    end)
    Floating.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        Floating.Visible = false
    end)
end

-- [[ INICIO ]]
ShowKeySystem()
Arregla éste Script lua
