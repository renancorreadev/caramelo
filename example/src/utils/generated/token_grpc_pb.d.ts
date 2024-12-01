// package: token_manager
// file: token.proto

/* tslint:disable */
/* eslint-disable */

import * as grpc from "@grpc/grpc-js";
import * as token_pb from "./token_pb";

interface ITokenManagerService extends grpc.ServiceDefinition<grpc.UntypedServiceImplementation> {
    getInfoToken: ITokenManagerService_IgetInfoToken;
    getBalance: ITokenManagerService_IgetBalance;
    sendTransactionToken: ITokenManagerService_IsendTransactionToken;
    approveToken: ITokenManagerService_IapproveToken;
}

interface ITokenManagerService_IgetInfoToken extends grpc.MethodDefinition<token_pb.GetInfoTokenRequest, token_pb.GetInfoTokenResponse> {
    path: "/token_manager.TokenManager/getInfoToken";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<token_pb.GetInfoTokenRequest>;
    requestDeserialize: grpc.deserialize<token_pb.GetInfoTokenRequest>;
    responseSerialize: grpc.serialize<token_pb.GetInfoTokenResponse>;
    responseDeserialize: grpc.deserialize<token_pb.GetInfoTokenResponse>;
}
interface ITokenManagerService_IgetBalance extends grpc.MethodDefinition<token_pb.GetBalanceTokenRequest, token_pb.GetBalanceTokenResponse> {
    path: "/token_manager.TokenManager/getBalance";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<token_pb.GetBalanceTokenRequest>;
    requestDeserialize: grpc.deserialize<token_pb.GetBalanceTokenRequest>;
    responseSerialize: grpc.serialize<token_pb.GetBalanceTokenResponse>;
    responseDeserialize: grpc.deserialize<token_pb.GetBalanceTokenResponse>;
}
interface ITokenManagerService_IsendTransactionToken extends grpc.MethodDefinition<token_pb.SendTransactionTokenRequest, token_pb.SendTransactionTokenResponse> {
    path: "/token_manager.TokenManager/sendTransactionToken";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<token_pb.SendTransactionTokenRequest>;
    requestDeserialize: grpc.deserialize<token_pb.SendTransactionTokenRequest>;
    responseSerialize: grpc.serialize<token_pb.SendTransactionTokenResponse>;
    responseDeserialize: grpc.deserialize<token_pb.SendTransactionTokenResponse>;
}
interface ITokenManagerService_IapproveToken extends grpc.MethodDefinition<token_pb.ApproveTokenRequest, token_pb.ApproveTokenResponse> {
    path: "/token_manager.TokenManager/approveToken";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<token_pb.ApproveTokenRequest>;
    requestDeserialize: grpc.deserialize<token_pb.ApproveTokenRequest>;
    responseSerialize: grpc.serialize<token_pb.ApproveTokenResponse>;
    responseDeserialize: grpc.deserialize<token_pb.ApproveTokenResponse>;
}

export const TokenManagerService: ITokenManagerService;

export interface ITokenManagerServer {
    getInfoToken: grpc.handleUnaryCall<token_pb.GetInfoTokenRequest, token_pb.GetInfoTokenResponse>;
    getBalance: grpc.handleUnaryCall<token_pb.GetBalanceTokenRequest, token_pb.GetBalanceTokenResponse>;
    sendTransactionToken: grpc.handleUnaryCall<token_pb.SendTransactionTokenRequest, token_pb.SendTransactionTokenResponse>;
    approveToken: grpc.handleUnaryCall<token_pb.ApproveTokenRequest, token_pb.ApproveTokenResponse>;
}

