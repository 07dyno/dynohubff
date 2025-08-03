-- Script da Mochila para Roblox
-- Coloque este script em StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configurações da mochila
local BACKPACK_SIZE = 20 -- Número de slots
local SLOT_SIZE = UDim2.new(0, 60, 0, 60)
local SLOTS_PER_ROW = 5

-- Criar a GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BackpackGUI"
screenGui.Parent = playerGui

-- Frame principal da mochila
local backpackFrame = Instance.new("Frame")
backpackFrame.Name = "BackpackFrame"
backpackFrame.Size = UDim2.new(0, 350, 0, 300)
backpackFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
backpackFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
backpackFrame.BorderSizePixel = 0
backpackFrame.Visible = false
backpackFrame.Parent = screenGui

-- Adicionar cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = backpackFrame

-- Título da mochila
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "🎒 MOCHILA"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = backpackFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botão de fechar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = backpackFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton

-- Área dos slots
local slotsFrame = Instance.new("ScrollingFrame")
slotsFrame.Name = "SlotsFrame"
slotsFrame.Size = UDim2.new(1, -20, 1, -50)
slotsFrame.Position = UDim2.new(0, 10, 0, 40)
slotsFrame.BackgroundTransparency = 1
slotsFrame.BorderSizePixel = 0
slotsFrame.ScrollBarThickness = 8
slotsFrame.CanvasSize = UDim2.new(0, 0, 0, math.ceil(BACKPACK_SIZE / SLOTS_PER_ROW) * 70)
slotsFrame.Parent = backpackFrame

-- Grid layout para os slots
local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = SLOT_SIZE
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.FillDirection = Enum.FillDirection.Horizontal
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = slotsFrame

-- Botão para abrir a mochila
local openButton = Instance.new("TextButton")
openButton.Name = "OpenBackpackButton"
openButton.Size = UDim2.new(0, 80, 0, 80)
openButton.Position = UDim2.new(1, -90, 1, -90)
openButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
openButton.BorderSizePixel = 0
openButton.Text = "🎒"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextScaled = true
openButton.Font = Enum.Font.GothamBold
openButton.Parent = screenGui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 40)
buttonCorner.Parent = openButton

-- Sistema de itens (dados dos itens)
local itemsData = {
    ["Espada"] = {
        icon = "⚔️",
        description = "Uma espada afiada",
        rarity = "Comum"
    },
    ["Poção de Vida"] = {
        icon = "🧪",
        description = "Restaura 50 HP",
        rarity = "Raro"
    },
    ["Escudo"] = {
        icon = "🛡️",
        description = "Proteção contra ataques",
        rarity = "Comum"
    },
    ["Gema Mágica"] = {
        icon = "💎",
        description = "Item muito valioso",
        rarity = "Épico"
    },
    ["Arco"] = {
        icon = "🏹",
        description = "Ataque à distância",
        rarity = "Raro"
    }
}

-- Inventário do jogador
local playerInventory = {}

-- Função para criar um slot
local function createSlot(slotNumber)
    local slot = Instance.new("Frame")
    slot.Name = "Slot" .. slotNumber
    slot.Size = SLOT_SIZE
    slot.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    slot.BorderSizePixel = 1
    slot.BorderColor3 = Color3.fromRGB(100, 100, 100)
    slot.Parent = slotsFrame
    
    local slotCorner = Instance.new("UICorner")
    slotCorner.CornerRadius = UDim.new(0, 5)
    slotCorner.Parent = slot
    
    -- Label para o item
    local itemLabel = Instance.new("TextLabel")
    itemLabel.Name = "ItemLabel"
    itemLabel.Size = UDim2.new(1, 0, 0.7, 0)
    itemLabel.Position = UDim2.new(0, 0, 0, 0)
    itemLabel.BackgroundTransparency = 1
    itemLabel.Text = ""
    itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemLabel.TextScaled = true
    itemLabel.Font = Enum.Font.Gotham
    itemLabel.Parent = slot
    
    -- Label para quantidade
    local quantityLabel = Instance.new("TextLabel")
    quantityLabel.Name = "QuantityLabel"
    quantityLabel.Size = UDim2.new(1, 0, 0.3, 0)
    quantityLabel.Position = UDim2.new(0, 0, 0.7, 0)
    quantityLabel.BackgroundTransparency = 1
    quantityLabel.Text = ""
    quantityLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    quantityLabel.TextScaled = true
    quantityLabel.Font = Enum.Font.Gotham
    quantityLabel.Parent = slot
    
    -- Botão invisível para detectar cliques
    local clickDetector = Instance.new("TextButton")
    clickDetector.Name = "ClickDetector"
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = slot
    
    return slot
