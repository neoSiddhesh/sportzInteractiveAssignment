//
//  FixtureViewModel.swift
//  SportzInteractive
//
//  Created by Neosoft on 20/01/23.
//

import Foundation

protocol FixtureViewModelOutput: AnyObject {
    func getFixtureData(data: [MatchDetailResponse]?)
}

class FixtureViewModel {
    
    private let fixtureAPI: FixtureAPI?
    
    weak var delegate: FixtureViewModelOutput?
    
    init(fixtureAPI: FixtureAPI) {
        self.fixtureAPI = fixtureAPI
    }
    
    func fetchFixtureData() {
        fixtureAPI?.fetchAllFixtures { fixtures in
            self.delegate?.getFixtureData(data: fixtures)
        }
    }
}
