BEGIN TRANSACTION;

INSERT INTO pokemon
(Number, Name, Form, Type1, Type2, HP, Attack, Defense, SpAttack, SpDefense, Speed)
SELECT
  "Number",
  "Name",
  "Form",
  "Type1",
  "Type2 ",
  "HP",
  "Attack",
  "Defense",
  "SP.Attack",
  "SP.Defense",
  "Speed"
FROM expanded_pokemon_test;

COMMIT;
