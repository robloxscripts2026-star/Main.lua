-- [[ 🥵 CHRISSHUB V2.5 - THE SUPREME UPDATE 🥵 ]]
-- [[ DEVELOPER: SASWARE32 | FIX: MULTI-LOAD & HITBOX ]]
-- [[ TOTAL LINES: 330+ | STATUS: STABLE ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- VARIABLE PARA PREVENIR DUPLICADOS
local IsLoaded = false

-- [[ 🔑 BASE DE DATOS: 15 KEYS ]]
local CH_KEYS = {
    "CHKEY_2964173850", "CHKEY_8317642950", "CHKEY_5729184630", "CHKEY_9463825170",
    "CHKEY_1857396240", "CHKEY_7248163950", "CHKEY_3692581740", "CHKEY_6159274830",
    "CHKEY_4836917250", "CHKEY_8527419630", "CHKEY_2769318450", "CHKEY_9148526730",
    "CHKEY_5382761940", "CHKEY_7615928340", "CHKEY_3974182650"
}

local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false,
        Aimbot = false, KillAura = false, Hitbox = false,
        ESP_Murd = false, ESP_Sheriff = false, ESP_Inno = false, Traces = false
    },
    SpeedValue = 50
}

-- [[ 📢 NOTIFICACIONES ]]
local function SendNotify(txt, col)
    spawn(function()
        local sg = Instance.new("ScreenGui", CoreGui)
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 240, 0, 50); frame.Position = UDim2.new(1, 10, 0.15, 0)
        frame.BackgroundColor3 = Color3.fromRGB(5, 5, 10); Instance.new("UICorner", frame)
        local st = Instance.new("UIStroke", frame); st.Color = col; st.Thickness = 2
        local l = Instance.new("TextLabel", frame); l.Size = UDim2.new(1, 0, 1, 0); l.Text = txt; l.TextColor3 = col
        l.Font = Enum.Font.GothamBold; l.BackgroundTransparency = 1; l.TextSize = 13
        frame:TweenPosition(UDim2.new(1, -250, 0.15, 0), "Out", "Back", 0.5, true)
        task.wait(3.5); frame:TweenPosition(UDim2.new(1, 10, 0.15, 0), "In", "Quad", 0.5, true)
        task.wait(0.6); sg:Destroy()
    end)
end

-- [[ 👁️ MOTOR ESP & HITBOX ]]
local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- [[ 🛠️ HITBOX EXPANDER (EXCLUSIVO ASESINO) ]]
task.spawn(function()
    while task.wait(0.5) do
        if Config.Toggles.Hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and GetRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(30, 30, 30)
                    hrp.Transparency = 0.9 -- Casi invisible
                    hrp.CanCollide = false
                end
            end
        else
            -- Reset Hitbox si se apaga
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    p.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
end)

local active_esp = {}
local function CreateESP(p)
    if active_esp[p] then return end
    local highlight = Instance.new("Highlight", CoreGui)
    highlight.OutlineTransparency = 0; highlight.FillTransparency = 0.4
    local line = Drawing.new("Line"); line.Thickness = 2; line.Transparency = 1
    active_esp[p] = {Highlight = highlight, Line = line}
    
    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
            local role = GetRole(p); local color = (role == "Murderer" and Color3.new(1,0,0)) or (role == "Sheriff" and Color3.new(0,0.7,1)) or Color3.new(0,1,0)
            local enabled = (role == "Murderer" and Config.Toggles.ESP_Murd) or (role == "Sheriff" and Config.Toggles.ESP_Sheriff) or (role == "Innocent" and Config.Toggles.ESP_Inno)
            if enabled and p.Character.Humanoid.Health > 0 then
                highlight.Enabled = true; highlight.Adornee = p.Character; highlight.FillColor = color
                local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if Config.Toggles.Traces and vis then
                    line.Visible = true; line.Color = color; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
                else line.Visible = false end
            else highlight.Enabled = false; line.Visible = false end
        else highlight.Enabled = false; line.Visible = false end
        if not Players:FindFirstChild(p.Name) then highlight:Destroy(); line:Remove(); active_esp[p] = nil end
    end)
end

for _, v in pairs(Players:GetPlayers()) do if v ~= lp then CreateESP(v) end end
Players.PlayerAdded:Connect(function(v) if v ~= lp then CreateESP(v) end end)

-- [[ ⚔️ COMBAT & MOVEMENT ]]
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if Config.Toggles.WalkSpeed then lp.Character.Humanoid.WalkSpeed = Config.SpeedValue end
        if Config.Toggles.Noclip then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
    if Config.Toggles.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if GetRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, p.Character.Head.Position)
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

-- [[ 🏙️ MENÚ AZUL NEÓN ]]
local function BuildMain()
    if IsLoaded then return end -- NO PERMITIR SEGUNDA CARGA
    IsLoaded = true
    
    local sg = Instance.new("ScreenGui", CoreGui)
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 480, 0, 320); main.Position = UDim2.new(0.5, -240, 0.5, -160)
    main.BackgroundColor3 = Color3.fromRGB(5, 10, 25); Instance.new("UICorner", main)
    local stroke = Instance.new("UIStroke", main); stroke.Color = Color3.fromRGB(0, 180, 255); stroke.Thickness = 3

    -- BOTÓN CH-HUB DRAGGABLE
    local float = Instance.new("TextButton", sg)
    float.Size = UDim2.new(0, 75, 0, 75); float.Position = UDim2.new(0.05, 0, 0.4, 0)
    float.BackgroundColor3 = Color3.fromRGB(0, 150, 255); float.Text = "CH-HUB"; float.TextColor3 = Color3.new(1,1,1)
    float.Font = Enum.Font.GothamBold; float.Visible = false; Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
    
    local f_drag, f_start, f_pos;
    float.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then f_drag = true; f_start = i.Position; f_pos = float.Position end end)
    float.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then f_drag = false end end)
    UserInputService.InputChanged:Connect(function(i) if f_drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - f_start; float.Position = UDim2.new(f_pos.X.Scale, f_pos.X.Offset + delta.X, f_pos.Y.Scale, f_pos.Y.Offset + delta.Y)
    end end)

    local close = Instance.new("TextButton", main); close.Size = UDim2.new(0, 35, 0, 35); close.Position = UDim2.new(1, -40, 0, 5); close.Text = "✖"; close.TextColor3 = Color3.new(1,0,0); close.BackgroundTransparency = 1; close.TextSize = 25
    close.MouseButton1Click:Connect(function() main.Visible = false; float.Visible = true end)
    float.MouseButton1Click:Connect(function() main.Visible = true; float.Visible = false end)

    local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 120, 1, -20); side.Position = UDim2.new(0, 10, 0, 10); side.BackgroundTransparency = 1
    Instance.new("UIListLayout", side).Padding = UDim.new(0, 8)
    local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -150, 1, -60); container.Position = UDim2.new(0, 140, 0, 50); container.BackgroundTransparency = 1

    local function CreateTab(name)
        local f = Instance.new("ScrollingFrame", container)
        f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0
        Instance.new("UIListLayout", f).Padding = UDim.new(0, 12)
        local b = Instance.new("TextButton", side); b.Size = UDim2.new(1, 0, 0, 45); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(15, 25, 50); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end f.Visible = true end)
        return f
    end

    local tabMain = CreateTab("MAIN"); tabMain.Visible = true
    local tabESP = CreateTab("ESP"); local tabCombat = CreateTab("COMBAT")

    local function CreateFunc(parent, name, key)
        local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0.95, 0, 0, 50); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            btn.BackgroundColor3 = Config.Toggles[key] and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            SendNotify(name .. (Config.Toggles[key] and " ACTIVADO" or " DESACTIVADO"), Config.Toggles[key] and Color3.new(0,1,0) or Color3.new(1,0,0))
            task.wait(5); btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
        end)
    end

    CreateFunc(tabMain, "NOCLIP", "Noclip"); CreateFunc(tabMain, "INFINITY JUMP", "InfJump"); CreateFunc(tabMain, "SPEED", "WalkSpeed")
    local cred = Instance.new("TextLabel", tabMain); cred.Size = UDim2.new(1,0,0,40); cred.Text = "Follow me on TikTok: sasware32 😏"; cred.TextColor3 = Color3.fromRGB(0, 180, 255); cred.BackgroundTransparency = 1; cred.Font = Enum.Font.GothamBold

    CreateFunc(tabESP, "ESP ASESINO (RED)", "ESP_Murd"); CreateFunc(tabESP, "ESP SHERIFF (BLUE)", "ESP_Sheriff"); CreateFunc(tabESP, "ESP INOCENTE (GREEN)", "ESP_Inno"); CreateFunc(tabESP, "TRACES", "Traces")

    CreateFunc(tabCombat, "HITBOX MURDERER", "Hitbox"); CreateFunc(tabCombat, "AIMBOT FIXED", "Aimbot"); CreateFunc(tabCombat, "KILL AURA", "KillAura")
    local tpS = Instance.new("TextButton", tabCombat); tpS.Size = UDim2.new(0.95, 0, 0, 50); tpS.Text = "TP SHERIFF"; tpS.BackgroundColor3 = Color3.fromRGB(30, 35, 50); tpS.TextColor3 = Color3.new(1,1,1); tpS.Font = Enum.Font.GothamBold; Instance.new("UICorner", tpS)
    tpS.MouseButton1Click:Connect(function()
        tpS.BackgroundColor3 = Color3.new(0, 1, 0); SendNotify("TELETRANSPORTANDO", Color3.fromRGB(0, 190, 255))
        task.wait(3); local sh = nil; for _, p in pairs(Players:GetPlayers()) do if GetRole(p) == "Sheriff" and p.Character then sh = p break end end
        if sh then lp.Character.HumanoidRootPart.CFrame = sh.Character.HumanoidRootPart.CFrame; SendNotify("TELEPORTACIÓN EXITOSA", Color3.new(0, 1, 0))
        else SendNotify("SHERIFF NO ENCONTRADO", Color3.new(1, 0, 0)) end
        task.wait(2); tpS.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    end)
