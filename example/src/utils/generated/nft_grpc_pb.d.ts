// package: nft_manager
// file: nft.proto

/* tslint:disable */
/* eslint-disable */

import * as grpc from "@grpc/grpc-js";
import * as nft_pb from "./nft_pb";

interface INFTManagerService extends grpc.ServiceDefinition<grpc.UntypedServiceImplementation> {
    getInfoNFT: INFTManagerService_IgetInfoNFT;
    sendTransactionNFT: INFTManagerService_IsendTransactionNFT;
    getNFTsForSale: INFTManagerService_IgetNFTsForSale;
    getTokenMetadataUrlsOwnedByAddress: INFTManagerService_IgetTokenMetadataUrlsOwnedByAddress;
    buyNFT: INFTManagerService_IbuyNFT;
    setNFTForSale: INFTManagerService_IsetNFTForSale;
}

interface INFTManagerService_IgetInfoNFT extends grpc.MethodDefinition<nft_pb.GetInfoNFTRequest, nft_pb.GetInfoNFTResponse> {
    path: "/nft_manager.NFTManager/getInfoNFT";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<nft_pb.GetInfoNFTRequest>;
    requestDeserialize: grpc.deserialize<nft_pb.GetInfoNFTRequest>;
    responseSerialize: grpc.serialize<nft_pb.GetInfoNFTResponse>;
    responseDeserialize: grpc.deserialize<nft_pb.GetInfoNFTResponse>;
}
interface INFTManagerService_IsendTransactionNFT extends grpc.MethodDefinition<nft_pb.SendTransactionNFTRequest, nft_pb.SendTransactionNFTResponse> {
    path: "/nft_manager.NFTManager/sendTransactionNFT";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<nft_pb.SendTransactionNFTRequest>;
    requestDeserialize: grpc.deserialize<nft_pb.SendTransactionNFTRequest>;
    responseSerialize: grpc.serialize<nft_pb.SendTransactionNFTResponse>;
    responseDeserialize: grpc.deserialize<nft_pb.SendTransactionNFTResponse>;
}
interface INFTManagerService_IgetNFTsForSale extends grpc.MethodDefinition<nft_pb.GetNFTsForSaleRequest, nft_pb.GetNFTsForSaleResponse> {
    path: "/nft_manager.NFTManager/getNFTsForSale";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<nft_pb.GetNFTsForSaleRequest>;
    requestDeserialize: grpc.deserialize<nft_pb.GetNFTsForSaleRequest>;
    responseSerialize: grpc.serialize<nft_pb.GetNFTsForSaleResponse>;
    responseDeserialize: grpc.deserialize<nft_pb.GetNFTsForSaleResponse>;
}
interface INFTManagerService_IgetTokenMetadataUrlsOwnedByAddress extends grpc.MethodDefinition<nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest, nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse> {
    path: "/nft_manager.NFTManager/getTokenMetadataUrlsOwnedByAddress";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest>;
    requestDeserialize: grpc.deserialize<nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest>;
    responseSerialize: grpc.serialize<nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse>;
    responseDeserialize: grpc.deserialize<nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse>;
}
interface INFTManagerService_IbuyNFT extends grpc.MethodDefinition<nft_pb.BuyNFTRequest, nft_pb.BuyNFTResponse> {
    path: "/nft_manager.NFTManager/buyNFT";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<nft_pb.BuyNFTRequest>;
    requestDeserialize: grpc.deserialize<nft_pb.BuyNFTRequest>;
    responseSerialize: grpc.serialize<nft_pb.BuyNFTResponse>;
    responseDeserialize: grpc.deserialize<nft_pb.BuyNFTResponse>;
}
interface INFTManagerService_IsetNFTForSale extends grpc.MethodDefinition<nft_pb.SetNFTForSaleRequest, nft_pb.SetNFTForSaleResponse> {
    path: "/nft_manager.NFTManager/setNFTForSale";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<nft_pb.SetNFTForSaleRequest>;
    requestDeserialize: grpc.deserialize<nft_pb.SetNFTForSaleRequest>;
    responseSerialize: grpc.serialize<nft_pb.SetNFTForSaleResponse>;
    responseDeserialize: grpc.deserialize<nft_pb.SetNFTForSaleResponse>;
}

export const NFTManagerService: INFTManagerService;

export interface INFTManagerServer {
    getInfoNFT: grpc.handleUnaryCall<nft_pb.GetInfoNFTRequest, nft_pb.GetInfoNFTResponse>;
    sendTransactionNFT: grpc.handleUnaryCall<nft_pb.SendTransactionNFTRequest, nft_pb.SendTransactionNFTResponse>;
    getNFTsForSale: grpc.handleUnaryCall<nft_pb.GetNFTsForSaleRequest, nft_pb.GetNFTsForSaleResponse>;
    getTokenMetadataUrlsOwnedByAddress: grpc.handleUnaryCall<nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest, nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse>;
    buyNFT: grpc.handleUnaryCall<nft_pb.BuyNFTRequest, nft_pb.BuyNFTResponse>;
    setNFTForSale: grpc.handleUnaryCall<nft_pb.SetNFTForSaleRequest, nft_pb.SetNFTForSaleResponse>;
}

