## Permissionless 2025 Hack and Hang

The game is called Pig.

- 1 player, 1 die game
    - Goal — Reach a score of 100
    - A new game will start on the first roll.
    - Continuously roll a die until 1 is rolled or the player calls hold — Consider hold or 1 as turns.
    - If a player rolls any other number than 1, the number is added to their turn score — consider these as rounds.
    - If it is 1, their current turn score is set to 0, and a new turn begins.
    - If they call hold, their turn ends, and those points are added to their total score.  A new turn begins.
    - If the player calls complete game, the game ends, complete_game is called in pig master with the results.
    - If the game has been completed, then it can be reset, and a new game started.

## Layout

- `contract/`: Contains the Move smart contract code
    - `contract/pig-game`: This is the code for you to fill in the Pig Game contract.
    - `contract/pig-master`: This is the code for maintaining scoring for the Pig game across all implementations.
- `website/`: Contains the React website code
