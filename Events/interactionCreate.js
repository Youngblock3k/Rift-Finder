module.exports = async (interaction) => {
  if (!interaction.isCommand()) return;

  if (interaction.commandName === "ping") {
    await interaction.reply("🏓 Pong via Slash Command!");
  }
};
