#[test_only]
module pig_master_addr::pig_master_tests {
    use std::signer;
    use pig_master_addr::pig_master;

    #[test
    (
        pig_master_signer = @pig_master_addr,
        player_signer = @0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
    )]
    fun test_complete_game(pig_master_signer: &signer, player_signer: &signer) {
        let user_address = signer::address_of(player_signer);

        // Setup the game
        pig_master::initialize_for_test(pig_master_signer);

        // Ensure the game state is initialized correctly
        assert!(pig_master::user_games_played(user_address).is_none());
        assert!(pig_master::user_top_score(user_address).is_none());
        assert!(pig_master::points_to_win() == 100);

        // Would have a game happen here

        // When the game is completed, ensure registration works correctly
        let game_result = pig_master::complete_game(player_signer, 5, 2, 3);
        assert!(game_result.score() == 5);
        assert!(game_result.rounds() == 2);
        assert!(game_result.rolls() == 3);

        let games_played = pig_master::user_games_played(user_address);
        assert!(games_played.is_some());
        assert!(games_played.destroy_some() == 1);

        let games_played = pig_master::user_top_score(user_address);
        assert!(games_played.is_some());
        let top_score = games_played.destroy_some();
        assert!(top_score.score() == 5);
        assert!(top_score.rounds() == 2);
        assert!(top_score.rolls() == 3);

        // Then complete the game again with a higher score
        let game_result = pig_master::complete_game(player_signer, 10, 3, 4);
        assert!(game_result.score() == 10);
        assert!(game_result.rounds() == 3);
        assert!(game_result.rolls() == 4);

        let games_played = pig_master::user_games_played(user_address);
        assert!(games_played.is_some());
        assert!(games_played.destroy_some() == 2);
        let games_played = pig_master::user_top_score(user_address);
        assert!(games_played.is_some());
        let top_score = games_played.destroy_some();
        assert!(top_score.score() == 10);
        assert!(top_score.rounds() == 3);
        assert!(top_score.rolls() == 4);

        // Now, complete the game again with a lower score, the game should not update the top score
        let game_result = pig_master::complete_game(player_signer, 8, 2, 5);
        assert!(game_result.score() == 8);
        assert!(game_result.rounds() == 2);
        assert!(game_result.rolls() == 5);
        let games_played = pig_master::user_games_played(user_address);
        assert!(games_played.is_some());
        assert!(games_played.destroy_some() == 3);
        let games_played = pig_master::user_top_score(user_address);
        assert!(games_played.is_some());
        let top_score = games_played.destroy_some();
        assert!(top_score.score() == 10); // Top score should not change
        assert!(top_score.rounds() == 3);
        assert!(top_score.rolls() == 4);
    }
}
