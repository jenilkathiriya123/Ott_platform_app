import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class amazon extends StatefulWidget {
  const amazon({Key? key}) : super(key: key);

  @override
  State<amazon> createState() => _amazonState();
}

class _amazonState extends State<amazon> {
  InAppWebViewController? inAppWebViewController;
  late PullToRefreshController pullToRefreshController;
  List allUri = [];

  @override
  void initState() {
    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(color: Colors.blue),
        onRefresh: () async {
          await inAppWebViewController?.reload();
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: Text("Amazon Prime")),
        actions: [
          IconButton(
            onPressed: () async {
              await inAppWebViewController?.loadUrl(
                  urlRequest: URLRequest(
                      url: Uri.parse("https://www.primevideo.com/?ref_=dvm_pds_amz_in_as_s_gm_159_mkw_sRumWk2Nj-dc&mrntrk=pcrid_610141119732_slid__pgrid_84577172328_pgeo_9062199_x__adext__ptid_kwd-303629226711&gclid=Cj0KCQiAw8OeBhCeARIsAGxWtUzcXluwLjdpWFZBSiPXzRY9eoDO2qADCJn3Ca498qnZNcadNV-67TYaAq6uEALw_wcB")));
            },
            icon: Icon(Icons.home),
          ),
          IconButton(
            onPressed: () async {
              await inAppWebViewController?.goBack();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: () async {
              await inAppWebViewController?.reload();
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              await inAppWebViewController?.goForward();
            },
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://www.primevideo.com/?ref_=dvm_pds_amz_in_as_s_gm_159_mkw_sRumWk2Nj-dc&mrntrk=pcrid_610141119732_slid__pgrid_84577172328_pgeo_9062199_x__adext__ptid_kwd-303629226711&gclid=Cj0KCQiAw8OeBhCeARIsAGxWtUzcXluwLjdpWFZBSiPXzRY9eoDO2qADCJn3Ca498qnZNcadNV-67TYaAq6uEALw_wcB")),
        onWebViewCreated: (controller) {
          setState(() {
            inAppWebViewController = controller;
          });
        },
        pullToRefreshController: pullToRefreshController,
        onLoadStop: (controller, url) async {
          await pullToRefreshController.endRefreshing();
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              Uri? uri = await inAppWebViewController?.getUrl();

              String url = uri.toString();
              allUri.add(url);
            },
            child: Icon(Icons.bookmark_added_outlined),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  scrollable: true,
                  title: Center(
                    child: Text("All-URL"),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: allUri
                        .map(
                          (e) => GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              await inAppWebViewController?.loadUrl(
                                urlRequest: URLRequest(
                                  url: Uri.parse(e),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Text("${allUri.indexOf(e) + 1}.$e"),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
            child: Icon(Icons.bookmark),
          )
        ],
      ),
    );
  }
}
