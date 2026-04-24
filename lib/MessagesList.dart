import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'AdManager/ad_helper.dart';
import 'AdManager/ad_manager.dart';
import 'Enums/project_routes_enum.dart';
import 'Singleton/project_manager.dart';
import 'data/Messages.dart';
import 'package:flutter/material.dart';
import 'data/Strings.dart';
import 'utils/SizeConfig.dart';
import 'utils/pass_data_between_screens.dart';

// ignore: must_be_immutable
class MessagesList extends StatefulWidget {
  const MessagesList({super.key});
  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList>
     {
  late String type;

  var data;

  BannerAd? _bannerAd;

  @override
  void initState() 
  {
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
    debugPrint("MessageList: Dispose Called");

    //projectManager.listener = null;
    //adManager.adListener = null;

    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PassDataBetweenScreens;
    type = args.title;

    debugPrint('Message List Build Method: Message type is $type');

    
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Message List",
          style: Theme.of(context).appBarTheme.toolbarTextStyle,
        ),
      ),
      body: SafeArea(
        child: data != null
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ProjectManager.instance.clickOnButton(ProjectRoutes.messagesDetailPage.toString(),PassDataBetweenScreens(type, index.toString()));
                      //Navigator.of(context).pushNamed(ProjectRoutes.messagesDetailPage.toString(),arguments: PassDataBetweenScreens("6", index.toString()));
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.all(1.93 * SizeConfig.widthMultiplier),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                borderRadius:
                                    // 40 /8.98 = 4.46
                                    BorderRadius.all(Radius.circular(
                                        4.46 * SizeConfig.widthMultiplier))),
                            child: ListTile(
                              leading: Icon(Icons.brightness_1,
                                  color:
                                      Theme.of(context).primaryIconTheme.color),
                              title: Text(
                                data[index],
                                maxLines: 2,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color:
                                      Theme.of(context).primaryIconTheme.color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: data.length,
              )
            : const Center(
                child: CircularProgressIndicator(),
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
  }

}
