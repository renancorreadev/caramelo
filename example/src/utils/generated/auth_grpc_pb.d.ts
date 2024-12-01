// package: Auth_manager
// file: auth.proto

/* tslint:disable */
/* eslint-disable */

import * as grpc from "@grpc/grpc-js";
import * as auth_pb from "./auth_pb";

interface IAuthManagerService extends grpc.ServiceDefinition<grpc.UntypedServiceImplementation> {
    registration: IAuthManagerService_Iregistration;
    generateTwoFactorAuthenticationCode: IAuthManagerService_IgenerateTwoFactorAuthenticationCode;
    turnOnTwoFactorAuthentication: IAuthManagerService_IturnOnTwoFactorAuthentication;
    loggingIn: IAuthManagerService_IloggingIn;
}

interface IAuthManagerService_Iregistration extends grpc.MethodDefinition<auth_pb.CreateUserRequest, auth_pb.CreateUserResponse> {
    path: "/Auth_manager.AuthManager/registration";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<auth_pb.CreateUserRequest>;
    requestDeserialize: grpc.deserialize<auth_pb.CreateUserRequest>;
    responseSerialize: grpc.serialize<auth_pb.CreateUserResponse>;
    responseDeserialize: grpc.deserialize<auth_pb.CreateUserResponse>;
}
interface IAuthManagerService_IgenerateTwoFactorAuthenticationCode extends grpc.MethodDefinition<auth_pb.genAuthenticationCodeRequest, auth_pb.genAuthenticationCodeResponse> {
    path: "/Auth_manager.AuthManager/generateTwoFactorAuthenticationCode";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<auth_pb.genAuthenticationCodeRequest>;
    requestDeserialize: grpc.deserialize<auth_pb.genAuthenticationCodeRequest>;
    responseSerialize: grpc.serialize<auth_pb.genAuthenticationCodeResponse>;
    responseDeserialize: grpc.deserialize<auth_pb.genAuthenticationCodeResponse>;
}
interface IAuthManagerService_IturnOnTwoFactorAuthentication extends grpc.MethodDefinition<auth_pb.turnOnTwoFactorAuthenticationRequest, auth_pb.turnOnTwoFactorAuthenticationResponse> {
    path: "/Auth_manager.AuthManager/turnOnTwoFactorAuthentication";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<auth_pb.turnOnTwoFactorAuthenticationRequest>;
    requestDeserialize: grpc.deserialize<auth_pb.turnOnTwoFactorAuthenticationRequest>;
    responseSerialize: grpc.serialize<auth_pb.turnOnTwoFactorAuthenticationResponse>;
    responseDeserialize: grpc.deserialize<auth_pb.turnOnTwoFactorAuthenticationResponse>;
}
interface IAuthManagerService_IloggingIn extends grpc.MethodDefinition<auth_pb.loggingInRequest, auth_pb.loggingInResponse> {
    path: "/Auth_manager.AuthManager/loggingIn";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<auth_pb.loggingInRequest>;
    requestDeserialize: grpc.deserialize<auth_pb.loggingInRequest>;
    responseSerialize: grpc.serialize<auth_pb.loggingInResponse>;
    responseDeserialize: grpc.deserialize<auth_pb.loggingInResponse>;
}

export const AuthManagerService: IAuthManagerService;

export interface IAuthManagerServer {
    registration: grpc.handleUnaryCall<auth_pb.CreateUserRequest, auth_pb.CreateUserResponse>;
    generateTwoFactorAuthenticationCode: grpc.handleUnaryCall<auth_pb.genAuthenticationCodeRequest, auth_pb.genAuthenticationCodeResponse>;
    turnOnTwoFactorAuthentication: grpc.handleUnaryCall<auth_pb.turnOnTwoFactorAuthenticationRequest, auth_pb.turnOnTwoFactorAuthenticationResponse>;
    loggingIn: grpc.handleUnaryCall<auth_pb.loggingInRequest, auth_pb.loggingInResponse>;
}

