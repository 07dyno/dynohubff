import discord
from discord.ext import commands
import pytesseract
import requests
import os
from io import BytesIO

# ===== CONFIG =====
TOKEN = os.getenv("TOKEN")  # Pegamos do ambiente no Render
GUILD_ID = 1405600016135094323
ROLE_ID_1 = 1394930083503931412
ROLE_ID_2 = 1394929411630960791
CANAL_VERIFICACAO_ID = 1398880681584754748
CANAL_STATUS_ID = 1407892073331429456  # Coloque o ID do canal de status
LINK_SCRIPTS = "https://discord.com/channels/1394924154985254993/1399178500656595125"

# ===== BOT =====
intents = discord.Intents.default()
intents.messages = True
intents.message_content = True
intents.guilds = True
intents.members = True

bot = commands.Bot(command_prefix="!", intents=intents)

# ===== BOT ONLINE =====
@bot.event
async def on_ready():
    print(f"🤖 Bot logado como {bot.user}")
    canal = bot.get_channel(CANAL_STATUS_ID)
    if canal:
        memoria = round(os.sys.getsizeof(bot) / 1024 / 1024, 2)
        await canal.send(f"✅ **Bot online!**\n📊 Memória: {memoria}MB\n📡 Ping: {round(bot.latency*1000)}ms")

# ===== VERIFICAÇÃO =====
@bot.event
async def on_message(message):
    if message.author.bot:
        return
    if message.channel.id != CANAL_VERIFICACAO_ID:
        return
    if not message.attachments:
        return

    await message.reply("🔍 Lendo sua imagem, aguarde...")

    try:
        # Baixar imagem
        url = message.attachments[0].url
        response = requests.get(url)
        img = BytesIO(response.content)

        # OCR com Tesseract
        texto = pytesseract.image_to_string(img, lang="por").lower()
        print("📝 Texto detectado:", texto)

        if "inscrito" in texto or "subscrito" in texto:
            membro = message.guild.get_member(message.author.id)
            if membro:
                role1 = message.guild.get_role(ROLE_ID_1)
                role2 = message.guild.get_role(ROLE_ID_2)
                await membro.add_roles(role1, role2)

            # Botão com link
            view = discord.ui.View()
            view.add_item(discord.ui.Button(label="📂 Ir para Scripts", url=LINK_SCRIPTS))

            await message.reply(
                "🎉 **Parabéns! Você foi verificado com sucesso.**\nAgora clique no botão abaixo para pegar seus scripts:",
                view=view
            )
        else:
            await message.reply("❌ Não encontrei nada que prove que você está inscrito. Envie outra imagem.")

    except Exception as e:
        print("Erro:", e)
        await message.reply("⚠️ Erro ao processar a imagem.")

    await bot.process_commands(message)

# ===== /status =====
@bot.tree.command(name="status", description="Mostra o status do bot")
async def status(interaction: discord.Interaction):
    memoria = round(os.sys.getsizeof(bot) / 1024 / 1024, 2)
    ping = round(bot.latency * 1000)
    await interaction.response.send_message(f"📊 **Status do Bot**\n💾 Memória usada: {memoria} MB\n📡 Ping: {ping}ms")

# ===== RUN =====
bot.run(TOKEN)
