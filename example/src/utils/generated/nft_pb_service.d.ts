// package: nft_manager
// file: nft.proto

import * as nft_pb from "./nft_pb";
import {grpc} from "@improbable-eng/grpc-web";

type NFTManagergetInfoNFT = {
  readonly methodName: string;
  readonly service: typeof NFTManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof nft_pb.GetInfoNFTRequest;
  readonly responseType: typeof nft_pb.GetInfoNFTResponse;
};

type NFTManagersendTransactionNFT = {
  readonly methodName: string;
  readonly service: typeof NFTManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof nft_pb.SendTransactionNFTRequest;
  readonly responseType: typeof nft_pb.SendTransactionNFTResponse;
};

type NFTManagergetNFTsForSale = {
  readonly methodName: string;
  readonly service: typeof NFTManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof nft_pb.GetNFTsForSaleRequest;
  readonly responseType: typeof nft_pb.GetNFTsForSaleResponse;
};

type NFTManagergetTokenMetadataUrlsOwnedByAddress = {
  readonly methodName: string;
  readonly service: typeof NFTManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest;
  readonly responseType: typeof nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse;
};

type NFTManagerbuyNFT = {
  readonly methodName: string;
  readonly service: typeof NFTManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof nft_pb.BuyNFTRequest;
  readonly responseType: typeof nft_pb.BuyNFTResponse;
};

type NFTManagersetNFTForSale = {
  readonly methodName: string;
  readonly service: typeof NFTManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof nft_pb.SetNFTForSaleRequest;
  readonly responseType: typeof nft_pb.SetNFTForSaleResponse;
};

export class NFTManager {
  static readonly serviceName: string;
  static readonly getInfoNFT: NFTManagergetInfoNFT;
  static readonly sendTransactionNFT: NFTManagersendTransactionNFT;
  static readonly getNFTsForSale: NFTManagergetNFTsForSale;
  static readonly getTokenMetadataUrlsOwnedByAddress: NFTManagergetTokenMetadataUrlsOwnedByAddress;
  static readonly buyNFT: NFTManagerbuyNFT;
  static readonly setNFTForSale: NFTManagersetNFTForSale;
}

export type ServiceError = { message: string, code: number; metadata: grpc.Metadata }
export type Status = { details: string, code: number; metadata: grpc.Metadata }

interface UnaryResponse {
  cancel(): void;
}
interface ResponseStream<T> {
  cancel(): void;
  on(type: 'data', handler: (message: T) => void): ResponseStream<T>;
  on(type: 'end', handler: (status?: Status) => void): ResponseStream<T>;
  on(type: 'status', handler: (status: Status) => void): ResponseStream<T>;
}
interface RequestStream<T> {
  write(message: T): RequestStream<T>;
  end(): void;
  cancel(): void;
  on(type: 'end', handler: (status?: Status) => void): RequestStream<T>;
  on(type: 'status', handler: (status: Status) => void): RequestStream<T>;
}
interface BidirectionalStream<ReqT, ResT> {
  write(message: ReqT): BidirectionalStream<ReqT, ResT>;
  end(): void;
  cancel(): void;
  on(type: 'data', handler: (message: ResT) => void): BidirectionalStream<ReqT, ResT>;
  on(type: 'end', handler: (status?: Status) => void): BidirectionalStream<ReqT, ResT>;
  on(type: 'status', handler: (status: Status) => void): BidirectionalStream<ReqT, ResT>;
}

export class NFTManagerClient {
  readonly serviceHost: string;

  constructor(serviceHost: string, options?: grpc.RpcOptions);
  getInfoNFT(
    requestMessage: nft_pb.GetInfoNFTRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: nft_pb.GetInfoNFTResponse|null) => void
  ): UnaryResponse;
  getInfoNFT(
    requestMessage: nft_pb.GetInfoNFTRequest,
    callback: (error: ServiceError|null, responseMessage: nft_pb.GetInfoNFTResponse|null) => void
  ): UnaryResponse;
  sendTransactionNFT(
    requestMessage: nft_pb.SendTransactionNFTRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: nft_pb.SendTransactionNFTResponse|null) => void
  ): UnaryResponse;
  sendTransactionNFT(
    requestMessage: nft_pb.SendTransactionNFTRequest,
    callback: (error: ServiceError|null, responseMessage: nft_pb.SendTransactionNFTResponse|null) => void
  ): UnaryResponse;
  getNFTsForSale(
    requestMessage: nft_pb.GetNFTsForSaleRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: nft_pb.GetNFTsForSaleResponse|null) => void
  ): UnaryResponse;
  getNFTsForSale(
    requestMessage: nft_pb.GetNFTsForSaleRequest,
    callback: (error: ServiceError|null, responseMessage: nft_pb.GetNFTsForSaleResponse|null) => void
  ): UnaryResponse;
  getTokenMetadataUrlsOwnedByAddress(
    requestMessage: nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse|null) => void
  ): UnaryResponse;
  getTokenMetadataUrlsOwnedByAddress(
    requestMessage: nft_pb.GetTokenMetadataUrlsOwnedByAddressRequest,
    callback: (error: ServiceError|null, responseMessage: nft_pb.GetTokenMetadataUrlsOwnedByAddressResponse|null) => void
  ): UnaryResponse;
  buyNFT(
    requestMessage: nft_pb.BuyNFTRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: nft_pb.BuyNFTResponse|null) => void
  ): UnaryResponse;
  buyNFT(
    requestMessage: nft_pb.BuyNFTRequest,
    callback: (error: ServiceError|null, responseMessage: nft_pb.BuyNFTResponse|null) => void
  ): UnaryResponse;
  setNFTForSale(
    requestMessage: nft_pb.SetNFTForSaleRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: nft_pb.SetNFTForSaleResponse|null) => void
  ): UnaryResponse;
  setNFTForSale(
    requestMessage: nft_pb.SetNFTForSaleRequest,
    callback: (error: ServiceError|null, responseMessage: nft_pb.SetNFTForSaleResponse|null) => void
  ): UnaryResponse;
}

