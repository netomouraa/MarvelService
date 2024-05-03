//
//  MarvelCollection.swift
//  MarvelService
//
//  Created by Neto Moura on 30/04/24.
//

import Foundation

public struct MarvelCollection: Decodable {
    public let available: Int
    public let collectionURI: String
    public let items: [MarvelCollectionItem]
    public let returned: Int
}
