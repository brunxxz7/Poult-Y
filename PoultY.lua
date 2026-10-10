
-- POULT Y | UI Prototype v1.0
-- Roblox Studio: LocalScript em StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "PoultY"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local green = Color3.fromRGB(0, 255, 130)
local dark = Color3.fromRGB(12, 15, 15)
local panelColor = Color3.fromRGB(20, 25, 24)
local muted = Color3.fromRGB(155, 175, 165)

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(720, 450),
    Position = UDim2.new(0.5, -360, 0.5, -225),
    BackgroundColor3 = dark,
    BorderSizePixel = 0,
}, gui)

make("UICorner", {CornerRadius = UDim.new(0, 12)}, main)
make("UIStroke", {Color = green, Transparency = 0.25}, main)

local header = make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 55),
    Position = UDim2.fromOffset(15, 4),
    BackgroundTransparency = 1,
    Text = "POULT Y   //   v1.0.0",
    TextColor3 = green,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    TextXAlignment = Enum.TextXAlignment.Left,
}, main)

local sidebar = make("Frame", {
    Position = UDim2.fromOffset(12, 65),
    Size = UDim2.new(0, 165, 1, -80),
    BackgroundColor3 = panelColor,
    BorderSizePixel = 0,
}, main)

make("UICorner", {CornerRadius = UDim.new(0, 8)}, sidebar)

local content = make("Frame", {
    Position = UDim2.fromOffset(190, 65),
    Size = UDim2.new(1, -205, 1, -80),
    BackgroundColor3 = panelColor,
    BorderSizePixel = 0,
}, main)

make("UICorner", {CornerRadius = UDim.new(0, 8)}, content)

local pages = {}
local names = {
    "Main", "Farm", "Boss Center", "Sea Events",
    "Player", "Travel", "Inventory", "Tools",
    "Settings", "About"
}

local function showPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
end

for i, name in ipairs(names) do
    local button = make("TextButton", {
        Name = name:gsub(" ", "") .. "Button",
        Position = UDim2.fromOffset(8, 8 + (i - 1) * 35),
        Size = UDim2.new(1, -16, 0, 30),
        BackgroundColor3 = panelColor,
        Text = name,
        TextColor3 = green,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        AutoButtonColor = true,
    }, sidebar)

    make("UICorner", {CornerRadius = UDim.new(0, 5)}, button)

    local page = make("Frame", {
        Name = name:gsub(" ", "") .. "Page",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
        Visible = false,
    }, content)

    pages[name] = page

    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = green,
        Font = Enum.Font.GothamBold,
        TextSize = 21,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, page)

    make("TextLabel", {
        Position = UDim2.fromOffset(0, 42),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = name == "Main"
            and "Bem-vindo ao POULT Y."
            or "Módulo preparado para implementação.",
        TextColor3 = muted,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, page)

    button.Activated:Connect(function()
        showPage(name)
    end)
end

showPage("Main")

-- Arrastar o painel pela barra superior
local dragging = false
local dragStart, startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

print("POULT Y: interface carregada.")
