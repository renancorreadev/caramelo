// package: Auth_manager
// file: auth.proto

import * as auth_pb from "./auth_pb";
import {grpc} from "@improbable-eng/grpc-web";

type AuthManagerregistration = {
  readonly methodName: string;
  readonly service: typeof AuthManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof auth_pb.CreateUserRequest;
  readonly responseType: typeof auth_pb.CreateUserResponse;
};

type AuthManagergenerateTwoFactorAuthenticationCode = {
  readonly methodName: string;
  readonly service: typeof AuthManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof auth_pb.genAuthenticationCodeRequest;
  readonly responseType: typeof auth_pb.genAuthenticationCodeResponse;
};

type AuthManagerturnOnTwoFactorAuthentication = {
  readonly methodName: string;
  readonly service: typeof AuthManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof auth_pb.turnOnTwoFactorAuthenticationRequest;
  readonly responseType: typeof auth_pb.turnOnTwoFactorAuthenticationResponse;
};

type AuthManagerloggingIn = {
  readonly methodName: string;
  readonly service: typeof AuthManager;
  readonly requestStream: false;
  readonly responseStream: false;
  readonly requestType: typeof auth_pb.loggingInRequest;
  readonly responseType: typeof auth_pb.loggingInResponse;
};

export class AuthManager {
  static readonly serviceName: string;
  static readonly registration: AuthManagerregistration;
  static readonly generateTwoFactorAuthenticationCode: AuthManagergenerateTwoFactorAuthenticationCode;
  static readonly turnOnTwoFactorAuthentication: AuthManagerturnOnTwoFactorAuthentication;
  static readonly loggingIn: AuthManagerloggingIn;
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

export class AuthManagerClient {
  readonly serviceHost: string;

  constructor(serviceHost: string, options?: grpc.RpcOptions);
  registration(
    requestMessage: auth_pb.CreateUserRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: auth_pb.CreateUserResponse|null) => void
  ): UnaryResponse;
  registration(
    requestMessage: auth_pb.CreateUserRequest,
    callback: (error: ServiceError|null, responseMessage: auth_pb.CreateUserResponse|null) => void
  ): UnaryResponse;
  generateTwoFactorAuthenticationCode(
    requestMessage: auth_pb.genAuthenticationCodeRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: auth_pb.genAuthenticationCodeResponse|null) => void
  ): UnaryResponse;
  generateTwoFactorAuthenticationCode(
    requestMessage: auth_pb.genAuthenticationCodeRequest,
    callback: (error: ServiceError|null, responseMessage: auth_pb.genAuthenticationCodeResponse|null) => void
  ): UnaryResponse;
  turnOnTwoFactorAuthentication(
    requestMessage: auth_pb.turnOnTwoFactorAuthenticationRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: auth_pb.turnOnTwoFactorAuthenticationResponse|null) => void
  ): UnaryResponse;
  turnOnTwoFactorAuthentication(
    requestMessage: auth_pb.turnOnTwoFactorAuthenticationRequest,
    callback: (error: ServiceError|null, responseMessage: auth_pb.turnOnTwoFactorAuthenticationResponse|null) => void
  ): UnaryResponse;
  loggingIn(
    requestMessage: auth_pb.loggingInRequest,
    metadata: grpc.Metadata,
    callback: (error: ServiceError|null, responseMessage: auth_pb.loggingInResponse|null) => void
  ): UnaryResponse;
  loggingIn(
    requestMessage: auth_pb.loggingInRequest,
    callback: (error: ServiceError|null, responseMessage: auth_pb.loggingInResponse|null) => void
  ): UnaryResponse;
}

