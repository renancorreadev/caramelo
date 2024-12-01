// package: Auth_manager
// file: auth.proto

var auth_pb = require("./auth_pb");
var grpc = require("@improbable-eng/grpc-web").grpc;

var AuthManager = (function () {
  function AuthManager() {}
  AuthManager.serviceName = "Auth_manager.AuthManager";
  return AuthManager;
}());

AuthManager.registration = {
  methodName: "registration",
  service: AuthManager,
  requestStream: false,
  responseStream: false,
  requestType: auth_pb.CreateUserRequest,
  responseType: auth_pb.CreateUserResponse
};

AuthManager.generateTwoFactorAuthenticationCode = {
  methodName: "generateTwoFactorAuthenticationCode",
  service: AuthManager,
  requestStream: false,
  responseStream: false,
  requestType: auth_pb.genAuthenticationCodeRequest,
  responseType: auth_pb.genAuthenticationCodeResponse
};

AuthManager.turnOnTwoFactorAuthentication = {
  methodName: "turnOnTwoFactorAuthentication",
  service: AuthManager,
  requestStream: false,
  responseStream: false,
  requestType: auth_pb.turnOnTwoFactorAuthenticationRequest,
  responseType: auth_pb.turnOnTwoFactorAuthenticationResponse
};

AuthManager.loggingIn = {
  methodName: "loggingIn",
  service: AuthManager,
  requestStream: false,
  responseStream: false,
  requestType: auth_pb.loggingInRequest,
  responseType: auth_pb.loggingInResponse
};

exports.AuthManager = AuthManager;

function AuthManagerClient(serviceHost, options) {
  this.serviceHost = serviceHost;
  this.options = options || {};
}

AuthManagerClient.prototype.registration = function registration(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(AuthManager.registration, {
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

AuthManagerClient.prototype.generateTwoFactorAuthenticationCode = function generateTwoFactorAuthenticationCode(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(AuthManager.generateTwoFactorAuthenticationCode, {
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

AuthManagerClient.prototype.turnOnTwoFactorAuthentication = function turnOnTwoFactorAuthentication(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(AuthManager.turnOnTwoFactorAuthentication, {
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

AuthManagerClient.prototype.loggingIn = function loggingIn(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(AuthManager.loggingIn, {
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

exports.AuthManagerClient = AuthManagerClient;

