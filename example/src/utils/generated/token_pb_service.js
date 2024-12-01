// package: token_manager
// file: token.proto

var token_pb = require("./token_pb");
var grpc = require("@improbable-eng/grpc-web").grpc;

var TokenManager = (function () {
  function TokenManager() {}
  TokenManager.serviceName = "token_manager.TokenManager";
  return TokenManager;
}());

TokenManager.getInfoToken = {
  methodName: "getInfoToken",
  service: TokenManager,
  requestStream: false,
  responseStream: false,
  requestType: token_pb.GetInfoTokenRequest,
  responseType: token_pb.GetInfoTokenResponse
};

TokenManager.getBalance = {
  methodName: "getBalance",
  service: TokenManager,
  requestStream: false,
  responseStream: false,
  requestType: token_pb.GetBalanceTokenRequest,
  responseType: token_pb.GetBalanceTokenResponse
};

TokenManager.sendTransactionToken = {
  methodName: "sendTransactionToken",
  service: TokenManager,
  requestStream: false,
  responseStream: false,
  requestType: token_pb.SendTransactionTokenRequest,
  responseType: token_pb.SendTransactionTokenResponse
};

TokenManager.approveToken = {
  methodName: "approveToken",
  service: TokenManager,
  requestStream: false,
  responseStream: false,
  requestType: token_pb.ApproveTokenRequest,
  responseType: token_pb.ApproveTokenResponse
};

exports.TokenManager = TokenManager;

function TokenManagerClient(serviceHost, options) {
  this.serviceHost = serviceHost;
  this.options = options || {};
}

TokenManagerClient.prototype.getInfoToken = function getInfoToken(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(TokenManager.getInfoToken, {
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

TokenManagerClient.prototype.getBalance = function getBalance(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(TokenManager.getBalance, {
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

TokenManagerClient.prototype.sendTransactionToken = function sendTransactionToken(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(TokenManager.sendTransactionToken, {
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

TokenManagerClient.prototype.approveToken = function approveToken(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(TokenManager.approveToken, {
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

exports.TokenManagerClient = TokenManagerClient;

