//
//  MovieSearch.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/15/22.
//

import Foundation

class MoviesSearch: Codable {
    var search: [Movie]?
}

extension MoviesSearch {
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
