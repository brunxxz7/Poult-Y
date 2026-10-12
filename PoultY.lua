-- Quantum Onyx Hub - Refactored (No-Key Version)
local API_CONFIG = {
    DISCORD_INVITE = "https://discord.gg/quantumonyx",
}

local Directory = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/Games"
local Scripts = {
    Free = {
        [994732206] = Directory .. "/BloxFruits.lua",
        [9186719164] = Directory .. "/SailorPiece.lua",
        [8191429227] = Directory .. "/CutTrees.lua",
    },
}

-- URL do Loader Premium/VIP
local STOCK_LOADER_URL = "https://api.luarmor.net/files/v4/loaders/0ae9fe4cf963e3a13d25eed0e2ce5940.lua"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local GameId = game.GameId

-- Utilitários preservados para compatibilidade com o script carregado
local function Tween(obj, props, t, style, dir)
    style = style or Enum.EasingStyle.Quint
    dir = dir or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(t, style, dir), props):Play()
end

local function Protect(gui)
    local env = (getgenv and getgenv()) or _G
    if env.HIDEUI then
        gui.Parent = env.HIDEUI
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end
end

local function Notify(title, desc, accent, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Quantum Onyx",
            Text = desc or "",
            Duration = duration or 5,
        })
    end)
end

-- Função de carregamento do Loader Premium
local function LoadStockLoader()
    pcall(function()
        Notify("Quantum Onyx", "Loading Premium/VIP Features...", Color3.fromRGB(120, 60, 220))
        loadstring(game:HttpGet(STOCK_LOADER_URL))()
    end)
end

-- Função de carregamento de Scripts Gratuitos
local function LoadFreeScript()
    local url = Scripts.Free[GameId]
    if url then
        pcall(function() 
            Notify("Quantum Onyx", "Loading Free Script...", Color3.fromRGB(100, 100, 100))
            loadstring(game:HttpGet(url))() 
        end)
    else
        warn("[Quantum Onyx] No free script for GameId: " .. tostring(GameId))
        Notify("Erro", "Nenhum script gratuito disponível para este jogo.", Color3.fromRGB(255, 0, 0))
    end
end

-- Bypass de Autenticação: Forçando variáveis de ambiente para enganar o script remoto
getgenv().script_key = "BYPASS_ACTIVE"
getgenv().key = "BYPASS_ACTIVE"
getgenv().key_expire = -1 -- Lifetime
getgenv().key_note = "Bypassed Access"

if type(_G) == "table" then _G.script_key = "BYPASS_ACTIVE" end
if type(shared) == "table" then shared.script_key = "BYPASS_ACTIVE" end

-- EXECUÇÃO DIRETA
-- O script agora tenta carregar a versão Premium primeiro. 
-- Se falhar ou se você quiser a Free, pode alterar a chamada abaixo.

task.spawn(function()
    Notify("Quantum Onyx Hub", "Authentication Bypassed. Accessing Panel...", Color3.fromRGB(80, 230, 130))
    
    -- Tenta carregar o Loader VIP/Premium diretamente
    LoadStockLoader()
    
    -- Caso o jogo seja suportado na lista Free e o Loader Premium não inicie, 
    -- você pode descomentar a linha abaixo para carregar a versão Free como fallback:
    -- LoadFreeScript()
end)
