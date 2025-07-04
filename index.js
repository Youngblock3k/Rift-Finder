require("dotenv").config();
const fs = require("fs");
const noblox = require("noblox.js");
const { Client, GatewayIntentBits, EmbedBuilder } = require("discord.js");

const client = new Client({
  intents: [GatewayIntentBits.Guilds]
});

(async () => {
  try {
    // Load events
    fs.readdirSync("./Events").forEach((file) => {
      const event = require(`./Events/${file}`);
      const name = file.split(".")[0];

      if (name === "ready") {
        client.once(name, (...args) => event(client, ...args));
      } else {
        client.on(name, (...args) => event(...args));
      }
    });

    // Login Discord
    await client.login(process.env.DISCORD_TOKEN);

    // Login Roblox
    await noblox.setCookie(process.env.ROBLOSECURITY);
    const user = await noblox.getCurrentUser();
    console.log(`[🤖] Logged into Roblox as ${user.UserName}`);

    // Launch game
    const open = await import("open");
    await open.default(`roblox://placeId=85896571713843`);
    console.log(`[🎮] Game launched.`);

    // Send Discord embed
    const channel = client.channels.cache.get(process.env.WEBHOOK_CHANNEL_ID);
    if (channel) {
      const embed = new EmbedBuilder()
        .setTitle("🌀 Rift Bot Online")
        .setDescription(`Logged in as **${user.UserName}** and launched Bubble Gum Simulator Infinity.`)
        .setColor("Blue")
        .setTimestamp();

      channel.send({ embeds: [embed] });
    } else {
      console.log("⚠️ Channel not found!");
    }
  } catch (err) {
    console.error("❌ Bot error:", err);
  }
})();
