-- TRUTH OR DARE GAME DATABASE SCHEMA
-- This script creates all necessary tables, indexes, and security policies for the Truth or Dare game

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- PLAYERS TABLE
-- Stores information about players
CREATE TABLE players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    gender TEXT CHECK (gender IN ('male', 'female', 'other')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- GAME_SESSIONS TABLE
-- Tracks individual game sessions
CREATE TABLE game_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ended_at TIMESTAMP WITH TIME ZONE,
    settings JSONB DEFAULT '{}'::jsonb
);

-- PLAYER_SESSIONS TABLE
-- Links players to game sessions (many-to-many)
CREATE TABLE player_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    player_id UUID REFERENCES players(id) ON DELETE CASCADE,
    session_id UUID REFERENCES game_sessions(id) ON DELETE CASCADE,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(player_id, session_id)
);

-- CATEGORIES TABLE
-- Defines different categories of questions/dares
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    difficulty INTEGER CHECK (difficulty BETWEEN 1 AND 5),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- CHALLENGES TABLE
-- Stores all truth questions and dares
CREATE TABLE challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type TEXT NOT NULL CHECK (type IN ('truth', 'dare')),
    content TEXT NOT NULL,
    category_id UUID REFERENCES categories(id) ON DELETE CASCADE,
    for_gender TEXT CHECK (for_gender IN ('male', 'female', 'any')),
    couple_only BOOLEAN DEFAULT FALSE,
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- CHALLENGE_HISTORY TABLE
-- Tracks which challenges have been used in which sessions
CREATE TABLE challenge_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE,
    session_id UUID REFERENCES game_sessions(id) ON DELETE CASCADE,
    player_id UUID REFERENCES players(id) ON DELETE CASCADE,
    completed BOOLEAN DEFAULT FALSE,
    skipped BOOLEAN DEFAULT FALSE,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- CUSTOM_CHALLENGES TABLE
-- Allows users to create their own challenges
CREATE TABLE custom_challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type TEXT NOT NULL CHECK (type IN ('truth', 'dare')),
    content TEXT NOT NULL,
    created_by UUID REFERENCES players(id) ON DELETE SET NULL,
    for_gender TEXT CHECK (for_gender IN ('male', 'female', 'any')),
    couple_only BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- INDEXES
-- For performance optimization

-- Players table indexes
CREATE INDEX idx_players_gender ON players(gender);

-- Game sessions indexes
CREATE INDEX idx_game_sessions_created_at ON game_sessions(created_at);

-- Player sessions indexes
CREATE INDEX idx_player_sessions_player_id ON player_sessions(player_id);
CREATE INDEX idx_player_sessions_session_id ON player_sessions(session_id);

-- Challenges indexes
CREATE INDEX idx_challenges_type ON challenges(type);
CREATE INDEX idx_challenges_category_id ON challenges(category_id);
CREATE INDEX idx_challenges_for_gender ON challenges(for_gender);
CREATE INDEX idx_challenges_couple_only ON challenges(couple_only);
CREATE INDEX idx_challenges_usage_count ON challenges(usage_count);

-- Challenge history indexes
CREATE INDEX idx_challenge_history_session_id ON challenge_history(session_id);
CREATE INDEX idx_challenge_history_player_id ON challenge_history(player_id);
CREATE INDEX idx_challenge_history_timestamp ON challenge_history(timestamp);

-- Custom challenges indexes
CREATE INDEX idx_custom_challenges_type ON custom_challenges(type);
CREATE INDEX idx_custom_challenges_created_by ON custom_challenges(created_by);

-- TRIGGERS
-- Update usage_count when a challenge is used
CREATE OR REPLACE FUNCTION increment_challenge_usage()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE challenges
    SET usage_count = usage_count + 1
    WHERE id = NEW.challenge_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER increment_challenge_usage_trigger
AFTER INSERT ON challenge_history
FOR EACH ROW
EXECUTE FUNCTION increment_challenge_usage();

-- Update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_players_updated_at
BEFORE UPDATE ON players
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_game_sessions_updated_at
BEFORE UPDATE ON game_sessions
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_challenges_updated_at
BEFORE UPDATE ON challenges
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
