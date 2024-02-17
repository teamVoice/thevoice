import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService{
     final String API_KEY = "AIzaSyAkMidlwsClYcGHujdsrYrTriLsRluEE_s";

      initializeGemini(){
            Gemini.init(apiKey: API_KEY);
      }
}
