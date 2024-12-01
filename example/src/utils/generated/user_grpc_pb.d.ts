// package: user_management
// file: user.proto

/* tslint:disable */
/* eslint-disable */

import * as grpc from "@grpc/grpc-js";
import * as user_pb from "./user_pb";

interface IUserManagerService extends grpc.ServiceDefinition<grpc.UntypedServiceImplementation> {
    getMyInfo: IUserManagerService_IgetMyInfo;
}

interface IUserManagerService_IgetMyInfo extends grpc.MethodDefinition<user_pb.GetMyInfoRequest, user_pb.GetMyInfoResponse> {
    path: "/user_management.UserManager/getMyInfo";
    requestStream: false;
    responseStream: false;
    requestSerialize: grpc.serialize<user_pb.GetMyInfoRequest>;
    requestDeserialize: grpc.deserialize<user_pb.GetMyInfoRequest>;
    responseSerialize: grpc.serialize<user_pb.GetMyInfoResponse>;
    responseDeserialize: grpc.deserialize<user_pb.GetMyInfoResponse>;
}

export const UserManagerService: IUserManagerService;

export interface IUserManagerServer {
    getMyInfo: grpc.handleUnaryCall<user_pb.GetMyInfoRequest, user_pb.GetMyInfoResponse>;
}

export interface IUserManagerClient {
    getMyInfo(request: user_pb.GetMyInfoRequest, callback: (error: grpc.ServiceError | null, response: user_pb.GetMyInfoResponse) => void): grpc.ClientUnaryCall;
    getMyInfo(request: user_pb.GetMyInfoRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: user_pb.GetMyInfoResponse) => void): grpc.ClientUnaryCall;
    getMyInfo(request: user_pb.GetMyInfoRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: user_pb.GetMyInfoResponse) => void): grpc.ClientUnaryCall;
}

export class UserManagerClient extends grpc.Client implements IUserManagerClient {
    constructor(address: string, credentials: grpc.ChannelCredentials, options?: object);
    public getMyInfo(request: user_pb.GetMyInfoRequest, callback: (error: grpc.ServiceError | null, response: user_pb.GetMyInfoResponse) => void): grpc.ClientUnaryCall;
    public getMyInfo(request: user_pb.GetMyInfoRequest, metadata: grpc.Metadata, callback: (error: grpc.ServiceError | null, response: user_pb.GetMyInfoResponse) => void): grpc.ClientUnaryCall;
    public getMyInfo(request: user_pb.GetMyInfoRequest, metadata: grpc.Metadata, options: Partial<grpc.CallOptions>, callback: (error: grpc.ServiceError | null, response: user_pb.GetMyInfoResponse) => void): grpc.ClientUnaryCall;
}
