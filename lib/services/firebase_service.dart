import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/auth_token.dart';

abstract class FirebaseService {
  String? _token;
  String? _userId;
  late final String? databaseUrl;

  FirebaseService([AuthToken? authToken])
      : _token = authToken?.token,
        _userId = authToken?.userId {
    databaseUrl = dotenv.env['FIREBASE_RTDB_URL'];
  }

  set authToken(AuthToken? authToken) {
    _token = authToken?.token;
    _userId = authToken?.userId;
  }

  @override
  String? get token => _token;

  @override
  String? get userId => _userId;
}
