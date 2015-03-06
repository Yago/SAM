path = require 'path'
cloudant = require path.join '..', 'plugins', 'cloudant.js';

module.exports = (robot) ->

  robot.hear /last/i, (msg) ->
    cloudant.pull 'last-message', (data) ->
      msg.send data
