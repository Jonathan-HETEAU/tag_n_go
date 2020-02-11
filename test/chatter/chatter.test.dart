import 'package:flutter_test/flutter_test.dart';
import 'package:tag_n_go/features/chatter/domain/entities/chat.dart';
import 'package:tag_n_go/features/chatter/domain/entities/contact.dart';
import 'package:tag_n_go/features/chatter/domain/entities/user.dart';
import 'package:tag_n_go/features/chatter/domain/usecases/messenger.dart';

import 'fake/repositories/message.dart';
import 'fake/services/date.dart';

void main() {
  group("Chatter", () {
    test("Un chat à un utilisateur et un contact", () {
      expect(
          () =>
              Messenger(new MessageRepositorieImpl(), new DateTimeServiceImpl())
                  .open(null, Contact("contact")),
          throwsException);
      expect(
          () =>
              Messenger(new MessageRepositorieImpl(), new DateTimeServiceImpl())
                  .open(User("user"), null),
          throwsException);
      expect(
          Messenger(new MessageRepositorieImpl(), new DateTimeServiceImpl())
              .open(User("user"), Contact("contact")),
          isNotNull);
    });
    test("Les Utilisateur d'un chat échange un message", () async {
      DateTimeServiceImpl dateTimeServiceImpl = new DateTimeServiceImpl();
      Messenger messenger =
          Messenger(new MessageRepositorieImpl(), dateTimeServiceImpl);
      String jonathan = "Jonathan";
      String olivia = "Olivia";
      Chat chat1 = messenger.open(User(olivia), Contact(jonathan));
      Chat chat2 = messenger.open(User(jonathan), Contact(olivia));
      String msg = "Coucou !";
      dateTimeServiceImpl.setNow(DateTime.parse('2020-01-01 00:00:00.000'));
      messenger.send(chat1, msg);
      dateTimeServiceImpl.setNow(DateTime.parse('2020-01-02 00:00:00.000'));
      var lastMsg1 = await messenger.lastMessage(chat1);
      var lastMsg2 = await messenger.lastMessage(chat2);
      expect(lastMsg1.content, equals(msg));
      expect(lastMsg2.content, equals(msg));
    });
    test("Les messages ont une heure et un jour d'envoie", () async {
      DateTimeServiceImpl dateTimeServiceImpl = new DateTimeServiceImpl();
      DateTime testDateTime = DateTime.parse('2020-01-01 00:00:00.000');
      dateTimeServiceImpl.setNow(testDateTime);
      Messenger messenger =
          Messenger(new MessageRepositorieImpl(), dateTimeServiceImpl);
      Chat chat = messenger.open(User("olivia"), Contact("jonathan"));
      messenger.send(chat, "Coucou!");
      dateTimeServiceImpl.setNow(DateTime.parse('2020-01-01 00:00:01.000'));
      var message = await messenger.lastMessage(chat);
      expect(message.dateTime, equals(testDateTime));
    });
    test("Le chatter à un notificateur des messages non lu", () async {
      DateTimeServiceImpl dtsi = new DateTimeServiceImpl();
      Messenger messenger = Messenger(new MessageRepositorieImpl(), dtsi);
      Function notification = (Stream<int> stream) async {
        await for (var value in stream) {
          return value;
        }
      };
      Chat chat = messenger.open(User("olivia"), Contact("jonathan"));
      dtsi.setNow(DateTime.parse('2020-01-01 00:00:00.000'));
      messenger.send(chat, "msg0");
      dtsi.setNow(DateTime.parse('2020-01-02 00:00:00.000'));
      messenger.send(chat, "msg1");
      dtsi.setNow(DateTime.parse('2020-01-03 00:00:00.000'));
      messenger.send(chat, "msg2");
      dtsi.setNow(DateTime.parse('2020-01-04 00:00:00.000'));
      messenger.send(chat, "msg3");
      var stream = messenger.notifier(
          User("jonathan"), DateTime.parse('2020-01-01 23:59:00.000'));
      int notificationDeMessageNonLut = await notification(stream);
      expect(notificationDeMessageNonLut, equals(3));
      dtsi.setNow(DateTime.parse('2020-01-04 00:00:30.000'));
      messenger.send(chat, "Last message");
      notificationDeMessageNonLut = await notification(stream);
      expect(notificationDeMessageNonLut, equals(4));
    });
  });
}
