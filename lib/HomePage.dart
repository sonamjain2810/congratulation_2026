import 'dart:async';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:congratulation_2026/utils/pass_data_between_screens.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'AdManager/ad_helper.dart';
import 'AdManager/ad_manager.dart';
import 'Enums/project_routes_enum.dart';
import 'Singleton/project_manager.dart';
import 'data/Quotes.dart';
import 'data/Shayari.dart';
import 'data/Status.dart';
import 'widgets/AppStoreAppsItemWidget1.dart';
import 'widgets/CustomBannerWidget.dart';
import 'widgets/CustomFBTextWidget.dart';
import 'widgets/CustomFeatureCard.dart';
import 'widgets/CustomFullCard.dart';
import 'widgets/DesignerContainer.dart';
import 'widgets/MessageWidget1.dart';
import 'widgets/MessageWidget3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/Gifs.dart';
import 'data/Images.dart';
import 'data/Messages.dart';
import 'data/Strings.dart';
import 'widgets/AppStoreItemWidget2.dart';
import 'utils/SizeConfig.dart';
import 'MyDrawer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/timezone.dart' as tz;

import 'widgets/SinglePost.dart';

// Height = 8.96
// Width = 4.14

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    implements ProjectListener, AdListener {
  String _authStatus = 'Unknown';

  BannerAd? _bannerAd;
  ProjectManager projectManager = ProjectManager.instance;
  AdManager adManager = AdManager.instance;

  @override
  void initState() {
    super.initState();

    projectManager.listener = this;

    adManager.adListener = this;

    projectManager.startApp();

    adManager.loadAdsInAdManager();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback(
      (_) => initPlugin(),
    );
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

    debugPrint("Home Page: Dispose Called");
    projectManager.listener = null;
    adManager.adListener = null;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  Future<void> showCustomTrackingDialog(
    BuildContext context,
  ) async => await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const Text('Dear User'),
      content: Text(
        'We care about your privacy and data security. We keep this app free by showing ads. '
        'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
        'Our partners will collect data and use a unique identifier on your device to show you ads.',
        style: Theme.of(context).textTheme.bodySmall,

      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Continue',        style: Theme.of(context).textTheme.bodySmall,
),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Alert",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              content: Text(
                "Do you want to Exit",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    launchUrlString(Strings.accountUrl);
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('More Apps'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Strings.RateNReview();
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Rate 5 ⭐'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        //AppBar Open
        appBar: AppBar(
          title: Text(
            "Home",
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
        ),
        //AppBar Complete
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                children: [
                  // Single Posts Start
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: Text(
                          "Explore Different Wishes",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SinglePost(
                              "assets/1.jpg",
                              "Baby Shower Wishes",
                              onBabyShowerClick,
                            ),
                            SinglePost(
                              "assets/2.jpg",
                              "Engagement Wishes",
                              onEngagementWishesClick,
                            ),
                            SinglePost(
                              "assets/3.jpg",
                              "Graduation Wishes for Student",
                              onGraduationWishesClick,
                            ),
                            SinglePost(
                              "assets/4.jpg",
                              "Best Wishes Messages",
                              onBestWishesClick,
                            ),
                            SinglePost(
                              "assets/5.jpg",
                              "New Born Wishes",
                              onNewBornClick,
                            ),
                            SinglePost(
                              "assets/6.jpg",
                              "Congrates on New Job",
                              onNewJobClick,
                            ),
                            SinglePost(
                              "assets/7.jpg",
                              "Congrates on Promotion",
                              onPromotionClick,
                            ),
                            SinglePost(
                              "assets/8.jpg",
                              "Send Wedding Wishes",
                              onWeddingWishesClick,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Single Posts End
                  const Divider(),
                  // Wish Creator Start
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: Text(
                          "Make Congratulations Greetings Card!!",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        //16.0
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: InkWell(
                          child: CustomBannerWidget(
                            size: MediaQuery.of(context).size,
                            imagePath: Images.imagesPath[2],
                            buttonText: "Make it",
                            topText: "Make Greetings for",
                            middleText: "Congratualtions",
                            bottomText:
                                "Share it With Your Friends & Relatives",
                          ),
                          onTap: () {
                            debugPrint("Meme Clicked");
                            ProjectManager.instance.clickOnButton(
                              ProjectRoutes.memeGenerator.toString(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // Wish Creator end
                  const Divider(),
                  // Apps from Developer Start
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: Text(
                          "Apps From Developer",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Row(
                            children: <Widget>[
                              //Column1
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple117/v4/8f/e7/b5/8fe7b5bc-03eb-808c-2b9e-fc2c12112a45/mzl.jivuavtz.png/292x0w.jpg",
                                    appTitle: "Good Morning Images & Messages",
                                    appUrl:
                                        "https://apps.apple.com/us/app/good-morning-images-messages-to-wish-greet-gm/id1232993917",
                                  ),
                                  Divider(),
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/44/e0/fd/44e0fdb5-667b-5468-7b2f-53638cba539e/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/292x0w.jpg",
                                    appTitle: "Birthday Status Wishes Quotes",
                                    appUrl:
                                        "https://apps.apple.com/us/app/birthday-status-wishes-quotes/id1522542709",
                                  ),
                                  Divider(),
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is3-ssl.mzstatic.com/image/thumb/Purple124/v4/9c/17/e3/9c17e319-fadf-d92a-b586-bacda2d699bd/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                    appTitle: "Good Night Gif Image Quote Sm‪s",
                                    appUrl:
                                        "https://apps.apple.com/us/app/good-night-gif-image-quote-sms/id1527002426",
                                  ),
                                ],
                              ),
                              SizedBox(width: SizeConfig.width(3)),
                              //Column2
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is2-ssl.mzstatic.com/image/thumb/Purple124/v4/e9/96/64/e99664d3-1083-5fac-6a0c-61718ee209fd/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-7.png/292x0w.jpg",
                                    appTitle: "Weight Loss My Diet Coach Tips",
                                    appUrl:
                                        "https://apps.apple.com/us/app/weight-loss-my-diet-coach-tips/id1448343218",
                                  ),
                                  Divider(),
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is2-ssl.mzstatic.com/image/thumb/Purple127/v4/5f/7c/45/5f7c45c7-fb75-ea39-feaa-a698b0e4b09e/pr_source.jpg/292x0w.jpg",
                                    appTitle: "English Speaking Course Grammar",
                                    appUrl:
                                        "https://apps.apple.com/us/app/english-speaking-course-learn-grammar-vocabulary/id1233093288",
                                  ),
                                  Divider(),
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/50/ad/82/50ad82d9-0d82-5007-fcdd-cc47c439bfd0/AppIcon-0-1x_U007emarketing-0-85-220-10.png/292x0w.jpg",
                                    appTitle: "English Hindi Language Diction",
                                    appUrl:
                                        "https://apps.apple.com/us/app/english-hindi-language-diction/id1441243874",
                                  ),
                                ],
                              ),
                              SizedBox(width: SizeConfig.width(3)),

                              //Column3
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple124/v4/89/1b/44/891b44e5-bbb3-a530-0f97-011c226d79e1/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                    appTitle: "Thank You Greetings Card Make‪r",
                                    appUrl:
                                        "https://apps.apple.com/us/app/thank-you-greetings-card-maker/id1552601152",
                                  ),
                                  Divider(),
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is3-ssl.mzstatic.com/image/thumb/Purple114/v4/b6/3d/cd/b63dcde0-b4db-d05b-7025-e879a338049a/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                    appTitle:
                                        "Sorry Forgive Card Status Gif‪s‬",
                                    appUrl:
                                        "https://apps.apple.com/us/app/sorry-forgive-card-status-gifs/id1549696526",
                                  ),
                                  Divider(),
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/9a/52/7a/9a527a0e-ca83-ecba-5f1b-336057d7a48b/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                    appTitle: "Anniversary Wishes Gif Image‪s‬",
                                    appUrl:
                                        "https://apps.apple.com/us/app/anniversary-wishes-gif-images/id1527002955",
                                  ),
                                ],
                              ),
                              SizedBox(width: SizeConfig.width(3)),

                              //Column4
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/cd/fa/5f/cdfa5f06-68b0-c6ff-eb35-e4b5cd5ac890/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                    appTitle: "Get Well Soon Gif Image eCard‪s",
                                    appUrl:
                                        "https://apps.apple.com/us/app/get-well-soon-gif-image-ecards/id1526953576",
                                  ),
                                  Divider(),
                                  /*AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is4-ssl.mzstatic.com/image/thumb/Purple91/v4/f0/84/d7/f084d764-79a8-f6d1-3778-1cb27fabb8bd/pr_source.png/292x0w.jpg",
                                appTitle: "Egg Recipes 100+ Recipes",
                                appUrl:
                                    "https://apps.apple.com/us/app/egg-recipes-100-recipes-collection-for-eggetarian/id1232736881"),
                            Divider(),*/
                                  AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/0f/d6/f4/0fd6f410-9664-94a5-123f-38d787bf28c6/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/292x0w.jpg",
                                    appTitle: "Rakshabandhan Images Greetings",
                                    appUrl:
                                        "https://apps.apple.com/us/app/rakshabandhan-images-greetings/id1523619788",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Apps from Developer End
                  const Divider(),
                  // Shayari start
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: Text(
                          " Shayari ",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: InkWell(
                          child: Container(
                            width: size.width - SizeConfig.width(16),
                            height: size.width / 2,
                            decoration: BoxDecoration(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.pink[300],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                  SizeConfig.height(20),
                                ),
                                topRight: Radius.circular(
                                  SizeConfig.height(20),
                                ),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.format_quote,
                                  color: Theme.of(
                                    context,
                                  ).primaryIconTheme.color,
                                ),
                                Positioned(
                                  top: 20,
                                  width: size.width - SizeConfig.width(16),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        SizeConfig.width(8),
                                      ),
                                      child: Text(
                                        Shayari.shayariData[29],
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  right: 0,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        SizeConfig.width(8),
                                      ),
                                      child: Text(
                                        "Tap Here to Continue",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(color: Colors.cyan[400]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            debugPrint("Shayari Clicked");
                            ProjectManager.instance.clickOnButton(
                              ProjectRoutes.shayariList.toString(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Shayari end
                  const Divider(),
                  // Status Start
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: Text(
                          " Status ",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomFBTextWidget(
                                  size: size,
                                  text: Status.statusData[2],
                                  color: Colors.orangeAccent.shade700,
                                  url: Images.imagesPath[18],
                                  isLeft: false,
                                ),
                                SizedBox(width: SizeConfig.width(8)),
                                CustomFBTextWidget(
                                  size: size,
                                  text: Status.statusData[3],
                                  color: Colors.amberAccent.shade700,
                                  url: Images.imagesPath[37],
                                  isLeft: false,
                                ),
                                SizedBox(width: SizeConfig.width(8)),
                                CustomFBTextWidget(
                                  size: size,
                                  text: Status.statusData[4],
                                  color: Colors.limeAccent.shade700,
                                  url: Images.imagesPath[25],
                                  isLeft: false,
                                ),
                                SizedBox(width: SizeConfig.width(8)),
                                CustomFBTextWidget(
                                  size: size,
                                  text: Status.statusData[7],
                                  color: Colors.tealAccent.shade700,
                                  url: Images.imagesPath[48],
                                  isLeft: false,
                                ),
                              ],
                            ),
                            onTap: () {
                              debugPrint("Status Clicked");
                              ProjectManager.instance.clickOnButton(
                                ProjectRoutes.statusList.toString(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Status End
                  const Divider(),
                  // Quotes Start
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: Text(
                          " Quotes ",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: InkWell(
                          child: Container(
                            width: size.width - SizeConfig.width(16),
                            height: size.width / 2,
                            decoration: BoxDecoration(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.pink[300],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                  SizeConfig.height(20),
                                ),
                                topRight: Radius.circular(
                                  SizeConfig.height(20),
                                ),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.format_quote,
                                  color: Theme.of(
                                    context,
                                  ).primaryIconTheme.color,
                                ),
                                Positioned(
                                  top: 20,
                                  width: size.width - SizeConfig.width(16),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        SizeConfig.width(8),
                                      ),
                                      child: Text(
                                        Quotes.quotesData[4],
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  right: 0,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        SizeConfig.width(8),
                                      ),
                                      child: Text(
                                        "Tap Here to Continue",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(color: Colors.cyan),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            debugPrint("Quotes Clicked");
                            ProjectManager.instance.clickOnButton(
                              ProjectRoutes.quotesList.toString(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Quotes End
                  const Divider(),
                  //Image Start
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: Text(
                          " Images ",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomFeatureCard(
                                  size: size,
                                  imageUrl: Images.imagesPath[13],
                                  ontap: null,
                                ),
                                CustomFeatureCard(
                                  size: size,
                                  imageUrl: Images.imagesPath[12],
                                  ontap: null,
                                ),
                                CustomFeatureCard(
                                  size: size,
                                  imageUrl: Images.imagesPath[8],
                                  ontap: null,
                                ),
                                CustomFeatureCard(
                                  size: size,
                                  imageUrl: Images.imagesPath[9],
                                  ontap: null,
                                ),
                              ],
                            ),
                            onTap: () {
                              debugPrint("Images Clicked");
                              ProjectManager.instance.clickOnButton(
                                ProjectRoutes.imagesList.toString(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Image End
                  const Divider(),
                  // Gifs Start
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: Text(
                          " Gifs ",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: InkWell(
                            child: Row(
                              children: <Widget>[
                                CustomFeatureCard(
                                  size: size,
                                  imageUrl: Gifs.gifsPath[0],
                                  ontap: null,
                                ),
                                CustomFeatureCard(
                                  size: size,
                                  imageUrl: Gifs.gifsPath[1],
                                  ontap: null,
                                ),
                                CustomFeatureCard(
                                  size: size,
                                  imageUrl: Gifs.gifsPath[2],
                                  ontap: null,
                                ),
                                CustomFeatureCard(
                                  size: size,
                                  imageUrl: Gifs.gifsPath[3],
                                  ontap: null,
                                ),
                              ],
                            ),
                            onTap: () {
                              debugPrint("Gifs Clicked");
                              ProjectManager.instance.clickOnButton(
                                ProjectRoutes.gifsList.toString(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Gifs End
                ],
              ),
            ],
          ),
        ),
        drawer: MyDrawer(),
      ),
    );
  }

  // ✅ ROUTING — CORRECT
  @override
  void moveToScreen(String s, [PassDataBetweenScreens? object]) {
    Navigator.of(context).pushNamed(s, arguments: object);
  }

  @override
  void moveToScreenAfterAd(String s, [PassDataBetweenScreens? object]) {
    Navigator.of(context).pushNamed(s, arguments: object);
  }

  @override
  void showAd(String s, [PassDataBetweenScreens? object]) {
    AdManager.instance.showInterstitialAd(s, object);
  }

  void onBabyShowerClick() {
    debugPrint("English Message Clicked");
    ProjectManager.instance.clickOnButton(
      ProjectRoutes.messagesList.toString(),
      PassDataBetweenScreens("1", "1"),
    );
  }

  void onEngagementWishesClick() {
    debugPrint("French Message Clicked");
    ProjectManager.instance.clickOnButton(
      ProjectRoutes.messagesList.toString(),
      PassDataBetweenScreens("2", "1"),
    );
  }

  void onGraduationWishesClick() {
    debugPrint("German Message Clicked");
    ProjectManager.instance.clickOnButton(
      ProjectRoutes.messagesList.toString(),
      PassDataBetweenScreens("3", "1"),
    );
  }

  void onBestWishesClick() {
    debugPrint("Hindi Message Clicked");
    ProjectManager.instance.clickOnButton(
      ProjectRoutes.messagesList.toString(),
      PassDataBetweenScreens("4", "1"),
    );
  }

  void onNewBornClick() {
    debugPrint("Italina Message Clicked");
    ProjectManager.instance.clickOnButton(
      ProjectRoutes.messagesList.toString(),
      PassDataBetweenScreens("5", "1"),
    );
  }

  void onNewJobClick() {
    debugPrint("English Message Clicked");
    ProjectManager.instance.clickOnButton(
      ProjectRoutes.messagesList.toString(),
      PassDataBetweenScreens("6", "1"),
    );
  }

  void onPromotionClick() {
    debugPrint("Spanish Message Clicked");
    ProjectManager.instance.clickOnButton(
      ProjectRoutes.messagesList.toString(),
      PassDataBetweenScreens("7", "1"),
    );
  }

  void onWeddingWishesClick() {
    debugPrint("Wedding Data Clicked");
    ProjectManager.instance.clickOnButton(
      ProjectRoutes.messagesList.toString(),
      PassDataBetweenScreens("8", "1"),
    );
  }
}
