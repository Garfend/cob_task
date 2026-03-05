import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKey {
  static final String? apiKey = dotenv.env['API_KEY'];
}
