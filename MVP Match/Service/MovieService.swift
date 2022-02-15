//
//  MovieService.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/8/22.
//

import Foundation
import Alamofire


class MovieService {
    
    func fetchSearchMovies (with title: String, completion: @escaping(MoviesSearch?,_ errorMessage: String?)->Void) {
        let url = Constant.baseUrl + "?apikey=" + Constant.ApiKey + "&s=" + title
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        AF.request(urlString!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { response in
            
            if response.error == nil {
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let json = utf8Text.data(using: .utf8)
                    print(utf8Text)
                    do {
                        let decoder = JSONDecoder()
                        let decodedJson = try decoder.decode(MoviesSearch.self, from: json!)
                        
                        if decodedJson.search == nil {
                            let error = utf8Text
                            completion(nil, error)
                        } else {
                            completion(decodedJson, nil)
                        }
                        
                    } catch let error {
                        completion(nil, error.localizedDescription)
                    }
                }
            } else {
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
    func fetchMovies (with imdbId: String, completion: @escaping(Movie?,_ errorMessage: String?)->Void) {
        let url = Constant.baseUrl + "?apikey=" + Constant.ApiKey + "&i=" + imdbId

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { response in
            
            if response.error == nil {
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let json = utf8Text.data(using: .utf8)
                    print(utf8Text)
                    do {
                        let decoder = JSONDecoder()
                        let decodedJson = try decoder.decode(Movie.self, from: json!)
                        completion(decodedJson, nil)
                    } catch let error {
                        completion(nil, error.localizedDescription)
                    }
                }
            } else {
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
}
