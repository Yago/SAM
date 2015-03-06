var Cloudant = require('cloudant')

var cloudantAccount = 'yago'
var cloudantPassword = process.env.HUBOT_CLOUDANT_PASS

function push (dataKey, dataValue) {
  Cloudant({account:cloudantAccount, password:cloudantPassword}, function(err, cloudant) {
    var samBrain = cloudant.use('sam-brain');

    samBrain.get(dataKey, { revs_info: false }, function(err, body) {
      if (typeof body != 'undefined') {
        if (!err)
          samBrain.destroy(body._id, body._rev, function(err, body) {
            if (!err)
              samBrain.insert({ data: dataValue }, dataKey, function(err, body, header) {
                if (err)
                  return console.log('[data.insert] ', err.message)
              })
          })
      } else {
        samBrain.insert({ data: dataValue }, dataKey, function(err, body, header) {
          if (err)
            return console.log('[data.insert] ', err.message)
        })
      }
    });
  })
}
exports.push = push;

function pull (dataKey, callback) {
  Cloudant({account:cloudantAccount, password:cloudantPassword}, function(err, cloudant) {
    var samBrain = cloudant.use('sam-brain');

    samBrain.get(dataKey, { revs_info: true }, function(err, body) {
      if (typeof body != 'undefined') {
        if (!err) {
          var data = body.data;
          callback(data);
        }
      }
    });
  })
}
exports.pull = pull;