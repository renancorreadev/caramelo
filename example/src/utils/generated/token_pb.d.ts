// package: token_manager
// file: token.proto

import * as jspb from "google-protobuf";

export class GetInfoTokenRequest extends jspb.Message {
  getFrom(): string;
  setFrom(value: string): void;

  getTokenaddress(): string;
  setTokenaddress(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetInfoTokenRequest.AsObject;
  static toObject(includeInstance: boolean, msg: GetInfoTokenRequest): GetInfoTokenRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetInfoTokenRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetInfoTokenRequest;
  static deserializeBinaryFromReader(message: GetInfoTokenRequest, reader: jspb.BinaryReader): GetInfoTokenRequest;
}

export namespace GetInfoTokenRequest {
  export type AsObject = {
    from: string,
    tokenaddress: string,
    network: string,
  }
}

export class GetInfoTokenResponse extends jspb.Message {
  getToken(): string;
  setToken(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetInfoTokenResponse.AsObject;
  static toObject(includeInstance: boolean, msg: GetInfoTokenResponse): GetInfoTokenResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetInfoTokenResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetInfoTokenResponse;
  static deserializeBinaryFromReader(message: GetInfoTokenResponse, reader: jspb.BinaryReader): GetInfoTokenResponse;
}

export namespace GetInfoTokenResponse {
  export type AsObject = {
    token: string,
  }
}

export class GetBalanceTokenRequest extends jspb.Message {
  getFrom(): string;
  setFrom(value: string): void;

  getTokenaddress(): string;
  setTokenaddress(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetBalanceTokenRequest.AsObject;
  static toObject(includeInstance: boolean, msg: GetBalanceTokenRequest): GetBalanceTokenRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetBalanceTokenRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetBalanceTokenRequest;
  static deserializeBinaryFromReader(message: GetBalanceTokenRequest, reader: jspb.BinaryReader): GetBalanceTokenRequest;
}

export namespace GetBalanceTokenRequest {
  export type AsObject = {
    from: string,
    tokenaddress: string,
    network: string,
  }
}

export class GetBalanceTokenResponse extends jspb.Message {
  getBalance(): string;
  setBalance(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetBalanceTokenResponse.AsObject;
  static toObject(includeInstance: boolean, msg: GetBalanceTokenResponse): GetBalanceTokenResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetBalanceTokenResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetBalanceTokenResponse;
  static deserializeBinaryFromReader(message: GetBalanceTokenResponse, reader: jspb.BinaryReader): GetBalanceTokenResponse;
}

export namespace GetBalanceTokenResponse {
  export type AsObject = {
    balance: string,
  }
}

export class SendTransactionTokenRequest extends jspb.Message {
  getPubkey(): string;
  setPubkey(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  getTransaction(): string;
  setTransaction(value: string): void;

  getTokenaddress(): string;
  setTokenaddress(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SendTransactionTokenRequest.AsObject;
  static toObject(includeInstance: boolean, msg: SendTransactionTokenRequest): SendTransactionTokenRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SendTransactionTokenRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SendTransactionTokenRequest;
  static deserializeBinaryFromReader(message: SendTransactionTokenRequest, reader: jspb.BinaryReader): SendTransactionTokenRequest;
}

export namespace SendTransactionTokenRequest {
  export type AsObject = {
    pubkey: string,
    twofactorauthenticationcode: string,
    transaction: string,
    tokenaddress: string,
    network: string,
  }
}

export class SendTransactionTokenResponse extends jspb.Message {
  getTransaction(): string;
  setTransaction(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SendTransactionTokenResponse.AsObject;
  static toObject(includeInstance: boolean, msg: SendTransactionTokenResponse): SendTransactionTokenResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SendTransactionTokenResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SendTransactionTokenResponse;
  static deserializeBinaryFromReader(message: SendTransactionTokenResponse, reader: jspb.BinaryReader): SendTransactionTokenResponse;
}

export namespace SendTransactionTokenResponse {
  export type AsObject = {
    transaction: string,
  }
}

export class ApproveTokenRequest extends jspb.Message {
  getPubkey(): string;
  setPubkey(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  getTransaction(): string;
  setTransaction(value: string): void;

  getTokenaddress(): string;
  setTokenaddress(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): ApproveTokenRequest.AsObject;
  static toObject(includeInstance: boolean, msg: ApproveTokenRequest): ApproveTokenRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: ApproveTokenRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): ApproveTokenRequest;
  static deserializeBinaryFromReader(message: ApproveTokenRequest, reader: jspb.BinaryReader): ApproveTokenRequest;
}

export namespace ApproveTokenRequest {
  export type AsObject = {
    pubkey: string,
    twofactorauthenticationcode: string,
    transaction: string,
    tokenaddress: string,
    network: string,
  }
}

export class ApproveTokenResponse extends jspb.Message {
  getTransaction(): string;
  setTransaction(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): ApproveTokenResponse.AsObject;
  static toObject(includeInstance: boolean, msg: ApproveTokenResponse): ApproveTokenResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: ApproveTokenResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): ApproveTokenResponse;
  static deserializeBinaryFromReader(message: ApproveTokenResponse, reader: jspb.BinaryReader): ApproveTokenResponse;
}

export namespace ApproveTokenResponse {
  export type AsObject = {
    transaction: string,
  }
}

