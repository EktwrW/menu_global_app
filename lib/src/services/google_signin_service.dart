import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  static Future<GoogleSignInAccount> signInWithGoogle() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      final googleKey = await account.authentication;
      //
      print(account);
      print('===== ID TOKEN =====');
      print(googleKey.idToken);

      return account;
    } catch (e) {
      print('Error Google signin');
      print(e);

      return null;
    }
  }

  static Future signOut() async {
    await _googleSignIn.signOut();
  }
}
