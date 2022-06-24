import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class WebViewPage extends StatefulWidget {
  WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = FutureBuilder(builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      return createWebView();
    });
    return scaffold;
  }

  Widget createWebView() {
    var webView = WebView(
        initialUrl: "file:/Users/lion/Documents/flutter_webview_injection_js_test_demo/demo/assets/html/index.html",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },
        navigationDelegate: (NavigationRequest request) {
          print('navigationDelegate');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page onPageStarted');
          // _injectionJS();
        },
        onPageFinished: (String url) {
          print('Page finished');
          _injectionJS();
        },
        onWebResourceError: (WebResourceError error) {
          print('Page onWebResourceError: ${error.description}');
        },
        gestureNavigationEnabled: true,
        backgroundColor: Colors.white);
    var scaffold = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("demo", style: TextStyle(color: Colors.black)),
      ),
      body: webView,
    );
    return scaffold;
  }

  _loadHtmlFromAssets() async {
    _webViewController.loadFlutterAsset("assets/html/index.html");
  }

  _injectionJS() {
    var js = "if(!window.myMessage)window.myMessage='321';";
    _webViewController.runJavascript(js);
  }
}
