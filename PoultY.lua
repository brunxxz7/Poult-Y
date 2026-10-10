
-- POULT Y v1.1 | Interface e ferramentas de UI
-- LocalScript em StarterPlayerScripts
-- Para testar no seu próprio projeto Roblox Studio.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("PoultY")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(12, 15, 14),
    panel = Color3.fromRGB(22, 27, 25),
    green = Color3.fromRGB(0, 255, 130),
    text = Color3.fromRGB(235, 245, 239),
    muted = Color3.fromRGB(145, 165, 153),
    red = Color3.fromRGB(255, 95, 95)
}

local gui = Instance.new("ScreenGui")
gui.Name = "PoultY"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, obj)
end

local function stroke(obj)
    create("UIStroke", {
        Color = C.green,
        Transparency = 0.65,
        Thickness = 1
    }, obj)
end

local window = create("Frame", {
    Name = "Window",
    Size = UDim2.fromOffset(740, 480),
    Position = UDim2.new(0.5, -370, 0.5, -240),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0
}, gui)
corner(window, 12)
stroke(window)

local header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 55),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0
}, window)
corner(header, 12)

create("TextLabel", {
    Position = UDim2.fromOffset(16, 0),
    Size = UDim2.new(0.6, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "POULT Y  /  v1.1",
    TextColor3 = C.green,
    TextSize = 23,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local function button(parent, text, pos, size)
    local b = create("TextButton", {
        Position = pos,
        Size = size,
        BackgroundColor3 = C.panel,
        Text = text,
        TextColor3 = C.text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = true,
        BorderSizePixel = 0
    }, parent)
    corner(b, 6)
    return b
end

local minimize = button(
    header, "—",
    UDim2.new(1, -76, 0, 10),
    UDim2.fromOffset(28, 32)
)

local close = button(
    header, "×",
    UDim2.new(1, -40, 0, 10),
    UDim2.fromOffset(28, 32)
)
close.TextColor3 = C.red

local sidebar = create("Frame", {
    Position = UDim2.fromOffset(12, 67),
    Size = UDim2.new(0, 175, 1, -80),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0
}, window)
corner(sidebar, 8)

local content = create("Frame", {
    Position = UDim2.fromOffset(197, 67),
    Size = UDim2.new(1, -209, 1, -80),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, window)
corner(content, 8)

local pageNames = {
    "Main", "Farm", "Boss Center", "Sea Events",
    "Player", "Travel", "Inventory", "Tools",
    "Settings", "Activity Log", "About"
}

local pages = {}
local navButtons = {}
local logs = {}
local favorites = {}

local function log(message)
    table.insert(logs, os.date("%H:%M:%S") .. "  " .. message)
    if #logs > 80 then
        table.remove(logs, 1)
    end
    print("[POULT Y] " .. message)
end

local function label(parent, text, pos, size, color, textSize)
    return create("TextLabel", {
        Position = pos,
        Size = size,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or C.text,
        TextSize = textSize or 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true
    }, parent)
end

local function clearPage(page)
    for _, child in ipairs(page:GetChildren()) do
        child:Destroy()
    end
end

local function actionButton(page, text, y, callback)
    local b = button(
        page, text,
        UDim2.fromOffset(8, y),
        UDim2.new(1, -16, 0, 34)
    )
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Text = "   " .. text
    b.Activated:Connect(callback)
    return b
end

local function buildPage(name, page)
    clearPage(page)

    label(page, name,
        UDim2.fromOffset(10, 5),
        UDim2.new(1, -20, 0, 34),
        C.green, 22)

    if name == "Main" then
        label(page, "Bem-vindo ao POULT Y.",
            UDim2.fromOffset(10, 45),
            UDim2.new(1, -20, 0, 30), C.text, 16)

        label(page, "Interface v1.1  |  Tema preto e verde",
            UDim2.fromOffset(10, 78),
            UDim2.new(1, -20, 0, 25), C.muted, 13)

        actionButton(page, "Ver Activity Log", 115, function()
            log("Painel de atividade solicitado")
            pages["Activity Log"].Visible = true
            for _, p in pairs(pages) do
                if p ~= pages["Activity Log"] then
                    p.Visible = false
                end
            end
        end)

        actionButton(page, "Adicionar Main aos favoritos", 155, function()
            favorites.Main = not favorites.Main
            log("Favorito Main: " .. tostring(favorites.Main))
        end)

    elseif name == "Farm" or name == "Boss Center"
        or name == "Sea Events" then

        label(page,
            "Módulo preparado para integração no seu próprio jogo.",
            UDim2.fromOffset(10, 45),
            UDim2.new(1, -20, 0, 48), C.muted, 13)

        actionButton(page, "Ativar modo de demonstração", 100, function()
            log(name .. ": demonstração ativada")
        end)

        actionButton(page, "Desativar demonstração", 140, function()
            log(name .. ": demonstração desativada")
        end)

    elseif name == "Settings" then
        actionButton(page, "Tema: Verde neon", 50, function()
            C.green = Color3.fromRGB(0, 255, 130)
            log("Tema verde selecionado")
        end)

        actionButton(page, "Tema: Azul", 90, function()
            C.green = Color3.fromRGB(65, 170, 255)
            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("UIStroke") then
                    obj.Color = C.green
                elseif obj:IsA("TextLabel")
                    and string.find(obj.Text, "POULT Y") then
                    obj.TextColor3 = C.green
                end
            end
            log("Tema azul selecionado")
        end)

        actionButton(page, "Restaurar tema verde", 130, function()
            C.green = Color3.fromRGB(0, 255, 130)
            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("UIStroke") then
                    obj.Color = C.green
                end
            end
            log("Tema verde restaurado")
        end)

    elseif name == "Activity Log" then
        actionButton(page, "Atualizar registro", 45, function()
            buildPage("Activity Log", page)
        end)

        local visible = math.min(#logs, 8)
        for i = 1, visible do
            local entry = logs[#logs - visible + i]
            label(page, entry,
                UDim2.fromOffset(10, 85 + (i - 1) * 27),
                UDim2.new(1, -20, 0, 25), C.muted, 11)
        end

    elseif name == "Travel" then
        label(page,
            "A navegação depende das APIs oficiais do seu jogo.",
            UDim2.fromOffset(10, 45),
            UDim2.new(1, -20, 0, 45), C.muted, 13)

        actionButton(page, "Registrar solicitação de viagem", 100, function()
            log("Solicitação de viagem registrada")
        end)

    elseif name == "Tools" then
        actionButton(page, "Verificar interface", 50, function()
            log("Verificação da interface concluída")
        end)

        actionButton(page, "Parada de emergência da interface", 90, function()
            log("Parada solicitada: ocultando janela")
            window.Visible = false
        end)

    elseif name == "About" then
        label(page,
            "POULT Y\nVersão 1.1\nProjeto experimental de interface Lua.",
            UDim2.fromOffset(10, 50),
            UDim2.new(1, -20, 0, 100), C.muted, 14)

    else
        label(page,
            "Módulo inicial. Novas funções serão adicionadas aqui.",
            UDim2.fromOffset(10, 45),
            UDim2.new(1, -20, 0, 45), C.muted, 13)
    end
end

local function showPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
    log("Aba aberta: " .. name)
end

for i, name in ipairs(pageNames) do
    local nav = button(
        sidebar, name,
        UDim2.fromOffset(7, 7 + (i - 1) * 35),
        UDim2.new(1, -14, 0, 30)
    )

    navButtons[name] = nav

    local page = create("Frame", {
        Name = name:gsub(" ", "") .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false
    }, content)

    pages[name] = page
    buildPage(name, page)

    nav.Activated:Connect(function()
        showPage(name)
    end)
end

-- Pesquisa global de abas
local search = create("TextBox", {
    Position = UDim2.new(1, -330, 0, 12),
    Size = UDim2.fromOffset(240, 30),
    BackgroundColor3 = C.bg,
    PlaceholderText = "Pesquisar abas...",
    Text = "",
    TextColor3 = C.text,
    PlaceholderColor3 = C.muted,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false
}, header)
corner(search)

search:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(search.Text)
    for name, nav in pairs(navButtons) do
        nav.Visible = query == ""
            or string.find(string.lower(name), query, 1, true) ~= nil
    end
end)

-- Minimizar e reabrir
local minimized = false

minimize.Activated:Connect(function()
    minimized = not minimized
    sidebar.Visible = not minimized
    content.Visible = not minimized
    window.Size = minimized
        and UDim2.fromOffset(740, 55)
        or UDim2.fromOffset(740, 480)
    minimize.Text = minimized and "+" or "—"
end)

close.Activated:Connect(function()
    gui:Destroy()
end)

-- Arrastar a janela
local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = window.Position
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

showPage("Main")
log("POULT Y v1.1 carregado")
