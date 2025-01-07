require 'discordrb'

DISCORD_BOT = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])

DISCORD_BOT.run(true)

Rails.logger.info("Discord bot is now running asynchronously.")
