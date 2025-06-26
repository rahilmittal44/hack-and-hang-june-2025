#[test_only]
module pig_game_addr::pig_game_tests {
    use std::signer;
    use pig_game_addr::pig_game;
    use pig_master_addr::pig_master;

    #[test(user = @0x123)]
    fun test_initial_state(user: &signer) {
        let user_addr = signer::address_of(user);
        
        // Initially, all values should be 0 or false
        assert!(pig_game::last_roll(user_addr) == 0, 1);
        assert!(pig_game::round(user_addr) == 0, 2);
        assert!(pig_game::turn(user_addr) == 0, 3);
        assert!(pig_game::game_over(user_addr) == false, 4);
        assert!(pig_game::turn_score(user_addr) == 0, 5);
        assert!(pig_game::total_score(user_addr) == 0, 6);
        assert!(pig_game::user_games_played(user_addr) == 0, 7);
    }

    #[test(user = @0x123)]
    fun test_roll_dice_non_bust(user: &signer) {
        let user_addr = signer::address_of(user);
        
        // Test rolling a 5 (non-bust)
        pig_game::roll_dice_for_test(user, 5);
        
        assert!(pig_game::last_roll(user_addr) == 5, 1);
        assert!(pig_game::round(user_addr) == 1, 2);
        assert!(pig_game::turn(user_addr) == 0, 3); // Turn doesn't increment on non-bust
        assert!(pig_game::turn_score(user_addr) == 5, 4);
        assert!(pig_game::total_score(user_addr) == 0, 5);
    }

    #[test(user = @0x123)]
    fun test_roll_dice_bust(user: &signer) {
        let user_addr = signer::address_of(user);
        
        // First roll a 5
        pig_game::roll_dice_for_test(user, 5);
        assert!(pig_game::turn_score(user_addr) == 5, 1);
        
        // Then roll a 1 (bust)
        pig_game::roll_dice_for_test(user, 1);
        
        assert!(pig_game::last_roll(user_addr) == 1, 2);
        assert!(pig_game::round(user_addr) == 2, 3);
        assert!(pig_game::turn(user_addr) == 1, 4); // Turn increments on bust
        assert!(pig_game::turn_score(user_addr) == 0, 5); // Turn score reset
        assert!(pig_game::total_score(user_addr) == 0, 6);
    }

    #[test(user = @0x123)]
    fun test_hold(user: &signer) {
        let user_addr = signer::address_of(user);
        
        // Roll some dice to build up turn score
        pig_game::roll_dice_for_test(user, 3);
        pig_game::roll_dice_for_test(user, 4);
        
        assert!(pig_game::turn_score(user_addr) == 7, 1);
        assert!(pig_game::round(user_addr) == 2, 2);
        
        // Hold
        pig_game::hold_for_test(user);
        
        assert!(pig_game::last_roll(user_addr) == 0, 3); // Reset on hold
        assert!(pig_game::round(user_addr) == 3, 4);
        assert!(pig_game::turn(user_addr) == 1, 5); // Turn increments on hold
        assert!(pig_game::turn_score(user_addr) == 0, 6); // Turn score reset
        assert!(pig_game::total_score(user_addr) == 7, 7); // Added to total
    }

    #[test(user = @0x123, master = @pig_master_addr, game_deployer = @pig_game_addr)]
    fun test_complete_game(user: &signer, master: &signer, game_deployer: &signer) {
        pig_master::initialize_for_test(master);
        pig_game::initialize_for_test(game_deployer);
        let user_addr = signer::address_of(user);
        
        // Simulate reaching the winning score
        // Roll enough to get close to 20
        pig_game::roll_dice_for_test(user, 6);
        pig_game::roll_dice_for_test(user, 6);
        pig_game::roll_dice_for_test(user, 6);
        pig_game::hold_for_test(user); // Should have 18 points
        
        // Roll enough to win
        pig_game::roll_dice_for_test(user, 2);
        pig_game::hold_for_test(user); // Should have 20 points and game_over = true
        
        assert!(pig_game::total_score(user_addr) == 20, 1);
        assert!(pig_game::game_over(user_addr) == true, 2);
        
        // Complete the game
        pig_game::complete_game_for_test(user);
        
        assert!(pig_game::user_games_played(user_addr) == 1, 3);
        assert!(pig_game::games_played() == 1, 4);
    }

    #[test(user = @0x123)]
    fun test_reset_game(user: &signer) {
        let user_addr = signer::address_of(user);
        
        // Play some game
        pig_game::roll_dice_for_test(user, 5);
        pig_game::hold_for_test(user);
        
        assert!(pig_game::total_score(user_addr) == 5, 1);
        assert!(pig_game::round(user_addr) == 2, 2);
        
        // Reset
        pig_game::reset_game_for_test(user);
        
        // Should be back to initial state
        assert!(pig_game::last_roll(user_addr) == 0, 3);
        assert!(pig_game::round(user_addr) == 0, 4);
        assert!(pig_game::turn(user_addr) == 0, 5);
        assert!(pig_game::game_over(user_addr) == false, 6);
        assert!(pig_game::turn_score(user_addr) == 0, 7);
        assert!(pig_game::total_score(user_addr) == 0, 8);
    }

    #[test(user = @0x123)]
    #[expected_failure(abort_code = pig_game_addr::pig_game::E_GAME_OVER)]
    fun test_cannot_roll_when_game_over(user: &signer) {
        // Simulate winning the game
        pig_game::roll_dice_for_test(user, 6);
        pig_game::roll_dice_for_test(user, 6);
        pig_game::roll_dice_for_test(user, 6);
        pig_game::hold_for_test(user); // 18 points
        
        pig_game::roll_dice_for_test(user, 2);
        pig_game::hold_for_test(user); // 20 points, game over
        
        // This should fail
        pig_game::roll_dice_for_test(user, 3);
    }

    #[test(user = @0x123)]
    #[expected_failure(abort_code = pig_game_addr::pig_game::E_GAME_OVER)]
    fun test_cannot_hold_when_game_over(user: &signer) {
        // Simulate winning the game
        pig_game::roll_dice_for_test(user, 6);
        pig_game::roll_dice_for_test(user, 6);
        pig_game::roll_dice_for_test(user, 6);
        pig_game::hold_for_test(user); // 18 points
        
        pig_game::roll_dice_for_test(user, 2);
        pig_game::hold_for_test(user); // 20 points, game over
        
        // This should fail
        pig_game::hold_for_test(user);
    }

    #[test(user = @0x123)]
    #[expected_failure(abort_code = pig_game_addr::pig_game::E_GAME_NOT_COMPLETE)]
    fun test_cannot_complete_unfinished_game(user: &signer) {
        // Play but don't finish the game
        pig_game::roll_dice_for_test(user, 5);
        pig_game::hold_for_test(user);
        
        // This should fail because game is not over
        pig_game::complete_game_for_test(user);
    }
}
