abstract class Profil implements Comparable<Profil> {
  String get id;
  String get pseudo;
  String get image;
}

class ProfilImpl implements Profil {
  String id;
  String pseudo;
  String image;

  ProfilImpl(this.id, this.pseudo, this.image);

  @override
  int compareTo(Profil other) {
    return id.compareTo(other.id);
  }
}
