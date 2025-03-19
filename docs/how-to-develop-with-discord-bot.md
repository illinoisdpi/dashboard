# How to Develop with Discord Bot

## Overview

We have developed a Discord Bot to automate tasks. As we continue to develop the dashboard, we might need to add more features to the bot. This guide will help you get started with developing the Discord Bot.

## Getting Started

The discord bot has been created for both development and production environments. I will include a guide to creating a new bot and inviting it to a server later on, but that should not be necessary anymore. (unless someone deletes the bot)

I have stored both the development bot and production bot's keys in Rails Credentials, so this requires no setup on your end.

## Working in Development

Since the bot credentials are already set, you just need to connect to the Development Discord Server, so we are not overloading the production server with test messages. [Click Here for the Invite](https://discord.gg/zkQcG3ydDt).

## Working in Production

The bot is already in the production server, so you can test your changes there.

## Creating a Bot

Again this will not be necessary, but it is here as a reference if the bot ever gets deleted.

1. Go to the [Discord Developer Portal](https://discord.com/developers/applications)
2. Sign in as `discord@dpi.dev`. Ask Ian for the password.
3. Click on `New Application`
4. Name the application based on the environment you are creating it for. (e.g. `DPI Bot - Development`) or (`DPI Bot`) for production.
5. Copy the token on the `Bot` page and store it in Rails Credentials. (e.g. `EDITOR="nano" bin/rails credentials:edit --environment development`)

## Inviting the Bot to a Server

1. Click on `Bot` in the left sidebar.
2. Toggle `Presence Intent`, `Server Members Intent`, and `Message Content Intent` to on.
3. Click on `Installation` and copy the `Invite Link`
4. Add this query parameter to the end of the invite URL to set permissions: `&scope=bot&permissions=3072` (3072 is the bit math for `Send Messages` and `View Channels` the minimum permissions required for the bot to work. Based on a later feature **you might need to recalculate this**)
5. Select the server you want to invite the bot to and click `Authorize`. If you cannot find the server, you might not have enough permissions to add the bot to the server.
