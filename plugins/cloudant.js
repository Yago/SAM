var Cloudant = require('cloudant')

var cloudantAccount = 'yago'
var cloudantPassword = 'gi9wett0aK2Eg1B'

function push (dataKey, dataValue) {
  Cloudant({account:cloudantAccount, password:cloudantPassword}, function(err, cloudant) {
    var samBrain = cloudant.use('sam-brain')

    samBrain.get(dataKey, { revs_info: false }, function(err, body) {
      if (typeof body != 'undefined') {
        if (!err)
          samBrain.destroy(body._id, body._rev, function(err, body) {
            if (!err)
              samBrain.insert({ data: dataValue }, dataKey, function(err, body, header) {
                if (err)
                  return console.log('[alice.insert] ', err.message)
              })
          })
      } else {
        samBrain.insert({ data: dataValue }, dataKey, function(err, body, header) {
          if (err)
            return console.log('[alice.insert] ', err.message)
        })
      }
    });
  })
}

exports.push = push;