import 'dart:async';
import 'package:tag_n_go/features/profiler/domain/entities/message.dart';
import 'package:tag_n_go/features/profiler/domain/entities/profil.dart';
import 'package:tag_n_go/features/profiler/domain/repositories/profil_repositorie.dart';

class ProfilRepositorieImpl implements ProfilRepositorie {
  static ProfilRepositorie createInstance(Profil me) {
    if (_repositories.containsKey(me.id)) {
      return _repositories[me.id];
    } else {
      ProfilRepositorie repositorie = ProfilRepositorieImpl._(me);
      _repositories.addEntries(
          [MapEntry<String, ProfilRepositorie>(me.id, repositorie)]);
      return repositorie;
    }
  }

  static Map<String, ProfilRepositorie> _repositories =
      Map<String, ProfilRepositorie>();

  Profil me;
  List<Profil> subscriptions = List<Profil>();
  List<PepMessage> messages = List<PepMessage>();
  Map<String, List<PepMessage>> pepSubscriptions =
      Map<String, List<PepMessage>>();

  StreamController<List<PepMessage>> pepSubscriptionMessageController =
      StreamController<List<PepMessage>>();

  Stream<List<PepMessage>> streamPepSubscriptionMessageController;

  StreamController<List<Profil>> subscriptionsController =
      StreamController<List<Profil>>();

  Stream<List<Profil>> streamsubscriptionsController;

  StreamController<List<PepMessage>> pepMessageController =
      StreamController<List<PepMessage>>();

  Stream<List<PepMessage>> streampepMessageController;

  ProfilRepositorieImpl._(this.me) {
    streampepMessageController =
        pepMessageController.stream.asBroadcastStream();
    streamPepSubscriptionMessageController =
        pepSubscriptionMessageController.stream.asBroadcastStream();
    streamsubscriptionsController =
        subscriptionsController.stream.asBroadcastStream();
  }

  @override
  Profil getMyProfil() {
    return me;
  }

  @override
  save(Profil me) {
    if (this.me.id.compareTo(me.id) == 0) {
      this.me = ProfilImpl(this.me.id, me.pseudo, me.image);
    }
  }

  @override
  Profil getProfilByPseudo(String pseudo) {
    return pseudo.compareTo(me.pseudo) == 0
        ? me
        : ProfilImpl("ID-$pseudo", pseudo, "${pseudo.trim()}.jpeg");
  }

  @override
  void addSubscription(Profil profil) {
    if (profil.id.compareTo(me.id) == 0) return;
    if (subscriptions
            .where((subscription) => subscription.id.compareTo(profil.id) == 0)
            .length ==
        0) {
      subscriptions.add(profil);
      if (!subscriptionsController.isClosed) {
        subscriptionsController.add(subscriptions);
      }
    }
  }

  @override
  Stream<List<Profil>> getMySubscriptions() {
    return streamsubscriptionsController;
  }

  @override
  void removeSubscription(Profil profil) {
    subscriptions = subscriptions
        .where((subscription) => subscription.id.compareTo(profil.id) != 0)
        .toList();
    subscriptionsController.add(subscriptions);
  }

  @override
  Stream<List<PepMessage>> getPepMessagesFrom(DateTime today) {
    return streampepMessageController;
  }

  @override
  void addPepMessage(PepMessage pepMessage) {
    messages.removeWhere((pep) => pep.compareTo(pepMessage) == 0);
    messages.add(pepMessage);
    pepMessageController.add(messages);
  }
  

  @override
  void removePepMessage(PepMessage pepMessage) {
    messages.removeWhere((pep) => pep.compareTo(pepMessage) == 0);
    pepMessageController.add(messages);
  }

  @override
  Stream<List<PepMessage>> getSubscreptionPepMessagesFrom(DateTime today) {
    subscriptions.forEach((profil) {
      _repositories[profil.id]?.getPepMessagesFrom(today).listen((messages) {
        pepSubscriptions.addEntries([MapEntry(profil.id, messages)]);
        pepSubscriptionMessageController
            .add(pepSubscriptions.values.expand((i) => i).toList());
      });
    });
    return streamPepSubscriptionMessageController;
  }
}
