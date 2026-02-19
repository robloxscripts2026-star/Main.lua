-- [[ 🟣 CHRISSHUB V6.5 SUPREME FINAL 🟣 ]]
-- [[ TODO INCLUIDO: SHOTMURDER | HITBOX 30X30 | COINAREA FARM ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

if _G.ChrisHubLoaded then return end
_G.ChrisHubLoaded = true

local CH_KEYS = {"CHKEY_2964173850", "CHKEY_8317642950", "CHKEY_5729184630", "CHKEY_9463825170", "CHKEY_1857396240", "CHKEY_7248163950", "CHKEY_3692581740", "CHKEY_6159274830", "CHKEY_4836917250", "CHKEY_8527419630"}

local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false,
        Aimbot = false, KillAura = false,
        ESP_Murd = false, ESP_Sheriff = false, ESP_Inno = false, Traces = false,
        AutoFarm = false, Hitbox = true
    },
    SpeedValue = 50
}

-- [[ 📢 SISTEMA DE MENSAJES ORIGINAL ]]
local function SendNotify(txt, col)
    task.spawn(function()
        local sg = Instance.new("ScreenGui", CoreGui)
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 240, 0, 50); frame.Position = UDim2.new(1, 10, 0.15, 0)
        frame.BackgroundColor3 = Color3.fromRGB(5, 5, 10); Instance.new("UICorner", frame)
        Instance.new("UIStroke", frame).Color = col; Instance.new("UIStroke", frame).Thickness = 2
        local l = Instance.new("TextLabel", frame)
        l.Size = UDim2.new(1, 0, 1, 0); l.Text = txt; l.TextColor3 = col; l.Font = Enum.Font.GothamBold; l.BackgroundTransparency = 1; l.TextSize = 13
        frame:TweenPosition(UDim2.new(1, -250, 0.15, 0), "Out", "Back", 0.5, true)
        task.wait(3); frame:TweenPosition(UDim2.new(1, 10, 0.15, 0), "In", "Quad", 0.5, true)
        task.wait(0.6); sg:Destroy()
    end)
end

local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- [[ 🎯 HITBOX 30X30 MOTOR ]]
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if GetRole(p) == "Murderer" and Config.Toggles.Hitbox then
                p.Character.HumanoidRootPart.Size = Vector3.new(30, 30, 30)
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.CanCollide = false
            else
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            end
        end
    end
end)

-- [[ 👁️ ESP MOTOR (SIN ERRORES) ]]
local active_esp = {}
local function CreateESP(p)
    if active_esp[p] then return end
    local h = Instance.new("Highlight", CoreGui)
    local l = Drawing.new("Line")
    l.Thickness = 2; active_esp[p] = {Highlight = h, Line = l}
    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local role = GetRole(p)
            local col = (role == "Murderer" and Color3.new(1,0,0)) or (role == "Sheriff" and Color3.new(0,0.7,1)) or Color3.new(0,1,0)
            local ena = (role == "Murderer" and Config.Toggles.ESP_Murd) or (role == "Sheriff" and Config.Toggles.ESP_Sheriff) or (role == "Innocent" and Config.Toggles.ESP_Inno)
            h.Enabled = ena; h.Adornee = p.Character; h.FillColor = col
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis and ena then
                l.Visible = true; l.Color = col; l.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); l.To = Vector2.new(pos.X, pos.Y)
            else l.Visible = false end
        else h.Enabled = false; l.Visible = false end
    end)
end

-- [[ 💰 AUTOFARM COINAREA ]]
task.spawn(function()
    while task.wait() do
        if Config.Toggles.AutoFarm and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local target = nil; local dist = math.huge
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "CoinArea" and v:IsA("BasePart") then
                    local d = (lp.Character.HumanoidRootPart.Position - v.Position).Magnitude
                    if d < dist then dist = d; target = v end
                end
            end
            if target then
                lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                lp.Character.Humanoid.PlatformStand = true
                lp.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, -3.5, 0)
            end
        end
    end
end)

