// package: wallet_manager
// file: wallet.proto

import * as wallet_pb from "./wallet_pb";
import {grpc} from "@improbable-eng/grpc-web";

type WalletManagerCreateWallet = {
  readonly methodName: string;
  readonly service: typeof WalletManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof wallet_pb.CreateWalletRequest;
  readonly responseType: typeof wallet_pb.CreateWalletResponse;
};

type WalletManagerExportWallet = {
  readonly methodName: string;
  readonly service: typeof WalletManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof wallet_pb.ExportWalletRequest;
  readonly responseType: typeof wallet_pb.ExportWalletResponse;
};

type WalletManagerSingTransactionUr = {
  readonly methodName: string;
  readonly service: typeof WalletManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof wallet_pb.SingUrTransactionRequest;
  readonly responseType: typeof wallet_pb.SingUrTransactionResponse;
};

type WalletManagerderiveAddress = {
  readonly methodName: string;
  readonly service: typeof WalletManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof wallet_pb.DeriveAddressRequest;
  readonly responseType: typeof wallet_pb.DeriveAddressResponse;
};

type WalletManagersingTransaction = {
  readonly methodName: string;
  readonly service: typeof WalletManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof wallet_pb.SingRawTransactionRequest;
  readonly responseType: typeof wallet_pb.SingRawTransactionResponse;
};

type WalletManagersendTransaction = {
  readonly methodName: string;
  readonly service: typeof WalletManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof wallet_pb.SendTransactionRequest;
  readonly responseType: typeof wallet_pb.SendTransactionResponse;
};

export class WalletManager {
  static readonly serviceName: string;
  static readonly CreateWallet: WalletManagerCreateWallet;
  static readonly ExportWallet: WalletManagerExportWallet;
  static readonly SingTransactionUr: WalletManagerSingTransactionUr;
  static readonly deriveAddress: WalletManagerderiveAddress;
  static readonly singTransaction: WalletManagersingTransaction;
  static readonly sendTransaction: WalletManagersendTransaction;
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

export class WalletManagerClient {
  readonly serviceHost: string;

  constructor(serviceHost: string, options?: grpc.RpcOptions);
  createWallet(
    requestMessage: wallet_pb.CreateWalletRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.CreateWalletResponse|null) => void
  ): UnaryResponse;
  createWallet(
    requestMessage: wallet_pb.CreateWalletRequest,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.CreateWalletResponse|null) => void
  ): UnaryResponse;
  exportWallet(
    requestMessage: wallet_pb.ExportWalletRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.ExportWalletResponse|null) => void
  ): UnaryResponse;
  exportWallet(
    requestMessage: wallet_pb.ExportWalletRequest,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.ExportWalletResponse|null) => void
  ): UnaryResponse;
  singTransactionUr(
    requestMessage: wallet_pb.SingUrTransactionRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.SingUrTransactionResponse|null) => void
  ): UnaryResponse;
  singTransactionUr(
    requestMessage: wallet_pb.SingUrTransactionRequest,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.SingUrTransactionResponse|null) => void
  ): UnaryResponse;
  deriveAddress(
    requestMessage: wallet_pb.DeriveAddressRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.DeriveAddressResponse|null) => void
  ): UnaryResponse;
  deriveAddress(
    requestMessage: wallet_pb.DeriveAddressRequest,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.DeriveAddressResponse|null) => void
  ): UnaryResponse;
  singTransaction(
    requestMessage: wallet_pb.SingRawTransactionRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.SingRawTransactionResponse|null) => void
  ): UnaryResponse;
  singTransaction(
    requestMessage: wallet_pb.SingRawTransactionRequest,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.SingRawTransactionResponse|null) => void
  ): UnaryResponse;
  sendTransaction(
    requestMessage: wallet_pb.SendTransactionRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.SendTransactionResponse|null) => void
  ): UnaryResponse;
  sendTransaction(
    requestMessage: wallet_pb.SendTransactionRequest,
    callback: (error: ServiceError|null, responseMessage: wallet_pb.SendTransactionResponse|null) => void
  ): UnaryResponse;
}

