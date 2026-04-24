import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'AdManager/ad_helper.dart';
import 'Enums/project_routes_enum.dart';
import 'data/Images.dart';
import 'data/Strings.dart';
import 'utils/SizeConfig.dart';
import 'utils/pass_data_between_screens.dart';
//import 'ImageDetailPage.dart';

class ImagesList extends StatefulWidget {
  @override
  _ImagesListState createState() => _ImagesListState();
}

class _ImagesListState extends State<ImagesList> {

  var data = Images.imagesPath;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Images",
          style: Theme.of(context).appBarTheme.toolbarTextStyle,
        ),
      ),
      body: SafeArea(
        child: data != null
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      child: Padding(
                        padding:
                            EdgeInsets.all(1.93 * SizeConfig.widthMultiplier),
                        child: ListTile(
                          title: CachedNetworkImage(
                            imageUrl: data[index],
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fadeOutDuration: const Duration(seconds: 1),
                            fadeInDuration: const Duration(seconds: 3),
                          ),
                        ),
                      ),
                      onTap: () {
                        debugPrint("Click on Image Grid item $index");
                        //Navigator.push(context,MaterialPageRoute(builder: (context) => ImageDetailPage(index)));

                        Navigator.of(context).pushNamed(
                          ProjectRoutes.imagesDetailPage.toString(),
                          arguments:
                              PassDataBetweenScreens("", index.toString()));
                      });
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
