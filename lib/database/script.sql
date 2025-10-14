CREATE TABLE tasks(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    due_date INTEGER,
    label TEXT,
    is_completed INTEGER NOT NULL DEFAULT 0,
    start_date INTEGER,
    priority INTEGER DEFAULT 0
);

CREATE TABLE tags(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);