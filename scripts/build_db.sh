#!/usr/bin/env bash

set -e

DB_FILE="masterballPhone.db"

echo "Removing old database..."
rm -f $DB_FILE

echo "Creating database..."

# Step 1: load raw dataset
sqlite3 $DB_FILE < expanded_pokemon_test.sql

# Step 2: create clean schema
sqlite3 $DB_FILE < sql/01_schema.sql

# Step 3: import into clean schema
sqlite3 $DB_FILE < sql/02_import_from_expanded.sql

echo "Database built successfully: $DB_FILE"