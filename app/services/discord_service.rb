class DiscordService
  def fetch_channels(discord_server_id)
    return [] if discord_server_id.blank?

    server = DISCORD_BOT.server(discord_server_id.to_i)
    return [] unless server

    server.channels.select { |ch| ch.type == 0 }.map { |ch| { id: ch.id.to_s, name: ch.name } }
  rescue => e
    Rails.logger.error("[DiscordService#fetch_channels] Error: #{e.message}")
    []
  end

  def fetch_channel(server_id, channel_id)
    channel = DISCORD_BOT.channel(channel_id.to_i)
    return nil unless channel && channel.type == 0

    {
      id: channel.id.to_s,
      name: channel.name,
      topic: channel.topic,
    }
  rescue => e
    Rails.logger.error("[DiscordService#fetch_channel] Error: #{e.message}")
    nil
  end

  # def send_message(channel_id, content)
  #   return if channel_id.blank? || content.blank?

  #   channel = DISCORD_BOT.channel(channel_id.to_i)
  #   channel&.send_message(content)
  # rescue => e
  #   Rails.logger.error("[DiscordService#send_message] Error: #{e.message}")
  # end
end
