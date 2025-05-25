-- Create emotions table for the Truth or Dare app
-- This table stores user emotions shared in real-time
-- Updated version without user_id requirement

CREATE TABLE IF NOT EXISTS emotions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    emoji TEXT NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    user_name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_emotions_created_at ON emotions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_emotions_user_name ON emotions(user_name);
CREATE INDEX IF NOT EXISTS idx_emotions_category ON emotions(category);

-- Enable Row Level Security (RLS)
ALTER TABLE emotions ENABLE ROW LEVEL SECURITY;

-- Create policies for RLS
-- Allow all users to read emotions (for real-time notifications)
CREATE POLICY "Allow read access to all users" ON emotions
    FOR SELECT USING (true);

-- Allow all users to insert emotions
CREATE POLICY "Allow insert access to all users" ON emotions
    FOR INSERT WITH CHECK (true);

-- Allow all users to delete emotions (simplified for this app)
CREATE POLICY "Allow delete access to all users" ON emotions
    FOR DELETE USING (true);

-- Enable real-time subscriptions for the emotions table
-- This allows the app to receive real-time updates when emotions are added
ALTER PUBLICATION supabase_realtime ADD TABLE emotions;

-- Create a function to clean up old emotions (optional)
CREATE OR REPLACE FUNCTION cleanup_old_emotions()
RETURNS void AS $$
BEGIN
    DELETE FROM emotions
    WHERE created_at < NOW() - INTERVAL '7 days';
END;
$$ LANGUAGE plpgsql;

-- Instructions for setting up real-time:
-- 1. Run this SQL script in your Supabase SQL editor
-- 2. Go to Database > Replication in your Supabase dashboard
-- 3. Make sure the 'emotions' table is enabled for real-time
-- 4. The app will automatically receive notifications when new emotions are shared

-- Sample data (optional - remove if not needed)
-- INSERT INTO emotions (emoji, name, category, user_name) VALUES
-- ('😊', 'Happy', '😄 Positive Emotions', 'Bouhmid'),
-- ('😍', 'Loving', '❤️‍🔥 Love & Desire', 'Marouma');
