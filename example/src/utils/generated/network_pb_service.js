// package: network_manager
// file: network.proto

var network_pb = require("./network_pb");
var grpc = require("@improbable-eng/grpc-web").grpc;

var NetworkManager = (function () {
  function NetworkManager() {}
  NetworkManager.serviceName = "network_manager.NetworkManager";
  return NetworkManager;
}());

NetworkManager.GetAvailableNetworks = {
  methodName: "GetAvailableNetworks",
  service: NetworkManager,
  requestStream: false,
  responseStream: false,
  requestType: network_pb.availableNetworkRequest,
  responseType: network_pb.availableNetworkResponse
};

exports.NetworkManager = NetworkManager;

function NetworkManagerClient(serviceHost, options) {
  this.serviceHost = serviceHost;
  this.options = options || {};
}

NetworkManagerClient.prototype.getAvailableNetworks = function getAvailableNetworks(requestMessage, metadata, callback) {
  if (arguments.length === 2) {
    callback = arguments[1];
  }
  var client = grpc.unary(NetworkManager.GetAvailableNetworks, {
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

exports.NetworkManagerClient = NetworkManagerClient;

