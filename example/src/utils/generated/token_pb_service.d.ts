// package: token_manager
// file: token.proto

import * as token_pb from "./token_pb";
import {grpc} from "@improbable-eng/grpc-web";

type TokenManagergetInfoToken = {
  readonly methodName: string;
  readonly service: typeof TokenManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof token_pb.GetInfoTokenRequest;
  readonly responseType: typeof token_pb.GetInfoTokenResponse;
};

type TokenManagergetBalance = {
  readonly methodName: string;
  readonly service: typeof TokenManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof token_pb.GetBalanceTokenRequest;
  readonly responseType: typeof token_pb.GetBalanceTokenResponse;
};

type TokenManagersendTransactionToken = {
  readonly methodName: string;
  readonly service: typeof TokenManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof token_pb.SendTransactionTokenRequest;
  readonly responseType: typeof token_pb.SendTransactionTokenResponse;
};

type TokenManagerapproveToken = {
  readonly methodName: string;
  readonly service: typeof TokenManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof token_pb.ApproveTokenRequest;
  readonly responseType: typeof token_pb.ApproveTokenResponse;
};

export class TokenManager {
  static readonly serviceName: string;
  static readonly getInfoToken: TokenManagergetInfoToken;
  static readonly getBalance: TokenManagergetBalance;
  static readonly sendTransactionToken: TokenManagersendTransactionToken;
  static readonly approveToken: TokenManagerapproveToken;
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

export class TokenManagerClient {
  readonly serviceHost: string;

  constructor(serviceHost: string, options?: grpc.RpcOptions);
  getInfoToken(
    requestMessage: token_pb.GetInfoTokenRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: token_pb.GetInfoTokenResponse|null) => void
  ): UnaryResponse;
  getInfoToken(
    requestMessage: token_pb.GetInfoTokenRequest,
    callback: (error: ServiceError|null, responseMessage: token_pb.GetInfoTokenResponse|null) => void
  ): UnaryResponse;
  getBalance(
    requestMessage: token_pb.GetBalanceTokenRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: token_pb.GetBalanceTokenResponse|null) => void
  ): UnaryResponse;
  getBalance(
    requestMessage: token_pb.GetBalanceTokenRequest,
    callback: (error: ServiceError|null, responseMessage: token_pb.GetBalanceTokenResponse|null) => void
  ): UnaryResponse;
  sendTransactionToken(
    requestMessage: token_pb.SendTransactionTokenRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: token_pb.SendTransactionTokenResponse|null) => void
  ): UnaryResponse;
  sendTransactionToken(
    requestMessage: token_pb.SendTransactionTokenRequest,
    callback: (error: ServiceError|null, responseMessage: token_pb.SendTransactionTokenResponse|null) => void
  ): UnaryResponse;
  approveToken(
    requestMessage: token_pb.ApproveTokenRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: token_pb.ApproveTokenResponse|null) => void
  ): UnaryResponse;
  approveToken(
    requestMessage: token_pb.ApproveTokenRequest,
    callback: (error: ServiceError|null, responseMessage: token_pb.ApproveTokenResponse|null) => void
  ): UnaryResponse;
}

