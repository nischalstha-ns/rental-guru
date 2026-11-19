import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Validates that the required environment variables are present at startup.
///
/// Throws a descriptive [StateError] if any required variable is missing,
/// which prevents the app from running with incomplete configuration.
class EnvironmentConfig {
  EnvironmentConfig._();

  /// Returns the Supabase project URL.
  static String get supabaseUrl => _required('SUPABASE_URL');

  /// Returns the Supabase publishable (anon) key.
  /// Tries `SUPABASE_PUBLISHABLE_KEY` first, falls back to legacy `SUPABASE_ANON_KEY`.
  static String get supabaseKey {
    final publishable = dotenv.get('SUPABASE_PUBLISHABLE_KEY');
    if (publishable.isNotEmpty) return publishable;
    final anon = dotenv.get('SUPABASE_ANON_KEY');
    if (anon.isNotEmpty) return anon;
    throw StateError(
      'Missing Supabase key. Set either SUPABASE_PUBLISHABLE_KEY or SUPABASE_ANON_KEY in assets/.env',
    );
  }

  /// Reads a required environment variable and throws if missing.
  static String _required(String key) {
    final value = dotenv.get(key);
    if (value.isEmpty) {
      throw StateError(
        'Missing required environment variable: $key\n'
        'Please copy assets/.env.example to assets/.env and fill in the values.',
      );
    }
    return value;
  }

  /// Validates all required configuration variables.
  ///
  /// Call this during app startup before initializing Supabase.
  static void validate() {
    _required('SUPABASE_URL');
    supabaseKey; // throws if key is also missing
  }
}