//
//  MoviesData.swift
//  MyApplication
//
//  Created by Can Talay on 29.12.2019.
//  Copyright © 2019 Can Talay. All rights reserved.
//

import Foundation

struct MoviesData: Codable {
    var Search: [Search]
}

struct Search: Codable {
    var Title: String
    var Year: String
    var imdbID: String
    var `Type`: String
    var Poster: String
}
