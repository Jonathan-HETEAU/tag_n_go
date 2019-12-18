import 'package:firebase_auth/firebase_auth.dart';
import 'package:tag_n_go/models/tag.dart';
import 'package:tag_n_go/models/user.dart';
import 'package:tag_n_go/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebasUser(FirebaseUser user) {
    return user != null
        ? User(
            uid: user.uid,
            tagsCollection: DatabaseService()
                .instance
                .collection('Taggers/${user.uid}/Tags'),
            historyCollection: DatabaseService()
                .instance
                .collection('Taggers/${user.uid}/History'))
        : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebasUser);
  }

  // sign in anonym
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebasUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in  email && password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebasUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register email && password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = _userFromFirebasUser(result.user);
      await user.updateTag(Tag(
        name: "MyFisrtHashTag",
        activated: true,
        days: [true, true, true, true, true, true, true],
      ));
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
