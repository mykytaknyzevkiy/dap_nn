import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'models/UserModel.dart';
import 'unit/MyConst.dart';
import 'unit/Requester.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

UserModel? myUserModel;

Future<bool> signInWithGoogle() async {
  /*final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final token = (await googleSignInAccount.authentication).idToken;

  //final AuthResult authResult = await _auth.signInWithCredential(credential);
  User? user = ( await _auth.signInWithCredential(credential)).user;

  if (user == null) {
    return false;
  }

  final data = await Requester().create<UserModel>(
      '/users/login/google',
      <String, String>{
        'token': token,
        'id': user.uid,
        'name': user.displayName!,
        'email': user.email!
      },
      'user',
          (data) => UserModel.fromJson(data)
  );

  if (data == null) {
    return false;
  }

  if (data.success) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(MyConst.user_id_key, data.data?.id);
    await prefs.setString(MyConst.user_token_key, data.data?.token);
    myUserModel = data.data;
  }

  return data.success;*/

  return true;
}

Future<bool> signInFacebook() async {
  return false;
  /*final result = await FacebookSdk.logInWithReadPermissions(['email']);
  final token = result.accessToken.token;
  final graphResponse = await http.get(
      'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
  final profile = json.decode(graphResponse.body);

  final name = profile['name'];
  final email = profile['email'];
  final id = profile['id'];

  final data = await Requester().create<UserModel>(
      '/users/login/fb',
      <String, String>{
        'token': token,
        'id': id,
        'name': name,
        'email': email
      },
      'user',
          (data) => UserModel.fromJson(data)
  );

  if (data == null) {
    return false;
  }

  if (data.success) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(MyConst.user_id_key, data.data.id);
    await prefs.setString(MyConst.user_token_key, data.data.token);
    myUserModel = data.data;
  }

  return data.success;*/
}

void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}

Future<bool> signUp(String email, String pass) async {
  final data = await Requester().create<String>(
      '/users/register',
      <String, String>{
        'email': email,
        'password': pass
      },
      '_id',
          (data) => data
  );

  if (data.data == null) {
    return false;
  }

  if (data.success) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(MyConst.user_id_key, data.data);
  }
  return data.success;
}

Future<bool> signIn(String email, String pass) async {
  final data = await Requester().create<UserModel>(
      '/users/login',
      <String, String>{
        'email': email,
        'password': pass
      },
      "user",
          (data) => UserModel.fromJson(data)
  );

  if (data.data == null) {
    return false;
  }

  if (data.success) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(MyConst.user_id_key, data.data?.id);
    await prefs.setString(MyConst.user_token_key, data.data?.token);
    await prefs.setString(MyConst.user_email_key, email);
    await prefs.setString(MyConst.user_passsword_key, pass);
    myUserModel = data.data;
  }

  return data.success;
}

Future<bool> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString(MyConst.user_id_key) == null || prefs.getString(MyConst.user_token_key) == null) {
    return false;
  }

  final data = await Requester().get<UserModel>(
      '/users/me',
      <String, String>{
      },
      "user",
          (data) => UserModel.fromJson(data)
  );

  if (data.data == null) {
    return false;
  }

  if (data.success) {
    myUserModel = data.data;
    myUserModel?.token = prefs.getString(MyConst.user_token_key);
  }

  return data.success;
}

logOut() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString(MyConst.user_id_key, null);
  await prefs.setString(MyConst.user_token_key, null);
  await prefs.setString(MyConst.user_email_key, null);
  await prefs.setString(MyConst.user_passsword_key, null);

}