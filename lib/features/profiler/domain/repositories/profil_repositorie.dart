import 'package:tag_n_go/features/profiler/domain/entities/message.dart';
import 'package:tag_n_go/features/profiler/domain/entities/profil.dart';

abstract class ProfilRepositorie {
  save(Profil me);
  Profil getMyProfil();
  Profil getProfilByPseudo(String pseudo);

  void addSubscription(Profil profil);

  Stream<List<Profil>> getMySubscriptions();

  void removeSubscription(Profil profil);

  Stream<List<PepMessage>> getPepMessagesFrom(DateTime today) {}

  void addPepMessage(PepMessage pepMessage) {}

  void removePepMessage(PepMessageImpl pepMessageImpl) {}

  Stream<List<PepMessage>> getSubscreptionPepMessagesFrom(DateTime today) {}
}
