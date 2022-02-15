//
//  PersistenceMangaer.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/9/22.
//

import Foundation


struct PersistenceManager {
    
    static let defaults = UserDefaults.standard
    private init(){}
    
    // save Data method
    static func saveMovies(movies: [Movie]){
        do{
            let encoder = JSONEncoder()
            let encodedMovies = try encoder.encode(movies)
            defaults.setValue(encodedMovies, forKey: Constant.favouriteMovies)
        }catch let err{
            print(err)
        }
    }
    
    //retrieve data method
    static func getFavouriteMovies() -> [Movie]{
        
        guard let moviesData = defaults.object(forKey: Constant.favouriteMovies) as? Data else{return []}
        do {
            let decoder = JSONDecoder()
            let movieDecoder = try decoder.decode([Movie].self, from: moviesData)
            return movieDecoder
        } catch let err {
            print(err.localizedDescription)
            return([])
        }
    }
}
