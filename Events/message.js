module.exports = async (message) => {
  if (message.author.bot) return;
  
  if (message.content === "!ping") {
    message.reply("🏓 Pong!");
  }
};
