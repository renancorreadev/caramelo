// package: user_management
// file: user.proto

import * as jspb from "google-protobuf";

export class GetMyInfoRequest extends jspb.Message {
  getToken(): string;
  setToken(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetMyInfoRequest.AsObject;
  static toObject(includeInstance: boolean, msg: GetMyInfoRequest): GetMyInfoRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetMyInfoRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetMyInfoRequest;
  static deserializeBinaryFromReader(message: GetMyInfoRequest, reader: jspb.BinaryReader): GetMyInfoRequest;
}

export namespace GetMyInfoRequest {
  export type AsObject = {
    token: string,
  }
}

export class GetMyInfoResponse extends jspb.Message {
  getName(): string;
  setName(value: string): void;

  getEmail(): string;
  setEmail(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetMyInfoResponse.AsObject;
  static toObject(includeInstance: boolean, msg: GetMyInfoResponse): GetMyInfoResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetMyInfoResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetMyInfoResponse;
  static deserializeBinaryFromReader(message: GetMyInfoResponse, reader: jspb.BinaryReader): GetMyInfoResponse;
}

export namespace GetMyInfoResponse {
  export type AsObject = {
    name: string,
    email: string,
  }
}

