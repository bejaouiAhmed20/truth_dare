-- TRUTH OR DARE GAME SEED DATA
-- This script populates the database with initial categories and challenges

-- Insert Categories
INSERT INTO categories (name, description, difficulty) VALUES
('Soft', 'Light and fun questions and dares suitable for new couples', 1),
('Romantic', 'Sweet and romantic challenges to bring couples closer', 2),
('Hot', 'Spicy challenges to heat things up', 3),
('Hard', 'More intense and intimate challenges', 4),
('Extreme', 'The most daring and adventurous challenges', 5);

-- SOFT CATEGORY
-- Truth questions - Soft
INSERT INTO challenges (type, content, category_id, for_gender, couple_only) VALUES
('truth', 'What was your first impression of me?', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('truth', 'What is your favorite physical feature about me?', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('truth', 'What is something I do that makes you smile?', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('truth', 'What is your favorite memory of us together?', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('truth', 'What is something you want to do together that we haven''t done yet?', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('truth', 'What song reminds you of me?', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('truth', 'What is your idea of a perfect date?', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('truth', 'What is something small I do that you find adorable?', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('truth', 'What is your favorite way to receive affection?', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('truth', 'What is something you admire about me?', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE);

-- Dare challenges - Soft
INSERT INTO challenges (type, content, category_id, for_gender, couple_only) VALUES
('dare', 'Give your partner a compliment that you''ve never given them before.', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('dare', 'Write a short poem for your partner on the spot.', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('dare', 'Give your partner a 30-second shoulder massage.', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('dare', 'Draw a portrait of your partner in 60 seconds.', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('dare', 'Do your best impression of your partner.', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('dare', 'Feed your partner a bite of food or drink.', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('dare', 'Slow dance with your partner for one minute to a song of their choice.', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('dare', 'Take a selfie together making funny faces.', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('dare', 'Give your partner a forehead kiss.', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE),
('dare', 'Tell your partner three things you love about them.', (SELECT id FROM categories WHERE name = 'Soft'), 'any', TRUE);

-- ROMANTIC CATEGORY
-- Truth questions - Romantic
INSERT INTO challenges (type, content, category_id, for_gender, couple_only) VALUES
('truth', 'When did you first realize you had feelings for me?', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('truth', 'What is the most romantic thing someone has ever done for you?', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('truth', 'What is your love language?', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('truth', 'What is something romantic you''ve always wanted to try?', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('truth', 'What was the moment you knew we were going to last?', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('truth', 'What is your favorite way that I show you love?', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('truth', 'What is a romantic fantasy you have?', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('truth', 'What is the most meaningful gift you''ve ever received?', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('truth', 'What is something I do that makes you feel loved?', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('truth', 'What is your favorite romantic movie and why?', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE);

-- Dare challenges - Romantic
INSERT INTO challenges (type, content, category_id, for_gender, couple_only) VALUES
('dare', 'Write a love note to your partner and read it aloud.', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('dare', 'Slow dance with your partner to a romantic song.', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('dare', 'Give your partner a gentle massage for 2 minutes.', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('dare', 'Feed each other a sweet treat.', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('dare', 'Recreate your first kiss.', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('dare', 'Look into each other''s eyes for 60 seconds without talking.', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('dare', 'Give your partner a gentle kiss on their favorite non-intimate body part.', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('dare', 'Plan a surprise date for your partner and tell them about it now.', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('dare', 'Whisper something sweet in your partner''s ear.', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE),
('dare', 'Create a playlist of songs that remind you of your partner.', (SELECT id FROM categories WHERE name = 'Romantic'), 'any', TRUE);

-- HOT CATEGORY
-- Truth questions - Hot
INSERT INTO challenges (type, content, category_id, for_gender, couple_only) VALUES
('truth', 'What is your favorite part of my body?', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('truth', 'What is something you find attractive that I do without realizing?', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('truth', 'What is a fantasy you have that we haven''t tried yet?', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('truth', 'What outfit would you love to see me in?', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('truth', 'What is something that always turns you on?', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('truth', 'What is your favorite way to be touched?', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('truth', 'What is something new you''d like to try in the bedroom?', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('truth', 'What is your favorite memory of us being intimate?', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('truth', 'What do I do that turns you on the most?', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('truth', 'If you could have me anywhere right now, where would it be?', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE);

-- Dare challenges - Hot
INSERT INTO challenges (type, content, category_id, for_gender, couple_only) VALUES
('dare', 'Give your partner a sensual neck kiss.', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('dare', 'Whisper something seductive in your partner''s ear.', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('dare', 'Give your partner a 30-second massage anywhere they choose.', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('dare', 'Take off one item of your partner''s clothing (their choice).', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('dare', 'Describe in detail what you would do to your partner if you had 10 minutes alone.', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('dare', 'Demonstrate your favorite kiss on your partner.', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('dare', 'Send your partner a flirty text message right now.', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('dare', 'Let your partner trace their finger anywhere on your body for 30 seconds.', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('dare', 'Show your partner how you like to be kissed.', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE),
('dare', 'Give your partner a sensual back massage for one minute.', (SELECT id FROM categories WHERE name = 'Hot'), 'any', TRUE);

-- HARD CATEGORY
-- Truth questions - Hard
INSERT INTO challenges (type, content, category_id, for_gender, couple_only) VALUES
('truth', 'What is your wildest fantasy that you haven''t shared with me yet?', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('truth', 'What is something you''ve always wanted to try in bed but have been too shy to ask?', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('truth', 'What is the most sensitive part of your body?', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('truth', 'What is something I do that drives you wild?', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('truth', 'What is your favorite position and why?', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('truth', 'What is a secret turn-on you have?', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('truth', 'What is something you''d like me to do more of in bed?', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('truth', 'What is your favorite type of foreplay?', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('truth', 'What is something you think about when you''re alone that turns you on?', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('truth', 'What is a fantasy you have that involves a specific location?', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE);

-- Dare challenges - Hard
INSERT INTO challenges (type, content, category_id, for_gender, couple_only) VALUES
('dare', 'Give your partner a passionate kiss that lasts at least 30 seconds.', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('dare', 'Let your partner blindfold you and kiss you wherever they want for 1 minute.', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('dare', 'Take a piece of ice and run it along your partner''s neck and collarbone.', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('dare', 'Give your partner a sensual lap dance for 1 minute.', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('dare', 'Describe in explicit detail what you want to do to your partner later.', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('dare', 'Let your partner trace their fingers along your inner thigh for 30 seconds.', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('dare', 'Remove an item of your clothing in a seductive way.', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('dare', 'Let your partner kiss your body starting from your neck down to your stomach.', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('dare', 'Demonstrate on your partner how you like to be touched.', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE),
('dare', 'Send your partner a suggestive photo of yourself right now (can be clothed but flirty).', (SELECT id FROM categories WHERE name = 'Hard'), 'any', TRUE);

-- EXTREME CATEGORY
-- Truth questions - Extreme
INSERT INTO challenges (type, content, category_id, for_gender, couple_only) VALUES
('truth', 'What is your ultimate sexual fantasy in detail?', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('truth', 'What is something taboo that turns you on?', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('truth', 'What is something you''ve always wanted to try but have been too afraid to suggest?', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('truth', 'What is the most adventurous place you''d like to be intimate?', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('truth', 'What is a role-play scenario you''ve fantasized about?', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('truth', 'What is something you''ve seen in adult content that you''d like to try?', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('truth', 'What is your ultimate sexual desire that we haven''t fulfilled yet?', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('truth', 'What is a sexual boundary you''d be willing to push?', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('truth', 'What is something unexpected that would turn you on right now?', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('truth', 'What is your most intense sexual experience and what made it so good?', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE);

-- Dare challenges - Extreme
INSERT INTO challenges (type, content, category_id, for_gender, couple_only) VALUES
('dare', 'Let your partner touch you anywhere they want for 2 minutes.', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('dare', 'Demonstrate your favorite way to pleasure yourself (can be simulated).', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('dare', 'Let your partner remove an item of your clothing using only their mouth.', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('dare', 'Role-play a fantasy scenario for 2 minutes.', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('dare', 'Let your partner blindfold you and feed you something while kissing different parts of your body.', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('dare', 'Give your partner a sensual massage using oil or lotion.', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('dare', 'Take a suggestive photo together that you''ll keep just between yourselves.', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('dare', 'Let your partner trace an ice cube anywhere on your body for 1 minute.', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('dare', 'Whisper your wildest fantasy in detail to your partner.', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE),
('dare', 'Let your partner give you a hickey somewhere only they will see.', (SELECT id FROM categories WHERE name = 'Extreme'), 'any', TRUE);
