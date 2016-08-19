//
//  Bet.swift
//  War
//
//  Created by Apple Dev on 2016-07-12.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import Foundation
import UIKit

// Globals
let startingWallet = 1000
var playerOneMoney = startingWallet
var playerTwoMoney = startingWallet
var pot = 0
var playerOneBet = 0
var playerTwoBet = 0

func bet(amount: Int) {
    guard (playerOneMoney <= 0 || playerTwoMoney <= 0) == false else {
        return
    }
    if amount > playerOneMoney {
        playerOneMoney = playerOneMoney - playerOneMoney
        playerTwoMoney = playerTwoMoney - playerOneMoney
        playerOneBet = playerOneMoney
        playerTwoBet = playerOneMoney
        pot = (playerOneMoney)*2
    } else if amount > playerTwoMoney {
        playerOneMoney = playerOneMoney - playerTwoMoney
        playerTwoMoney = playerTwoMoney - playerTwoMoney
        playerOneBet = playerTwoMoney
        playerTwoBet = playerTwoMoney
        pot = (playerTwoMoney)*2
    } else {
        playerOneMoney = playerOneMoney - amount
        playerTwoMoney = playerTwoMoney - amount
        playerOneBet = amount
        playerTwoBet = amount
        pot = (amount)*2
    }
}
func roundWinner(inout roundWinner: Int) {
    return roundWinner += pot
}

