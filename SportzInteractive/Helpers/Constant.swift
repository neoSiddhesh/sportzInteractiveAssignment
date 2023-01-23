//
//  Constant.swift
//  SportzInteractive
//
//  Created by Neosoft on 23/01/23.
//

import Foundation

enum Constant {
    static let fixtureTableViewCell = "FixtureTableViewCell"
    static let teamDetailsVC = "TeamDetailsViewController"
    static let teamDetailTableViewCell = "TeamDetailTableViewCell"
    static let filterTitle = "Select Filter"
    static let all = "All"
    static let cancel = "Cancel"
    static let ok = "OK"
    static let battingStyle = "Batting Style: "
    static let bowlingStyle = "Bowling Style: "
    static let captainWK = " (C & WK)"
    static let wk = " (WK)"
    static let captain = " (C)"
    static let matchCenter = "Match Center"
    static let team = "Teams"
}

enum DisplayPlayers: CaseIterable {
    case homeTeam
    case awayTeam
    case allPlayers
}
