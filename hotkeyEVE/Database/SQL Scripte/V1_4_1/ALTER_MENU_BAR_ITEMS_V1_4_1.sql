BEGIN TRANSACTION;
ALTER TABLE "menu_bar_items" RENAME TO 'menu_bar_items_ME_TMP';
CREATE TABLE "menu_bar_items" (
"id" INTEGER PRIMARY KEY,
"identifier" TEXT,
"element_title" TEXT,
"element_help" TEXT,
"parent_title" TEXT,
"lang" TEXT,
"shortcut_id" INTEGER REFERENCES "shortcuts"("id"),
"application_id" INTEGER REFERENCES "applications"("id"),
UNIQUE ("identifier", "parent_title") ON CONFLICT IGNORE
);
DROP TABLE "menu_bar_items_ME_TMP";
COMMIT;

