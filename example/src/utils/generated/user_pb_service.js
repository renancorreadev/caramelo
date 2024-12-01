// package: user_management
// file: user.proto

var user_pb = require("./user_pb");
var grpc = require("@improbable-eng/grpc-web").grpc;

var UserManager = (function () {
  function UserManager() {}
  UserManager.serviceName = "user_management.UserManager";
  return UserManager;
}());

UserManager.getMyInfo = {
  methodName: "getMyInfo",
  service: UserManager,
  requestStream: false,
  responseStream: false,
  requestType: user_pb.GetMyInfoRequest,
  responseType: user_pb.GetMyInfoResponse
};

exports.UserManager = UserManager;

function UserManagerClient(serviceHost, options) {
  this.serviceHost = serviceHost;
  this.options = options || {};
}

UserManagerClient.prototype.getMyInfo = function getMyInfo(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(UserManager.getMyInfo, {
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

exports.UserManagerClient = UserManagerClient;

