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
	lang TEXT,
	shortcut_id INTEGER REFERENCES shortcuts(id),
	application_id INTEGER REFERENCES applications(id),
	UNIQUE(identifier) ON CONFLICT REPLACE
);

DROP TABLE menu_bar_search;
CREATE VIRTUAL TABLE menu_bar_search USING fts3(
       	identifier TEXT,
       	element_title TEXT,
       	parent_title TEXT,
       	shortcut_id INTEGER);

DROP TABLE gui_elements;
CREATE TABLE gui_elements (
	id INTEGER PRIMARY KEY,
	identifier TEXT,
	cocoa_identifier TEXT,
	app_name TEXT,
	bundle_identifier TEXT,
	element_title TEXT,
	element_help TEXT,
	parent_title TEXT,
	shortcut_string TEXT,
	application_id INTEGER REFERENCES applications(id),
	shortcut_id INTEGER REFERENCES shortcuts(id),
	UNIQUE(identifier) ON CONFLICT IGNORE
);

DROP TABLE user_data;
CREATE TABLE user_data (
	id INTEGER PRIMARY KEY,
	user_name TEXT,
	start_at_login INTEGER,
	UNIQUE(user_name) ON CONFLICT REPLACE
);

DROP TABLE applications;
CREATE TABLE applications (
	id INTEGER PRIMARY KEY,
	app_name TEXT,
	bundle_identifier TEXT,
	menu_bar_active INTEGER,
	menu_bar_support INTEGER,
	gui_support INTEGER,
	UNIQUE(bundle_identifier, app_name) ON CONFLICT REPLACE
);

DROP TABLE disabled_shortcuts;
CREATE TABLE disabled_shortcuts (
	id INTEGER PRIMARY KEY,
	application_id INTEGER REFERENCES applications(id),
	shortcut_id INTEGER REFERENCES shortcuts(id),
	user_id INTEGER REFERENCES user_data(id),
	UNIQUE(application_id, shortcut_id, user_id) ON CONFLICT REPLACE
);

DROP TABLE gui_supported_apps;
CREATE TABLE gui_supported_apps  (
	id INTEGER PRIMARY KEY,
	app_name TEXT,
	bundle_identifier TEXT,
	lang TEXT
);

DROP TABLE displayed_shortcuts;
CREATE TABLE displayed_shortcuts  (
	id INTEGER PRIMARY KEY,
	timestamp DATE DEFAULT (datetime('now','localtime')),
	application_id INTEGER REFERENCES applications(id),
	shortcut_id INTEGER REFERENCES shortcuts(id),
	user_id INTEGER REFERENCES user_data(id)
);

