//
//  Response.swift
//  MarvelService_Example
//
//  Created by Neto Moura on 30/04/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public struct MarvelResponse: Decodable {
    public let code: Int
    public let status: String
    public let data: MarvelCharacterDataWrapper
}
