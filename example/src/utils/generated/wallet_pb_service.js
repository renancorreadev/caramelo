// package: wallet_manager
// file: wallet.proto

var wallet_pb = require("./wallet_pb");
var grpc = require("@improbable-eng/grpc-web").grpc;

var WalletManager = (function () {
  function WalletManager() {}
  WalletManager.serviceName = "wallet_manager.WalletManager";
  return WalletManager;
}());

WalletManager.CreateWallet = {
  methodName: "CreateWallet",
  service: WalletManager,
  requestStream: false,
  responseStream: false,
  requestType: wallet_pb.CreateWalletRequest,
  responseType: wallet_pb.CreateWalletResponse
};

WalletManager.ExportWallet = {
  methodName: "ExportWallet",
  service: WalletManager,
  requestStream: false,
  responseStream: false,
  requestType: wallet_pb.ExportWalletRequest,
  responseType: wallet_pb.ExportWalletResponse
};

WalletManager.SingTransactionUr = {
  methodName: "SingTransactionUr",
  service: WalletManager,
  requestStream: false,
  responseStream: false,
  requestType: wallet_pb.SingUrTransactionRequest,
  responseType: wallet_pb.SingUrTransactionResponse
};

WalletManager.deriveAddress = {
  methodName: "deriveAddress",
  service: WalletManager,
  requestStream: false,
  responseStream: false,
  requestType: wallet_pb.DeriveAddressRequest,
  responseType: wallet_pb.DeriveAddressResponse
};

WalletManager.singTransaction = {
  methodName: "singTransaction",
  service: WalletManager,
  requestStream: false,
  responseStream: false,
  requestType: wallet_pb.SingRawTransactionRequest,
  responseType: wallet_pb.SingRawTransactionResponse
};

WalletManager.sendTransaction = {
  methodName: "sendTransaction",
  service: WalletManager,
  requestStream: false,
  responseStream: false,
  requestType: wallet_pb.SendTransactionRequest,
  responseType: wallet_pb.SendTransactionResponse
};

exports.WalletManager = WalletManager;

function WalletManagerClient(serviceHost, options) {
  this.serviceHost = serviceHost;
  this.options = options || {};
}

WalletManagerClient.prototype.createWallet = function createWallet(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(WalletManager.CreateWallet, {
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

WalletManagerClient.prototype.exportWallet = function exportWallet(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(WalletManager.ExportWallet, {
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

WalletManagerClient.prototype.singTransactionUr = function singTransactionUr(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(WalletManager.SingTransactionUr, {
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

WalletManagerClient.prototype.deriveAddress = function deriveAddress(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(WalletManager.deriveAddress, {
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

WalletManagerClient.prototype.singTransaction = function singTransaction(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(WalletManager.singTransaction, {
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

WalletManagerClient.prototype.sendTransaction = function sendTransaction(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(WalletManager.sendTransaction, {
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

exports.WalletManagerClient = WalletManagerClient;

