

-- Schema generated from ER diagram

-- Note: This file uses PostgreSQL types (SERIAL, JSONB, TIMESTAMP).

-- desks
CREATE TABLE IF NOT EXISTS desk (
    id VARCHAR(150) UNIQUE NOT NULL,
    height INT NOT NULL CHECK (height >= 0)
);

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    current_desk_id INT,
    standing_height INT,
    sitting_height INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    CONSTRAINT fk_users_current_desk FOREIGN KEY (current_desk_id) REFERENCES desk(id) ON DELETE SET NULL
);

-- Workouts table
CREATE TABLE IF NOT EXISTS workouts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    calories_burned INT CHECK (calories_burned >= 0),
    sets INT CHECK (sets >= 0),
    reps INT CHECK (reps >= 0),
    muscle_group JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Food table
CREATE TABLE IF NOT EXISTS foods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    calories_intake INT CHECK (calories_intake >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Workout records table
CREATE TABLE IF NOT EXISTS workout_records (
    id SERIAL PRIMARY KEY,
    workout_id INT NOT NULL,
    user_id INT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT fk_workout_records_workout FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE,
    CONSTRAINT fk_workout_records_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Food records table
CREATE TABLE IF NOT EXISTS food_records (
    id SERIAL PRIMARY KEY,
    food_id INT NOT NULL,
    user_id INT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT fk_food_records_food FOREIGN KEY (food_id) REFERENCES foods(id) ON DELETE CASCADE,
    CONSTRAINT fk_food_records_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_workout_records_user ON workout_records(user_id);
CREATE INDEX IF NOT EXISTS idx_food_records_user ON food_records(user_id);

-- END OF SCHEMA

-- Insert desks
INSERT INTO desk (height) VALUES
(70),
(75),
(80);

-- Insert users
INSERT INTO users (name, email, password_hash, type, current_desk_id, standing_height, sitting_height)
VALUES
('admin', 'admin@admin.com', '$2b$10$Adna/ERWMRANNTNtm7lxMOj66cNEZM1vf..op4n/EgV4OAZJj5G7y', 'admin', NULL, NULL, NULL),
('premium', 'premium@premium.com', '$2b$10$Adna/ERWMRANNTNtm7lxMOj66cNEZM1vf..op4n/EgV4OAZJj5G7y', 'premium', 'cd:fb:1a:53:fb:e6', NULL, NULL);

-- Insert workouts
INSERT INTO workouts (name, calories_burned, sets, reps, muscle_group)
VALUES
('Leg Press', 250, 3, 15, '["Glutes", "Hamstrings", "Quadriceps"]'),
('Bench Press', 150, 4, 10, '["Chest", "Triceps", "Shoulders"]'),
('Deadlift', 300, 3, 8, '["Back", "Hamstrings", "Glutes"]'),
('Squats', 250, 4, 12, '["Quadriceps", "Glutes", "Hamstrings"]'),
('Pull-ups', 200, 3, 10, '["Back", "Biceps", "Shoulders"]'),
('Shoulder Press', 150, 3, 12, '["Shoulders", "Triceps"]'),
('Bicep Curls', 60, 3, 15, '["Biceps"]'),
('Tricep Dips', 80, 3, 12, '["Triceps", "Chest"]'),
('Push Ups', 60, 3, 12, '["chest","triceps"]'),
('Squats', 250, 4, 15, '["legs","glutes"]'),
('Lateral Raises', 50, 3, 12, '["Shoulders"]'),
('Hamstring Curls', 70, 4, 15, '["Hamstrings"]'),
('Calf Raises', 40, 3, 15, '["Calves"]'),
('Chest Fly', 60, 4, 12, '["Chest"]'),
('Lat Pulldown', 120, 3, 10, '["Back", "Biceps"]'),
('Face Pulls', 60, 3, 12, '["Rear Delts", "Upper Back"]'),
('Leg Extensions', 70, 3, 15, '["Quadriceps"]'),
('Overhead Tricep Extension', 60, 3, 12, '["Triceps"]'),
('Incline Push Ups', 60, 3, 12, '["Chest","Triceps"]'),
('Glute Bridge', 90, 4, 15, '["Glutes"]'),
('Bulgarian Split Squat', 120, 4, 12, '["Quadriceps", "Glutes"]'),
('Seated Row', 180, 3, 10, '["Back", "Biceps"]'),
('Hip Thrust', 200, 3, 12, '["Glutes", "Hamstrings"]'),
('Front Squat', 250, 4, 10, '["Quadriceps"]'),
('Chest Press Machine', 150, 3, 10, '["Chest", "Triceps"]'),
('Arnold Press', 150, 3, 8, '["Shoulders", "Triceps"]'),
('Preacher Curl', 60, 3, 12, '["Biceps"]'),
('Cable Tricep Pushdown', 60, 3, 15, '["Triceps"]'),
('Reverse Lunges', 120, 4, 15, '["Glutes", "Quadriceps"]'),
('Back Extension', 80, 3, 12, '["Lower Back"]');

-- Insert foods
INSERT INTO foods (name, calories_intake)
VALUES
('Apple', 95),
('Chicken Breast', 165),
('Banana', 105),
('Orange', 62),
('Strawberries', 50),
('Blueberries', 85),
('Grapes', 62),
('Watermelon', 46),
('Pineapple', 80),
('Mango', 99),
('Avocado', 240),
('Broccoli', 55),
('Spinach', 23),
('Kale', 33),
('Carrots', 41),
('Sweet Potato', 112),
('Potato', 130),
('Tomato', 22),
('Cucumber', 16),
('Bell Pepper', 40),
('Onion', 44),
('Garlic', 4),
('Egg', 78),
('Egg White', 17),
('Salmon', 208),
('Tuna', 132),
('Shrimp', 99),
('Beef', 250),
('Pork', 242),
('Turkey', 135),
('Cheese', 113),
('Yogurt', 59),
('Milk', 103),
('Almonds', 164),
('Walnuts', 185),
('Peanut Butter', 188),
('Rice', 206),
('Oats', 150),
('Bread', 70),
('Pasta', 157),
('Quinoa', 120),
('Lentils', 116),
('Chickpeas', 269),
('Black Beans', 114),
('Kidney Beans', 127),
('Tofu', 76),
('Tempeh', 193),
('Olive Oil', 119),
('Coconut Oil', 117),
('Dark Chocolate', 170),
('Cabbage', 25),
('Cauliflower', 25);

-- Insert workout records
INSERT INTO workout_records (workout_id, user_id)
VALUES
(1, 1),
(2, 2);

-- Insert food records
INSERT INTO food_records (food_id, user_id)
VALUES
(1, 1),
(2, 2);

