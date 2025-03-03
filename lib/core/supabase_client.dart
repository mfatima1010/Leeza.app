import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientHelper {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url:
          'https://bnuiyxagqjahzxpjkcor.supabase.co', // Replace with your Supabase URL
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJudWl5eGFncWphaHp4cGprY29yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3Mzk0MTAsImV4cCI6MjA1NDMxNTQxMH0.TAptpOcSrhGsZtJ8cpfCkK-3fmH68HwgLg6xBcTm6Bo', // Replace with your Supabase anon key
    );
  }

  static final supabase = Supabase.instance.client;
}
