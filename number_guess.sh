#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

LOGIN(){
#ask for username
echo Enter your username:
read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_ID ]]
  then #insert if not a returning user
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

  else # welcome back if returning user
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GUESS=$($PSQL "SELECT min(best_guess) FROM games WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GUESS guesses."
fi
}

GAME(){
  #generate random number
  ANSWER=$(((RANDOM % 1000) + 1 ))

  NUM_OF_GUESS=0
  GUESSED=0

  echo Guess the secret number between 1 and 1000:

  while [[ $GUESSED = 0 ]]
  do
    read GUESS
    if [[ ! $GUESS =~ ^[0-9]+$ ]]     #if not a number
    then
      echo "That is not an integer, guess again:"
    elif [[ $GUESS == $ANSWER ]]  #if answer
      then
      NUM_OF_GUESS=$(($NUM_OF_GUESS + 1))
      echo "You guessed it in $NUM_OF_GUESS tries. The secret number was $ANSWER. Nice job!"
      #insert into db
      INSERT_GAMES=$($PSQL "INSERT INTO games(best_guess, user_id) VALUES ($NUM_OF_GUESS, $USER_ID)")
      GUESSED=1
    elif [[ $ANSWER -lt $GUESS ]]     #if lower
    then
      NUM_OF_GUESS=$(($NUM_OF_GUESS + 1))
      echo "It's lower than that, guess again:"
    else     #if higher
      echo "It's higher than that, guess again:"
      NUM_OF_GUESS=$(($NUM_OF_GUESS + 1))
    fi
  done
}
 
LOGIN
GAME
