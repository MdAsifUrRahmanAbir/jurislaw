import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/utility/custom_alert_dialog.dart';
import '../../data/models/payment_models.dart';

class PaymentGatewayArgs {
  final PaymentSession session;
  final String bookingId;

  const PaymentGatewayArgs({required this.session, required this.bookingId});
}

/// SSLCommerz hosted page in a web view. Pops `true` as soon as the page
/// reaches one of the API's `return_urls` (success, fail or cancel — the
/// status screen finds out which), `false` if the user backs out.
class PaymentGatewayScreen extends StatefulWidget {
  final PaymentGatewayArgs args;

  const PaymentGatewayScreen({super.key, required this.args});

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => mounted ? setState(() => _progress = progress) : null,
          onNavigationRequest: (request) {
            if (_isReturnUrl(request.url)) {
              _finish(true);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
            if (_isReturnUrl(url)) _finish(true);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.args.session.gatewayUrl));
  }

  bool _isReturnUrl(String url) {
    final returnUrls = widget.args.session.returnUrls;
    if (returnUrls.isNotEmpty) {
      return returnUrls.any((r) => r.isNotEmpty && url.startsWith(r));
    }
    // No return URLs sent: treat landing back on our own backend as done.
    final apiHost = Uri.parse(ApiEndpoints.baseUrl).host;
    return Uri.tryParse(url)?.host == apiHost;
  }

  void _finish(bool returned) {
    if (_finished || !mounted) return;
    _finished = true;
    Navigator.of(context).pop(returned);
  }

  Future<void> _confirmLeave() async {
    final leave = await CustomAlertDialog.confirm(
      context,
      title: 'Leave payment?',
      message: 'If you already paid, we will still confirm it on the next screen.',
      confirmText: 'Leave',
      cancelText: 'Stay',
    );
    if (leave == true) _finish(false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(title: 'Secure Payment', onBackTap: _confirmLeave),
              if (_progress < 100)
                LinearProgressIndicator(value: _progress / 100, color: AppColors.primary, minHeight: 2),
              Expanded(child: WebViewWidget(controller: _controller)),
            ],
          ),
        ),
      ),
    );
  }
}
