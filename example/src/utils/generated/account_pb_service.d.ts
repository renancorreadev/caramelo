// package: account_manager
// file: account.proto

import * as account_pb from "./account_pb";
import {grpc} from "@improbable-eng/grpc-web";

type AccountManagerGetBalance = {
  readonly methodName: string;
  readonly service: typeof AccountManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof account_pb.GetBalanceRequest;
  readonly responseType: typeof account_pb.GetBalanceResponse;
};

export class AccountManager {
  static readonly serviceName: string;
  static readonly GetBalance: AccountManagerGetBalance;
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

export class AccountManagerClient {
  readonly serviceHost: string;

  constructor(serviceHost: string, options?: grpc.RpcOptions);
  getBalance(
    requestMessage: account_pb.GetBalanceRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: account_pb.GetBalanceResponse|null) => void
  ): UnaryResponse;
  getBalance(
    requestMessage: account_pb.GetBalanceRequest,
    callback: (error: ServiceError|null, responseMessage: account_pb.GetBalanceResponse|null) => void
  ): UnaryResponse;
}

