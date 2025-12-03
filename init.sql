

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
    current_desk_id VARCHAR(150),
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

-- Hydration records table
CREATE TABLE IF NOT EXISTS hydration_records (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    goal_ml INT NOT NULL DEFAULT 2000,
    current_ml INT NOT NULL DEFAULT 0,
    recorded_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    CONSTRAINT fk_hydration_records_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Personal extension Bartek - Contact form
CREATE TABLE IF NOT EXISTS contact_messages (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_workout_records_user ON workout_records(user_id);
CREATE INDEX IF NOT EXISTS idx_food_records_user ON food_records(user_id);
CREATE INDEX IF NOT EXISTS idx_hydration_records_user ON hydration_records(user_id);
CREATE INDEX IF NOT EXISTS idx_hydration_records_date ON hydration_records(recorded_at);

-- END OF SCHEMA

-- Insert desks
INSERT INTO desk (id, height) VALUES
('ee:62:5b:b8:73:1d', 800),
('cd:fb:1a:53:fb:e6', 750);

-- Insert users
INSERT INTO users (name, email, password_hash, type, current_desk_id, standing_height, sitting_height)
VALUES
('admin', 'admin@admin.com', '$2b$10$Adna/ERWMRANNTNtm7lxMOj66cNEZM1vf..op4n/EgV4OAZJj5G7y', 'admin', 'ee:62:5b:b8:73:1d', NULL, NULL),
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

-- contactmessagemodel functions
CREATE OR REPLACE FUNCTION contactmessage_create(
    p_name VARCHAR,
    p_email VARCHAR,
    p_message TEXT
)
RETURNS SETOF contact_messages AS $$
BEGIN
    RETURN QUERY
    INSERT INTO contact_messages (name, email, message)
    VALUES (p_name, p_email, p_message)
    RETURNING *;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION contactmessage_list()
    RETURNS SETOF contact_messages AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM contact_messages ORDER BY id ASC;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

--desk functions
CREATE OR REPLACE FUNCTION desk_list()
    RETURNS SETOF desk AS $$
BEGIN
    RETURN QUERY    
    SELECT * FROM desk ORDER BY id ASC;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION desk_get(p_id VARCHAR)
    RETURNS TABLE(id INT, height INT) AS $$
BEGIN
    RETURN QUERY
    SELECT id, height
    FROM desk
    WHERE id = p_id;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION desk_create(
    p_id INT 
    p_height INT
)
RETURNS TABLE(
    id INT, 
    height INT
) AS $$
BEGIN
        RETURN QUERY
        INSERT INTO desk (id, height)
        VALUES (p_id, p_height)
        RETURNING *;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION desk_update(p_id INT , p_height INT)
    RETURNS TABLE(id INT, height INT) AS $$
BEGIN
    RETURN QUERY    
    UPDATE desk
    SET height = p_height
    WHERE id = p_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;


--food functions
CREATE OR REPLACE FUNCTION list_food()
    RETURNS SETOF foods AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM foods ORDER BY id ASC;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


CREATE OR REPLACE FUNCTION create_food(
    p_name TEXT,
    p_calories_intake INT
)
RETURNS SETOF foods AS $$
BEGIN
    RETURN QUERY
    INSERT INTO foods (name, calories_intake)
    VALUES (p_name, p_calories_intake)
    RETURNING *;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;


CREATE OR REPLACE FUNCTION delete_food(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM foods WHERE id = p_id;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

--meal functions
CREATE OR REPLACE FUNCTION meal_records(p_user_id INT, p_food_id INT)
    RETURNS SETOF food_records AS $$
BEGIN
    RETURN QUERY
    INSERT INTO food_records (user_id, food_id)
    VALUES (p_user_id, p_food_id)
    RETURNING *;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION meal_list()
    RETURNS TABLE(id INT, name VARCHAR, calories INT) AS $$
BEGIN
    RETURN QUERY
    SELECT f.id, f.name, f.calories_intake::int AS calories
    FROM foods AS f
    ORDER BY id ASC;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


CREATE OR REPLACE FUNCTION meal_delete(p_user_id INT, p_record_id INT)
RETURNS SETOF food_records AS $$
BEGIN
    RETURN QUERY
    DELETE FROM food_records 
    WHERE user_id = p_user_id 
    AND id = p_record_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION meal_today(p_user_id INT)
RETURNS TABLE(total_meals INT, calories_eaten INT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT(*)::int AS total_meals,
        COALESCE(SUM(f.calories_intake), 0)::int AS calories_eaten
    FROM food_records fr
    JOIN foods f ON f.id = fr.food_id
    WHERE fr.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION meal_get(p_user_id INT)
RETURNS TABLE(id INT, foodId INT, name VARCHAR, calories INT) AS $$
        SELECT
                fr.id,
                fr.food_id AS foodId,
                f.name,
                f.calories_intake AS calories
            FROM food_records fr
            JOIN foods f ON f.id = fr.food_id
            WHERE fr.user_id = p_user_id
            ORDER BY fr.timestamp ASC;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION meal_clear(p_user_id INT,p_start DATE,p_end DATE)
RETURNS TABLE(day DATE, calories INT) AS $$
BEGIN 
    RETURN QUERY
    SELECT
        DATE(fr.timestamp) AS day,
        COALESCE(SUM(f.calories_intake), 0)::int AS calories
      FROM food_records fr
      JOIN foods f ON f.id = fr.food_id
      WHERE fr.user_id = p_user_id
        AND fr.timestamp >= p_start
        AND fr.timestamp <= p_end
      GROUP BY DATE(fr.timestamp)
      ORDER BY DATE(fr.timestamp);
END;
$$ lANGUAGE plpgsql STABLE SECURITY DEFINER;

--user functions
CREATE OR REPLACE FUNCTION user_get()
RETURNS SETOF users AS $$
BEGIN
    RETURN QUERY
    SELECT * 
    FROM users
    ORDER BY id ASC;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION user_delete(p_id INT)
RETURNS SETOF users AS $$
BEGIN
    RETURN QUERY
    DELETE FROM users
    WHERE id = p_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION user_create(
    p_name VARCHAR,
    p_email VARCHAR,
    p_password_hash TEXT,
    p_type VARCHAR,
    p_current_desk_id INT,
    p_standing_height INT,
    p_sitting_height INT
)
RETURNS TABLE(
    id INT,
    name VARCHAR,
    email VARCHAR,
    password_hash VARCHAR,
    type VARCHAR,
    current_desk_id INT,
    standing_height INT,
    sitting_height INT,
    created_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    INSERT INTO users (
        name,
        email,
        password_hash,
        type,
        current_desk_id,
        standing_height,
        sitting_height
    ) VALUES (
        p_name,
        p_email,
        p_password_hash,
        p_type,
        p_current_desk_id,
        p_standing_height,
        p_sitting_height
    )
    RETURNING
        users.id,
        users.name,
        users.email,
        users.password_hash::varchar AS password_hash,
        users.type,
        users.current_desk_id,
        users.standing_height,
        users.sitting_height,
        users.created_at::timestamp AS created_at;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;


CREATE OR REPLACE FUNCTION user_email(p_email TEXT)
RETURNS SETOF users AS $$
    SELECT * FROM users WHERE email = p_email LIMIT 1;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION user_id(p_id INT)
RETURNS TABLE (
    id INT,
    name VARCHAR,
    email VARCHAR,
    password_hash VARCHAR,
    type VARCHAR,
    current_desk_id INT,
    standing_height INT,
    sitting_height INT,
    created_at TIMESTAMP
)AS $$
BEGIN
    RETURN QUERY
    SELECT
        id,
        name,
        email,
        password_hash,
        type,
        current_desk_id,
        standing_height,
        sitting_height,
        created_at
    FROM users
    WHERE id = p_id;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION user_update(p_id INT,p_type VARCHAR)
RETURNS TABLE (
    id INT,
    name VARCHAR,
    email VARCHAR,
    type VARCHAR,
    current_desk_id INT,
    standing_height INT,
    sitting_height INT,
    created_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    UPDATE users
    SET type = p_type
    WHERE id = p_id
    RETURNING
        id,
        name,
        email,
        type,
        current_desk_id,
        standing_height,
        sitting_height,
        created_at;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

--workout functions
CREATE OR REPLACE FUNCTION workout_list()
    RETURNS SETOF workouts AS $$
BEGIN
    RETURN QUERY
    SELECT * 
    FROM workouts 
    ORDER BY id ASC;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION workout_create(
    p_name TEXT,
    p_calories_burned INT,
    p_sets INT,
    p_reps INT,
    p_muscle_group JSONB
)
RETURNS SETOF workouts AS $$
BEGIN
    RETURN QUERY
    INSERT INTO workouts (
        name,
        calories_burned,
        sets,
        reps,
        muscle_group
    )
    VALUES (
        p_name, 
        p_calories_burned, 
        p_sets, 
        p_reps, 
        p_muscle_group
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;


CREATE OR REPLACE FUNCTION workout_delete(p_id INT)
RETURNS SETOF workouts AS $$
BEGIN
    RETURN QUERY
    DELETE FROM workouts
    WHERE id = p_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

--workoutrecord functions
CREATE OR REPLACE FUNCTION workoutrecord_model(
    p_workout_id INT,
    p_user_id INT,
    p_timestamp TIMESTAMP DEFAULT NULL
    )
    RETURNS TABLE (
        record_id INT,
        workout_id INT,
        user_id INT,
        "timestamp" TIMESTAMP
    ) AS $$
BEGIN
    RETURN QUERY    
    INSERT INTO workout_records (workout_id, user_id, "timestamp")
    VALUES (p_workout_id, p_user_id,COALESCE(p_timestamp, now()))
    RETURNING workout_records.id AS record_id,
              workout_records.workout_id, 
              workout_records.user_id, 
              workout_records."timestamp"::timestamp AS timestamp;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION workoutrecord_get(p_user_id INT, p_record_id INT)
    RETURNS TABLE (
        record_id INT,
        workout_id INT,
        name TEXT,
        calories_burned INT,
        sets INT,
        reps INT,
        muscle_group JSONB,
        "timestamp" TIMESTAMP
    ) AS $$
BEGIN
    RETURN QUERY    
    SELECT
        wr.id AS record_id,
        w.id AS workout_id,
        w.name::text AS name,
        w.calories_burned,
        w.sets,
        w.reps,
        w.muscle_group,
        wr."timestamp"::timestamp AS timestamp
      FROM workout_records wr
      JOIN workouts w ON w.id = wr.workout_id
      WHERE wr.user_id = p_user_id
      AND(p_record_id IS NULL OR wr.id = p_record_id)
      ORDER BY wr."timestamp" ASC;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION workoutrecord_user(p_user_id INT, p_limit INT)
    RETURNS TABLE(
        record_id INT,
        workout_id INT,
        name VARCHAR,
        total_workouts INT,
        calories_burned INT,
        sets INT,
        reps INT,
        muscle_group JSONB,
        "timestamp" TIMESTAMP
    ) AS $$
BEGIN
RETURN QUERY
    SELECT
        wr.id AS record_id,
        w.id AS workout_id,
        w.name,
        COUNT(wr.id) OVER()::int AS total_workouts,
        w.calories_burned,
        w.sets,
        w.reps,
        w.muscle_group,
        wr.timestamp::timestamp AS timestamp
      FROM workout_records wr
      JOIN workouts w ON w.id = wr.workout_id
      WHERE wr.user_id = p_user_id
      ORDER BY wr.timestamp ASC
      LIMIT p_limit;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION workoutrecord_stats(p_user_id INT)
RETURNS JSON AS $$
DECLARE
        total_workouts INT;
        total_calories INT;
        total_records INT;
BEGIN
        SELECT 
            COUNT(DISTINCT date_trunc('day', wr.timestamp))::int AS total_workouts,
            COALESCE(SUM(COALESCE(w.calories_burned,0)),0)::int AS total_calories,
            COUNT(*)::int AS total_records
        INTO total_workouts, total_calories, total_records
        FROM workout_records wr
        JOIN workouts w ON wr.workout_id = w.id
        WHERE wr.user_id = p_user_id;

        RETURN json_build_object(
            'total_workouts', total_workouts,
            'total_calories', total_calories,
            'total_records', total_records
        );
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


CREATE OR REPLACE FUNCTION workoutrecord_week(p_user_id INT)
RETURNS TABLE(
    week_records INT, 
    week_calories INT
    ) AS $$
BEGIN
    RETURN QUERY
    SELECT
    COUNT(*)::int AS week_records, 
    COALESCE(SUM(COALESCE(w.calories_burned,0))::int, 0) AS week_calories
    FROM workout_records wr
    JOIN workouts w ON wr.workout_id = w.id
    WHERE wr.user_id = p_user_id
        AND wr.timestamp >= (now() - interval '6 days')::timestamp;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION workoutrecord_day(p_user_id INT)
RETURNS TABLE(
    day DATE,
    calories INT,
    records INT
    ) AS $$
BEGIN
    RETURN QUERY
        SELECT 
            date_trunc('day', wr.timestamp)::date AS day,
            COALESCE(SUM(COALESCE(w.calories_burned,0))::int, 0) AS calories,
            COUNT(*)::int AS records
       FROM workout_records wr
       JOIN workouts w ON wr.workout_id = w.id
       WHERE wr.user_id = p_user_id 
        AND wr.timestamp >= (now() - interval '6 days')::timestamp
    GROUP BY date_trunc('day', wr.timestamp)::date
    ORDER BY date_trunc('day', wr.timestamp)::date ASC;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION workoutrecord_delete(p_id INT, p_user_id INT DEFAULT NULL)
RETURNS VOID AS $$
BEGIN
    IF p_user_id IS NOT NULL THEN
        DELETE FROM workout_records 
        WHERE id = p_id AND user_id = p_user_id;
    ELSE
        DELETE FROM workout_records 
        WHERE id = p_id;
    END IF;
END;    
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;