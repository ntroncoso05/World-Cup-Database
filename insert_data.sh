if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate teams, games;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    #Get team_ids
    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name = '$WINNER';")
    TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name = '$OPPONENT';")
    #if not found winner
    if [[ -z $TEAM_ID_WINNER ]]
    then
      #insert winner team
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER');")
      echo $INSERT_WINNER_RESULT
      #get new major_id
      TEAM_ID_WINNER=$($PSQL "select team_id from teams where name = '$WINNER';")
    fi

    #if not found opponent
    if [[ -z $TEAM_ID_OPPONENT ]]
    then
      #insert opponent team
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT');")
      echo $INSERT_OPPONENT_RESULT
      #get new major_id
      TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name = '$OPPONENT';")
    fi

    #insert game
      INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS);")
      echo $INSERT_GAME_RESULT
  fi
done