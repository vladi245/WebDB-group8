

-- Schema generated from ER diagram

-- Note: This file uses PostgreSQL types (SERIAL, JSONB, TIMESTAMP).

-- desks
CREATE TABLE IF NOT EXISTS desk (
    id SERIAL PRIMARY KEY,
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
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
    ,
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

--insert desks
CREATE OR REPLACE FUNCTION add_desk(_height INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO desk (height) VALUES (_height);
END;
$$ LANGUAGE plpgsql;

SELECT add_desk(70);
SELECT add_desk(75);
SELECT add_desk(80);

--insert users
CREATE OR REPLACE FUNCTION add_user(
    _name TEXT,
    _email TEXT,
    _password_hash TEXT,
    _type TEXT,
    _current_desk_id INT DEFAULT NULL,
    _standing_height INT DEFAULT NULL,
    _sitting_height INT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO users (name, email, password_hash, type, current_desk_id, standing_height, sitting_height)
    VALUES (_name, _email, _password_hash, _type, _current_desk_id, _standing_height, _sitting_height);
END;
$$ LANGUAGE plpgsql;

SELECT add_user('Alice', 'alice@example.com', 'hashed_password_1', 'standard', 1, 110, 70);
SELECT add_user('Bob', 'bob@example.com', 'hashed_password_2', 'premium', 2, 115, 72);
SELECT add_user('admin', 'admin@admin.com', '$2b$10$Adna/ERWMRANNTNtm7lxMOj66cNEZM1vf..op4n/EgV4OAZJj5G7y', 'admin', NULL, NULL, NULL);
SELECT add_user('premium', 'premium@premium.com', '$2b$10$Adna/ERWMRANNTNtm7lxMOj66cNEZM1vf..op4n/EgV4OAZJj5G7y', 'premium', NULL, NULL, NULL);

-- Insert workouts
CREATE OR REPLACE FUNCTION add_workout(
    _name TEXT,
    _calories_burned INT,
    _sets INT,
    _reps INT,
    _muscle_group JSONB
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO workouts (name, calories_burned, sets, reps, muscle_group)
    VALUES (_name, _calories_burned, _sets, _reps, _muscle_group);
END;
$$ LANGUAGE plpgsql;

SELECT add_workout('Leg Press', 250, 3, 15, ' ["Glutes", "Hamstrings", "Quadriceps"]'::jsonb);
SELECT add_workout('Bench Press', 150, 4, 10, ' ["Chest", "Triceps", "Shoulders"]'::jsonb);
SELECT add_workout('Deadlift', 300, 3, 8, ' ["Back", "Hamstrings", "Glutes"]'::jsonb);
SELECT add_workout('Squats', 250, 4, 12, ' ["Quadriceps", "Glutes", "Hamstrings"]'::jsonb);
SELECT add_workout('Pull-ups', 200, 3, 10, ' ["Back", "Biceps", "Shoulders"]'::jsonb);
SELECT add_workout('Shoulder Press', 150, 3, 12, ' ["Shoulders", "Triceps"]'::jsonb);
SELECT add_workout('Bicep Curls', 60, 3, 15, ' ["Biceps"]'::jsonb);
SELECT add_workout('Tricep Dips', 80, 3, 12, ' ["Triceps", "Chest"]'::jsonb);
SELECT add_workout('Push Ups', 60, 3, 12, ' ["chest","triceps"]'::jsonb);
SELECT add_workout('Squats', 250, 4, 15, ' ["legs","glutes"]'::jsonb);
SELECT add_workout('Lateral Raises', 50, 3, 12, ' ["Shoulders"]'::jsonb);
SELECT add_workout('Hamstring Curls', 70, 4, 15, ' ["Hamstrings"]'::jsonb);
SELECT add_workout('Calf Raises', 40, 3, 15, ' ["Calves"]'::jsonb);
SELECT add_workout('Chest Fly', 60, 4, 12, ' ["Chest"]'::jsonb);
SELECT add_workout('Lat Pulldown', 120, 3, 10, ' ["Back", "Biceps"]'::jsonb);
SELECT add_workout('Face Pulls', 60, 3, 12, ' ["Rear Delts", "Upper Back"]'::jsonb);
SELECT add_workout('Leg Extensions', 70, 3, 15, ' ["Quadriceps"]'::jsonb);
SELECT add_workout('Overhead Tricep Extension', 60, 3, 12, ' ["Triceps"]'::jsonb);
SELECT add_workout('Incline Push Ups', 60, 3, 12, ' ["Chest","Triceps"]'::jsonb);
SELECT add_workout('Glute Bridge', 90, 4, 15, ' ["Glutes"]'::jsonb);
SELECT add_workout('Bulgarian Split Squat', 120, 4, 12, ' ["Quadriceps", "Glutes"]'::jsonb);
SELECT add_workout('Seated Row', 180, 3, 10, ' ["Back", "Biceps"]'::jsonb);
SELECT add_workout('Hip Thrust', 200, 3, 12, ' ["Glutes", "Hamstrings"]'::jsonb);
SELECT add_workout('Front Squat', 250, 4, 10, ' ["Quadriceps"]'::jsonb);
SELECT add_workout('Chest Press Machine', 150, 3, 10, ' ["Chest", "Triceps"]'::jsonb);
SELECT add_workout('Arnold Press', 150, 3, 8, ' ["Shoulders", "Triceps"]'::jsonb);
SELECT add_workout('Preacher Curl', 60, 3, 12, ' ["Biceps"]'::jsonb);
SELECT add_workout('Cable Tricep Pushdown', 60, 3, 15, ' ["Triceps"]'::jsonb);
SELECT add_workout('Reverse Lunges', 120, 4, 15, ' ["Glutes", "Quadriceps"]'::jsonb);
SELECT add_workout('Back Extension', 80, 3, 12, ' ["Lower Back"]'::jsonb);

-- Insert foods
CREATE or REPLACE FUNCTION add_food (_name TEXT, _calories_intake INT)
Returns VOID AS $$
BEGIN
    INSERT INTO foods (name, calories_intake)
    VALUES (_name, _calories_intake);
END;
$$ LANGUAGE plpgsql;

SELECT add_food('Apple', 95);
SELECT add_food('Chicken Breast', 165);
SELECT add_food('Banana', 105);
SELECT add_food('Orange', 62);
SELECT add_food('Strawberries', 50);
SELECT add_food('Blueberries', 85);
SELECT add_food('Grapes', 62);
SELECT add_food('Watermelon', 46);
SELECT add_food('Pineapple', 80);
SELECT add_food('Mango', 99);
SELECT add_food('Avocado', 240);
SELECT add_food('Broccoli', 55);
SELECT add_food('Spinach', 23);
SELECT add_food('Kale', 33);
SELECT add_food('Carrots', 41);
SELECT add_food('Sweet Potato', 112);
SELECT add_food('Potato', 130);
SELECT add_food('Tomato', 22);
SELECT add_food('Cucumber', 16);
SELECT add_food('Bell Pepper', 40);
SELECT add_food('Onion', 44);
SELECT add_food('Garlic', 4);
SELECT add_food('Egg', 78);
SELECT add_food('Egg White', 17);
SELECT add_food('Salmon', 208);
SELECT add_food('Tuna', 132);
SELECT add_food('Shrimp', 99);
SELECT add_food('Beef', 250);
SELECT add_food('Pork', 242);
SELECT add_food('Turkey', 135);
SELECT add_food('Cheese', 113);
SELECT add_food('Yogurt', 59);
SELECT add_food('Milk', 103);
SELECT add_food('Almonds', 164);
SELECT add_food('Walnuts', 185);
SELECT add_food('Peanut Butter', 188);
SELECT add_food('Rice', 206);
SELECT add_food('Oats', 150);
SELECT add_food('Bread', 70);
SELECT add_food('Pasta', 157);
SELECT add_food('Quinoa', 120);
SELECT add_food('Lentils', 116);
SELECT add_food('Chickpeas', 269);
SELECT add_food('Black Beans', 114);
SELECT add_food('Kidney Beans', 127);
SELECT add_food('Tofu', 76);
SELECT add_food('Tempeh', 193);
SELECT add_food('Olive Oil', 119);
SELECT add_food('Coconut Oil', 117);
SELECT add_food('Dark Chocolate', 170);
SELECT add_food('Cabbage', 25);
SELECT add_food('Cauliflower', 25);

-- Insert workout records
CREATE OR REPLACE FUNCTION add_workout_record(_workout_id INT, _user_id INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO workout_records (workout_id, user_id) VALUES (_workout_id, _user_id);
END;
$$ LANGUAGE plpgsql;

SELECT add_workout_record(1, 1);
SELECT add_workout_record(2, 2);

-- Insert food records
CREATE OR REPLACE FUNCTION add_food_record(_food_id INT, _user_id INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO food_records (food_id, user_id) VALUES (_food_id, _user_id);
END;
$$ LANGUAGE plpgsql;

SELECT add_food_record(1, 1);
SELECT add_food_record(2, 2);

