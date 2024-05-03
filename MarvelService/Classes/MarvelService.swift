//
//  MarvelService.swift
//  MarvelService_Example
//
//  Created by Neto Moura on 30/04/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import CryptoKit

import Foundation
import Combine
import CryptoKit

@available(iOS 13.0, *)
public class MarvelService {
    @Published var characters: [MarvelCharacter] = []
    
    public static let shared = MarvelService()
    
    private let publicKey = "d05c8e9956339435c43e94a1f690108f"
    private let privateKey = "26d54e7f9ab1c783ee61de7d5c3f9d156b24f0c0"
    
    private var cancellable: AnyCancellable?
    
    private let networkManager = NetworkManager.shared
    
    public init() {
        networkManager.startMonitoring()
    }
    
    deinit {
        networkManager.stopMonitoring()
    }
    
    public func fetchCharacters(name: String? = nil, limit: Int, offset: Int) -> AnyPublisher<[MarvelCharacter], Error> {
        guard networkManager.isConnectedToInternet else {
            return Fail(error: NSError(domain: "No internet connection", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        var queryString = ""
        if let name = name {
            queryString += "&name=\(name)"
        }
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = md5("\(ts)\(privateKey)\(publicKey)")
        
        let urlString = "https://gateway.marvel.com/v1/public/characters?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)&limit=\(limit)&offset=\(offset)\(queryString)"

        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
                }
                return data
            }
            .tryMap { data -> [MarvelCharacter] in
                let result = try JSONDecoder().decode(MarvelResponse.self, from: data)
                let characters = result.data.results
                guard !characters.isEmpty else {
                    throw NSError(domain: "Empty character list", code: 0, userInfo: nil)
                }
                return characters
            }
            .mapError { error in
                if let error = error as? NSError {
                    return error
                } else {
                    return NSError(domain: "Unknown error", code: 0, userInfo: nil)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func md5(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
