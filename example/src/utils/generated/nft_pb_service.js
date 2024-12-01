// package: nft_manager
// file: nft.proto

var nft_pb = require("./nft_pb");
var grpc = require("@improbable-eng/grpc-web").grpc;

var NFTManager = (function () {
  function NFTManager() {}
  NFTManager.serviceName = "nft_manager.NFTManager";
  return NFTManager;
}());

NFTManager.getInfoNFT = {
  methodName: "getInfoNFT",
  service: NFTManager,
  requestStream: false,
  responseStream: false,
  requestType: nft_pb.GetInfoNFTRequest,
  responseType: nft_pb.GetInfoNFTResponse
};

NFTManager.sendTransactionNFT = {
  methodName: "sendTransactionNFT",
  service: NFTManager,
  requestStream: false,
  responseStream: false,
  requestType: nft_pb.SendTransactionNFTRequest,
  responseType: nft_pb.SendTransactionNFTResponse
};

NFTManager.getNFTsForSale = {
  methodName: "getNFTsForSale",
  service: NFTManager,
  requestStream: false,
  responseStream: false,
  requestType: nft_pb.GetNFTsForSaleRequest,
  responseType: nft_pb.GetNFTsForSaleResponse
};

NFTManager.getTokenMetadataUrlsOwnedByAddress = {
  methodName: "getTokenMetadataUrlsOwnedByAddress",
  service: NFTManager,
  requestStream: false,
  responseStream: false,
  requestType: nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest,
  responseType: nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse
};

NFTManager.buyNFT = {
  methodName: "buyNFT",
  service: NFTManager,
  requestStream: false,
  responseStream: false,
  requestType: nft_pb.BuyNFTRequest,
  responseType: nft_pb.BuyNFTResponse
};

NFTManager.setNFTForSale = {
  methodName: "setNFTForSale",
  service: NFTManager,
  requestStream: false,
  responseStream: false,
  requestType: nft_pb.SetNFTForSaleRequest,
  responseType: nft_pb.SetNFTForSaleResponse
};

exports.NFTManager = NFTManager;

function NFTManagerClient(serviceHost, options) {
  this.serviceHost = serviceHost;
  this.options = options || {};
}

NFTManagerClient.prototype.getInfoNFT = function getInfoNFT(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(NFTManager.getInfoNFT, {
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

NFTManagerClient.prototype.sendTransactionNFT = function sendTransactionNFT(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(NFTManager.sendTransactionNFT, {
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

NFTManagerClient.prototype.getNFTsForSale = function getNFTsForSale(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(NFTManager.getNFTsForSale, {
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

NFTManagerClient.prototype.getTokenMetadataUrlsOwnedByAddress = function getTokenMetadataUrlsOwnedByAddress(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(NFTManager.getTokenMetadataUrlsOwnedByAddress, {
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

NFTManagerClient.prototype.buyNFT = function buyNFT(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(NFTManager.buyNFT, {
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

NFTManagerClient.prototype.setNFTForSale = function setNFTForSale(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(NFTManager.setNFTForSale, {
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

exports.NFTManagerClient = NFTManagerClient;

