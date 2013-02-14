-- BEGIN TABLE ALTERATIONS
BEGIN TRANSACTION;
ALTER TABLE "gui_elements" RENAME TO 'gui_elements_ME_TMP';
CREATE TABLE "gui_elements" (
"id" INTEGER PRIMARY KEY,
"identifier" TEXT,
"cocoa_identifier" TEXT,
"element_title" TEXT,
"element_help" TEXT,
"shortcut_string" TEXT,
"module_id" INTEGER REFERENCES "applications"("id"),
"shortcut_id" INTEGER REFERENCES "shortcuts"("id"),
UNIQUE ("identifier") ON CONFLICT IGNORE
);
INSERT INTO "gui_elements"  ("id", "identifier", "cocoa_identifier", "element_title", "element_help", "shortcut_string", "module_id", "shortcut_id") SELECT "id", "identifier", "cocoa_identifier", "element_title", "element_help", "shortcut_string", "application_id", "shortcut_id" FROM "gui_elements_ME_TMP";
DROP TABLE "gui_elements_ME_TMP";
COMMIT;
-- END TABLE ALTERATIONS

