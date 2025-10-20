CREATE TABLE tasks(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    dueDate INTEGER,
    label TEXT,
    isCompleted INTEGER NOT NULL DEFAULT 0,
    startDate INTEGER,
    priority INTEGER DEFAULT 0,
    estimatedTime REAL
);

CREATE TABLE tags(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE task_tags (
  taskId INTEGER,
  tagId INTEGER,
  PRIMARY KEY (taskId, tagId),
  FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE,
  FOREIGN KEY (tagId) REFERENCES tags (id) ON DELETE CASCADE
);
