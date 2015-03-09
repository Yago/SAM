path = require 'path'
cloudant = require path.join '..', 'plugins', 'cloudant.js';

apiKey = process.env.HUBOT_MAP_API_KEY

module.exports = (robot) ->

  robot.hear /^\d*\.\d*\,\d*\.\d*$/, (msg) ->
    cloudant.push 'last-position', msg.message.text.replace /^sam\s/, ''

  robot.hear /(^https\:\/\/maps\.google\.com\/\?ll\=)(\d*\.\d*\,\d*\.\d*)(\&z\=\d*$)/, (msg) ->
    cloudant.push 'last-position', msg.match[2]

  robot.hear /(^sam\s)(https\:\/\/maps\.google\.com\/\?ll\=)(\d*\.\d*\,\d*\.\d*)(\&z\=\d*$)/, (msg) ->
    cloudant.push 'last-position', msg.match[3]

  # Search https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=46.569222,6.828633&radius=5000&name=postomat&key=mykeyhere

  robot.hear /(\w*\s)((la|le)\s)(plus\sproche)/, (msg) ->
    cloudant.pull 'last-position', (data) ->
      coord = data.replace ' ', ''
      robot.http("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+coord+"&radius=5000&name="+msg.match[1]+"&key="+apiKey).get() (err, res, body) ->
          # msg.send body.results[0].geometry.location.lat
          result = JSON.parse(body)
          console.log coord
          coord = result.results[0].geometry.location.lat+","+result.results[0].geometry.location.lng

          staticMap = "https://maps.googleapis.com/maps/api/staticmap?center="+coord+"&zoom=16&size=400x400\
&markers=color:red%7Clabel:S%7C"+coord+""

          mapUrl = "http://maps.google.com/maps?hl=fr&q="+coord+"&z=17"

          msg.send staticMap
          msg.send "Alors, "+msg.match[2]+msg.match[1]+msg.match[2]+"plus proche est "+msg.match[2]+result.results[0].name+", "+result.results[0].vicinity+"."
          msg.send "📍 => "+mapUrl+""