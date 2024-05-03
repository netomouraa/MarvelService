//
//  MarvelCharacter.swift
//  MarvelService
//
//  Created by Neto Moura on 30/04/24.
//

import Foundation

public struct MarvelCharacter: Identifiable, Decodable {
    public let id: Int
    public let name: String
    public let description: String
    public let modified: String
    public let thumbnail: MarvelThumbnail
    public let comics: MarvelCollection
    public let series: MarvelCollection
    public let stories: MarvelCollection
    public let events: MarvelCollection
    public let urls: [MarvelURLInfo]
    public var isFavorite: Bool?
}
