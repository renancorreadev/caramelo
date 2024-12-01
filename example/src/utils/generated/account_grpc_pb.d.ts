// package: account_manager
// file: account.proto

/* tslint:disable */
/* eslint-disable */

import * as grpc from "@grpc/grpc-js";
import * as account_pb from "./account_pb";

interface IAccountManagerService extends grpc.ServiceDefinition<grpc.UntypedServiceImplementation> {
    getBalance: IAccountManagerService_IGetBalance;
}

interface IAccountManagerService_IGetBalance extends grpc.MethodDefinition<account_pb.GetBalanceRequest, account_pb.GetBalanceResponse> {
    path: "/account_manager.AccountManager/GetBalance";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<account_pb.GetBalanceRequest>;
    requestDeserialize: grpc.deserialize<account_pb.GetBalanceRequest>;
    responseSerialize: grpc.serialize<account_pb.GetBalanceResponse>;
    responseDeserialize: grpc.deserialize<account_pb.GetBalanceResponse>;
}

export const AccountManagerService: IAccountManagerService;

export interface IAccountManagerServer {
    getBalance: grpc.handleUnaryCall<account_pb.GetBalanceRequest, account_pb.GetBalanceResponse>;
}

export interface IAccountManagerClient {
    getBalance(request: account_pb.GetBalanceRequest, callback: (error: grpc.ServiceError | null, response: account_pb.GetBalanceResponse) => void): grpc.ClientUnaryCall;
    getBalance(request: account_pb.GetBalanceRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: account_pb.GetBalanceResponse) => void): grpc.ClientUnaryCall;
    getBalance(request: account_pb.GetBalanceRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: account_pb.GetBalanceResponse) => void): grpc.ClientUnaryCall;
}

export class AccountManagerClient extends grpc.Client implements IAccountManagerClient {
    constructor(address: string, credentials: grpc.ChannelCredentials, options?: object);
    public getBalance(request: account_pb.GetBalanceRequest, callback: (error: grpc.ServiceError | null, response: account_pb.GetBalanceResponse) => void): grpc.ClientUnaryCall;
    public getBalance(request: account_pb.GetBalanceRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: account_pb.GetBalanceResponse) => void): grpc.ClientUnaryCall;
    public getBalance(request: account_pb.GetBalanceRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: account_pb.GetBalanceResponse) => void): grpc.ClientUnaryCall;
}
