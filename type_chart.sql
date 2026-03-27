BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS "type_chart" (
  "Type" TEXT NOT NULL UNIQUE,
  "Normal" NUMERIC NOT NULL,
  "Fire" NUMERIC NOT NULL,
  "Water" NUMERIC NOT NULL,
  "Electric" NUMERIC NOT NULL,
  "Grass" NUMERIC NOT NULL,
  "Ice" NUMERIC NOT NULL,
  "Fighting" NUMERIC NOT NULL,
  "Poison" NUMERIC NOT NULL,
  "Ground" NUMERIC NOT NULL,
  "Flying" NUMERIC NOT NULL,
  "Psychic" NUMERIC NOT NULL,
  "Bug" NUMERIC NOT NULL,
  "Rock" NUMERIC NOT NULL,
  "Ghost" NUMERIC NOT NULL,
  "Dragon" NUMERIC NOT NULL,
  "Dark" NUMERIC NOT NULL,
  "Steel" NUMERIC NOT NULL,
  "Fairy" NUMERIC NOT NULL
);

INSERT INTO "type_chart" VALUES
('Normal',1,1,1,1,1,1,2,1,1,1,1,1,1,0,1,1,1,1),
('Fire',1,0.5,2,1,0.5,0.5,1,1,2,1,1,0.5,2,1,1,1,0.5,0.5),
('Water',1,0.5,0.5,2,2,0.5,1,1,1,1,1,1,1,1,1,1,0.5,1),
('Electric',1,1,1,0.5,1,1,1,1,2,0.5,1,1,1,1,1,1,0.5,1),
('Grass',1,2,0.5,0.5,0.5,2,1,2,0.5,2,1,2,1,1,1,1,1,1),
('Ice',1,2,1,1,1,0.5,2,1,1,1,1,1,2,1,1,1,2,1),
('Fighting',1,1,1,1,1,1,1,1,1,2,2,0.5,0.5,1,1,0.5,1,2),
('Poison',1,1,1,1,0.5,1,0.5,0.5,2,1,2,0.5,1,1,1,1,1,0.5),
('Ground',1,1,2,0,2,2,1,0.5,1,1,1,1,0.5,1,1,1,1,1),
('Flying',1,1,1,2,0.5,2,0.5,1,0,1,1,0.5,2,1,1,1,1,1),
('Psychic',1,1,1,1,1,1,0.5,1,1,1,0.5,2,1,2,1,2,1,1),
('Bug',1,2,1,1,0.5,1,0.5,1,0.5,2,1,1,2,1,1,1,1,1),
('Rock',0.5,0.5,2,1,2,1,2,0.5,2,0.5,1,1,1,1,1,1,2,1),
('Ghost',0,1,1,1,1,1,0,0.5,1,1,1,0.5,1,2,1,2,1,1),
('Dragon',1,0.5,0.5,0.5,0.5,2,1,1,1,1,1,1,1,1,2,1,1,2),
('Dark',1,1,1,1,1,1,2,1,1,1,0,2,1,0.5,1,0.5,1,2),
('Steel',0.5,2,1,1,0.5,0.5,2,0,2,0.5,0.5,0.5,0.5,1,0.5,1,0.5,0.5),
('Fairy',1,1,1,1,1,1,0.5,2,1,1,1,0.5,1,1,0,0.5,2,1);

COMMIT;