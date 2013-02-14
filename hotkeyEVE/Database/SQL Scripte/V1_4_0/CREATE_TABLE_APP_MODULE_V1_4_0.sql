CREATE TABLE "app_module" (
"id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
"ModuleID" STRING UNIQUE,
"Language" STRING,
"application_id" INTEGER REFERENCES "applications"("id"),
"UserName" STRING,
"Credat" STRING
);

