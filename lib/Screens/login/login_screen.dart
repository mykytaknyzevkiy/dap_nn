import 'package:dap_app_new/MyLocalizations.dart';
import 'package:dap_app_new/Screens/root.dart';
import 'package:dap_app_new/sign_in.dart';
import 'package:dap_app_new/ui/Commands.dart';
import 'package:flutter/material.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _passwordReplayController = TextEditingController();
bool isLoading = false;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: PageView(
          controller: _controller,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[LoginPage(), HomePage(), SignupPage()],
        )
    );
  }

  Widget HomePage() {
    final translater =  AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 210.0, bottom: 40.0),
              child: const Center(
                child: Icon(
                  Icons.headset_mic,
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "Heatly",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    "Waves",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 150.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => gotoSignup(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                translater.translate('sign_up'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: const Color(0xFF2F80ED),
                      onPressed: () => gotoLogin(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                translater.translate("login_in"),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget LoginPage() {
    final translater =  AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 80.0, bottom: 40.0),
              child: const Center(
                child: Icon(
                  Icons.headset_mic,
                  color: Color(0xFF2F80ED),
                  size: 50.0,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      translater.translate("email"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F80ED),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color(0xFF2F80ED),
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextField(
                      controller: _emailController,
                      obscureText: false,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'youremail@gmail.com',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 24.0,
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      translater.translate("password"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F80ED),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color(0xFF2F80ED),
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '*********',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 24.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: new MaterialButton(
                    child: new Text(
                      translater.translate("forgot_password"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F80ED),
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () => {},
                  ),
                ),
              ],
            ),
            (isLoading) ? loadWidget() : new Column(
              children: <Widget>[
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new MaterialButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          color: Color(0xFF2F80ED),
                          onPressed: () => {
                            doSignIn(_emailController.text,
                                _passwordController.text)
                          },
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 20.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Text(
                                    translater.translate("login"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.all(8.0),
                          decoration:
                          BoxDecoration(border: Border.all(width: 0.25)),
                        ),
                      ),
                      Text(
                        translater.translate("or_connect_with"),
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.all(8.0),
                          decoration:
                          BoxDecoration(border: Border.all(width: 0.25)),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.only(right: 8.0),
                          alignment: Alignment.center,
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new MaterialButton(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0),
                                  ),
                                  color: Color(0Xff3B5998),
                                  onPressed: () => {
                                  },
                                  child: new Container(
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                          child: new MaterialButton(
                                            onPressed: () => {
                                              doSignInFb()
                                            },
                                            padding: EdgeInsets.only(
                                              top: 20.0,
                                              bottom: 20.0,
                                            ),
                                            child: new Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Icon(
                                                  const IconData(0xea90,
                                                      fontFamily: 'icomoon'),
                                                  color: Colors.white,
                                                  size: 15.0,
                                                ),
                                                Text(
                                                  "FACEBOOK",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.only(left: 8.0),
                          alignment: Alignment.center,
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new MaterialButton(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(30.0),
                                  ),
                                  color: Color(0Xffdb3236),
                                  onPressed: () => {},
                                  child: new Container(
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                            child: new MaterialButton(
                                              onPressed: () {
                                                doSignInGoogle();
                                              },
                                              padding: EdgeInsets.only(
                                                top: 20.0,
                                                bottom: 20.0,
                                              ),
                                              child: new Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Icon(
                                                    const IconData(0xea88,
                                                        fontFamily: 'icomoon'),
                                                    color: Colors.white,
                                                    size: 15.0,
                                                  ),
                                                  Text(
                                                    "GOOGLE",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              )],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget SignupPage() {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20.0),
      child: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 40.0, top: 80.0),
              child: Center(
                child: Icon(
                  Icons.headset_mic,
                  color: Color(0xFF2F80ED),
                  size: 50.0,
                ),
              ),
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      "EMAIL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F80ED),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color(0xFF2F80ED),
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      obscureText: false,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'youremail@gmail.com',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 24.0,
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      "PASSWORD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F80ED),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color(0xFF2F80ED),
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '*********',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 24.0,
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      "CONFIRM PASSWORD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F80ED),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color(0xFF2F80ED),
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextField(
                      controller: _passwordReplayController,
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '*********',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 24.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: new MaterialButton(
                    child: new Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F80ED),
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () => {_controller.jumpToPage(0)},
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: isLoading
                        ? loadWidget()
                        : new MaterialButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            color: Color(0xFF2F80ED),
                            onPressed: () => doSignUp(
                                _emailController.text,
                                _passwordController.text,
                                _passwordReplayController.text),
                            child: new Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 20.0,
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(
                                    child: Text(
                                      "SIGN UP",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  // ignore: missing_return
  Future doSignUp(
      String email, String password, String passConfig) async {
    if (password != passConfig) {
      Scaffold.of(context);
      return null;
    }

    setState(() {
      isLoading = true;
    });

    final success = await signUp(email, password);

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return gotoSignup();
          },
        ),
      );
    } else {
      Scaffold.of(context);
    }
  }

  Future doSignIn(String email, String password) async {
    setState(() {
      isLoading = true;
    });

    final success = await signIn(email, password);

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return DosPlayerApp();
          },
        ),
      );
    } else {
      Scaffold.of(context);
    }
  }

  Future doSignInGoogle() async {
    setState(() {
      isLoading = true;
    });

    final success = await signInWithGoogle();

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return DosPlayerApp();
          },
        ),
      );
    } else {
      Scaffold.of(context);
    }
  }

  Future doSignInFb() async {
    setState(() {
      isLoading = true;
    });

    final success = await signInFacebook();

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return DosPlayerApp();
          },
        ),
      );
    } else {
      Scaffold.of(context);
    }
  }

}
