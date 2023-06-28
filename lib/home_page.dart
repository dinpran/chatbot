import 'package:chatai/feature_box.dart';
import 'package:chatai/openai_service.dart';
import 'package:chatai/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _texteditingcontroller = TextEditingController();
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  @override
  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-8996334303873561/6384197833',
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdLoaded = true;
              });
            },
            onAdFailedToLoad: ((ad, error) {})),
        request: AdRequest());
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatAI"),
        centerTitle: true,
        leading: Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle),
                ),
              ),
              Container(
                height: 123,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("assets/images/virtualAssistant.png")),
                    shape: BoxShape.circle),
              )
            ]),
            Visibility(
              visible: generatedImageUrl == null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
                decoration: BoxDecoration(
                    border: Border.all(color: Pallete.borderColor),
                    borderRadius: BorderRadius.circular(20)
                        .copyWith(topLeft: Radius.zero)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    generatedContent == null
                        ? "Good Morning, what task can I do for you?"
                        : generatedContent!,
                    style: TextStyle(
                        fontFamily: "Cera Pro",
                        fontSize: generatedContent == null ? 25 : 18,
                        color: Pallete.mainFontColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: _texteditingcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Type the question",
                    labelText: "Ask me anything"),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(generatedImageUrl!)),
              ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 22, top: 10),
                child: const Text(
                  "Here are few features",
                  style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontFamily: "Cera Pro",
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headertext: "ChatGPT",
                      descriptiontext:
                          "A smarter way to stay organized and informed with ChatGPT"),
                  FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headertext: "Dall-E",
                      descriptiontext:
                          "Get inspired and stay creative with your personal assistant provided by Dall-E"),
                  FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headertext: "Smart Voice Assistant",
                      descriptiontext:
                          "Get the best of both the worlds with a voice assistant provided by Dall-E and Chat-GPT"),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final speech =
              await openAIService.isArtPromptAPI(_texteditingcontroller.text);
          print(speech);
          if (speech.contains('http')) {
            generatedImageUrl = speech;
            generatedContent = null;
            setState(() {});
          } else {
            generatedImageUrl = null;
            generatedContent = speech;
            setState(() {});
          }
        },
        backgroundColor: Pallete.firstSuggestionBoxColor,
        child: const Icon(Icons.search),
      ),
      bottomNavigationBar: _isAdLoaded
          ? Container(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : SizedBox(),
    );
  }
}
