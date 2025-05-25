-- TRUTH OR DARE GAME RLS POLICIES
-- This script sets up Row Level Security policies for the Truth or Dare game

-- Enable Row Level Security on all tables
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenge_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE custom_challenges ENABLE ROW LEVEL SECURITY;

-- Create a role for authenticated users
CREATE ROLE authenticated;

-- PLAYERS TABLE POLICIES
-- Anyone can create a player
CREATE POLICY players_insert_policy ON players
    FOR INSERT TO authenticated
    WITH CHECK (true);

-- Players can only update their own data
CREATE POLICY players_update_policy ON players
    FOR UPDATE TO authenticated
    USING (id = auth.uid())
    WITH CHECK (id = auth.uid());

-- Players can only see their own data and players in the same game session
CREATE POLICY players_select_policy ON players
    FOR SELECT TO authenticated
    USING (
        id = auth.uid() OR
        id IN (
            SELECT ps.player_id
            FROM player_sessions ps
            JOIN player_sessions my_ps ON ps.session_id = my_ps.session_id
            WHERE my_ps.player_id = auth.uid()
        )
    );

-- GAME_SESSIONS TABLE POLICIES
-- Anyone can create a game session
CREATE POLICY game_sessions_insert_policy ON game_sessions
    FOR INSERT TO authenticated
    WITH CHECK (true);

-- Only players in a session can update it
CREATE POLICY game_sessions_update_policy ON game_sessions
    FOR UPDATE TO authenticated
    USING (
        id IN (
            SELECT session_id
            FROM player_sessions
            WHERE player_id = auth.uid()
        )
    )
    WITH CHECK (
        id IN (
            SELECT session_id
            FROM player_sessions
            WHERE player_id = auth.uid()
        )
    );

-- Players can only see sessions they're part of
CREATE POLICY game_sessions_select_policy ON game_sessions
    FOR SELECT TO authenticated
    USING (
        id IN (
            SELECT session_id
            FROM player_sessions
            WHERE player_id = auth.uid()
        )
    );

-- PLAYER_SESSIONS TABLE POLICIES
-- Players can add themselves to sessions
CREATE POLICY player_sessions_insert_policy ON player_sessions
    FOR INSERT TO authenticated
    WITH CHECK (player_id = auth.uid());

-- Players can only update their own session links
CREATE POLICY player_sessions_update_policy ON player_sessions
    FOR UPDATE TO authenticated
    USING (player_id = auth.uid())
    WITH CHECK (player_id = auth.uid());

-- Players can see all players in sessions they're part of
CREATE POLICY player_sessions_select_policy ON player_sessions
    FOR SELECT TO authenticated
    USING (
        session_id IN (
            SELECT session_id
            FROM player_sessions
            WHERE player_id = auth.uid()
        )
    );

-- CATEGORIES TABLE POLICIES
-- Categories are read-only for authenticated users
CREATE POLICY categories_select_policy ON categories
    FOR SELECT TO authenticated
    USING (true);

-- CHALLENGES TABLE POLICIES
-- Challenges are read-only for authenticated users
CREATE POLICY challenges_select_policy ON challenges
    FOR SELECT TO authenticated
    USING (true);

-- CHALLENGE_HISTORY TABLE POLICIES
-- Players can record challenge history for their sessions
CREATE POLICY challenge_history_insert_policy ON challenge_history
    FOR INSERT TO authenticated
    WITH CHECK (
        session_id IN (
            SELECT session_id
            FROM player_sessions
            WHERE player_id = auth.uid()
        )
    );

-- Players can update challenge history for their sessions
CREATE POLICY challenge_history_update_policy ON challenge_history
    FOR UPDATE TO authenticated
    USING (
        session_id IN (
            SELECT session_id
            FROM player_sessions
            WHERE player_id = auth.uid()
        )
    )
    WITH CHECK (
        session_id IN (
            SELECT session_id
            FROM player_sessions
            WHERE player_id = auth.uid()
        )
    );

-- Players can see challenge history for their sessions
CREATE POLICY challenge_history_select_policy ON challenge_history
    FOR SELECT TO authenticated
    USING (
        session_id IN (
            SELECT session_id
            FROM player_sessions
            WHERE player_id = auth.uid()
        )
    );

-- CUSTOM_CHALLENGES TABLE POLICIES
-- Players can create custom challenges
CREATE POLICY custom_challenges_insert_policy ON custom_challenges
    FOR INSERT TO authenticated
    WITH CHECK (created_by = auth.uid());

-- Players can update their own custom challenges
CREATE POLICY custom_challenges_update_policy ON custom_challenges
    FOR UPDATE TO authenticated
    USING (created_by = auth.uid())
    WITH CHECK (created_by = auth.uid());

-- Players can see all custom challenges in their sessions
CREATE POLICY custom_challenges_select_policy ON custom_challenges
    FOR SELECT TO authenticated
    USING (
        created_by = auth.uid() OR
        created_by IN (
            SELECT ps.player_id
            FROM player_sessions ps
            JOIN player_sessions my_ps ON ps.session_id = my_ps.session_id
            WHERE my_ps.player_id = auth.uid()
        )
    );
