BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "type_chart" (
	"Type"	TEXT NOT NULL UNIQUE,
	"Normal"	NUMERIC NOT NULL,
	"Fire"	NUMERIC NOT NULL,
	"Water"	NUMERIC NOT NULL,
	"Electric"	NUMERIC NOT NULL,
	"Grass"	NUMERIC NOT NULL,
	"Ice"	NUMERIC NOT NULL,
	"Fighting"	NUMERIC NOT NULL,
	"Poison"	NUMERIC NOT NULL,
	"Ground"	NUMERIC NOT NULL,
	"Flying"	NUMERIC NOT NULL,
	"Psychic"	NUMERIC NOT NULL,
	"Bug"	NUMERIC NOT NULL,
	"Rock"	NUMERIC NOT NULL,
	"Ghost"	NUMERIC NOT NULL,
	"Dragon"	NUMERIC NOT NULL,
	"Dark"	NUMERIC NOT NULL,
	"Steel"	NUMERIC NOT NULL,
	"Fairy"	NUMERIC NOT NULL
);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Normal',1,1,1,1,1,1,1,1,1,1,1,1,0.5,0,1,1,0.5,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Fire',1,0.5,0.5,1,2,2,1,1,1,1,1,2,0.5,1,0.5,1,2,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Water',1,2,0.5,1,0.5,1,1,1,2,1,1,1,2,1,0.5,1,1,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Electric',1,1,2,0.5,0.5,1,1,1,0,2,1,1,1,1,0.5,1,1,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Grass',1,0.5,2,1,0.5,1,1,0.5,2,0.5,1,0.5,2,1,0.5,1,0.5,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Ice',1,0.5,0.5,1,2,0.5,1,1,2,2,1,1,1,1,2,1,0.5,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Fighting',2,1,1,1,1,2,1,0.5,1,0.5,0.5,0.5,2,0,1,2,2,0.5);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Poison',1,1,1,1,2,1,1,0.5,0.5,1,1,1,0.5,0.5,1,1,0,2);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Ground',1,2,1,2,0.5,1,1,2,1,0,1,0.5,2,1,1,1,2,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Flying',1,1,1,0.5,2,1,2,1,1,1,1,2,0.5,1,1,1,0.5,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Psychic',1,1,1,1,1,1,2,2,1,1,0.5,1,1,1,1,0,0.5,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Bug',1,0.5,1,1,2,1,0.5,0.5,1,0.5,2,1,1,0.5,1,2,0.5,0.5);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Rock',1,2,1,1,1,2,0.5,1,0.5,2,1,2,1,1,1,1,0.5,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Ghost',0,1,1,1,1,1,1,1,1,1,2,1,1,2,1,0.5,1,1);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Dragon',1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,0.5,0);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Dark',1,1,1,1,1,1,0.5,1,1,1,2,1,1,2,1,0.5,1,0.5);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Steel',1,0.5,0.5,0.5,1,2,1,1,1,1,1,1,2,1,1,1,0.5,2);
INSERT INTO "type_chart" ("Type","Normal","Fire","Water","Electric","Grass","Ice","Fighting","Poison","Ground","Flying","Psychic","Bug","Rock","Ghost","Dragon","Dark","Steel","Fairy") VALUES ('Fairy',1,0.5,1,1,1,1,2,0.5,1,1,1,1,1,1,2,2,0.5,1);
COMMIT;