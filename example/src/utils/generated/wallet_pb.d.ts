// package: wallet_manager
// file: wallet.proto

import * as jspb from "google-protobuf";

export class CreateWalletRequest extends jspb.Message {
  getLabel(): string;
  setLabel(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): CreateWalletRequest.AsObject;
  static toObject(includeInstance: boolean, msg: CreateWalletRequest): CreateWalletRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: CreateWalletRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): CreateWalletRequest;
  static deserializeBinaryFromReader(message: CreateWalletRequest, reader: jspb.BinaryReader): CreateWalletRequest;
}

export namespace CreateWalletRequest {
  export type AsObject = {
    label: string,
    twofactorauthenticationcode: string,
    network: string,
  }
}

export class CreateWalletResponse extends jspb.Message {
  getPubkey(): string;
  setPubkey(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): CreateWalletResponse.AsObject;
  static toObject(includeInstance: boolean, msg: CreateWalletResponse): CreateWalletResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: CreateWalletResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): CreateWalletResponse;
  static deserializeBinaryFromReader(message: CreateWalletResponse, reader: jspb.BinaryReader): CreateWalletResponse;
}

export namespace CreateWalletResponse {
  export type AsObject = {
    pubkey: string,
  }
}

export class ExportWalletRequest extends jspb.Message {
  getPubkey(): string;
  setPubkey(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): ExportWalletRequest.AsObject;
  static toObject(includeInstance: boolean, msg: ExportWalletRequest): ExportWalletRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: ExportWalletRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): ExportWalletRequest;
  static deserializeBinaryFromReader(message: ExportWalletRequest, reader: jspb.BinaryReader): ExportWalletRequest;
}

export namespace ExportWalletRequest {
  export type AsObject = {
    pubkey: string,
    twofactorauthenticationcode: string,
  }
}

export class ExportWalletResponse extends jspb.Message {
  getUr(): string;
  setUr(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): ExportWalletResponse.AsObject;
  static toObject(includeInstance: boolean, msg: ExportWalletResponse): ExportWalletResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: ExportWalletResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): ExportWalletResponse;
  static deserializeBinaryFromReader(message: ExportWalletResponse, reader: jspb.BinaryReader): ExportWalletResponse;
}

export namespace ExportWalletResponse {
  export type AsObject = {
    ur: string,
  }
}

export class SingUrTransactionRequest extends jspb.Message {
  getUr(): string;
  setUr(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SingUrTransactionRequest.AsObject;
  static toObject(includeInstance: boolean, msg: SingUrTransactionRequest): SingUrTransactionRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SingUrTransactionRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SingUrTransactionRequest;
  static deserializeBinaryFromReader(message: SingUrTransactionRequest, reader: jspb.BinaryReader): SingUrTransactionRequest;
}

export namespace SingUrTransactionRequest {
  export type AsObject = {
    ur: string,
    twofactorauthenticationcode: string,
  }
}

export class SingUrTransactionResponse extends jspb.Message {
  getUr(): string;
  setUr(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SingUrTransactionResponse.AsObject;
  static toObject(includeInstance: boolean, msg: SingUrTransactionResponse): SingUrTransactionResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SingUrTransactionResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SingUrTransactionResponse;
  static deserializeBinaryFromReader(message: SingUrTransactionResponse, reader: jspb.BinaryReader): SingUrTransactionResponse;
}

export namespace SingUrTransactionResponse {
  export type AsObject = {
    ur: string,
  }
}

export class DeriveAddressRequest extends jspb.Message {
  getPubkey(): string;
  setPubkey(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): DeriveAddressRequest.AsObject;
  static toObject(includeInstance: boolean, msg: DeriveAddressRequest): DeriveAddressRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: DeriveAddressRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): DeriveAddressRequest;
  static deserializeBinaryFromReader(message: DeriveAddressRequest, reader: jspb.BinaryReader): DeriveAddressRequest;
}

export namespace DeriveAddressRequest {
  export type AsObject = {
    pubkey: string,
    twofactorauthenticationcode: string,
    network: string,
  }
}

export class DeriveAddressResponse extends jspb.Message {
  getAddress(): string;
  setAddress(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): DeriveAddressResponse.AsObject;
  static toObject(includeInstance: boolean, msg: DeriveAddressResponse): DeriveAddressResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: DeriveAddressResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): DeriveAddressResponse;
  static deserializeBinaryFromReader(message: DeriveAddressResponse, reader: jspb.BinaryReader): DeriveAddressResponse;
}

export namespace DeriveAddressResponse {
  export type AsObject = {
    address: string,
  }
}

export class SingRawTransactionRequest extends jspb.Message {
  getPubkey(): string;
  setPubkey(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  getTransaction(): string;
  setTransaction(value: string): void;

  getChainid(): string;
  setChainid(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SingRawTransactionRequest.AsObject;
  static toObject(includeInstance: boolean, msg: SingRawTransactionRequest): SingRawTransactionRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SingRawTransactionRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SingRawTransactionRequest;
  static deserializeBinaryFromReader(message: SingRawTransactionRequest, reader: jspb.BinaryReader): SingRawTransactionRequest;
}

export namespace SingRawTransactionRequest {
  export type AsObject = {
    pubkey: string,
    twofactorauthenticationcode: string,
    transaction: string,
    chainid: string,
    network: string,
  }
}

export class SingRawTransactionResponse extends jspb.Message {
  getTransaction(): string;
  setTransaction(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SingRawTransactionResponse.AsObject;
  static toObject(includeInstance: boolean, msg: SingRawTransactionResponse): SingRawTransactionResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SingRawTransactionResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SingRawTransactionResponse;
  static deserializeBinaryFromReader(message: SingRawTransactionResponse, reader: jspb.BinaryReader): SingRawTransactionResponse;
}

export namespace SingRawTransactionResponse {
  export type AsObject = {
    transaction: string,
  }
}

export class SendTransactionRequest extends jspb.Message {
  getPubkey(): string;
  setPubkey(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  getTransaction(): string;
  setTransaction(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SendTransactionRequest.AsObject;
  static toObject(includeInstance: boolean, msg: SendTransactionRequest): SendTransactionRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SendTransactionRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SendTransactionRequest;
  static deserializeBinaryFromReader(message: SendTransactionRequest, reader: jspb.BinaryReader): SendTransactionRequest;
}

export namespace SendTransactionRequest {
  export type AsObject = {
    pubkey: string,
    twofactorauthenticationcode: string,
    transaction: string,
    network: string,
  }
}

export class SendTransactionResponse extends jspb.Message {
  getTransaction(): string;
  setTransaction(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SendTransactionResponse.AsObject;
  static toObject(includeInstance: boolean, msg: SendTransactionResponse): SendTransactionResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SendTransactionResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SendTransactionResponse;
  static deserializeBinaryFromReader(message: SendTransactionResponse, reader: jspb.BinaryReader): SendTransactionResponse;
}

export namespace SendTransactionResponse {
  export type AsObject = {
    transaction: string,
  }
}

