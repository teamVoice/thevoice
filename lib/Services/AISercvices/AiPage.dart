import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thevoice2/Services/AISercvices/history.dart';
import 'package:thevoice2/SystemUiValues.dart';

import 'aiservice.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  final TextEditingController _controller = TextEditingController();

  String? _response;
  final _box = Hive.box('responseHistory');

  Future getResponse(String prompt) async {
    AIServices services = AIServices();
    var response = await services.chatGPTAPI(prompt);
    if (response.isEmpty) {
      setState(() {
        _response = "An internal error has occurred";
      });
    } else {
      setState(() {
        _response = response;
        _box.put(prompt, _response);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Ask AI"),
              background: Container(
                color: Colors.deepPurple,
              ),
            ),
            backgroundColor: Colors.deepPurple.shade100,
            expandedHeight: 70,
            floating: true,
            pinned: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const History()));
                },
                icon: Icon(Icons.history),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                  child: Center(
                child: Text(
                  _response == null
                      ? "Welcome to Ai Powered Assistant"
                      : _response!,
                  style: GoogleFonts.openSans(fontSize: 18),
                ),
              )),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 500,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Enter your question",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        getResponse(
                          _controller.value.text.trim(),
                        );
                        _controller.clear();
                      },
                    ),

                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepPurple.shade50,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
