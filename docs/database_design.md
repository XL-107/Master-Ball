# Master Ball Database Design

## Overview

The Master Ball database stores all Pokémon and their associated forms and base stats.  
It is designed to support fast searching, filtering, and sorting operations for the mobile application.

## Table Structure

### pokemon

| Column | Description |
|------|-------------|
| EntryId | Unique internal ID |
| Number | National Pokédex number |
| Name | Pokémon name |
| Form | Alternate form (Mega, Regional, etc.) |
| Type1 | Primary type |
| Type2 | Secondary type (nullable) |
| HP | Base HP |
| Attack | Base Attack |
| Defense | Base Defense |
| SpAttack | Base Special Attack |
| SpDefense | Base Special Defense |
| Speed | Base Speed |

The combination `(Number, Name, Form)` is enforced as unique to ensure no duplicate Pokémon forms exist.

## Derived Data

A database view called `pokemon_with_total` calculates total base stats:
