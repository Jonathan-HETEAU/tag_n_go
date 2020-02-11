import 'package:tag_n_go/features/profiler/domain/entities/message.dart';
import 'package:tag_n_go/features/profiler/domain/entities/profil.dart';
import 'package:tag_n_go/features/profiler/domain/repositories/profil_repositorie.dart';
import 'package:tag_n_go/features/profiler/domain/service/date.dart';

class Profiler {
  ProfilRepositorie profilRepositorie;
  DateService dateService;

  Profiler(this.profilRepositorie, this.dateService);

  Profil get me => profilRepositorie.getMyProfil();

  Stream<List<Profil>> get subscriptions =>
      profilRepositorie.getMySubscriptions();

  Stream<List<PepMessage>> get pepMessages =>
      profilRepositorie.getPepMessagesFrom(dateService.today);

  Profil changePseudo(String pseudo) {
    Profil monProfil = this.me;
    Profil nouveauProfil = ProfilImpl(monProfil.id, pseudo, monProfil.image);
    profilRepositorie.save(nouveauProfil);
    return nouveauProfil;
  }

  Profil getProfil(String pseudo) {
    return profilRepositorie.getProfilByPseudo(pseudo);
  }

  Profil changeImage(String image) {
    Profil monProfil = this.me;
    Profil nouveauProfil = ProfilImpl(monProfil.id, monProfil.pseudo, image);
    profilRepositorie.save(nouveauProfil);
    return nouveauProfil;
  }

  void follow(Profil profil) {
    profilRepositorie.addSubscription(profil);
  }

  void stopFollow(Profil profil) {
    profilRepositorie.removeSubscription(profil);
  }

  PepMessage writePepMessage(String hashtag, String message) {
    PepMessage pepMessage =
        PepMessageImpl(me, hashtag, message, dateService.now);
    profilRepositorie.addPepMessage(pepMessage);
    return pepMessage;
  }

  void removePepMessage(String hashtag) {
    profilRepositorie
        .removePepMessage(PepMessageImpl(me, hashtag, "", dateService.now));
  }

  Stream<List<PepMessage>> getSubscreptionPepMessages() =>
      profilRepositorie.getSubscreptionPepMessagesFrom(dateService.today);
}
