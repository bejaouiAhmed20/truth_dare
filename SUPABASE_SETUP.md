# Supabase Setup Guide for Truth or Dare: Couples Edition

This guide provides detailed instructions for setting up the Supabase backend for the Truth or Dare: Couples Edition app.

## 1. Create a Supabase Account

1. Go to [https://supabase.com](https://supabase.com) and sign up for an account if you don't have one already.
2. Log in to your Supabase account.

## 2. Create a New Project

1. Click on "New Project" in the Supabase dashboard.
2. Enter a name for your project (e.g., "Truth or Dare").
3. Set a secure database password (you'll need this for database access).
4. Choose a region closest to your users.
5. Click "Create New Project".

## 3. Get Your Supabase Credentials

Once your project is created, you'll need to get your Supabase credentials:

1. In your project dashboard, go to "Settings" in the left sidebar.
2. Click on "API" in the settings menu.
3. You'll find your:
   - **Project URL**: This is your Supabase URL (e.g., https://xnmmemirznytfsdqcuzm.supabase.co)
   - **anon/public** key: This is your public API key for anonymous access

These credentials need to be added to the `lib/supabase.dart` file in your Flutter app.

## 4. Run the Database Migration Scripts

The app requires several tables and initial data. You'll need to run the SQL scripts in the Supabase SQL Editor:

1. In your project dashboard, go to "SQL Editor" in the left sidebar.
2. Create a new query.
3. Copy and paste the contents of the following files (in order) and run each script:
   - `supabase/migrations/20250101000000_truth_dare_schema.sql`
   - `supabase/migrations/20250101000001_rls_policies.sql`
   - `supabase/migrations/20250101000002_seed_data.sql`

### Schema Script

The first script (`20250101000000_truth_dare_schema.sql`) creates all the necessary tables, indexes, and triggers for the database.

### RLS Policies Script

The second script (`20250101000001_rls_policies.sql`) sets up Row Level Security policies to protect your data.

### Seed Data Script

The third script (`20250101000002_seed_data.sql`) populates the database with initial categories and challenges.

## 5. Verify the Database Setup

After running all the scripts, you should verify that the database was set up correctly:

1. Go to "Table Editor" in the left sidebar.
2. You should see the following tables:
   - `players`
   - `game_sessions`
   - `player_sessions`
   - `categories`
   - `challenges`
   - `challenge_history`
   - `custom_challenges`

3. Click on the `categories` table to verify that it contains the categories (Soft, Romantic, Hot, Hard, Extreme).
4. Click on the `challenges` table to verify that it contains the initial challenges.

## 6. Update Your Flutter App

Now that your Supabase backend is set up, you need to update your Flutter app with the correct credentials:

1. Open the `lib/supabase.dart` file in your Flutter project.
2. Update the following constants with your Supabase credentials:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

Replace `YOUR_SUPABASE_URL` with your Project URL and `YOUR_SUPABASE_ANON_KEY` with your anon/public key.

## 7. Test the Connection

To test that your Flutter app can connect to your Supabase backend:

1. Run your Flutter app.
2. The app should be able to load categories and challenges from the database.
3. You should be able to create players and game sessions.

If you encounter any issues, check the following:

- Verify that your Supabase URL and anon key are correct.
- Make sure all the SQL scripts were executed successfully.
- Check that the RLS policies are not blocking access to the data.

## 8. Troubleshooting

### Common Issues

1. **Authentication Issues**:
   - Make sure your anon key is correct.
   - Check that the RLS policies allow anonymous access to the necessary tables.

2. **Missing Tables or Data**:
   - Verify that all SQL scripts were executed without errors.
   - Check the "Table Editor" to make sure all tables exist and contain data.

3. **Connection Issues**:
   - Ensure your device has internet access.
   - Verify that your Supabase project is active and not paused.

### Getting Help

If you continue to experience issues, you can:

1. Check the Supabase documentation at [https://supabase.com/docs](https://supabase.com/docs).
2. Visit the Supabase GitHub repository at [https://github.com/supabase/supabase](https://github.com/supabase/supabase).
3. Join the Supabase Discord community for support.

## 9. Next Steps

Once your backend is set up and connected to your Flutter app, you can:

1. Customize the challenges by adding more to the `challenges` table.
2. Modify the categories or add new ones in the `categories` table.
3. Adjust the RLS policies to fit your specific security requirements.
4. Implement user authentication if you want to add user accounts.

Enjoy your Truth or Dare: Couples Edition app!
