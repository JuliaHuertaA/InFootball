//
//  FootballData.swift
//  InFootball
//
//  Created by Mac7 on 29/01/21.
//

import Foundation

struct FootballData: Decodable {
    let scorers : [Scorers]
}
struct Scorers:Decodable {
    let player : Player
    let team : Team
    let numberOfGoals : Int
}

struct Player: Decodable {
    let name : String
}

struct Team: Decodable {
    let name : String
}
