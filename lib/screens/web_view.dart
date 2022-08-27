import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({Key? key}) : super(key: key);

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0xFF191970),
        title: const Text('SlIMS'),
        centerTitle: true,
      ),
      body: const WebView(
        initialUrl: 'http://cslims.com/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
