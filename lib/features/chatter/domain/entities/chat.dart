import 'package:tag_n_go/features/chatter/domain/entities/contact.dart';
import 'package:tag_n_go/features/chatter/domain/entities/user.dart';

class Chat {
  User user;
  Contact contact;
 
  Chat(this.user, this.contact);

  String getFrom() {
    return user.id;
  }

  String getTo() {
    return contact.id;
  }
}
