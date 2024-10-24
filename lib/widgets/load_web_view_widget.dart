import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'index_widgets.dart';

const host = 'truckservice247.com';

class LoadWebViewWidget extends StatefulWidget {
  const LoadWebViewWidget({super.key});

  @override
  State<LoadWebViewWidget> createState() => _LoadWebViewWidgetState();
}

class _LoadWebViewWidgetState extends State<LoadWebViewWidget> {
  late final WebViewController webController;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    final uri = Uri(scheme: 'https', host: host);
    late final PlatformWebViewControllerCreationParams params;
    params = WebViewPlatform.instance is WebKitWebViewPlatform
        ? WebKitWebViewControllerCreationParams(
            allowsInlineMediaPlayback: true,
            mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
          )
        : AndroidWebViewControllerCreationParams();

    webController = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (request) => request.grant(),
    );

    if (webController.platform is AndroidWebViewController) {
      (webController.platform as AndroidWebViewController)
          .setOnPlatformPermissionRequest((request) => request.grant());
    }

    webController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webController.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          loadingPercentage = 0;
          setState(() {});
        },
        onProgress: (progress) {
          loadingPercentage = progress;
          setState(() {});
        },
        onPageFinished: (url) {
          loadingPercentage = 100;
          setState(() {});
        },
        onUrlChange: (url) {
          if (!url.url!.contains(host)) {
            Navigator.of(context).pop();
          }
        },
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(host)) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
    webController.loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (loadingPercentage < 100) ...[
          LoadingWidget(value: loadingPercentage),
        ],
        if (loadingPercentage == 100) ...[
          WebViewWidget(controller: webController),
        ],
      ],
    );
  }
}
