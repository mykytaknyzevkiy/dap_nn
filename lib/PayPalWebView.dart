import 'dart:async';
import 'package:dap_app_new/blocs/global.dart';
import 'package:dap_app_new/unit/Config.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPalWebView extends StatefulWidget {

  final String url;
  final String trackID;
  final GlobalBloc globalBloc;

  const PayPalWebView(this.url, this.trackID, this.globalBloc);

  @override
  State<StatefulWidget> createState() => PayPalWebViewState(url, trackID, globalBloc);
}

class PayPalWebViewState extends State<PayPalWebView> {

  final String url;
  final String trackID;
  final GlobalBloc globalBloc;

  PayPalWebViewState(this.url, this.trackID, this.globalBloc);

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    /*WebView
    final webC = WebView;

    webC.onUrlChanged.listen((url)  {

      print('Page finished loading: $url');

      if (url == Config.apiUrl + '/api/success') {

        globalBloc.musicControllerBloc.userTrackIds.value.add(trackID);

        Navigator.pop(context);

      }

    });

    final web =  WebviewScaffold(
      url: url,
      webviewReference: webC,
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color(0xFF2F80ED),
      ),
    );


    return web;*/
    return Container();
  }
}
