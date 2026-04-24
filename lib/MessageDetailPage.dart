import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'AdManager/ad_helper.dart';
import 'data/Messages.dart';
import 'data/Strings.dart';
import 'utils/SizeConfig.dart';
import 'utils/pass_data_between_screens.dart';

/*
how to pass data into another screen watch this video
https://www.youtube.com/watch?v=d5PpeNb-dOY
 */
class MessageDetailPage extends StatefulWidget {
  MessageDetailPage({super.key});
  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  
  late String type;
  late int defaultIndex;
  var data = [];

  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    loadBannerAd().load();
  }

  BannerAd loadBannerAd() {
    return BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PassDataBetweenScreens;
    type = args.title;
    defaultIndex = int.parse(args.message);

        if (type == '1') {
      // English
      data = Messages.englishData;
    } else if (type == '4') {
      // Hindi
      data = Messages.hindiData;
    } else if (type == '3') {
      // German
      data = Messages.germanData;
    } else if (type == '2') {
      // french
      data = Messages.frenchData;
    } else if (type == '5') {
      // Italian
      data = Messages.italyData;
    } else if (type == '6') {
      // Portuguese
      data = Messages.portugalData;
    } else if (type == '7') {
      // Portuguese
      data = Messages.spanishData;
    } else {
      // Spanish:
      data = Messages.weddingData;
    }

    return PageView.builder(
      controller: PageController(
          initialPage: defaultIndex, keepPage: true, viewportFraction: 1),
      itemBuilder: (context, index) {
        return Scaffold(
          appBar: AppBar(
              title: Text(
            "Message No. ${index + 1}",
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          )),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(1.93 * SizeConfig.widthMultiplier),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(1.93 * SizeConfig.widthMultiplier),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(data[index],
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 1.93 * SizeConfig.widthMultiplier),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Builder(builder: (BuildContext context) {
                                return ElevatedButton(
                                    child: const Text("Share"),
                                    onPressed: () {
                                      debugPrint("Share Button Clicked");
                                      _onShare(
                                          context,
                                          data[index] +
                                              "\n" +
                                              "Share Via:" +
                                              "\n" +
                                              Strings.shareAppText);
                                    });
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: _bannerAd != null
                ? SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(
                      ad: _bannerAd!,
                    ),
                  )
                : Container(),
          ),
        );
      },
    );
  }

  void _onShare(BuildContext context, String text) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;

    /*if (imagePaths.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < imagePaths.length; i++) {
        files.add(XFile(imagePaths[i], name: imageNames[i]));
      }
      await Share.shareXFiles(files,
          text: text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {*/
    await Share.share(text,
        subject: "Share",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    //}
  }

  Future<void> shareText(String message) async {
    try {
      Share.share(message);
    } catch (e) {
      debugPrint('error: $e');
    }
  }
}
