// package: account_manager
// file: account.proto

var account_pb = require("./account_pb");
var grpc = require("@improbable-eng/grpc-web").grpc;

var AccountManager = (function () {
  function AccountManager() {}
  AccountManager.serviceName = "account_manager.AccountManager";
  return AccountManager;
}());

AccountManager.GetBalance = {
  methodName: "GetBalance",
  service: AccountManager,
  requestStream: false,
  responseStream: false,
  requestType: account_pb.GetBalanceRequest,
  responseType: account_pb.GetBalanceResponse
};

exports.AccountManager = AccountManager;

function AccountManagerClient(serviceHost, options) {
  this.serviceHost = serviceHost;
  this.options = options || {};
}

AccountManagerClient.prototype.getBalance = function getBalance(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(AccountManager.GetBalance, {
    request: requestMessage,
    host: this.serviceHost,
    metadata: metadata,
    transport: this.options.transport,
    debug: this.options.debug,
    onEnd: function (response) {
      if (callback) {
        if (response.status !== grpc.Code.OK) {
          var err = new Error(response.statusMessage);
          err.code = response.status;
          err.metadata = response.trailers;
          callback(err, null);
        } else {
          callback(null, response.message);
        }
      }
    }
  });
  return {
    cancel: function () {
      callback = null;
      client.close();
    }
  };
};

exports.AccountManagerClient = AccountManagerClient;

