import 'dart:async';

import 'package:tag_n_go/features/chatter/domain/entities/chat.dart';
import 'package:tag_n_go/features/chatter/domain/entities/contact.dart';
import 'package:tag_n_go/features/chatter/domain/entities/message.dart';
import 'package:tag_n_go/features/chatter/domain/entities/user.dart';
import 'package:tag_n_go/features/chatter/domain/repositories/message_repositorie.dart';
import 'package:tag_n_go/features/chatter/domain/services/date.dart';

class Messenger {
  DateTimeService dateTimeService;
  MessageRepositorie repositorie;

  Messenger(this.repositorie, this.dateTimeService);

  Chat open(User utilisateur, Contact contact) {
    if (utilisateur == null) throw Exception("Utilisateur not null");
    if (contact == null) throw Exception("contact not null");
    return Chat(utilisateur, contact);
  }

  void send(Chat chat, String message) {
    if (message != null && message.length > 0) {
      repositorie.save(new Message(
          from: chat.getFrom(),
          to: chat.getTo(),
          content: message,
          dateTime: dateTimeService.now()));
    }
  }

  Future<Message> lastMessage(Chat chat) {
    return repositorie
        .getMessagesBefore(
            chat.getFrom(), dateTimeService.now(), chat.getTo(), 1)
        .then((messages) {
      return messages.isEmpty ? null : messages.last;
    }).catchError((error) => throw error);
  }

  Stream<int> notifier(User user, DateTime dateTime) {
    NotifierController nc = NotifierController(user.id, count: 0);

    repositorie.getMessagesAfter(user.id, dateTime, null).then((data) {
      nc.count = data.length;
    });
    repositorie.message(user.id).listen((message) => nc.onMessage(message));
    return nc.stream;
  }
}

class NotifierController {
  int _count = 0;
  String user;
  StreamController<int> streamController = new StreamController<int>();

  set count(int count) {
    this._count = count;
    streamController.add(this._count);
  }

  NotifierController(this.user, {count: int}) {
    this._count = count;
    if (this._count > 0) {
      streamController.add(this._count);
    }
  }

  void onMessage(Message message) {
    if (message.to == user) {
      _count++;
      streamController.add(_count);
    } else if (message.from == user) {
      _count = 0;
      streamController.add(_count);
    }
  }

  Stream<int> get stream {
    return streamController.stream.asBroadcastStream();
  }
}
