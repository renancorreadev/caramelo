// package: network_manager
// file: network.proto

import * as jspb from "google-protobuf";

export class availableNetworkRequest extends jspb.Message {
  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): availableNetworkRequest.AsObject;
  static toObject(includeInstance: boolean, msg: availableNetworkRequest): availableNetworkRequest.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: availableNetworkRequest, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): availableNetworkRequest;
  static deserializeBinaryFromReader(message: availableNetworkRequest, reader: jspb.BinaryReader): availableNetworkRequest;
}

export namespace availableNetworkRequest {
  export type AsObject = {
  }
}

export class availableNetworkResponse extends jspb.Message {
  getNetworklist(): string;
  setNetworklist(value: string): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): availableNetworkResponse.AsObject;
  static toObject(includeInstance: boolean, msg: availableNetworkResponse): availableNetworkResponse.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: availableNetworkResponse, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): availableNetworkResponse;
  static deserializeBinaryFromReader(message: availableNetworkResponse, reader: jspb.BinaryReader): availableNetworkResponse;
}

export namespace availableNetworkResponse {
  export type AsObject = {
    networklist: string,
  }
}

