//
//  Bet.swift
//  War
//
//  Created by Apple Dev on 2016-07-12.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import Foundation
import UIKit

var playerOneMoney = 500
var playerTwoMoney = 500
var pot = 0
var playerOneBet = 0
var playerTwoBet = 0

func bet(amount: Int) {
    playerOneMoney = playerOneMoney - amount
    playerTwoMoney = playerTwoMoney - amount
    playerOneBet += amount
    playerTwoBet += amount
    pot += (amount)*2
}



func roundWinner(inout roundWinner: Int) {
    return roundWinner += pot
    
    
}

