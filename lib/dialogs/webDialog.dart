import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webViewDialog extends StatefulWidget {
  const webViewDialog({required this.url, Key? key}) : super(key: key);
  final String url;
  @override
  State<webViewDialog> createState() => _webViewDialogState();
}

class _webViewDialogState extends State<webViewDialog> {

  double diaHeight = 300;
  bool lottieVis = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius
                .all(Radius.circular(15))
        ),
        child: AnimatedContainer(
          height: diaHeight,
          width: MediaQuery.of(context).size.width * 0.8,
          duration: Duration(milliseconds: 100),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Stack(
                children: [
                  Visibility(
                    visible: true,
                    child: WebView(
                      initialUrl: widget.url,
                      javascriptMode: JavascriptMode.unrestricted,

                      onProgress: (value){
                        if(value == 70){
                          print("expanding");
                          setState((){
                            lottieVis = false;
                            diaHeight = 600;
                          });
                        }
                      },

                      onPageFinished: (finish){
                        print("loaded");
                        setState((){
                          lottieVis = false;
                          diaHeight = 600;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: Visibility(
                      visible: lottieVis,
                      child: LottieBuilder.asset(
                          "assets/lottie/loader.json",
                        width: 250,
                        height: 250,
                      ),
                    ),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}
