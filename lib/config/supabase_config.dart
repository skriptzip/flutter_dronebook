import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String supabaseUrl = dotenv.get('SUPABASE_URL', fallback: 'https://your-supabase-url.supabase.co');
  static String supabaseAnonKey = dotenv.get('SUPABASE_ANON_KEY', fallback: 'your-supabase-anon-key');
}
