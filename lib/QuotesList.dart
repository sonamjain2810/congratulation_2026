import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'utils/pass_data_between_screens.dart';
import 'AdManager/ad_helper.dart';
import 'AdManager/ad_manager.dart';
import 'Enums/project_routes_enum.dart';
import 'Singleton/project_manager.dart';
import 'data/Quotes.dart';
import 'data/Strings.dart';
import 'utils/SizeConfig.dart';

class QuotesList extends StatefulWidget {
  @override
  _QuotesListState createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList>
{
  var data = Quotes.quotesData;

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
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quotes List",
          style: Theme.of(context).appBarTheme.toolbarTextStyle,
        ),
      ),
      body: SafeArea(
        // ignore: unnecessary_null_comparison
        child: data != null
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ProjectManager.instance.clickOnButton(
                          ProjectRoutes.quotesDetailPage.toString(),
                          PassDataBetweenScreens("6", index.toString()));
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
