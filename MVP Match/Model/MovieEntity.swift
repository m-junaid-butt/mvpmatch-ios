//
//  MovieEntity.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/15/22.
//

import Foundation
import RealmSwift

@objcMembers class MovieEntity: Object {
    dynamic var title: String = ""
    dynamic var year: String = ""
    dynamic var released: String = ""
    dynamic var plot: String = ""
    dynamic var poster: String = ""
    dynamic var imdbRating: String = ""
    dynamic var id: String = ""
    dynamic var isFavourite: Bool = false
    dynamic var isHidden: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
