import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../SystemUiValues.dart';
import 'history.dart';

class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final gemini = Gemini.instance;

  final _box = Hive.box('History');

  final _controller = TextEditingController();

  late String prompt;

  String? response;

  bool triggered = false;

  Future getResponse(String initialPrompt) async {
    if (_controller.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SystemUi.NormalSnackBar(title: "Field is empty!"));
    } else {
      gemini.text(initialPrompt).then((value) {
        setState(() {
          triggered = !triggered;
          response = value?.output;
          print(response);
          _box.put(prompt, response);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      appBar: AppBar(
        title: Text(
          "Ask AI",
          style: SystemUi.headerTextStyle,
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => History()));
              },
              icon: Icon(Icons.history, color: Colors.black,),
            ),
        ],
      ),
      extendBody: true,
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical  ,
                child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(10),
                            child: triggered
                  ? response == null
                      ? LoadingAnimationWidget.stretchedDots(
                          color: Colors.deepPurple, size: 80)
                      : Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            response!.toString(),
                            style: GoogleFonts.courierPrime(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                  : Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Welcome to the AI powered assistant",
                        style: GoogleFonts.courierPrime(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                          ),
              )),
          Container(
            // height: 60,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Write your question here...",
                    hintStyle: GoogleFonts.courierPrime(
                        fontSize: 14, color: Colors.grey.shade700),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        setState(() {
                          prompt = _controller.value.text.trim();
                        });
                        getResponse(prompt);
                        _controller.clear();
                      },
                    ),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.deepPurple.shade50,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
