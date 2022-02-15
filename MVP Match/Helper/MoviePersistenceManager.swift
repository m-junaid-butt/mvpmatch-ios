//
//  MoviePersistenceManager.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/15/22.
//

import Foundation
import RealmSwift

class MoviePersistenceManager {
    static let shared = MoviePersistenceManager()
    private var realm: Realm!
    
    private init() {
        self.realm = try! Realm()
    }
    
    func save(movies: [Movie]) {
        do {
            try self.realm.safeWrite({
                for movie in movies {
                    let singleMovie = MovieEntity()
                    singleMovie.isHidden = movie.isHidden
                    singleMovie.isFavourite = movie.isFavourite
                    singleMovie.id = movie.imdbID ?? ""
                    singleMovie.title = movie.title ?? ""
                    singleMovie.plot = movie.plot ?? ""
                    singleMovie.poster = movie.poster ?? ""
                    singleMovie.imdbRating = movie.imdbRating ?? ""
                    singleMovie.year = movie.year ?? ""
                    self.realm.add(singleMovie, update: .modified)
                }
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetch() -> [Movie] {
        let movies = Array(self.realm.objects(MovieEntity.self))
        var favouriteMovies = [Movie]()
        
        for favMovie in movies {
            let singleMovie = Movie()
            singleMovie.isHidden = favMovie.isHidden
            singleMovie.isFavourite = favMovie.isFavourite
            singleMovie.imdbID = favMovie.id
            singleMovie.title = favMovie.title
            singleMovie.plot = favMovie.plot
            singleMovie.poster = favMovie.poster
            singleMovie.imdbRating = favMovie.imdbRating
            singleMovie.year = favMovie.year
            favouriteMovies.append(singleMovie)
        }
        return favouriteMovies
    }
    
    func deleteMovie(id: String) {
        
        do {
            let object = realm.objects(MovieEntity.self).filter("id = %@", id).first
            
            try realm.write {
                if let obj = object {
                    realm.delete(obj)
                }
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
