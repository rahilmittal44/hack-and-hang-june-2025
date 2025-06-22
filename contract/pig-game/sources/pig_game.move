/// Each turn, a player repeatedly rolls a die until a 1 is rolled or the player decides to "hold":
///
/// If the player rolls a 1, they score nothing and it becomes the next player's turn.
/// If the player rolls any other number, it is added to their turn total and the player's turn continues.
/// If a player chooses to "hold", their turn total is added to their score, and it becomes the next player's turn.
/// The first player to score 100 or more points wins.
///
/// Your task:
/// - Implement the pig game here
/// - Integrate it with the pig master contract
/// - Test it with the frontend
module pig_game_addr::pig_game {

    /// Function is not implemented
    const E_NOT_IMPLEMENTED: u64 = 1;

    // ======================== Entry (Write) functions ========================

    /// Roll the dice
    entry fun roll_dice(user: &signer) {
        abort E_NOT_IMPLEMENTED
    }

    /// End the turn by calling hold, add points to the overall
    /// accumulated score for the current game for the specified user
    entry fun hold(user: &signer) {
        abort E_NOT_IMPLEMENTED
    }

    /// The intended score has been reached, end the game, publish the
    /// score to both the local and global database.
    entry fun complete_game(user: &signer) {
        abort E_NOT_IMPLEMENTED
    }

    /// The user wants to start a new game, end this one.
    entry fun reset_game(user: &signer) {
        abort E_NOT_IMPLEMENTED
    }

    // ======================== View (Read) Functions ========================

    #[view]
    /// Return the users top score from the current game
    public fun current_score(user: address) {
        abort E_NOT_IMPLEMENTED
    }

    #[view]
    /// Return the user's top score within this game's context
    public fun user_top_score(user: address) {
        abort E_NOT_IMPLEMENTED
    }

    #[view]
    /// Return total number of games played within this game's context
    public fun games_played(): u64 {
        abort E_NOT_IMPLEMENTED
    }

    #[view]
    /// Return the user's top score across all games
    public fun user_global_top_score(user: address) {
        abort E_NOT_IMPLEMENTED
    }

    #[view]
    /// Return the user's total number of games played
    public fun user_global_games_played(user: address): u64 {
        abort E_NOT_IMPLEMENTED
    }
}
