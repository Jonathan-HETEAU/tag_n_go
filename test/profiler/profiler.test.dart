import 'package:flutter_test/flutter_test.dart';
import 'package:tag_n_go/features/profiler/domain/entities/message.dart';
import 'package:tag_n_go/features/profiler/domain/entities/profil.dart';
import 'package:tag_n_go/features/profiler/domain/usecases/profiler.dart';

import 'fake/repositories/profil.dart';
import 'fake/services/date.dart';

main() {
  group("Profile", () {
    group("Pseudo", () {
      test("Change Pseudo", () {
        Profiler profiler = initProfiler(ProfilImpl("1", "pseudo1", "image2"));
        Profil profil = profiler.me;
        expect(profil.pseudo, equals("pseudo1"));
        Profil changedProfil = profiler.changePseudo("newPseudo");
        expect(changedProfil.pseudo, equals("newPseudo"));
        expect(profil.id.compareTo(changedProfil.id) == 0, isTrue);
      });
      test("Find Profile by Pseudo", () {
        Profiler profiler = initProfiler(ProfilImpl("1", "pseudo1", "image2"));
        Profil userProfil = profiler.me;
        Profil searchProfil = profiler.getProfil(userProfil.pseudo);
        expect(searchProfil.id.compareTo(userProfil.id) == 0, isTrue);
        searchProfil = profiler.getProfil("autrePseudo");
        expect(searchProfil.id.compareTo(userProfil.id) == 0, isFalse);
        expect(searchProfil.pseudo.compareTo("autrePseudo") == 0, isTrue);
      });
    });
    group("Photo", () {
      test("Change image Profile", () {
        Profiler profiler = initProfiler(ProfilImpl("1", "pseudo1", "image2"));
        Profil changedProfil = profiler.changeImage("imageUri");
        expect(changedProfil.image.compareTo(profiler.me.image) == 0, isTrue);
      });
      group("Abonnements", () {
        test("Ajouter/Supprimmer abonnements", () async {
          Profiler profiler =
              initProfiler(ProfilImpl("1", "pseudo1", "image2"));
          Profil profil = ProfilImpl("id", "pseudo", "image");
          profiler.follow(profil);
          profiler.follow(profiler.me);
          profiler.follow(ProfilImpl("id2", "pseudo2", "image2"));
          profiler.follow(ProfilImpl("id3", "pseudo3", "image3"));
          Stream<List<Profil>> stream = profiler.subscriptions;

          List<Profil> abonnements = await streamListener(stream.skip(2));

          expect(abonnements.length, equals(3));
          expect(abonnements.first.id.compareTo(profil.id) == 0, isTrue);

          profiler.stopFollow(profil);
          abonnements = await streamListener(stream);
          expect(abonnements.length, equals(2));
          expect(abonnements.last.id.compareTo(profil.id) == 0, isFalse);
        });
        group("Message d'encouragement", () {
          test("Ecrire/Suprimmer/Modifier", () async {
            Profiler profiler =
                initProfiler(ProfilImpl("1", "pseudo1", "image2"));
            PepMessage message =
                profiler.writePepMessage("tag", "message d'encouragement");
            Stream<List<PepMessage>> stream = profiler.pepMessages;
            List<PepMessage> messages = await streamListener(stream);
            expect(messages.length, equals(1));
            expect(messages.last.compareTo(message) == 0, isTrue);
            profiler.removePepMessage("tag");
            messages = await streamListener(stream);
            expect(messages.length, equals(0));
          });

          test("Recevoir les messages d'encouragement", () async {
            Profil profil1 = ProfilImpl("1", "pseudo1", "image2");
            Profil profil2 = ProfilImpl("2", "pseudo2", "image2");

            Profiler profiler1 = initProfiler(profil1);
            Profiler profiler2 = initProfiler(profil2);

            profiler1.writePepMessage('hashtag', 'mes message');
            profiler2.follow(profil1);

            Stream<List<PepMessage>> stream =
                profiler2.getSubscreptionPepMessages();
            List<PepMessage> messages = await streamListener(stream);
            expect(messages.length, equals(1));
            expect(messages.last.author.compareTo(profil1) == 0, isTrue);
            profiler1.writePepMessage("hashtag", "J'ai changer!!");
            messages = await streamListener(stream);
            expect(messages.length, equals(1));
            expect(messages.last.author.compareTo(profil1) == 0, isTrue);
          });
        });
      });
      group("Image contrainte", () {
        test("Taille", () {});
        test("Poid", () {});
        test("Format", () {});
      });
    });
    group("Liens", () {
      test("Ajouter", () {});
      test("Suprimer", () {});
      test("Limit", () {});
      test("Reseaux Sociaux", () {});
      test("Site perso", () {});
      test("Site patenaire", () {});
    });
  });
}

Function initProfiler = (Profil me) {
  return Profiler(
      ProfilRepositorieImpl.createInstance(me),
      DateServiceImpl(
          DateTime.parse('2020-01-04 13:27:00'), DateTime.parse('2020-01-04')));
};

Function streamListener = (stream) async {
  await for (var value in stream) {
    return value;
  }
};
