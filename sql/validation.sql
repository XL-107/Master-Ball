-- Total row count
SELECT COUNT(*) AS total_rows FROM pokemon;

-- Distinct pokedex numbers
SELECT COUNT(DISTINCT Number) AS unique_pokemon FROM pokemon;

-- Pokemon with forms
SELECT Name, Form
FROM pokemon
WHERE Form IS NOT NULL
ORDER BY Number
LIMIT 20;

-- Top 10 by total stats
SELECT Number, Name, Form, Total
FROM pokemon_with_total
ORDER BY Total DESC
LIMIT 10;

-- Count by primary type
SELECT Type1, COUNT(*) AS count
FROM pokemon
GROUP BY Type1
ORDER BY count DESC;

-- Sample search
SELECT Number, Name, Form
FROM pokemon
WHERE Name LIKE 'Char%'
ORDER BY Number;

-- Sample type filter
SELECT Number, Name, Form, Type1, Type2
FROM pokemon
WHERE Type1 = 'Fire' OR Type2 = 'Fire'
ORDER BY Number
LIMIT 20;