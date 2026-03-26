import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration loaded from .env
class SupabaseConfig {
  static String get url {
    final value = dotenv.env['SUPABASE_URL'];
    if (value == null || value.isEmpty) {
      throw Exception(
        'SUPABASE_URL is not set in .env. '
        'Copy .env.example to .env and add your Supabase URL.',
      );
    }
    return value;
  }

  static String get anonKey {
    final value = dotenv.env['SUPABASE_ANON_KEY'];
    if (value == null || value.isEmpty) {
      throw Exception(
        'SUPABASE_ANON_KEY is not set in .env. '
        'Copy .env.example to .env and add your Supabase anon key.',
      );
    }
    return value;
  }
}
