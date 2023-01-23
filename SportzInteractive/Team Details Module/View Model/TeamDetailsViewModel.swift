//
//  TeamDetailsViewModel.swift
//  SportzInteractive
//
//  Created by Neosoft on 23/01/23.
//

import Foundation

class TeamDetailsViewModel {
    
    private var fixture: MatchDetailResponse?
    private var teamHomeID: String = ""
    private var teamAwayID: String = ""
    
    var filterOprions = ["All"]
    
    init(fixture: MatchDetailResponse?) {
        self.fixture = fixture
        self.teamHomeID = fixture?.matchdetail?.teamHome ?? ""
        self.teamAwayID = fixture?.matchdetail?.teamAway ?? ""
        
        filterOprions.append(fixture?.teams?[self.teamHomeID]?.nameFull ?? "")
        filterOprions.append(fixture?.teams?[self.teamAwayID]?.nameFull ?? "")
    }
    
    var homeTeam: [Player]? {
        return fixture?.teams?[self.teamHomeID]?.players?.values.map({ return $0 })
    }
    
    var awayTeam: [Player]? {
        return fixture?.teams?[self.teamAwayID]?.players?.values.map({ return $0 })
    }
    
    var homeTeamName: String? {
        return fixture?.teams?[self.teamHomeID]?.nameFull
    }
    
    var awayTeamName: String? {
        return fixture?.teams?[self.teamAwayID]?.nameFull
    }
}
