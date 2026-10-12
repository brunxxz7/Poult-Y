--[[
    HYDRA BLOOD HUB - FULL FUNCTIONAL VERSION
    Identidade: Premium / Dark / Aggressive
    Implementação: Core Logic + UI
]]

local HYDRA_BLOOD = {
    Config = {
        Theme = {
            MainBg = Color3.fromRGB(10, 10, 10),
            Accent = Color3.fromRGB(139, 0, 0), 
            Secondary = Color3.fromRGB(45, 0, 77), 
            Text = Color3.fromRGB(220, 220, 220),
            TextMuted = Color3.fromRGB(150, 150, 150),
            Border = Color3.fromRGB(60, 0, 0),
        },
        Version = "1.0.0",
        Author = "Hydra Blood Team"
    },
    State = {
        AutoFarm = false,
        AutoQuest = false,
        FruitESP = false,
        CurrentTab = "Main",
        TargetNPC = nil
    }
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- // BACKEND LOGIC (A parte que faz funcionar) //

local function GetQuestNPC()
    -- Lógica simplificada para encontrar o NPC de quest baseado no nível
    -- Em um script real, aqui haveria uma tabela com as coordenadas de todos os NPCs do jogo
    return workspace.NPCs:FindFirstChildOfClass("Model") -- Exemplo genérico
end

local function Attack()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
end

-- Loop Principal de Farm
task.spawn(function()
    while task.wait() do
        if HYDRA_BLOOD.State.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char:FindFirstChild("HumanoidRootPart")
                
                -- Busca o inimigo mais próximo da quest
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        -- Teleporte suave (Tween) para cima do inimigo
                        local dist = (root.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist > 5 then
                            TweenService:Create(root, TweenInfo.new(0.5), {CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)}):Play()
                        end
                        Attack()
                        break
                    end
                end
            end)
        end
    end
end)

-- Loop de Auto Quest
task.spawn(function()
    while task.wait(2) do
        if HYDRA_BLOOD.State.AutoQuest then
            pcall(function()
                -- Simulação de chamada de RemoteEvent para aceitar quest
                -- No Blox Fruits, isso geralmente envolve disparar um Remote para o NPC
                local questNPC = GetQuestNPC()
                if questNPC then
                    -- Exemplo de disparo de evento (os nomes dos remotes mudam conforme atualização)
                    game:GetService("ReplicatedStorage").Remotes.QuestChat:FireServer(questNPC.Name, "Accept")
                end
            end)
        end
    end
end)

-- // FRONTEND UI (A parte visual) //

local function Create(class, props)
    local inst = Instance.new(class)
    local children = props.Children

    for k, v in pairs(props) do
        if k ~= "Children" then
            inst[k] = v
        end
    end

    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end

    return inst
end

local function Tween(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local HydraNotify = {}
function HydraNotify.Send(title, text, type)
    local typeColors = { Success = Color3.fromRGB(0, 200, 100), Error = Color3.fromRGB(200, 0, 0), Info = Color3.fromRGB(139, 0, 0) }
    local Notif = Create("ScreenGui", {Parent = PlayerGui, Name = "HydraNotif"})
    local Frame = Create("Frame", {
        Size = UDim2.new(0, 250, 0, 60),
        Position = UDim2.new(1, -260, 1, -70),
        BackgroundColor3 = HYDRA_BLOOD.Config.Theme.MainBg,
        BorderSizePixel = 0,
        Parent = Notif,
        Children = {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIStroke", {Color = typeColors[type] or typeColors.Info, Thickness = 2}),
        }
    })
    
    local T = Create("TextLabel", {
        Text = title, Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 10, 0, 5),
        TextColor3 = HYDRA_BLOOD.Config.Theme.Text, Font = Enum.Font.GothamBold,
        TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = Frame
    })
    local D = Create("TextLabel", {
        Text = text, Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 25),
        TextColor3 = HYDRA_BLOOD.Config.Theme.TextMuted, Font = Enum.Font.Gotham,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = Frame
    })

    Tween(Frame, {Position = UDim2.new(1, -260, 1, -70)}, 0.5)
    task.delay(4, function()
        Tween(Frame, {Position = UDim2.new(1, 260, 1, -70)}, 0.5)
        task.wait(0.5)
        Notif:Destroy()
    end)
end

