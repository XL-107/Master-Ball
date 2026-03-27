-- ============================================
-- Canonical Queries for Master Ball Database
-- ============================================

-- Search Pokémon by name prefix
SELECT EntryId, Number, Name, Form, Type1, Type2
FROM pokemon
WHERE Name LIKE ? || '%'
ORDER BY Name
LIMIT ? OFFSET ?;


-- Filter Pokémon by type
SELECT EntryId, Number, Name, Form, Type1, Type2
FROM pokemon
WHERE Type1 = ? OR Type2 = ?
ORDER BY Number
LIMIT ? OFFSET ?;


-- Sort Pokémon by speed
SELECT EntryId, Number, Name, Form, Speed
FROM pokemon
ORDER BY Speed DESC
LIMIT ? OFFSET ?;


-- Sort Pokémon by attack
SELECT EntryId, Number, Name, Form, Attack
FROM pokemon
ORDER BY Attack DESC
LIMIT ? OFFSET ?;


-- Sort Pokémon by total base stats
SELECT EntryId, Number, Name, Form, Total
FROM pokemon_with_total
ORDER BY Total DESC
LIMIT ? OFFSET ?;


-- Only base forms (no mega/alternate forms)
SELECT EntryId, Number, Name, Form
FROM pokemon
WHERE Form IS NULL
ORDER BY Number;