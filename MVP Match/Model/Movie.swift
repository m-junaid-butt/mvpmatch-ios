//
//  Movie.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/8/22.
//

import Foundation
import RealmSwift

class Movie: Codable {
    var title: String?
    var year: String?
    var released: String?
    var plot: String?
    var poster: String?
    var imdbRating: String?
    var imdbID: String?
    var isFavourite: Bool = false
    var isHidden: Bool = false
}

extension Movie {
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case released = "Released"
        case plot = "Plot"
        case poster = "Poster"
        case imdbRating
        case imdbID
    }
}






