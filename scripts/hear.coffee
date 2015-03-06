path = require 'path'
cloudant = require path.join '..', 'plugins', 'cloudant.js';

module.exports = (robot) ->

  robot.hear /message/i, (msg) ->
    cloudant.push 'last-message', msg.message.text.replace /^sam\s/, ''