export interface IAuthManagerClient {
    registration(request: auth_pb.CreateUserRequest, callback: (error: grpc.ServiceError | null, response: auth_pb.CreateUserResponse) => void): grpc.ClientUnaryCall;
    registration(request: auth_pb.CreateUserRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: auth_pb.CreateUserResponse) => void): grpc.ClientUnaryCall;
    registration(request: auth_pb.CreateUserRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: auth_pb.CreateUserResponse) => void): grpc.ClientUnaryCall;
    generateTwoFactorAuthenticationCode(request: auth_pb.genAuthenticationCodeRequest, callback: (error: grpc.ServiceError | null, response: auth_pb.genAuthenticationCodeResponse) => void): grpc.ClientUnaryCall;
    generateTwoFactorAuthenticationCode(request: auth_pb.genAuthenticationCodeRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: auth_pb.genAuthenticationCodeResponse) => void): grpc.ClientUnaryCall;
    generateTwoFactorAuthenticationCode(request: auth_pb.genAuthenticationCodeRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: auth_pb.genAuthenticationCodeResponse) => void): grpc.ClientUnaryCall;
    turnOnTwoFactorAuthentication(request: auth_pb.turnOnTwoFactorAuthenticationRequest, callback: (error: grpc.ServiceError | null, response: auth_pb.turnOnTwoFactorAuthenticationResponse) => void): grpc.ClientUnaryCall;
    turnOnTwoFactorAuthentication(request: auth_pb.turnOnTwoFactorAuthenticationRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: auth_pb.turnOnTwoFactorAuthenticationResponse) => void): grpc.ClientUnaryCall;
    turnOnTwoFactorAuthentication(request: auth_pb.turnOnTwoFactorAuthenticationRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: auth_pb.turnOnTwoFactorAuthenticationResponse) => void): grpc.ClientUnaryCall;
    loggingIn(request: auth_pb.loggingInRequest, callback: (error: grpc.ServiceError | null, response: auth_pb.loggingInResponse) => void): grpc.ClientUnaryCall;
    loggingIn(request: auth_pb.loggingInRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: auth_pb.loggingInResponse) => void): grpc.ClientUnaryCall;
    loggingIn(request: auth_pb.loggingInRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: auth_pb.loggingInResponse) => void): grpc.ClientUnaryCall;
}

export class AuthManagerClient extends grpc.Client implements IAuthManagerClient {
    constructor(address: string, credentials: grpc.ChannelCredentials, options?: object);
    public registration(request: auth_pb.CreateUserRequest, callback: (error: grpc.ServiceError | null, response: auth_pb.CreateUserResponse) => void): grpc.ClientUnaryCall;
    public registration(request: auth_pb.CreateUserRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: auth_pb.CreateUserResponse) => void): grpc.ClientUnaryCall;
    public registration(request: auth_pb.CreateUserRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: auth_pb.CreateUserResponse) => void): grpc.ClientUnaryCall;
    public generateTwoFactorAuthenticationCode(request: auth_pb.genAuthenticationCodeRequest, callback: (error: grpc.ServiceError | null, response: auth_pb.genAuthenticationCodeResponse) => void): grpc.ClientUnaryCall;
    public generateTwoFactorAuthenticationCode(request: auth_pb.genAuthenticationCodeRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: auth_pb.genAuthenticationCodeResponse) => void): grpc.ClientUnaryCall;
    public generateTwoFactorAuthenticationCode(request: auth_pb.genAuthenticationCodeRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: auth_pb.genAuthenticationCodeResponse) => void): grpc.ClientUnaryCall;
    public turnOnTwoFactorAuthentication(request: auth_pb.turnOnTwoFactorAuthenticationRequest, callback: (error: grpc.ServiceError | null, response: auth_pb.turnOnTwoFactorAuthenticationResponse) => void): grpc.ClientUnaryCall;
    public turnOnTwoFactorAuthentication(request: auth_pb.turnOnTwoFactorAuthenticationRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: auth_pb.turnOnTwoFactorAuthenticationResponse) => void): grpc.ClientUnaryCall;
    public turnOnTwoFactorAuthentication(request: auth_pb.turnOnTwoFactorAuthenticationRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: auth_pb.turnOnTwoFactorAuthenticationResponse) => void): grpc.ClientUnaryCall;
    public loggingIn(request: auth_pb.loggingInRequest, callback: (error: grpc.ServiceError | null, response: auth_pb.loggingInResponse) => void): grpc.ClientUnaryCall;
    public loggingIn(request: auth_pb.loggingInRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: auth_pb.loggingInResponse) => void): grpc.ClientUnaryCall;
    public loggingIn(request: auth_pb.loggingInRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: auth_pb.loggingInResponse) => void): grpc.ClientUnaryCall;
}
