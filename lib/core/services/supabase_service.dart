import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:supabase_flutter/supabase_flutter.dart' as auth_show;

import '../config/environment_config.dart';
import '../constants/app_constants.dart';

/// Global service wrapper around the Supabase client.
///
/// Provides typed accessors for authentication, database, and storage so that
/// every repository in the app talks through this single shared instance.
class SupabaseService {
  SupabaseService._();

  static final _client = Supabase.instance.client;

  /// The underlying Supabase client.
  static SupabaseClient get client => _client;

  /// Auth convenience accessor.
  static GoTrueClient get auth => _client.auth;

  /// Database query builder.
  static PostgrestBuilder from(String table) => _client.from(table);

  /// Storage bucket accessor.
  static dynamic get storage => _client.storage;

  /// Returns the currently signed-in user, or null if no session exists.
  static User? get currentUser => _client.auth.currentUser;

  /// Whether a user is currently signed in.
  static bool get isLoggedIn => _client.auth.currentUser != null;

  /// Initialize the Supabase client using values from [EnvironmentConfig].
  /// Must be called before any repository or provider is used.
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvironmentConfig.supabaseUrl,
      anonKey: EnvironmentConfig.supabaseKey,
      debug: false,
    );
  }

  // ─── Convenience helpers ──────────────────────────────────────

  /// Builds a filters expression: `column.eq(value)`.
  static String eq(String column, dynamic value) => '$column.eq.${_encode(value)}';

  /// Builds a filters expression: `column.in.([...])`.
  static String inFilter(String column, List<dynamic> values) =>
      '${column}.in.([${values.map(_encode).join(',')}])';

  static String _encode(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return '"$value"';
    if (value is int || value is double) return value.toString();
    return '"$value"';
  }
}