end

-- Criar todos os slots
for i = 1, BACKPACK_SIZE do
    createSlot(i)
end

-- Função para adicionar item ao inventário
local function addItemToInventory(itemName, quantity)
    quantity = quantity or 1
    
    if not itemsData[itemName] then
        warn("Item não encontrado: " .. itemName)
        return false
    end
    
    -- Procurar se o item já existe no inventário
    for i, item in pairs(playerInventory) do
        if item.name == itemName then
            item.quantity = item.quantity + quantity
            updateSlotDisplay(i)
            return true
        end
    end
    
    -- Procurar slot vazio
    for i = 1, BACKPACK_SIZE do
        if not playerInventory[i] then
            playerInventory[i] = {
                name = itemName,
                quantity = quantity
            }
            updateSlotDisplay(i)
            return true
        end
    end
    
    warn("Inventário cheio!")
    return false
end

-- Função para atualizar a exibição de um slot
function updateSlotDisplay(slotIndex)
    local slot = slotsFrame:FindFirstChild("Slot" .. slotIndex)
    if not slot then return end
    
    local itemLabel = slot:FindFirstChild("ItemLabel")
    local quantityLabel = slot:FindFirstChild("QuantityLabel")
    
    if playerInventory[slotIndex] then
        local item = playerInventory[slotIndex]
        local itemData = itemsData[item.name]
        
        itemLabel.Text = itemData.icon
        quantityLabel.Text = item.quantity > 1 and tostring(item.quantity) or ""
        
        -- Cor baseada na raridade
        if itemData.rarity == "Comum" then
            slot.BorderColor3 = Color3.fromRGB(150, 150, 150)
        elseif itemData.rarity == "Raro" then
            slot.BorderColor3 = Color3.fromRGB(100, 150, 255)
        elseif itemData.rarity == "Épico" then
            slot.BorderColor3 = Color3.fromRGB(255, 100, 255)
        end
    else
        itemLabel.Text = ""
        quantityLabel.Text = ""
        slot.BorderColor3 = Color3.fromRGB(100, 100, 100)
    end
end

-- Função para remover item do inventário
local function removeItemFromInventory(slotIndex, quantity)
    quantity = quantity or 1
    
    if not playerInventory[slotIndex] then return false end
    
    local item = playerInventory[slotIndex]
    item.quantity = item.quantity - quantity
    
    if item.quantity <= 0 then
        playerInventory[slotIndex] = nil
    end
    
    updateSlotDisplay(slotIndex)
    return true
end

-- Eventos dos botões
openButton.MouseButton1Click:Connect(function()
    backpackFrame.Visible = true
    
    -- Animação de abertura
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(backpackFrame, tweenInfo, {
        Size = UDim2.new(0, 350, 0, 300)
    })
    tween:Play()
end)

closeButton.MouseButton1Click:Connect(function()
    -- Animação de fechamento
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local tween = TweenService:Create(backpackFrame, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0)
    })
    tween:Play()
    
    tween.Completed:Connect(function()
        backpackFrame.Visible = false
        backpackFrame.Size = UDim2.new(0, 350, 0, 300)
    end)
end)

-- Detectar cliques nos slots
for i = 1, BACKPACK_SIZE do
    local slot = slotsFrame:FindFirstChild("Slot" .. i)
    local clickDetector = slot:FindFirstChild("ClickDetector")
    
    clickDetector.MouseButton1Click:Connect(function()
        if playerInventory[i] then
            local item = playerInventory[i]
            local itemData = itemsData[item.name]
            
            -- Mostrar informações do item
            print("Item: " .. item.name)
            print("Descrição: " .. itemData.description)
            print("Raridade: " .. itemData.rarity)
            print("Quantidade: " .. item.quantity)
        end
    end)
    
    -- Remover item com clique direito
    clickDetector.MouseButton2Click:Connect(function()
        if playerInventory[i] then
            removeItemFromInventory(i, 1)
        end
    end)
end

-- Atalho do teclado para abrir/fechar mochila
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.B then
        backpackFrame.Visible = not backpackFrame.Visible
    end
end)

-- Adicionar alguns itens de exemplo para teste
wait(1) -- Esperar um segundo para tudo carregar
addItemToInventory("Espada", 1)
addItemToInventory("Poção de Vida", 3)
addItemToInventory("Escudo", 1)
addItemToInventory("Gema Mágica", 1)
addItemToInventory("Arco", 1)

print("Sistema de mochila carregado! Pressione 'B' ou clique no botão para abrir.")
print("Clique esquerdo nos itens para ver informações, clique direito para remover.")