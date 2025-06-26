/// Each turn, a player repeatedly rolls a die until a 1 is rolled or the player decides to "hold":
///
/// If the player rolls a 1, they score nothing and it becomes the next player's turn.
/// If the player rolls any other number, it is added to their turn total and the player's turn continues.
/// If a player chooses to "hold", their turn total is added to their score, and it becomes the next player's turn.
/// The first player to score 20 or more points wins.
///
/// Your task:
/// - Implement the pig game here
/// - Integrate it with the pig master contract
/// - Test it with the frontend
module pig_game_addr::pig_game {
    use std::signer;
    use aptos_framework::randomness;
    use pig_master_addr::pig_master;

    /// Function is not implemented
    const E_NOT_IMPLEMENTED: u64 = 1;
    /// Game is already over, cannot perform this action
    const E_GAME_OVER: u64 = 2;
    /// Game has not been completed yet
    const E_GAME_NOT_COMPLETE: u64 = 3;

    /// Target score to win the game
    const TARGET_SCORE: u64 = 20;

    /// Game state for a specific user
    struct GameState has key {
        /// Current total score for the game (excluding current turn)
        total_score: u64,
        /// Score accumulated during the current turn
        turn_score: u64,
        /// The last dice roll value
        last_roll: u8,
        /// Current round number (incremented on each roll or hold)
        round: u64,
        /// Current turn number (incremented on bust or hold)
        turn: u64,
        /// Whether the game is over
        game_over: bool,
        /// Number of games played by this user in this contract
        games_played: u64,
    }

    /// Global stats for the contract
    struct GlobalStats has key {
        /// Total number of games played across all users
        total_games: u64,
    }

    /// Initialize global stats when module is deployed
    fun init_module(deployer: &signer) {
        move_to(deployer, GlobalStats {
            total_games: 0,
        });
    }

    /// Initialize game state for a user if it doesn't exist
    fun initialize_user_game_state(user: &signer) {
        let user_addr = signer::address_of(user);
        if (!exists<GameState>(user_addr)) {
            move_to(user, GameState {
                total_score: 0,
                turn_score: 0,
                last_roll: 0,
                round: 0,
                turn: 0,
                game_over: false,
                games_played: 0,
            });
        }
    }

    // ======================== Entry (Write) functions ========================
    #[randomness]
    /// Roll the dice
    entry fun roll_dice(user: &signer) acquires GameState {
        initialize_user_game_state(user);
        let user_addr = signer::address_of(user);
        let game_state = borrow_global_mut<GameState>(user_addr);
        
        // Cannot roll if game is over
        assert!(!game_state.game_over, E_GAME_OVER);

        // Generate random number between 1 and 6
        let roll = (randomness::u8_range(1, 7) as u8);
        
        game_state.last_roll = roll;
        game_state.round = game_state.round + 1;

        if (roll == 1) {
            // Bust! Turn ends, lose all turn score
            game_state.turn_score = 0;
            game_state.turn = game_state.turn + 1;
        } else {
            // Add to turn score
            game_state.turn_score = game_state.turn_score + (roll as u64);
        }
    }

    #[test_only]
    /// Optional, useful for testing purposes
    public fun roll_dice_for_test(user: &signer, num: u8) acquires GameState {
        initialize_user_game_state(user);
        let user_addr = signer::address_of(user);
        let game_state = borrow_global_mut<GameState>(user_addr);
        
        // Cannot roll if game is over
        assert!(!game_state.game_over, E_GAME_OVER);

        game_state.last_roll = num;
        game_state.round = game_state.round + 1;

        if (num == 1) {
            // Bust! Turn ends, lose all turn score
            game_state.turn_score = 0;
            game_state.turn = game_state.turn + 1;
        } else {
            // Add to turn score
            game_state.turn_score = game_state.turn_score + (num as u64);
        }
    }

    #[test_only]
    /// Test-only wrapper for hold function
    public fun hold_for_test(user: &signer) acquires GameState {
        hold(user);
    }

    #[test_only]
    /// Test-only wrapper for complete_game function
    public fun complete_game_for_test(user: &signer) acquires GameState, GlobalStats {
        complete_game(user);
    }

    #[test_only]
    /// Test-only wrapper for reset_game function
    public fun reset_game_for_test(user: &signer) acquires GameState {
        reset_game(user);
    }

    #[test_only]
    /// Initialize global stats for testing
    public fun initialize_for_test(deployer: &signer) {
        if (!exists<GlobalStats>(signer::address_of(deployer))) {
            move_to(deployer, GlobalStats {
                total_games: 0,
            });
        }
    }

