import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sentimental/services/networking.dart';

class VoiceInputScreen extends StatefulWidget {
  static const String id = 'voice_input_screen';
  @override
  _VoiceInputScreenState createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text Example'),
      ),
      body: Column(children: [
        Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Text('Initialize'),
                    onPressed: _hasSpeech ? null : initSpeechState,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).selectedRowColor,
                      child: Center(
                        child: Text(
                          lastWords,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 40,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: .26,
                                      spreadRadius: level * 1.5,
                                      color: Colors.black.withOpacity(.05))
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.mic),
                                onPressed: !_hasSpeech || speech.isListening
                                    ? null
                                    : startListening,
                              ),
                            ),
                            Container(
                              width: 75,
                              height: 75,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: .26,
                                      spreadRadius: level * 1.5,
                                      color: Colors.black.withOpacity(.05))
                                ],
                                color: lastWords == "" || speech.isListening
                                    ? Colors.white
                                    : Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.check),
                                onPressed: lastWords == "" || speech.isListening
                                    ? null
                                    : submitResponse,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        pauseFor: Duration(seconds: 10),
        listenFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  void submitResponse() async {
    NetworkHelper networkHelper = NetworkHelper('dsdf');
    dynamic response = await networkHelper.getData();
    print(response);
  }
}
