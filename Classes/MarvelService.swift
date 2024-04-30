//
//  MarvelService.swift
//  MarvelService_Example
//
//  Created by Neto Moura on 30/04/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import CryptoKit

public protocol MarvelServiceProtocol {
    func fetchCharacters(completion: @escaping (Result<[MarvelCharacter], Error>) -> Void)
}

@available(iOS 13.0, *)
public class MarvelService {
    @Published var characters: [MarvelCharacter] = []
     
    public static let shared = MarvelService()

    private let publicKey = "d05c8e9956339435c43e94a1f690108f"
    private let privateKey = "26d54e7f9ab1c783ee61de7d5c3f9d156b24f0c0"
    
    public init() {}

    public func fetchCharacters(completion: @escaping (Result<[MarvelCharacter], Error>) -> Void) {
        let ts = String(Date().timeIntervalSince1970)
        let hash = md5("\(ts)\(privateKey)\(publicKey)")
        
        let urlString = "https://gateway.marvel.com/v1/public/characters?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(MarvelResponse.self, from: data)
                let characters = result.data.results
                if characters.isEmpty {
                    completion(.failure(NSError(domain: "Empty character list", code: 0, userInfo: nil)))
                } else {
                    completion(.success(characters))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func md5(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }

}
