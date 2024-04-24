// ignore_for_file: constant_identifier_names

import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/tcpconnect/connect/byte_buffer.dart';
import 'package:desktop_im/tcpconnect/connect/message_factory.dart';
import 'package:desktop_im/utils/uint8list_utils.dart';
import 'package:flutter/foundation.dart';

const int _MAGICNUMBER = 891013;
const int _VERSION = 1;

class MessageCodec {
  ByteBuf encode(Message message) {
    ByteBuf out = ByteBuf.allocator(size: 16);
    out.writeInt(_MAGICNUMBER);
    out.writeInt8(_VERSION);
    out.writeInt8(0);
    out.writeInt64(message.msgId);
    out.writeInt(message.messageType.index);
    out.writeInt64(message.timestamp);
    out.writeInt64(message.fromId);
    out.writeInt8(message.fromEntity.index);
    out.writeInt64(message.toId);
    out.writeInt8(message.toEntity.index);
    out.writeInt64(message.entityId);
    out.writeInt8(message.entityType.index);
    out.writeInt8(message.status.index);
    ByteBuf innercontent = ByteBuf.allocator(size: 16);
    innercontent.writeString(message.content);
    // out.writeInt(innercontent.couldReadableSize);
    out.writeString(message.content);

    ByteBuf result = ByteBuf(16);
    result.writeInt(out.couldReadableSize);
    result.writeByteBuf(out);

    return result;
  }

  Message? decode(Uint8List aData) {
    Message message;
    ByteBuf byteBuf = ByteBuf.allocator(size: aData.length);
    byteBuf.writeUint8List(aData);
    int magicNumber = byteBuf.readInt();
    if (magicNumber != _MAGICNUMBER) {
      return null;
    }
    int version = byteBuf.readInt8();
    if (version != _VERSION) {
      return null;
    }
    int serialize = byteBuf.readInt8();
    if (serialize != 0) {
      return null;
    }
    int messageId = byteBuf.readInt64();
    int messsageType = byteBuf.readInt();
    message = MessageFactory.messageFromType(intToMessageType(messsageType));
    message.msgId = messageId;

    int timestamp = byteBuf.readInt64();
    message.timestamp = timestamp;

    int fromId = byteBuf.readInt64();
    int fromEntityType = byteBuf.readInt8();
    message.fromId = fromId;
    message.fromEntity = intToMessageEntityType(fromEntityType);

    int toId = byteBuf.readInt64();
    int toEntityType = byteBuf.readInt8();
    message.toId = toId;
    message.toEntity = intToMessageEntityType(toEntityType);

    int entityId = byteBuf.readInt64();
    int entityType = byteBuf.readInt8();
    message.entityId = entityId;
    message.entityType = intToMessageEntityType(entityType);

    message.status = intToMessageStatus(byteBuf.readInt8());

    int length = byteBuf.readInt();
    Uint8List data = byteBuf.readUint8List(length);
    String content = Uint8ListUtils.convertUint8ListToString(data);
    message.content = content;
    return message;
  }
}

//         // 获取内容字节数组
//         int length = in.readInt();
//         byte[] contentByte = new byte[length];
//         in.readBytes(contentByte, 0, length);
//         String content = new String(contentByte, StandardCharsets.UTF_8);
//         message.setContent(content);