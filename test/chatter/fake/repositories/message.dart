import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:tag_n_go/features/chatter/domain/entities/message.dart';
import 'package:tag_n_go/features/chatter/domain/repositories/message_repositorie.dart';

class MessageControler {
  String user;
  StreamController<Message> controller;

  MessageControler(this.user) {
    controller = StreamController<Message>();
  }

  void update(Message message) {
    if (message.from == user || message.to == user) {
      controller.add(message);
    }
  }

  Stream<Message> get stream {
    return controller.stream.asBroadcastStream();
  }
}

class MessageRepositorieImpl implements MessageRepositorie {
  List<Message> depot = new List<Message>();
  List<MessageControler> controllers = new List<MessageControler>();

  T cast<T>(x) => x is T ? x : null;

  @override
  Message getLastMessage(String user1, String user2) {
    return depot
        .where((message) => ((message.from == user1 && message.to == user2) ||
            (message.from == user2 && message.to == user1)))
        .toList()
        .last;
  }

  @override
  void save(Message message) {
    depot.add(message);
    controllers.forEach((controller) => controller.update(message));
    depot.sort();
  }

  @override
  Future<List<Message>> getMessagesAfter(
      String user, DateTime dateTime, String contact) {
    List<Message> messages = depot
        .where((message) =>
            (message.from == user || message.to == user) &&
            message.dateTime.isAfter(dateTime))
        .toList();
    if (contact != null && contact != "") {
      messages = messages
          .where((message) => message.from == contact || message.to == contact)
          .toList();
    }
    return Future.value(messages);
  }

  @override
  Future<List<Message>> getMessagesBefore(
      String user, DateTime dateTime, String contact, int take) {
    List<Message> messages = depot
        .where((message) =>
            (message.from == user || message.to == user) &&
            message.dateTime.isBefore(dateTime))
        .toList();
    if (contact != null && contact != "") {
      messages = messages
          .where((message) => message.from == contact || message.to == contact)
          .toList();
    }

    if (take != null && take > 0 && messages.length > 0) {
      messages = messages.reversed
          .take(min(take, messages.length))
          .toList()
          .reversed
          .toList();
    }
    return Future.value(messages);
  }

  @override
  Stream<Message> message(String user) {
    var controllersFiltered =
        controllers.where((controller) => controller.user == user);
    Stream stream =
        controllersFiltered.isNotEmpty ? controllersFiltered.last.stream : null;
    if (stream == null) {
      MessageControler mc = new MessageControler(user);
      controllers.add(mc);
      stream = mc.stream;
    }
    return stream;
  }
}
