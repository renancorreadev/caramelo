// package: wallet_manager
// file: wallet.proto

/* tslint:disable */
/* eslint-disable */

import * as grpc from "@grpc/grpc-js";
import * as wallet_pb from "./wallet_pb";

interface IWalletManagerService extends grpc.ServiceDefinition<grpc.UntypedServiceImplementation> {
    createWallet: IWalletManagerService_ICreateWallet;
    exportWallet: IWalletManagerService_IExportWallet;
    singTransactionUr: IWalletManagerService_ISingTransactionUr;
    deriveAddress: IWalletManagerService_IderiveAddress;
    singTransaction: IWalletManagerService_IsingTransaction;
    sendTransaction: IWalletManagerService_IsendTransaction;
}

interface IWalletManagerService_ICreateWallet extends grpc.MethodDefinition<wallet_pb.CreateWalletRequest, wallet_pb.CreateWalletResponse> {
    path: "/wallet_manager.WalletManager/CreateWallet";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<wallet_pb.CreateWalletRequest>;
    requestDeserialize: grpc.deserialize<wallet_pb.CreateWalletRequest>;
    responseSerialize: grpc.serialize<wallet_pb.CreateWalletResponse>;
    responseDeserialize: grpc.deserialize<wallet_pb.CreateWalletResponse>;
}
interface IWalletManagerService_IExportWallet extends grpc.MethodDefinition<wallet_pb.ExportWalletRequest, wallet_pb.ExportWalletResponse> {
    path: "/wallet_manager.WalletManager/ExportWallet";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<wallet_pb.ExportWalletRequest>;
    requestDeserialize: grpc.deserialize<wallet_pb.ExportWalletRequest>;
    responseSerialize: grpc.serialize<wallet_pb.ExportWalletResponse>;
    responseDeserialize: grpc.deserialize<wallet_pb.ExportWalletResponse>;
}
interface IWalletManagerService_ISingTransactionUr extends grpc.MethodDefinition<wallet_pb.SingUrTransactionRequest, wallet_pb.SingUrTransactionResponse> {
    path: "/wallet_manager.WalletManager/SingTransactionUr";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<wallet_pb.SingUrTransactionRequest>;
    requestDeserialize: grpc.deserialize<wallet_pb.SingUrTransactionRequest>;
    responseSerialize: grpc.serialize<wallet_pb.SingUrTransactionResponse>;
    responseDeserialize: grpc.deserialize<wallet_pb.SingUrTransactionResponse>;
}
interface IWalletManagerService_IderiveAddress extends grpc.MethodDefinition<wallet_pb.DeriveAddressRequest, wallet_pb.DeriveAddressResponse> {
    path: "/wallet_manager.WalletManager/deriveAddress";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<wallet_pb.DeriveAddressRequest>;
    requestDeserialize: grpc.deserialize<wallet_pb.DeriveAddressRequest>;
    responseSerialize: grpc.serialize<wallet_pb.DeriveAddressResponse>;
    responseDeserialize: grpc.deserialize<wallet_pb.DeriveAddressResponse>;
}
interface IWalletManagerService_IsingTransaction extends grpc.MethodDefinition<wallet_pb.SingRawTransactionRequest, wallet_pb.SingRawTransactionResponse> {
    path: "/wallet_manager.WalletManager/singTransaction";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<wallet_pb.SingRawTransactionRequest>;
    requestDeserialize: grpc.deserialize<wallet_pb.SingRawTransactionRequest>;
    responseSerialize: grpc.serialize<wallet_pb.SingRawTransactionResponse>;
    responseDeserialize: grpc.deserialize<wallet_pb.SingRawTransactionResponse>;
}
interface IWalletManagerService_IsendTransaction extends grpc.MethodDefinition<wallet_pb.SendTransactionRequest, wallet_pb.SendTransactionResponse> {
    path: "/wallet_manager.WalletManager/sendTransaction";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<wallet_pb.SendTransactionRequest>;
    requestDeserialize: grpc.deserialize<wallet_pb.SendTransactionRequest>;
    responseSerialize: grpc.serialize<wallet_pb.SendTransactionResponse>;
    responseDeserialize: grpc.deserialize<wallet_pb.SendTransactionResponse>;
}

export const WalletManagerService: IWalletManagerService;

export interface IWalletManagerServer {
    createWallet: grpc.handleUnaryCall<wallet_pb.CreateWalletRequest, wallet_pb.CreateWalletResponse>;
    exportWallet: grpc.handleUnaryCall<wallet_pb.ExportWalletRequest, wallet_pb.ExportWalletResponse>;
    singTransactionUr: grpc.handleUnaryCall<wallet_pb.SingUrTransactionRequest, wallet_pb.SingUrTransactionResponse>;
    deriveAddress: grpc.handleUnaryCall<wallet_pb.DeriveAddressRequest, wallet_pb.DeriveAddressResponse>;
    singTransaction: grpc.handleUnaryCall<wallet_pb.SingRawTransactionRequest, wallet_pb.SingRawTransactionResponse>;
    sendTransaction: grpc.handleUnaryCall<wallet_pb.SendTransactionRequest, wallet_pb.SendTransactionResponse>;
}

