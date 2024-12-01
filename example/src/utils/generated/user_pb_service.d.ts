// package: user_management
// file: user.proto

import * as user_pb from "./user_pb";
import {grpc} from "@improbable-eng/grpc-web";

type UserManagergetMyInfo = {
  readonly methodName: string;
  readonly service: typeof UserManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof user_pb.GetMyInfoRequest;
  readonly responseType: typeof user_pb.GetMyInfoResponse;
};

export class UserManager {
  static readonly serviceName: string;
  static readonly getMyInfo: UserManagergetMyInfo;
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

export class UserManagerClient {
  readonly serviceHost: string;

  constructor(serviceHost: string, options?: grpc.RpcOptions);
  getMyInfo(
    requestMessage: user_pb.GetMyInfoRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: user_pb.GetMyInfoResponse|null) => void
  ): UnaryResponse;
  getMyInfo(
    requestMessage: user_pb.GetMyInfoRequest,
    callback: (error: ServiceError|null, responseMessage: user_pb.GetMyInfoResponse|null) => void
  ): UnaryResponse;
}

