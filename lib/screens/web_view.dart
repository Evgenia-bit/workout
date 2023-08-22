import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MainView extends StatefulWidget {
  String r;

  MainView({Key? key, required this.r}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late InAppWebViewController _webViewController;
  double progress = 0;

  Future<bool> onBackPressed() async {
    _webViewController.goBack();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          shadowColor: Colors.black.withOpacity(0.5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => onBackPressed(),
          ),
        ),
        body: WillPopScope(
          onWillPop: onBackPressed,
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(widget.r)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    javaScriptCanOpenWindowsAutomatically: true,
                  ),
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onLoadError: (controller, url, code, message) {
                  controller.loadData(data: """
                      <html>
                        <body>
                         <div style='font-size: 30; padding: 30;'>
                           <h1 style='text-align: center;'>A network connection is required to continue</h1>
                         </div>
                        </body>
                      </html>
                  """);
                },
              ),
              progress < 1.0
                  ? Center(
                      child: CircularProgressIndicator(
                      value: progress,
                      color: const Color.fromARGB(255, 54, 244, 177),
                      strokeWidth: 2,
                    ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
