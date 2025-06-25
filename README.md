## Permissionless 2025 Hack and Hang

The game is called Pig.

- 1 player, 1 die game
    - Goal — Reach a score of 50
    - A new game will start on the first roll.
    - Continuously roll a die until 1 is rolled or the player calls hold — Consider hold or 1 as turns.
    - If a player rolls any other number than 1, the number is added to their turn score — consider these as rounds.
    - If it is 1, their current turn score is set to 0, and a new turn begins.
    - If they call hold, their turn ends, and those points are added to their total score. A new turn begins.
    - If the player calls complete game, the game ends, complete_game is called in pig master with the results.
    - If the game has been completed, then it can be reset, and a new game started.

## Get Started

To get started, you will need to do the following:

* [Fork this repository](https://github.com/aptos-labs/hack-and-hang-june-2025/fork)
* [Clone your forked repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
* Install the [Aptos CLI](https://aptos.dev/en/build/cli)
* Initialize an account for publishing the Move smart contract:
    ```bash
    aptos init --network testnet --profile pig-game
    ```
* Fund the account with some testnet APT using the [Faucet](https://aptos.dev/en/network/faucet).
* Modify the Move smart contract code in `contract/pig-game` to implement the Pig Game logic.
* (Optional) You can unit tests to test your contract in `contract/pig-game/tests`.
    * Run the Move unit tests using the Aptos CLI in the `contract/pig-game` directory:
      ```bash
      aptos move test --dev
      ```
* Publish the contract to testnet in the `contract/pig-game` directory:
    ```bash
    aptos move publish --named-addresses pig_game=pig-game
    ```
* Visit the [website](https://hack-and-hang-june-2025.vercel.app/)
    * Connect your Aptos connect wallet to the website.
    * Fund the account with some testnet APT using the [Faucet](https://aptos.dev/en/network/faucet).
    * Enter your contract address in the input field (who deployed it).
    * Play the Pig game by rolling the die, holding, and completing the game.

## Move Code

1. Implement the [pig-game contract](https://github.com/aptos-labs/hack-and-hang-june-2025/tree/main/contract/pig-game/sources)
2. When implementing the `complete_game` contract, make sure to call `pig_master_addr::pig_master::complete_game`.

## Layout

- `contract/`: Contains the Move smart contract code
    - `contract/pig-game`: This is the code for you to fill in the Pig Game contract.
    - `contract/pig-master`: This is the code for maintaining scoring for the Pig game across all implementations.
- `website/`: Contains the React website code
