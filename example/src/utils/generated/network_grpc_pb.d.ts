// package: network_manager
// file: network.proto

/* tslint:disable */
/* eslint-disable */

import * as grpc from "@grpc/grpc-js";
import * as network_pb from "./network_pb";

interface INetworkManagerService extends grpc.ServiceDefinition<grpc.UntypedServiceImplementation> {
    getAvailableNetworks: INetworkManagerService_IGetAvailableNetworks;
}

interface INetworkManagerService_IGetAvailableNetworks extends grpc.MethodDefinition<network_pb.availableNetworkRequest, network_pb.availableNetworkResponse> {
    path: "/network_manager.NetworkManager/GetAvailableNetworks";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<network_pb.availableNetworkRequest>;
    requestDeserialize: grpc.deserialize<network_pb.availableNetworkRequest>;
    responseSerialize: grpc.serialize<network_pb.availableNetworkResponse>;
    responseDeserialize: grpc.deserialize<network_pb.availableNetworkResponse>;
}

export const NetworkManagerService: INetworkManagerService;

export interface INetworkManagerServer {
    getAvailableNetworks: grpc.handleUnaryCall<network_pb.availableNetworkRequest, network_pb.availableNetworkResponse>;
}

export interface INetworkManagerClient {
    getAvailableNetworks(request: network_pb.availableNetworkRequest, callback: (error: grpc.ServiceError | null, response: network_pb.availableNetworkResponse) => void): grpc.ClientUnaryCall;
    getAvailableNetworks(request: network_pb.availableNetworkRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: network_pb.availableNetworkResponse) => void): grpc.ClientUnaryCall;
    getAvailableNetworks(request: network_pb.availableNetworkRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: network_pb.availableNetworkResponse) => void): grpc.ClientUnaryCall;
}

export class NetworkManagerClient extends grpc.Client implements INetworkManagerClient {
    constructor(address: string, credentials: grpc.ChannelCredentials, options?: object);
    public getAvailableNetworks(request: network_pb.availableNetworkRequest, callback: (error: grpc.ServiceError | null, response: network_pb.availableNetworkResponse) => void): grpc.ClientUnaryCall;
    public getAvailableNetworks(request: network_pb.availableNetworkRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: network_pb.availableNetworkResponse) => void): grpc.ClientUnaryCall;
    public getAvailableNetworks(request: network_pb.availableNetworkRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: network_pb.availableNetworkResponse) => void): grpc.ClientUnaryCall;
}
