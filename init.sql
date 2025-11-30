

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
    SELECT id, name, calories_intake::int AS calories
    FROM foods
    ORDER BY id ASC;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


CREATE OR REPLACE FUNCTION meal_delete(p_user_id INT, p_record_id INT)
RETURNS SETOF food_records AS $$
BEGIN
    RETURN QUERY
    DELETE FROM food_records
    WHERE user_id = p_user_id AND id = p_record_id
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
        id,
        name,
        email,
        password_hash,
        type,
        current_desk_id,
        standing_height,
        sitting_height,
        created_at;
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
    p_user_id INT, 
    p_workout_id INT,
    p_timestamp TIMESTAMP DEFAULT now()
    )
    RETURNS TABLE (
        workout_id INT,
        user_id INT,
        record_ts TIMESTAMP
    ) AS $$
BEGIN
    RETURN QUERY    
    INSERT INTO workout_records (workout_id, user_id, timestamp)
    VALUES (p_workout_id, p_user_id, p_timestamp)
    RETURNING workout_id, user_id, timestamp AS record_ts;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION workoutrecord_get(p_user_id INT)
    RETURNS TABLE (
        id INT,
        workoutId INT,
        name TEXT,
        calories_burned INT,
        sets INT,
        reps INT,
        muscle_group JSONB,
        record_ts TIMESTAMP
    ) AS $$
BEGIN
    RETURN QUERY    
    SELECT
        wr.id,
        w.id AS workoutId,
        w.name,
        w.calories_burned,
        w.sets,
        w.reps,
        w.muscle_group,
        wr.timestamp AS record_ts
      FROM workout_records wr
      JOIN workouts w ON w.id = wr.workout_id
      WHERE wr.user_id = p_user_id
      ORDER BY wr.timestamp ASC;
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
        record_ts TIMESTAMP
    ) AS $$
BEGIN
RETURN QUERY
    SELECT
        wr.id AS record_id,
        w.id AS workout_id,
        w.name,
        COUNT(wr.id) OVER() AS total_workouts,
        w.calories_burned,
        w.sets,
        w.reps,
        w.muscle_group,
        wr.timestamp AS record_ts
      FROM workout_records wr
      JOIN workouts w ON w.id = wr.workout_id
      WHERE wr.user_id = p_user_id
      ORDER BY wr.timestamp ASC
      LIMIT p_limit;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

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
    COUNT(*) AS week_records, 
    COALESCE(SUM(COALESCE(w.calories_burned,0)),0) AS week_calories
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
            date_trunc('day', wr.timestamp) AS day,
            COALESCE(SUM(COALESCE(w.calories_burned,0)),0) AS calories,
            COUNT(*) AS records
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