    /// End the turn by calling hold, add points to the overall
    /// accumulated score for the current game for the specified user
    entry fun hold(user: &signer) acquires GameState {
        initialize_user_game_state(user);
        let user_addr = signer::address_of(user);
        let game_state = borrow_global_mut<GameState>(user_addr);
        
        // Cannot hold if game is over
        assert!(!game_state.game_over, E_GAME_OVER);

        // Add turn score to total score
        game_state.total_score = game_state.total_score + game_state.turn_score;
        game_state.turn_score = 0;
        game_state.last_roll = 0; // Reset last roll to indicate hold
        game_state.round = game_state.round + 1;
        game_state.turn = game_state.turn + 1;

        // Check if game is won
        if (game_state.total_score >= TARGET_SCORE) {
            game_state.game_over = true;
        }
    }

    /// The intended score has been reached, end the game, publish the
    /// score to both the global storage
    entry fun complete_game(user: &signer) acquires GameState, GlobalStats {
        let user_addr = signer::address_of(user);
        assert!(exists<GameState>(user_addr), E_NOT_IMPLEMENTED);
        
        let game_state = borrow_global_mut<GameState>(user_addr);
        
        // Game must be over to complete it
        assert!(game_state.game_over, E_GAME_NOT_COMPLETE);

        // Report to pig master
        pig_master::complete_game(
            user,
            game_state.total_score,
            game_state.round,
            game_state.turn
        );

        // Update global stats
        let global_stats = borrow_global_mut<GlobalStats>(@pig_game_addr);
        global_stats.total_games = global_stats.total_games + 1;

        // Update user's games played count
        game_state.games_played = game_state.games_played + 1;
    }

    /// The user wants to start a new game, end this one.
    entry fun reset_game(user: &signer) acquires GameState {
        let user_addr = signer::address_of(user);
        if (exists<GameState>(user_addr)) {
            let game_state = borrow_global_mut<GameState>(user_addr);
            game_state.total_score = 0;
            game_state.turn_score = 0;
            game_state.last_roll = 0;
            game_state.round = 0;
            game_state.turn = 0;
            game_state.game_over = false;
        } else {
            initialize_user_game_state(user);
        }
    }

    // ======================== View (Read) Functions ========================

    #[view]
    /// Return the user's last roll value from the current game, 0 is considered no roll / hold
    public fun last_roll(user: address): u8 acquires GameState {
        if (!exists<GameState>(user)) {
            return 0
        };
        borrow_global<GameState>(user).last_roll
    }

    #[view]
    /// Tells us which number round the game is on, this only resets when the game is reset
    ///
    /// This increments every time the user rolls the dice or holds
    public fun round(user: address): u64 acquires GameState {
        if (!exists<GameState>(user)) {
            return 0
        };
        borrow_global<GameState>(user).round
    }

    #[view]
    /// Tells us which number turn the game is on, this only resets when the game is reset
    ///
    /// This increments every time the user rolls a 1 or holds
    public fun turn(user: address): u64 acquires GameState {
        if (!exists<GameState>(user)) {
            return 0
        };
        borrow_global<GameState>(user).turn
    }

    #[view]
    /// Tells us whether the game is over for the user (the user has reached the target score)
    public fun game_over(user: address): bool acquires GameState {
        if (!exists<GameState>(user)) {
            return false
        };
        borrow_global<GameState>(user).game_over
    }

    #[view]
    /// Return the user's current turn score, this is the score accumulated during the current turn.  If the player holds
    /// this score will be added to the total score for the game.
    public fun turn_score(user: address): u64 acquires GameState {
        if (!exists<GameState>(user)) {
            return 0
        };
        borrow_global<GameState>(user).turn_score
    }

    #[view]
    /// Return the user's current total game score for the current game, this does not include the current turn score
    public fun total_score(user: address): u64 acquires GameState {
        if (!exists<GameState>(user)) {
            return 0
        };
        borrow_global<GameState>(user).total_score
    }

    #[view]
    /// Return total number of games played within this game's context
    public fun games_played(): u64 acquires GlobalStats {
        if (!exists<GlobalStats>(@pig_game_addr)) {
            return 0
        };
        borrow_global<GlobalStats>(@pig_game_addr).total_games
    }

    #[view]
    /// Return total number of games played within this game's context for the given user
    public fun user_games_played(user: address): u64 acquires GameState {
        if (!exists<GameState>(user)) {
            return 0
        };
        borrow_global<GameState>(user).games_played
    }
}
