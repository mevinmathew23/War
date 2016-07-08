//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

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

roundWinner(&playerOneMoney)