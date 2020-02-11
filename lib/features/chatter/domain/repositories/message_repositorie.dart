import 'package:tag_n_go/features/chatter/domain/entities/message.dart';

abstract class MessageRepositorie {
  void save(Message message);
  Stream<Message> message(String user);
  Future<List<Message>> getMessagesAfter(
      String user, DateTime dateTime, String contact);
  Future<List<Message>> getMessagesBefore(
      String user, DateTime datetime, String contact, int take);
}
