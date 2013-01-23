-- BEGIN TABLE ALTERATIONS
BEGIN TRANSACTION;
ALTER TABLE "applications" RENAME TO 'applications_ME_TMP';
CREATE TABLE "applications" (
"id" INTEGER PRIMARY KEY,
"app_name" TEXT,
"bundle_identifier" TEXT,
UNIQUE ("bundle_identifier", "app_name") ON CONFLICT REPLACE
);
INSERT INTO "applications"  ("id", "app_name", "bundle_identifier") SELECT "id", "app_name", "bundle_identifier" FROM "applications_ME_TMP";
DROP TABLE "applications_ME_TMP";
COMMIT;
-- END TABLE ALTERATIONS

