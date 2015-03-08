path = require 'path'
emojis = require path.join '..', 'plugins', 'emoji.js'
{msgVariables, stringElseRandomKey} = require path.join '..', 'node_modules', 'hubot-tellbot', 'lib', 'common.coffee'

class tell
  constructor: (@interaction) ->
  process: (msg) =>
    messageType = @interaction.messageType?.toLowerCase() or 'tell'
    switch messageType
      when 'action', 'emote'
        messageType = 'emote'
      else
        messageType = 'send'

    message = stringElseRandomKey @interaction.message

    emojified = emojis.print message

    message = msgVariables emojified, msg
    msg[messageType] message

module.exports = tell