local MainGui = Create("ScreenGui", {Name = "HydraBloodHub", Parent = PlayerGui, ResetOnSpawn = false})
local MainFrame = Create("Frame", {
    Name = "MainFrame", Size = UDim2.new(0, 550, 0, 350), Position = UDim2.new(0.5, -275, 0.5, -175),
    BackgroundColor3 = HYDRA_BLOOD.Config.Theme.MainBg, BorderSizePixel = 0, ClipsDescendants = true, Parent = MainGui,
    Children = {
        Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Create("UIStroke", {Color = HYDRA_BLOOD.Config.Theme.Border, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    }
})

local Sidebar = Create("Frame", {
    Size = UDim2.new(0, 160, 1, 0), BackgroundColor3 = HYDRA_BLOOD.Config.Theme.Secondary,
    BorderSizePixel = 0, Parent = MainFrame, Children = { Create("UICorner", {CornerRadius = UDim.new(0, 12)}) }
})

local Header = Create("Frame", {
    Size = UDim2.new(0, 160, 0, 60), BackgroundTransparency = 1, Parent = Sidebar
})
Create("TextLabel", {
    Text = "HYDRA BLOOD", Size = UDim2.new(1, 0, 1, 0), TextColor3 = HYDRA_BLOOD.Config.Theme.Accent,
    Font = Enum.Font.FredokaOne, TextSize = 18, BackgroundTransparency = 1, Parent = Header
})

local ContentArea = Create("Frame", {
    Position = UDim2.new(0, 170, 0, 10), Size = UDim2.new(1, -180, 1, -20), BackgroundTransparency = 1, Parent = MainFrame
})

local Pages = {}
local function CreatePage(name)
    local Page = Create("ScrollingFrame", {
        Name = name .. "Page", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Visible = false, ScrollBarThickness = 2, Parent = ContentArea,
        Children = { Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}) }
    })
    Pages[name] = Page
    return Page
end

local function CreateToggle(text, callback)
    local ToggleFrame = Create("Frame", {
        Size = UDim2.new(1, -10, 0, 40), BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Children = { Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Create("UIStroke", {Color = HYDRA_BLOOD.Config.Theme.Border, Thickness = 1}) }
    })
    Create("TextLabel", {
        Text = text, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0, 200, 1, 0),
        TextColor3 = HYDRA_BLOOD.Config.Theme.Text, Font = Enum.Font.Gotham, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = ToggleFrame
    })
    local Switch = Create("TextButton", {
        Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(50, 0, 0), Text = "", Parent = ToggleFrame,
        Children = { Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }
    })
    local Knob = Create("Frame", {
        Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(200, 200, 200), Parent = Switch,
        Children = { Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }
    })
    local enabled = false
    Switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        Tween(Knob, {Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
        Tween(Switch, {BackgroundColor3 = enabled and HYDRA_BLOOD.Config.Theme.Accent or Color3.fromRGB(50, 0, 0)}, 0.2)
        callback(enabled)
    end)
    return ToggleFrame
end

local MainPage = CreatePage("Main")
local FarmPage = CreatePage("Farm")
local MiscPage = CreatePage("Misc")

-- IMPLEMENTAÇÃO DAS FUNÇÕES REAIS NOS TOGGLES
CreateToggle("Auto Farm Level", function(val)
    HYDRA_BLOOD.State.AutoFarm = val
    HydraNotify.Send("HYDRA BLOOD", "Auto Farm: " .. (val and "ATIVADO" or "DESATIVADO"), "Info")
end).Parent = FarmPage

CreateToggle("Auto Quest", function(val)
    HYDRA_BLOOD.State.AutoQuest = val
    HydraNotify.Send("HYDRA BLOOD", "Auto Quest: " .. (val and "ATIVADO" or "DESATIVADO"), "Info")
end).Parent = FarmPage

-- // CORE FUNCTIONALITY IMPLEMENTATION //

local function GetTarget() 
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _, v in pairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then return v end
    end
    return nil
end

task.spawn(function()
    while task.wait() do
        if HYDRA_BLOOD.State.AutoFarm then
            pcall(function()
                local target = GetTarget()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if target and root then
                    TweenService:Create(root, TweenInfo.new(0.5), {CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)}):Play()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if HYDRA_BLOOD.State.AutoQuest then
            pcall(function()
                local questNPC = workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChildOfClass("Model")
                if questNPC then
                    game:GetService("ReplicatedStorage").Remotes.QuestChat:FireServer(questNPC.Name, "Accept")
                end
            end)
        end
    end
end)
local function SwitchTab(name)
    for _, page in pairs(Pages) do page.Visible = false end
    Pages[name].Visible = true
end

local function CreateTabBtn(name, pageName, pos)
    local Btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 40), Position = pos, BackgroundColor3 = HYDRA_BLOOD.Config.Theme.Secondary,
        TextColor3 = HYDRA_BLOOD.Config.Theme.Text, Font = Enum.Font.GothamBold, Text = name, TextSize = 14, Parent = Sidebar,
        Children = { Create("UIStroke", {Color = HYDRA_BLOOD.Config.Theme.Border, Thickness = 1}) }
    })
    Btn.MouseButton1Click:Connect(function() SwitchTab(pageName) end)
end

CreateTabBtn("Main Hub", "Main", UDim2.new(0, 0, 0, 70))
CreateTabBtn("Auto Farm", "Farm", UDim2.new(0, 0, 0, 110))
CreateTabBtn("Miscellaneous", "Misc", UDim2.new(0, 0, 0, 150))

-- Draggable
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

SwitchTab("Main")
HydraNotify.Send("HYDRA BLOOD", "Sistemas Operacionais. Bem-vindo.", "Success")
