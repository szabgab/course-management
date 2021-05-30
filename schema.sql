CREATE TABLE solutions (
    id INTEGER PRIMARY KEY,
    exercise_name TEXT,
    student_email TEXT,
    is_accepted BOOLEAN,
    UNIQUE(exercise_name, student_email)
);
