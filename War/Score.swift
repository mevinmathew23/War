//
//  Score.swift
//  War
//
//  Created by Apple Dev on 2016-07-06.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import Foundation
import UIKit


let war = War()
var playerOneScore: Int

func scoreKeeper() {
    playerOneScore = war.playerOneCards.count + war.playerOneCardsInPlay.count + war.playerOneStorage.count
    var playerTwoScore = war.playerTwoCards.count + war.playerTwoCardsInPlay.count + war.playerTwoStorage.count
}
