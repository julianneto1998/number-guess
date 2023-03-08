#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

echo $($PSQL "SELECT setval('games_game_id_seq', 1, false)")
echo $($PSQL "SELECT setval('users_user_id_seq', 1, false)")
echo $($PSQL "TRUNCATE TABLE users, games")