-- [[ 🏙️ MENÚ AZUL ORIGINAL ]]
local function BuildMain()
    local sg = Instance.new("ScreenGui", CoreGui); local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 480, 0, 320); main.Position = UDim2.new(0.5, -240, 0.5, -160); main.BackgroundColor3 = Color3.fromRGB(5, 10, 25); Instance.new("UICorner", main)
    Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 180, 255); Instance.new("UIStroke", main).Thickness = 3

    -- BOTÓN SHOTMURDER (EXTERNO)
    local shot = Instance.new("TextButton", sg)
    shot.Size = UDim2.new(0, 130, 0, 50); shot.Position = UDim2.new(1, -150, 0.4, -60); shot.Text = "SHOTMURDER"; shot.BackgroundColor3 = Color3.fromRGB(0, 80, 255); shot.TextColor3 = Color3.new(1,1,1); shot.Font = Enum.Font.GothamBold; Instance.new("UICorner", shot)
    shot.MouseButton1Click:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if GetRole(p) == "Murderer" and p.Character then camera.CFrame = CFrame.new(camera.CFrame.Position, p.Character.HumanoidRootPart.Position); SendNotify("APUNTANDO ASESINO", Color3.new(1,0,0)) end
        end
    end)

    local float = Instance.new("TextButton", sg); float.Size = UDim2.new(0, 70, 0, 70); float.Position = UDim2.new(0.05, 0, 0.4, 0); float.Visible = false; float.Text = "CH-HUB"; float.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Instance.new("UICorner", float).CornerRadius = UDim.new(1,0)
    local close = Instance.new("TextButton", main); close.Size = UDim2.new(0, 35, 0, 35); close.Position = UDim2.new(1, -40, 0, 5); close.Text = "✖"; close.TextColor3 = Color3.new(1,0,0); close.BackgroundTransparency = 1; close.TextSize = 25
    close.MouseButton1Click:Connect(function() main.Visible = false; float.Visible = true end)
    float.MouseButton1Click:Connect(function() main.Visible = true; float.Visible = false end)

    local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 120, 1, -20); side.Position = UDim2.new(0, 10, 0, 10); side.BackgroundTransparency = 1; Instance.new("UIListLayout", side).Padding = UDim.new(0, 8)
    local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -150, 1, -60); container.Position = UDim2.new(0, 140, 0, 50); container.BackgroundTransparency = 1

    local function Tab(n)
        local f = Instance.new("ScrollingFrame", container); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0; Instance.new("UIListLayout", f).Padding = UDim.new(0, 12)
        local b = Instance.new("TextButton", side); b.Size = UDim2.new(1, 0, 0, 45); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(15, 25, 50); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end f.Visible = true end)
        return f
    end

    local t1 = Tab("MAIN"); t1.Visible = true; local t2 = Tab("ESP"); local t3 = Tab("COMBAT"); local t4 = Tab("FARM")
    local function AddFunc(p, name, key)
        local btn = Instance.new("TextButton", p); btn.Size = UDim2.new(0.95, 0, 0, 50); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            btn.BackgroundColor3 = Config.Toggles[key] and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            SendNotify(name .. (Config.Toggles[key] and " ACTIVADO" or " DESACTIVADO"), Config.Toggles[key] and Color3.new(0,1,0) or Color3.new(1,0,0))
            task.wait(1); btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
        end)
    end

    AddFunc(t1, "NOCLIP", "Noclip"); AddFunc(t1, "INF JUMP", "InfJump"); AddFunc(t1, "SPEED", "WalkSpeed")
    AddFunc(t2, "ESP MURDER", "ESP_Murd"); AddFunc(t2, "ESP SHERIFF", "ESP_Sheriff"); AddFunc(t2, "TRACES", "Traces")
    AddFunc(t3, "KILL AURA", "KillAura"); AddFunc(t3, "HITBOX 30x30", "Hitbox")
    local tpS = Instance.new("TextButton", t3); tpS.Size = UDim2.new(0.95, 0, 0, 50); tpS.Text = "TP SHERIFF"; tpS.BackgroundColor3 = Color3.fromRGB(30,35,50); tpS.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tpS); tpS.Font = Enum.Font.GothamBold
    tpS.MouseButton1Click:Connect(function()
        local s = nil; for _, p in pairs(Players:GetPlayers()) do if GetRole(p) == "Sheriff" and p.Character then s = p; break end end
        if s then lp.Character.HumanoidRootPart.CFrame = s.Character.HumanoidRootPart.CFrame; SendNotify("TP EXITOSO", Color3.new(0,1,0)) else SendNotify("SHERIFF NO HALLADO", Color3.new(1,0,0)) end
    end)
    AddFunc(t4, "AUTOFARM COINAREA", "AutoFarm")
end

-- [[ 🚀 INTRO & KEYS ]]
local function StartIntro()
    local sg = Instance.new("ScreenGui", CoreGui); local title = "CHRISSHUB V2"; local labels = {}
    for i = 1, #title do
        local l = Instance.new("TextLabel", sg); l.Text = title:sub(i,i); l.Size = UDim2.new(0, 60, 0, 60); l.Position = UDim2.new(0.32 + (i*0.04), 0, -0.2, 0); l.TextColor3 = Color3.fromRGB(0, 255, 120); l.TextSize = 70; l.Font = Enum.Font.Code; l.BackgroundTransparency = 1; table.insert(labels, l)
        l:TweenPosition(UDim2.new(0.32 + (i*0.04), 0, 0.45, 0), "Out", "Bounce", 1 + (i*0.12), true)
    end
    task.wait(4.5); sg:Destroy(); BuildMain()
end

local function RunKeys()
    local sg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 350, 0, 250); f.Position = UDim2.new(0.5, -175, 0.5, -125); f.BackgroundColor3 = Color3.fromRGB(15, 5, 35); Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Color3.fromRGB(180, 0, 255); Instance.new("UIStroke", f).Thickness = 2
    local i = Instance.new("TextBox", f); i.Size = UDim2.new(0.8, 0, 0, 50); i.Position = UDim2.new(0.1, 0, 0.35, 0); i.PlaceholderText = "Enter licencia"; i.BackgroundColor3 = Color3.fromRGB(30, 15, 60); i.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", i)
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 120, 0, 40); b.Position = UDim2.new(0.5, -60, 0.75, 0); b.Text = "VERIFY"; b.BackgroundColor3 = Color3.fromRGB(180, 0, 255); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function() if table.find(CH_KEYS, i.Text) then sg:Destroy(); StartIntro() else i.Text = ""; i.PlaceholderText = "Incorrect Key" end end)
end

RunKeys(); for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if Config.Toggles.WalkSpeed then lp.Character.Humanoid.WalkSpeed = Config.SpeedValue end
        if Config.Toggles.Noclip or Config.Toggles.AutoFarm then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)
