// package: nft_manager
// file: nft.proto

import * as jspb from "google-protobuf";

export class GetInfoNFTRequest extends jspb.Message {
  getFrom(): string;
  setFrom(value: string): void;

  getContractaddress(): string;
  setContractaddress(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  getTokenid(): string;
  setTokenid(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetInfoNFTRequest.AsObject;
  static toObject(includeInstance: boolean, msg: GetInfoNFTRequest): GetInfoNFTRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetInfoNFTRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetInfoNFTRequest;
  static deserializeBinaryFromReader(message: GetInfoNFTRequest, reader: jspb.BinaryReader): GetInfoNFTRequest;
}

export namespace GetInfoNFTRequest {
  export type AsObject = {
    from: string,
    contractaddress: string,
    network: string,
    tokenid: string,
  }
}

export class GetInfoNFTResponse extends jspb.Message {
  getNft(): string;
  setNft(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetInfoNFTResponse.AsObject;
  static toObject(includeInstance: boolean, msg: GetInfoNFTResponse): GetInfoNFTResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetInfoNFTResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetInfoNFTResponse;
  static deserializeBinaryFromReader(message: GetInfoNFTResponse, reader: jspb.BinaryReader): GetInfoNFTResponse;
}

export namespace GetInfoNFTResponse {
  export type AsObject = {
    nft: string,
  }
}

export class SendTransactionNFTRequest extends jspb.Message {
  getPubkey(): string;
  setPubkey(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  getTransaction(): string;
  setTransaction(value: string): void;

  getContractaddress(): string;
  setContractaddress(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  getTokenid(): string;
  setTokenid(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SendTransactionNFTRequest.AsObject;
  static toObject(includeInstance: boolean, msg: SendTransactionNFTRequest): SendTransactionNFTRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SendTransactionNFTRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SendTransactionNFTRequest;
  static deserializeBinaryFromReader(message: SendTransactionNFTRequest, reader: jspb.BinaryReader): SendTransactionNFTRequest;
}

export namespace SendTransactionNFTRequest {
  export type AsObject = {
    pubkey: string,
    twofactorauthenticationcode: string,
    transaction: string,
    contractaddress: string,
    network: string,
    tokenid: string,
  }
}

export class SendTransactionNFTResponse extends jspb.Message {
  getTransaction(): string;
  setTransaction(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SendTransactionNFTResponse.AsObject;
  static toObject(includeInstance: boolean, msg: SendTransactionNFTResponse): SendTransactionNFTResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SendTransactionNFTResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SendTransactionNFTResponse;
  static deserializeBinaryFromReader(message: SendTransactionNFTResponse, reader: jspb.BinaryReader): SendTransactionNFTResponse;
}

export namespace SendTransactionNFTResponse {
  export type AsObject = {
    transaction: string,
  }
}

export class GetNFTsForSaleRequest extends jspb.Message {
  getContractaddress(): string;
  setContractaddress(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetNFTsForSaleRequest.AsObject;
  static toObject(includeInstance: boolean, msg: GetNFTsForSaleRequest): GetNFTsForSaleRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetNFTsForSaleRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetNFTsForSaleRequest;
  static deserializeBinaryFromReader(message: GetNFTsForSaleRequest, reader: jspb.BinaryReader): GetNFTsForSaleRequest;
}

export namespace GetNFTsForSaleRequest {
  export type AsObject = {
    contractaddress: string,
    network: string,
  }
}

export class GetNFTsForSaleResponse extends jspb.Message {
  getNftdatalist(): string;
  setNftdatalist(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetNFTsForSaleResponse.AsObject;
  static toObject(includeInstance: boolean, msg: GetNFTsForSaleResponse): GetNFTsForSaleResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetNFTsForSaleResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetNFTsForSaleResponse;
  static deserializeBinaryFromReader(message: GetNFTsForSaleResponse, reader: jspb.BinaryReader): GetNFTsForSaleResponse;
}

export namespace GetNFTsForSaleResponse {
  export type AsObject = {
    nftdatalist: string,
  }
}

export class GetTokenMetadataUrlsOwnedByAddressRequest extends jspb.Message {
  getContractaddress(): string;
  setContractaddress(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  getFrom(): string;
  setFrom(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetTokenMetadataUrlsOwnedByAddressRequest.AsObject;
  static toObject(includeInstance: boolean, msg: GetTokenMetadataUrlsOwnedByAddressRequest): GetTokenMetadataUrlsOwnedByAddressRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetTokenMetadataUrlsOwnedByAddressRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetTokenMetadataUrlsOwnedByAddressRequest;
  static deserializeBinaryFromReader(message: GetTokenMetadataUrlsOwnedByAddressRequest, reader: jspb.BinaryReader): GetTokenMetadataUrlsOwnedByAddressRequest;
}

export namespace GetTokenMetadataUrlsOwnedByAddressRequest {
  export type AsObject = {
    contractaddress: string,
    network: string,
    from: string,
  }
}

export class GetTokenMetadataUrlsOwnedByAddressResponse extends jspb.Message {
  getNftdatalist(): string;
  setNftdatalist(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): GetTokenMetadataUrlsOwnedByAddressResponse.AsObject;
  static toObject(includeInstance: boolean, msg: GetTokenMetadataUrlsOwnedByAddressResponse): GetTokenMetadataUrlsOwnedByAddressResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: GetTokenMetadataUrlsOwnedByAddressResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): GetTokenMetadataUrlsOwnedByAddressResponse;
  static deserializeBinaryFromReader(message: GetTokenMetadataUrlsOwnedByAddressResponse, reader: jspb.BinaryReader): GetTokenMetadataUrlsOwnedByAddressResponse;
}

export namespace GetTokenMetadataUrlsOwnedByAddressResponse {
  export type AsObject = {
    nftdatalist: string,
  }
}

export class BuyNFTRequest extends jspb.Message {
  getPubkey(): string;
  setPubkey(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  getTransaction(): string;
  setTransaction(value: string): void;

  getContractaddress(): string;
  setContractaddress(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  getTokenid(): string;
  setTokenid(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): BuyNFTRequest.AsObject;
  static toObject(includeInstance: boolean, msg: BuyNFTRequest): BuyNFTRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: BuyNFTRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): BuyNFTRequest;
  static deserializeBinaryFromReader(message: BuyNFTRequest, reader: jspb.BinaryReader): BuyNFTRequest;
}

export namespace BuyNFTRequest {
  export type AsObject = {
    pubkey: string,
    twofactorauthenticationcode: string,
    transaction: string,
    contractaddress: string,
    network: string,
    tokenid: string,
  }
}

export class BuyNFTResponse extends jspb.Message {
  getTransaction(): string;
  setTransaction(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): BuyNFTResponse.AsObject;
  static toObject(includeInstance: boolean, msg: BuyNFTResponse): BuyNFTResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: BuyNFTResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): BuyNFTResponse;
  static deserializeBinaryFromReader(message: BuyNFTResponse, reader: jspb.BinaryReader): BuyNFTResponse;
}

export namespace BuyNFTResponse {
  export type AsObject = {
    transaction: string,
  }
}

export class SetNFTForSaleRequest extends jspb.Message {
  getPubkey(): string;
  setPubkey(value: string): void;

  getTwofactorauthenticationcode(): string;
  setTwofactorauthenticationcode(value: string): void;

  getTransaction(): string;
  setTransaction(value: string): void;

  getContractaddress(): string;
  setContractaddress(value: string): void;

  getNetwork(): string;
  setNetwork(value: string): void;

  getTokenid(): string;
  setTokenid(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SetNFTForSaleRequest.AsObject;
  static toObject(includeInstance: boolean, msg: SetNFTForSaleRequest): SetNFTForSaleRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SetNFTForSaleRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SetNFTForSaleRequest;
  static deserializeBinaryFromReader(message: SetNFTForSaleRequest, reader: jspb.BinaryReader): SetNFTForSaleRequest;
}

export namespace SetNFTForSaleRequest {
  export type AsObject = {
    pubkey: string,
    twofactorauthenticationcode: string,
    transaction: string,
    contractaddress: string,
    network: string,
    tokenid: string,
  }
}

export class SetNFTForSaleResponse extends jspb.Message {
  getTransaction(): string;
  setTransaction(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): SetNFTForSaleResponse.AsObject;
  static toObject(includeInstance: boolean, msg: SetNFTForSaleResponse): SetNFTForSaleResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: SetNFTForSaleResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): SetNFTForSaleResponse;
  static deserializeBinaryFromReader(message: SetNFTForSaleResponse, reader: jspb.BinaryReader): SetNFTForSaleResponse;
}

export namespace SetNFTForSaleResponse {
  export type AsObject = {
    transaction: string,
  }
}

