//
//  HomeCollectionViewCell.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/8/22.
//

import UIKit
import SDWebImage

protocol HomeCollectionViewProtocol: AnyObject {
    func favouriteMovies(indexPath: IndexPath)
    func hideMovies(indexPath: IndexPath)
}

class HomeCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var addFavouriteBtn: UIButton!
    @IBOutlet weak var hiddenBtn: UIButton!
    @IBOutlet weak var overlayView: UIView!
    
    var favButtonPressed : (() -> ()) = {}
    var hiddenButtonPressed : (() -> ()) = {}
    
    weak var delegate: HomeCollectionViewProtocol?
    var indexPath: IndexPath?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addFavouriteBtn.setImage(UIImage(named: "star-empty"), for: .normal)
    }
    
    func configure (movie: Movie?) {
        moviePosterImageView.layer.cornerRadius = 12
        overlayView.layer.cornerRadius = 12
        self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        if let url = movie?.poster, let title = movie?.title {
            moviePosterImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "film-poster-placeholder"))
            movieTitle.text = title
        }

    }
    
    @IBAction func addFavouriteBtnTapped(_ sender: UIButton) {
//        favButtonPressed()
        if let indexPath = indexPath {
            delegate?.favouriteMovies(indexPath: indexPath)
        }
    }
    
    @IBAction func hiddenBtnTapped(_ sender: UIButton) {
//        hiddenButtonPressed()
        if let indexPath = indexPath {
            delegate?.hideMovies(indexPath: indexPath)
        }
    }
    
}
