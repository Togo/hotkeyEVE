PRAGMA foreign_keys = ON;

DROP TABLE shortcuts;
CREATE TABLE shortcuts (
	id INTEGER PRIMARY KEY,
	shortcut_string TEXT,
	UNIQUE(shortcut_string) ON CONFLICT REPLACE
);

DROP TABLE menu_bar_items;
CREATE TABLE menu_bar_items (
	id INTEGER PRIMARY KEY,
	identifier TEXT,
	element_title TEXT,
	element_help TEXT,
	parent_title TEXT,
	shortcut_id INTEGER REFERENCES shortcuts(id)
);


DROP TABLE gui_elements;
CREATE TABLE gui_elements (
	id INTEGER PRIMARY KEY,
	identifier TEXT,
	element_title TEXT,
	element_help TEXT,
	parent_title TEXT,
	shortcut_string TEXT
);