export interface ITokenManagerClient {
    getInfoToken(request: token_pb.GetInfoTokenRequest, callback: (error: grpc.ServiceError | null, response: token_pb.GetInfoTokenResponse) => void): grpc.ClientUnaryCall;
    getInfoToken(request: token_pb.GetInfoTokenRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: token_pb.GetInfoTokenResponse) => void): grpc.ClientUnaryCall;
    getInfoToken(request: token_pb.GetInfoTokenRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: token_pb.GetInfoTokenResponse) => void): grpc.ClientUnaryCall;
    getBalance(request: token_pb.GetBalanceTokenRequest, callback: (error: grpc.ServiceError | null, response: token_pb.GetBalanceTokenResponse) => void): grpc.ClientUnaryCall;
    getBalance(request: token_pb.GetBalanceTokenRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: token_pb.GetBalanceTokenResponse) => void): grpc.ClientUnaryCall;
    getBalance(request: token_pb.GetBalanceTokenRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: token_pb.GetBalanceTokenResponse) => void): grpc.ClientUnaryCall;
    sendTransactionToken(request: token_pb.SendTransactionTokenRequest, callback: (error: grpc.ServiceError | null, response: token_pb.SendTransactionTokenResponse) => void): grpc.ClientUnaryCall;
    sendTransactionToken(request: token_pb.SendTransactionTokenRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: token_pb.SendTransactionTokenResponse) => void): grpc.ClientUnaryCall;
    sendTransactionToken(request: token_pb.SendTransactionTokenRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: token_pb.SendTransactionTokenResponse) => void): grpc.ClientUnaryCall;
    approveToken(request: token_pb.ApproveTokenRequest, callback: (error: grpc.ServiceError | null, response: token_pb.ApproveTokenResponse) => void): grpc.ClientUnaryCall;
    approveToken(request: token_pb.ApproveTokenRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: token_pb.ApproveTokenResponse) => void): grpc.ClientUnaryCall;
    approveToken(request: token_pb.ApproveTokenRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: token_pb.ApproveTokenResponse) => void): grpc.ClientUnaryCall;
}

export class TokenManagerClient extends grpc.Client implements ITokenManagerClient {
    constructor(address: string, credentials: grpc.ChannelCredentials, options?: object);
    public getInfoToken(request: token_pb.GetInfoTokenRequest, callback: (error: grpc.ServiceError | null, response: token_pb.GetInfoTokenResponse) => void): grpc.ClientUnaryCall;
    public getInfoToken(request: token_pb.GetInfoTokenRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: token_pb.GetInfoTokenResponse) => void): grpc.ClientUnaryCall;
    public getInfoToken(request: token_pb.GetInfoTokenRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: token_pb.GetInfoTokenResponse) => void): grpc.ClientUnaryCall;
    public getBalance(request: token_pb.GetBalanceTokenRequest, callback: (error: grpc.ServiceError | null, response: token_pb.GetBalanceTokenResponse) => void): grpc.ClientUnaryCall;
    public getBalance(request: token_pb.GetBalanceTokenRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: token_pb.GetBalanceTokenResponse) => void): grpc.ClientUnaryCall;
    public getBalance(request: token_pb.GetBalanceTokenRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: token_pb.GetBalanceTokenResponse) => void): grpc.ClientUnaryCall;
    public sendTransactionToken(request: token_pb.SendTransactionTokenRequest, callback: (error: grpc.ServiceError | null, response: token_pb.SendTransactionTokenResponse) => void): grpc.ClientUnaryCall;
    public sendTransactionToken(request: token_pb.SendTransactionTokenRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: token_pb.SendTransactionTokenResponse) => void): grpc.ClientUnaryCall;
    public sendTransactionToken(request: token_pb.SendTransactionTokenRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: token_pb.SendTransactionTokenResponse) => void): grpc.ClientUnaryCall;
    public approveToken(request: token_pb.ApproveTokenRequest, callback: (error: grpc.ServiceError | null, response: token_pb.ApproveTokenResponse) => void): grpc.ClientUnaryCall;
    public approveToken(request: token_pb.ApproveTokenRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: token_pb.ApproveTokenResponse) => void): grpc.ClientUnaryCall;
    public approveToken(request: token_pb.ApproveTokenRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: token_pb.ApproveTokenResponse) => void): grpc.ClientUnaryCall;
}
