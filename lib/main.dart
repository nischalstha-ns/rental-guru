import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/environment_config.dart';
import 'core/services/supabase_service.dart';
import 'app/app.dart';

/// Entry point of the Rental Management System application.
///
/// Initializes environment configuration, validates required secrets,
/// boots the Supabase client, then starts the Riverpod container and root [RentalApp].
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file.
  await dotenv.load(fileName: 'assets/.env');

  // Validate that required Supabase credentials are present.
  EnvironmentConfig.validate();

  // Initialize the Supabase client before anything else accesses it.
  await SupabaseService.initialize();

  runApp(const ProviderScope(child: RentalApp()));
}