end

-- [[ 🚀 INTRO RENOVADA (GREEN & LARGE) ]]
local function StartIntro()
    local sg = Instance.new("ScreenGui", CoreGui); local title = "CHRISSHUB"
    local labels = {}
    for i = 1, #title do
        local l = Instance.new("TextLabel", sg); l.Text = title:sub(i,i); l.Size = UDim2.new(0, 80, 0, 80)
        l.Position = UDim2.new(0.28 + (i*0.05), 0, -0.2, 0); l.TextColor3 = Color3.fromRGB(0, 255, 50)
        l.TextSize = 90; l.Font = Enum.Font.Code; l.BackgroundTransparency = 1
        local s = Instance.new("UIStroke", l); s.Color = Color3.new(0,0,0); s.Thickness = 4
        table.insert(labels, l)
        l:TweenPosition(UDim2.new(0.28 + (i*0.05), 0, 0.45, 0), "Out", "Bounce", 1 + (i*0.12), true)
    end
    task.wait(4)
    for _, v in pairs(labels) do
        TweenService:Create(v, TweenInfo.new(0.6), {TextSize = 400, TextTransparency = 1, TextColor3 = Color3.new(0,1,0.2)}):Play()
    end
    task.wait(0.7); sg:Destroy(); BuildMain()
end

-- [[ 🔑 KEY SYSTEM FIX ]]
local function RunKeys()
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg); frame.Size = UDim2.new(0, 350, 0, 250); frame.Position = UDim2.new(0.5, -175, 0.5, -125); frame.BackgroundColor3 = Color3.fromRGB(15, 5, 35); Instance.new("UICorner", frame)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(180, 0, 255)
    local input = Instance.new("TextBox", frame); input.Size = UDim2.new(0.8, 0, 0, 50); input.Position = UDim2.new(0.1, 0, 0.35, 0); input.PlaceholderText = "Enter licencia"; input.Text = ""; input.TextColor3 = Color3.new(1,1,1); input.BackgroundColor3 = Color3.fromRGB(30, 15, 60); Instance.new("UICorner", input)
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0.8, 0, 0, 50); btn.Position = UDim2.new(0.1, 0, 0.7, 0); btn.Text = "VERIFY"; btn.BackgroundColor3 = Color3.fromRGB(180, 0, 255); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    
    local verifying = false
    btn.MouseButton1Click:Connect(function()
        if verifying then return end -- NO PERMITIR CLIC MIENTRAS VERIFICA
        if table.find(CH_KEYS, input.Text) then
            verifying = true; btn.Text = "Verifying key..."; btn.TextColor3 = Color3.new(1, 1, 0)
            task.wait(3); sg:Destroy(); StartIntro()
        else
            input.Text = ""; input.PlaceholderText = "Incorrect key"; input.PlaceholderColor3 = Color3.new(1, 0, 0); task.wait(2); input.PlaceholderText = "Enter licencia"
        end
    end)
end

RunKeys()
