//
//  MarvelCharacterDataWrapper.swift
//  MarvelService
//
//  Created by Neto Moura on 30/04/24.
//

import Foundation

public struct MarvelCharacterDataWrapper: Decodable {
    public let offset: Int
    public let limit: Int
    public let total: Int
    public let count: Int
    public let results: [MarvelCharacter]
}
