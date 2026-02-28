BEGIN TRANSACTION;

DROP TABLE IF EXISTS pokemon;

CREATE TABLE pokemon (
  EntryId INTEGER PRIMARY KEY AUTOINCREMENT,
  Number INTEGER NOT NULL,
  Name TEXT NOT NULL,
  Form TEXT,
  Type1 TEXT NOT NULL,
  Type2 TEXT,
  HP INTEGER NOT NULL,
  Attack INTEGER NOT NULL,
  Defense INTEGER NOT NULL,
  SpAttack INTEGER NOT NULL,
  SpDefense INTEGER NOT NULL,
  Speed INTEGER NOT NULL,
  UNIQUE(Number, Name, Form)
);

-- Indexes for search/filter/sort performance
CREATE INDEX IF NOT EXISTS idx_pokemon_number ON pokemon(Number);
CREATE INDEX IF NOT EXISTS idx_pokemon_name   ON pokemon(Name);
CREATE INDEX IF NOT EXISTS idx_pokemon_type1  ON pokemon(Type1);
CREATE INDEX IF NOT EXISTS idx_pokemon_type2  ON pokemon(Type2);

CREATE INDEX IF NOT EXISTS idx_pokemon_hp     ON pokemon(HP);
CREATE INDEX IF NOT EXISTS idx_pokemon_attack ON pokemon(Attack);
CREATE INDEX IF NOT EXISTS idx_pokemon_speed  ON pokemon(Speed);

-- Computed total stats
DROP VIEW IF EXISTS pokemon_with_total;
CREATE VIEW pokemon_with_total AS
SELECT
  *,
  (HP + Attack + Defense + SpAttack + SpDefense + Speed) AS Total
FROM pokemon;

COMMIT;
