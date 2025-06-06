# Truth or Dare: Couples Edition

A Flutter application with Supabase backend for a Truth or Dare game designed specifically for couples. This game includes various categories of challenges from soft to extreme, with a focus on bringing couples closer together.

## Features

- Multiple challenge categories (Soft, Romantic, Hot, Hard, Extreme)
- Gender-specific challenges
- Custom challenges creation
- Game session tracking
- Usage statistics for challenges
- Couple-specific content

## Database Architecture

The database is designed with the following tables:

1. **players** - Stores player information
2. **game_sessions** - Tracks individual game sessions
3. **player_sessions** - Links players to game sessions (many-to-many)
4. **categories** - Defines different categories of questions/dares
5. **challenges** - Stores all truth questions and dares
6. **challenge_history** - Tracks which challenges have been used in which sessions
7. **custom_challenges** - Allows users to create their own challenges

The database includes proper relationships, constraints, indexes for performance optimization, and Row Level Security (RLS) policies for data protection.

## Setup Instructions

### 1. Supabase Setup

1. Create a Supabase account at [https://supabase.com](https://supabase.com) if you don't have one already.
2. Create a new project in Supabase.
3. Note your Supabase URL and anon/public key from the API settings.
4. Run the SQL scripts in the following order:
   - `supabase/migrations/20250101000000_truth_dare_schema.sql` - Creates tables and indexes
   - `supabase/migrations/20250101000001_rls_policies.sql` - Sets up security policies
   - `supabase/migrations/20250101000002_seed_data.sql` - Adds initial data

You can run these scripts in the SQL Editor in the Supabase dashboard.

### 2. Flutter Setup

1. Make sure you have Flutter installed. If not, follow the instructions at [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).
2. Clone this repository.
3. Run `flutter pub get` to install dependencies.
4. Update the Supabase credentials in `lib/supabase.dart` with your own:

```dart
// lib/supabase.dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

5. Run the app with `flutter run`.

## Supabase Credentials

The app requires the following Supabase credentials:

1. **Supabase URL**: The URL of your Supabase project (e.g., https://xnmmemirznytfsdqcuzm.supabase.co)
2. **Anon/Public Key**: The anonymous key for public access to your Supabase project

These credentials should be inserted in the `lib/supabase.dart` file in the `SupabaseConfig` class.

## Database Structure

### Tables

1. **players**
   - `id` (UUID, Primary Key)
   - `name` (TEXT)
   - `gender` (TEXT)
   - `created_at` (TIMESTAMP)
   - `updated_at` (TIMESTAMP)

2. **game_sessions**
   - `id` (UUID, Primary Key)
   - `session_name` (TEXT)
   - `created_at` (TIMESTAMP)
   - `updated_at` (TIMESTAMP)
   - `ended_at` (TIMESTAMP)
   - `settings` (JSONB)

3. **player_sessions**
   - `id` (UUID, Primary Key)
   - `player_id` (UUID, Foreign Key)
   - `session_id` (UUID, Foreign Key)
   - `joined_at` (TIMESTAMP)

4. **categories**
   - `id` (UUID, Primary Key)
   - `name` (TEXT)
   - `description` (TEXT)
   - `difficulty` (INTEGER)
   - `created_at` (TIMESTAMP)

5. **challenges**
   - `id` (UUID, Primary Key)
   - `type` (TEXT)
   - `content` (TEXT)
   - `category_id` (UUID, Foreign Key)
   - `for_gender` (TEXT)
   - `couple_only` (BOOLEAN)
   - `usage_count` (INTEGER)
   - `created_at` (TIMESTAMP)
   - `updated_at` (TIMESTAMP)

6. **challenge_history**
   - `id` (UUID, Primary Key)
   - `challenge_id` (UUID, Foreign Key)
   - `session_id` (UUID, Foreign Key)
   - `player_id` (UUID, Foreign Key)
   - `completed` (BOOLEAN)
   - `skipped` (BOOLEAN)
   - `timestamp` (TIMESTAMP)

7. **custom_challenges**
   - `id` (UUID, Primary Key)
   - `type` (TEXT)
   - `content` (TEXT)
   - `created_by` (UUID, Foreign Key)
   - `for_gender` (TEXT)
   - `couple_only` (BOOLEAN)
   - `created_at` (TIMESTAMP)

### Indexes

The database includes indexes on frequently queried columns for performance optimization, such as:

- `players.gender`
- `challenges.type`
- `challenges.category_id`
- `challenges.for_gender`
- `challenges.couple_only`
- `challenges.usage_count`
- `challenge_history.session_id`
- `challenge_history.player_id`

### Security Policies (RLS)

Row Level Security policies are implemented to ensure that:

- Players can only see their own data and data of players in the same game session
- Players can only update their own data
- Players can only see game sessions they're part of
- Categories and challenges are read-only for authenticated users

## Future Enhancements

- Multiplayer mode for group play
- User authentication for persistent profiles
- Challenge rating system
- More categories and challenges
- Offline mode
- Custom category creation

## License

This project is licensed under the MIT License - see the LICENSE file for details.
#   t r u t h _ d a r e  
 