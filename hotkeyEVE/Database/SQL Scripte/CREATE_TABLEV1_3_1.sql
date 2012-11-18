
DROP TABLE application_blacklist;
CREATE TABLE application_blacklist (
	id INTEGER PRIMARY KEY,
	app_name TEXT,
	bundle_identifier TEXT,
	UNIQUE(bundle_identifier, app_name) ON CONFLICT REPLACE
);
