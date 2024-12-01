// package: Auth_manager
// file: auth.proto

import * as jspb from "google-protobuf";

export class CreateUserRequest extends jspb.Message {
  getName(): string;
  setName(value: string): void;

  getEmail(): string;
  setEmail(value: string): void;

  getPassword(): string;
  setPassword(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): CreateUserRequest.AsObject;
  static toObject(includeInstance: boolean, msg: CreateUserRequest): CreateUserRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: CreateUserRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): CreateUserRequest;
  static deserializeBinaryFromReader(message: CreateUserRequest, reader: jspb.BinaryReader): CreateUserRequest;
}

export namespace CreateUserRequest {
  export type AsObject = {
    name: string,
    email: string,
    password: string,
  }
}

export class CreateUserResponse extends jspb.Message {
  getToken(): string;
  setToken(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): CreateUserResponse.AsObject;
  static toObject(includeInstance: boolean, msg: CreateUserResponse): CreateUserResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: CreateUserResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): CreateUserResponse;
  static deserializeBinaryFromReader(message: CreateUserResponse, reader: jspb.BinaryReader): CreateUserResponse;
}

export namespace CreateUserResponse {
  export type AsObject = {
    token: string,
  }
}

export class genAuthenticationCodeRequest extends jspb.Message {
  getAutorization(): string;
  setAutorization(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): genAuthenticationCodeRequest.AsObject;
  static toObject(includeInstance: boolean, msg: genAuthenticationCodeRequest): genAuthenticationCodeRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: genAuthenticationCodeRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): genAuthenticationCodeRequest;
  static deserializeBinaryFromReader(message: genAuthenticationCodeRequest, reader: jspb.BinaryReader): genAuthenticationCodeRequest;
}

export namespace genAuthenticationCodeRequest {
  export type AsObject = {
    autorization: string,
  }
}

export class genAuthenticationCodeResponse extends jspb.Message {
  getQrcode(): Uint8Array | string;
  getQrcode_asU8(): Uint8Array;
  getQrcode_asB64(): string;
  setQrcode(value: Uint8Array | string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): genAuthenticationCodeResponse.AsObject;
  static toObject(includeInstance: boolean, msg: genAuthenticationCodeResponse): genAuthenticationCodeResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: genAuthenticationCodeResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): genAuthenticationCodeResponse;
  static deserializeBinaryFromReader(message: genAuthenticationCodeResponse, reader: jspb.BinaryReader): genAuthenticationCodeResponse;
}

export namespace genAuthenticationCodeResponse {
  export type AsObject = {
    qrcode: Uint8Array | string,
  }
}

export class turnOnTwoFactorAuthenticationRequest extends jspb.Message {
  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): turnOnTwoFactorAuthenticationRequest.AsObject;
  static toObject(includeInstance: boolean, msg: turnOnTwoFactorAuthenticationRequest): turnOnTwoFactorAuthenticationRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: turnOnTwoFactorAuthenticationRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): turnOnTwoFactorAuthenticationRequest;
  static deserializeBinaryFromReader(message: turnOnTwoFactorAuthenticationRequest, reader: jspb.BinaryReader): turnOnTwoFactorAuthenticationRequest;
}

export namespace turnOnTwoFactorAuthenticationRequest {
  export type AsObject = {
    twofactorauthenticationcode: string,
  }
}

export class turnOnTwoFactorAuthenticationResponse extends jspb.Message {
  getRes(): string;
  setRes(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): turnOnTwoFactorAuthenticationResponse.AsObject;
  static toObject(includeInstance: boolean, msg: turnOnTwoFactorAuthenticationResponse): turnOnTwoFactorAuthenticationResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: turnOnTwoFactorAuthenticationResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): turnOnTwoFactorAuthenticationResponse;
  static deserializeBinaryFromReader(message: turnOnTwoFactorAuthenticationResponse, reader: jspb.BinaryReader): turnOnTwoFactorAuthenticationResponse;
}

export namespace turnOnTwoFactorAuthenticationResponse {
  export type AsObject = {
    res: string,
  }
}

export class loggingInRequest extends jspb.Message {
  getEmail(): string;
  setEmail(value: string): void;

  getPass(): string;
  setPass(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): loggingInRequest.AsObject;
  static toObject(includeInstance: boolean, msg: loggingInRequest): loggingInRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: loggingInRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): loggingInRequest;
  static deserializeBinaryFromReader(message: loggingInRequest, reader: jspb.BinaryReader): loggingInRequest;
}

export namespace loggingInRequest {
  export type AsObject = {
    email: string,
    pass: string,
  }
}

export class loggingInResponse extends jspb.Message {
  getRes(): string;
  setRes(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): loggingInResponse.AsObject;
  static toObject(includeInstance: boolean, msg: loggingInResponse): loggingInResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: loggingInResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): loggingInResponse;
  static deserializeBinaryFromReader(message: loggingInResponse, reader: jspb.BinaryReader): loggingInResponse;
}

export namespace loggingInResponse {
  export type AsObject = {
    res: string,
  }
}

