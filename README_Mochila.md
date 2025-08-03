# 🎒 Sistema de Mochila para Roblox

Um script completo de mochila/inventário para jogos no Roblox com interface gráfica moderna e funcionalidades completas.

## 📋 Funcionalidades

- ✅ **Interface moderna** com cantos arredondados e animações
- ✅ **20 slots** para itens (configurável)
- ✅ **Sistema de raridade** com cores diferentes
- ✅ **Ícones emoji** para representar itens
- ✅ **Quantidade de itens** visível
- ✅ **Animações suaves** para abrir/fechar
- ✅ **Atalho de teclado** (tecla B)
- ✅ **Clique para ver informações** dos itens
- ✅ **Clique direito para remover** itens
- ✅ **Scroll automático** quando há muitos itens

## 🚀 Como Usar

### 1. Instalação
1. Abra o Roblox Studio
2. Vá para `StarterPlayer > StarterPlayerScripts`
3. Crie um novo `LocalScript`
4. Cole o código do arquivo `BackpackScript.lua`
5. Renomeie o script para "BackpackScript"

### 2. Controles
- **Botão 🎒**: Clique no botão no canto inferior direito da tela
- **Tecla B**: Pressione a tecla B para abrir/fechar a mochila
- **Clique esquerdo**: Ver informações do item
- **Clique direito**: Remover 1 unidade do item
- **Botão X**: Fechar a mochila

### 3. Adicionando Novos Itens

Para adicionar novos itens, edite a seção `itemsData`:

```lua
local itemsData = {
    ["Nome do Item"] = {
        icon = "🎯",  -- Emoji do item
        description = "Descrição do item",
        rarity = "Raro"  -- Comum, Raro, ou Épico
    }
}
```

### 4. Adicionando Itens ao Inventário

Use a função `addItemToInventory()`:

```lua
addItemToInventory("Nome do Item", quantidade)
```

## 🎨 Personalização

### Cores por Raridade
- **Comum**: Cinza (150, 150, 150)
- **Raro**: Azul (100, 150, 255)  
- **Épico**: Rosa (255, 100, 255)

### Configurações Ajustáveis
```lua
local BACKPACK_SIZE = 20  -- Número de slots
local SLOTS_PER_ROW = 5   -- Slots por linha
```

## 📱 Interface

A mochila possui:
- **Título** com ícone de mochila
- **Botão de fechar** (X vermelho)
- **Grid de slots** organizados
- **Scroll** quando necessário
- **Botão flutuante** sempre visível

## 🔧 Funcionalidades Técnicas

- Sistema de inventário baseado em array
- Detecção automática de itens duplicados
- Atualização em tempo real da interface
- Animações com TweenService
- Suporte a eventos de mouse e teclado

## 📝 Itens de Exemplo Incluídos

- ⚔️ **Espada** (Comum)
- 🧪 **Poção de Vida** (Raro) - 3 unidades
- 🛡️ **Escudo** (Comum)
- 💎 **Gema Mágica** (Épico)
- 🏹 **Arco** (Raro)

## ⚠️ Observações

- Este é um script **LocalScript** (só funciona no cliente)
- Para persistência de dados, adicione sistema de DataStore
- Para multiplayer, implemente RemoteEvents
- Os itens são apenas visuais - adicione lógica de jogo conforme necessário

## 🐛 Solução de Problemas

1. **Script não funciona**: Verifique se está em StarterPlayerScripts
2. **Botão não aparece**: Aguarde alguns segundos para carregar
3. **Itens não aparecem**: Verifique se os nomes estão corretos no itemsData

---

**Criado para Roblox Studio** 🎮