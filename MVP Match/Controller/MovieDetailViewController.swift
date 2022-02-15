//
//  MovieDetailViewController.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/8/22.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    
    static func instantiate() -> MovieDetailViewController {
        let name = String(describing: MovieDetailViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: name)
        return viewController as! MovieDetailViewController
    }
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var movieDescriptionLbl: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    
    let movieService = MovieService()
    var imdbID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if Connectivity.isConnectedToInternet {
            getMovieDetail()
        } else {
            self.showAlert(title: "Network Error", message: "Your internet Connection appears to be offline")
        }
    }
    
    func getMovieDetail () {
        self.showActivityView()
        movieService.fetchMovies(with: imdbID) {[weak self] movie, errorMessage in
            guard let self = self else {return}
            self.hideActivityView()
            if let errorMessage = errorMessage {
                self.showAlert(title: "Error", message: errorMessage)
            } else {
                guard let movie = movie else {return}
                if let url =  URL(string: movie.poster ?? "") {
                    self.moviePosterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "film-poster-placeholder"))
                } else {
                    self.moviePosterImageView.image = UIImage(named: "film-poster-placeholder")
                }
                self.movieNameLbl.text = movie.title
                self.movieDescriptionLbl.text = movie.plot
                self.movieRating.text = movie.imdbRating ?? "" + "/10"
            }
        }
    }
}
