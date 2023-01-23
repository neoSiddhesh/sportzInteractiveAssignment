//
//  FixtureAPI.swift
//  SportzInteractive
//
//  Created by Neosoft on 20/01/23.
//

import Foundation

class FixtureAPI {
    
   private func callNZvsINDFixtureAPI(completion: @escaping (Result<MatchDetailResponse, Error>) -> Void) {
        NetworkService.shared.apiCall(callURL: APIConfig.baseURL + APIConfig.NZvsINDFixtrue,
                                      responseType: MatchDetailResponse.self) { result in
            switch result {
            case .success(let responseData):
                completion(.success(responseData))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func callSAvsPAKFixtureAPI(completion: @escaping (Result<MatchDetailResponse, Error>) -> Void) {
        NetworkService.shared.apiCall(callURL: APIConfig.baseURL + APIConfig.SAvsPAKFixture,
                                      responseType: MatchDetailResponse.self) { result in
            switch result {
            case .success(let responseData):
                completion(.success(responseData))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchAllFixtures(completion: @escaping ([MatchDetailResponse]) -> Void) {
        var fixtures = [MatchDetailResponse]()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        callNZvsINDFixtureAPI { result in
            switch result {
            case .success(let responseData):
                fixtures.append(responseData)
            case .failure(let error):
                print(error.localizedDescription)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        callSAvsPAKFixtureAPI{ result in
            switch result {
            case .success(let responseData):
                fixtures.append(responseData)
            case .failure(let error):
                print(error.localizedDescription)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(fixtures)
        }
    }
}