export interface INFTManagerClient {
    getInfoNFT(request: nft_pb.GetInfoNFTRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.GetInfoNFTResponse) => void): grpc.ClientUnaryCall;
    getInfoNFT(request: nft_pb.GetInfoNFTRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.GetInfoNFTResponse) => void): grpc.ClientUnaryCall;
    getInfoNFT(request: nft_pb.GetInfoNFTRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.GetInfoNFTResponse) => void): grpc.ClientUnaryCall;
    sendTransactionNFT(request: nft_pb.SendTransactionNFTRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.SendTransactionNFTResponse) => void): grpc.ClientUnaryCall;
    sendTransactionNFT(request: nft_pb.SendTransactionNFTRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.SendTransactionNFTResponse) => void): grpc.ClientUnaryCall;
    sendTransactionNFT(request: nft_pb.SendTransactionNFTRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.SendTransactionNFTResponse) => void): grpc.ClientUnaryCall;
    getNFTsForSale(request: nft_pb.GetNFTsForSaleRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.GetNFTsForSaleResponse) => void): grpc.ClientUnaryCall;
    getNFTsForSale(request: nft_pb.GetNFTsForSaleRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.GetNFTsForSaleResponse) => void): grpc.ClientUnaryCall;
    getNFTsForSale(request: nft_pb.GetNFTsForSaleRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.GetNFTsForSaleResponse) => void): grpc.ClientUnaryCall;
    getTokenMetadataUrlsOwnedByAddress(request: nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse) => void): grpc.ClientUnaryCall;
    getTokenMetadataUrlsOwnedByAddress(request: nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse) => void): grpc.ClientUnaryCall;
    getTokenMetadataUrlsOwnedByAddress(request: nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse) => void): grpc.ClientUnaryCall;
    buyNFT(request: nft_pb.BuyNFTRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.BuyNFTResponse) => void): grpc.ClientUnaryCall;
    buyNFT(request: nft_pb.BuyNFTRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.BuyNFTResponse) => void): grpc.ClientUnaryCall;
    buyNFT(request: nft_pb.BuyNFTRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.BuyNFTResponse) => void): grpc.ClientUnaryCall;
    setNFTForSale(request: nft_pb.SetNFTForSaleRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.SetNFTForSaleResponse) => void): grpc.ClientUnaryCall;
    setNFTForSale(request: nft_pb.SetNFTForSaleRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.SetNFTForSaleResponse) => void): grpc.ClientUnaryCall;
    setNFTForSale(request: nft_pb.SetNFTForSaleRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.SetNFTForSaleResponse) => void): grpc.ClientUnaryCall;
}

export class NFTManagerClient extends grpc.Client implements INFTManagerClient {
    constructor(address: string, credentials: grpc.ChannelCredentials, options?: object);
    public getInfoNFT(request: nft_pb.GetInfoNFTRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.GetInfoNFTResponse) => void): grpc.ClientUnaryCall;
    public getInfoNFT(request: nft_pb.GetInfoNFTRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.GetInfoNFTResponse) => void): grpc.ClientUnaryCall;
    public getInfoNFT(request: nft_pb.GetInfoNFTRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.GetInfoNFTResponse) => void): grpc.ClientUnaryCall;
    public sendTransactionNFT(request: nft_pb.SendTransactionNFTRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.SendTransactionNFTResponse) => void): grpc.ClientUnaryCall;
    public sendTransactionNFT(request: nft_pb.SendTransactionNFTRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.SendTransactionNFTResponse) => void): grpc.ClientUnaryCall;
    public sendTransactionNFT(request: nft_pb.SendTransactionNFTRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.SendTransactionNFTResponse) => void): grpc.ClientUnaryCall;
    public getNFTsForSale(request: nft_pb.GetNFTsForSaleRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.GetNFTsForSaleResponse) => void): grpc.ClientUnaryCall;
    public getNFTsForSale(request: nft_pb.GetNFTsForSaleRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.GetNFTsForSaleResponse) => void): grpc.ClientUnaryCall;
    public getNFTsForSale(request: nft_pb.GetNFTsForSaleRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.GetNFTsForSaleResponse) => void): grpc.ClientUnaryCall;
    public getTokenMetadataUrlsOwnedByAddress(request: nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse) => void): grpc.ClientUnaryCall;
    public getTokenMetadataUrlsOwnedByAddress(request: nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse) => void): grpc.ClientUnaryCall;
    public getTokenMetadataUrlsOwnedByAddress(request: nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse) => void): grpc.ClientUnaryCall;
    public buyNFT(request: nft_pb.BuyNFTRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.BuyNFTResponse) => void): grpc.ClientUnaryCall;
    public buyNFT(request: nft_pb.BuyNFTRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.BuyNFTResponse) => void): grpc.ClientUnaryCall;
    public buyNFT(request: nft_pb.BuyNFTRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.BuyNFTResponse) => void): grpc.ClientUnaryCall;
    public setNFTForSale(request: nft_pb.SetNFTForSaleRequest, callback: (error: grpc.ServiceError | null, response: nft_pb.SetNFTForSaleResponse) => void): grpc.ClientUnaryCall;
    public setNFTForSale(request: nft_pb.SetNFTForSaleRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: nft_pb.SetNFTForSaleResponse) => void): grpc.ClientUnaryCall;
    public setNFTForSale(request: nft_pb.SetNFTForSaleRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: nft_pb.SetNFTForSaleResponse) => void): grpc.ClientUnaryCall;
}