export interface IWalletManagerClient {
    createWallet(request: wallet_pb.CreateWalletRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.CreateWalletResponse) => void): grpc.ClientUnaryCall;
    createWallet(request: wallet_pb.CreateWalletRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.CreateWalletResponse) => void): grpc.ClientUnaryCall;
    createWallet(request: wallet_pb.CreateWalletRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.CreateWalletResponse) => void): grpc.ClientUnaryCall;
    exportWallet(request: wallet_pb.ExportWalletRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.ExportWalletResponse) => void): grpc.ClientUnaryCall;
    exportWallet(request: wallet_pb.ExportWalletRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.ExportWalletResponse) => void): grpc.ClientUnaryCall;
    exportWallet(request: wallet_pb.ExportWalletRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.ExportWalletResponse) => void): grpc.ClientUnaryCall;
    singTransactionUr(request: wallet_pb.SingUrTransactionRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingUrTransactionResponse) => void): grpc.ClientUnaryCall;
    singTransactionUr(request: wallet_pb.SingUrTransactionRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingUrTransactionResponse) => void): grpc.ClientUnaryCall;
    singTransactionUr(request: wallet_pb.SingUrTransactionRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingUrTransactionResponse) => void): grpc.ClientUnaryCall;
    deriveAddress(request: wallet_pb.DeriveAddressRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.DeriveAddressResponse) => void): grpc.ClientUnaryCall;
    deriveAddress(request: wallet_pb.DeriveAddressRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.DeriveAddressResponse) => void): grpc.ClientUnaryCall;
    deriveAddress(request: wallet_pb.DeriveAddressRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.DeriveAddressResponse) => void): grpc.ClientUnaryCall;
    singTransaction(request: wallet_pb.SingRawTransactionRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingRawTransactionResponse) => void): grpc.ClientUnaryCall;
    singTransaction(request: wallet_pb.SingRawTransactionRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingRawTransactionResponse) => void): grpc.ClientUnaryCall;
    singTransaction(request: wallet_pb.SingRawTransactionRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingRawTransactionResponse) => void): grpc.ClientUnaryCall;
    sendTransaction(request: wallet_pb.SendTransactionRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.SendTransactionResponse) => void): grpc.ClientUnaryCall;
    sendTransaction(request: wallet_pb.SendTransactionRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.SendTransactionResponse) => void): grpc.ClientUnaryCall;
    sendTransaction(request: wallet_pb.SendTransactionRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.SendTransactionResponse) => void): grpc.ClientUnaryCall;
}

export class WalletManagerClient extends grpc.Client implements IWalletManagerClient {
    constructor(address: string, credentials: grpc.ChannelCredentials, options?: object);
    public createWallet(request: wallet_pb.CreateWalletRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.CreateWalletResponse) => void): grpc.ClientUnaryCall;
    public createWallet(request: wallet_pb.CreateWalletRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.CreateWalletResponse) => void): grpc.ClientUnaryCall;
    public createWallet(request: wallet_pb.CreateWalletRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.CreateWalletResponse) => void): grpc.ClientUnaryCall;
    public exportWallet(request: wallet_pb.ExportWalletRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.ExportWalletResponse) => void): grpc.ClientUnaryCall;
    public exportWallet(request: wallet_pb.ExportWalletRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.ExportWalletResponse) => void): grpc.ClientUnaryCall;
    public exportWallet(request: wallet_pb.ExportWalletRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.ExportWalletResponse) => void): grpc.ClientUnaryCall;
    public singTransactionUr(request: wallet_pb.SingUrTransactionRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingUrTransactionResponse) => void): grpc.ClientUnaryCall;
    public singTransactionUr(request: wallet_pb.SingUrTransactionRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingUrTransactionResponse) => void): grpc.ClientUnaryCall;
    public singTransactionUr(request: wallet_pb.SingUrTransactionRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingUrTransactionResponse) => void): grpc.ClientUnaryCall;
    public deriveAddress(request: wallet_pb.DeriveAddressRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.DeriveAddressResponse) => void): grpc.ClientUnaryCall;
    public deriveAddress(request: wallet_pb.DeriveAddressRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.DeriveAddressResponse) => void): grpc.ClientUnaryCall;
    public deriveAddress(request: wallet_pb.DeriveAddressRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.DeriveAddressResponse) => void): grpc.ClientUnaryCall;
    public singTransaction(request: wallet_pb.SingRawTransactionRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingRawTransactionResponse) => void): grpc.ClientUnaryCall;
    public singTransaction(request: wallet_pb.SingRawTransactionRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingRawTransactionResponse) => void): grpc.ClientUnaryCall;
    public singTransaction(request: wallet_pb.SingRawTransactionRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.SingRawTransactionResponse) => void): grpc.ClientUnaryCall;
    public sendTransaction(request: wallet_pb.SendTransactionRequest, callback: (error: grpc.ServiceError | null, response: wallet_pb.SendTransactionResponse) => void): grpc.ClientUnaryCall;
    public sendTransaction(request: wallet_pb.SendTransactionRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: wallet_pb.SendTransactionResponse) => void): grpc.ClientUnaryCall;
    public sendTransaction(request: wallet_pb.SendTransactionRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: wallet_pb.SendTransactionResponse) => void): grpc.ClientUnaryCall;
}
