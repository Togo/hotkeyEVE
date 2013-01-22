CREATE TABLE "app_module" (
"internal_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
"external_id" UNIQUE,
"application_id" REFERENCES "applications"("id")
);


