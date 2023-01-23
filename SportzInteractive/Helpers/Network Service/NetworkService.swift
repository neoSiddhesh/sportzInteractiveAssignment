//
//  NetworkService.swift
//  SportzInteractive
//
//  Created by Neosoft on 20/01/23.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {    }
    
    func apiCall<T: Decodable>(callURL: String,
                               method: HTTPMethod = .get,
                               headerType: HTTPHeaderType =  .contentType,
                               headerValue: HTTPHeaderValue = .application_json,
                               responseType: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: callURL) else { return }
        
        var request = URLRequest(url: url)
        request.setValue(headerValue.rawValue, forHTTPHeaderField: headerType.rawValue)
        request.httpMethod = method.rawValue
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

enum HTTPHeaderType: String {
    case contentType = "Content-Type"
    case auth = "Authentication"
    case accept = "Accept"
}

enum HTTPHeaderValue: String {
    case application_json = "application/json"
    case formUrlEncoded = "application/x-www-form-urlencoded"
}
