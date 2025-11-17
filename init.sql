

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

-- Insert desks
INSERT INTO desk (height) VALUES
(70),
(75),
(80);

-- Insert users
INSERT INTO users (name, email, password_hash, type, current_desk_id, standing_height, sitting_height)
VALUES
('Alice', 'alice@example.com', 'hashed_password_1', 'standard', 1, 110, 70),
('Bob', 'bob@example.com', 'hashed_password_2', 'premium', 2, 115, 72);

-- Insert workouts
INSERT INTO workouts (name, calories_burned, sets, reps, muscle_group) 
VALUES
('Leg Press', 200, 3, 15, '["Glutes", "Hamstrings", "Quadriceps"]'),
('Bench Press', 100, 4, 10, '["Chest", "Triceps", "Shoulders"]'),
('Deadlift', 200, 3, 8, '["Back", "Hamstrings", "Glutes"]'),
('Squats', 100, 4, 12, '["Quadriceps", "Glutes", "Hamstrings"]'),
('Pull-ups', 150, 3, 10, '["Back", "Biceps", "Shoulders"]'),
('Shoulder Press', 200, 3, 12, '["Shoulders", "Triceps"]'),
('Bicep Curls', 300, 3, 15, '["Biceps"]'),
('Tricep Dips', 100, 3, 12, '["Triceps", "Chest"]');

-- Insert foods
INSERT INTO foods (name, calories_intake)
VALUES
('Oatmeal', 250),
('Greek Yogurt', 120),
('Scrambled Eggs', 210),
('Boiled Egg', 70),
('Toast', 90),
('Butter Toast', 150),
('Peanut Butter Toast', 210),
('Jam Toast', 140),
('Cereal with Milk', 220),
('Cornflakes', 180),
('Muesli', 240),
('Apple', 80),
('Banana', 95),
('Orange', 70),
('Pear', 85),
('Grapes', 60),
('Strawberries', 50),
('Blueberries', 85),
('Kiwi', 60),
('Watermelon', 45),
('Granola Bar', 180),
('Protein Bar', 210),
('Pretzels', 110),
('Crackers', 90),
('Popcorn', 100),
('Cheese Stick', 80),
('Chips', 150),
('Rice Cake', 35),
('Mixed Nuts', 170),
('Coffee', 5),
('Tea', 5),
('Milk', 120),
('Chocolate Milk', 180),
('Orange Juice', 110),
('Apple Juice', 120),
('Cola', 140),
('Lemonade', 130),
('Iced Coffee', 90),
('Smoothie', 200),
('Ham Sandwich', 350),
('Cheese Sandwich', 320),
('Peanut Butter Sandwich', 330),
('Tuna Sandwich', 400),
('Chicken Sandwich', 420),
('Turkey Sandwich', 390),
('Egg Sandwich', 320),
('Rice', 200),
('Pasta', 350),
('Boiled Potatoes', 150),
('Mashed Potatoes', 210),
('Fried Potatoes', 320),
('Grilled Chicken', 280),
('Baked Chicken', 260),
('Fried Chicken', 420),
('Ground Beef', 290),
('Meatballs', 330),
('Hot Dog', 280),
('Sausage', 300),
('Bread Roll', 150),
('Bagel', 280),
('Croissant', 230),
('Muffin', 300),
('Pita Bread', 170),
('Cheddar Cheese', 110),
('Mozzarella Cheese', 85),
('Cottage Cheese', 90),
('Yogurt', 100),
('Carrots', 50),
('Tomatoes', 30),
('Cucumber', 15),
('Broccoli', 55),
('Green Beans', 40),
('Corn', 140),
('Tomato Soup', 150),
('Chicken Soup', 180),
('Vegetable Soup', 120),
('Baked Beans', 190),
('Yogurt Drink', 90),
('Croutons', 110),
('Plain Bagel', 260),
('Hard Bread', 60),
('Jam', 60),
('Honey Toast', 170),
('Cucumber Sandwich', 210);

-- Insert workout records
INSERT INTO workout_records (workout_id, user_id)
VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 1),
(5, 1)
ON CONFLICT DO NOTHING;

-- Insert food records
INSERT INTO food_records (food_id, user_id)
VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 1),
(5, 1)
ON CONFLICT DO NOTHING;
