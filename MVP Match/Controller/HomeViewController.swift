//
//  HomeViewController.swift
//  MVP Match
//
//  Created by Junaid Butt on 2/8/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let movieService = MovieService()
    private var movies: [Movie] = []
    private var favouriteMovies: [Movie] = []
    private var hiddenMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
        
        self.title = "Movies"
        
        getFavouriteMovies()
        getHiddenMovies()
    }
    
    //MARK: - Search Movie Api call
    private func getSearchedMovies(with title: String) {
        self.showActivityView()
        movieService.fetchSearchMovies(with: title) { [weak self] movies, errorMessage in
            guard let self = self else {return}
            self.hideActivityView()
            if let errorMessage = errorMessage {
                self.showAlert(title: "Error", message: errorMessage)
            } else {
                guard let movies = movies, var searchMovies = movies.search else {
                    print("Movies is empty")
                    return
                }
                
                // Favourite Movies show
                for movie in searchMovies {
                    for favouriteMovie in self.favouriteMovies {
                        if movie.imdbID == favouriteMovie.imdbID {
                            movie.isFavourite = true
                            continue
                        }
                    }
                }
                
                //Hidden Movies show
                for movie in searchMovies {
                    for hiddenMovie in self.hiddenMovies {
                        if movie.imdbID == hiddenMovie.imdbID {
                            if let index = searchMovies.firstIndex(where: {$0.imdbID == hiddenMovie.imdbID}) {
                                movie.isHidden = true
                                searchMovies.remove(at: index)
                                continue
                            }
                        }
                    }
                }
                self.movies = searchMovies
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Get Favourite movies
    func getFavouriteMovies () {
        let favMovies = MoviePersistenceManager.shared.fetch().filter({$0.isFavourite == true})
        self.favouriteMovies = favMovies
        self.movies = favMovies
        self.collectionView.reloadData()
    }
    
    //MARK: - Get Hidden movies
    func getHiddenMovies() {
        let hiddenMovies = MoviePersistenceManager.shared.fetch().filter({$0.isHidden == true})
        self.hiddenMovies = hiddenMovies
    }
}

//MARK: -  Collectionview Delegate & Datasource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchBar.text == "" {
            return favouriteMovies.count
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        var movie: Movie?
        
        if searchBar.text == "" {
            movie = favouriteMovies[indexPath.row]
            cell.hiddenBtn.isHidden = true
        } else {
            movie =  self.movies[indexPath.row]
            cell.hiddenBtn.isHidden = false
            
        }
        
        cell.configure(movie: movie)
        cell.delegate = self
        cell.indexPath = indexPath
        
        let imageName = (movie?.isFavourite ?? false) ? "star" : "star-empty"
        cell.addFavouriteBtn.setImage(UIImage(named: imageName), for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailViewController.instantiate()
        
        if searchBar.text == "" {
            vc.imdbID = favouriteMovies[indexPath.row].imdbID ?? ""
        } else {
            vc.imdbID = movies[indexPath.row].imdbID ?? ""
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Collectionview Flow Layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width/2.0
        let yourHeight = yourWidth + 100
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - Home Collectionview Protocol
extension HomeViewController: HomeCollectionViewProtocol {
    
    //MARK: - Favourite Movies Delegate
    func favouriteMovies(indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        if movie.isFavourite {
            for favMovie in self.favouriteMovies {
                if favMovie.imdbID == movie.imdbID {
                    //find index and them remove from user default
                    if let index = self.favouriteMovies.firstIndex(where: {$0.imdbID == movie.imdbID}) {
                        
                        if self.searchBar.text == "" {
                            MoviePersistenceManager.shared.deleteMovie(id: favouriteMovies[indexPath.row].imdbID ?? "")
                            self.favouriteMovies.remove(at: indexPath.row)
                            
                        } else {
                            movie.isFavourite = false
                            MoviePersistenceManager.shared.deleteMovie(id: favouriteMovies[index].imdbID ?? "")
                            self.favouriteMovies.remove(at: index)
                        }
                        
                        break
                    }
                }
            }
            
        } else {
            movie.isFavourite = true
            self.favouriteMovies.append(movie)
            MoviePersistenceManager.shared.save(movies: self.favouriteMovies)
        }
        self.collectionView.reloadData()
        
    }
    
    //MARK: - Hidden movies delegate
    func hideMovies(indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        if self.searchBar.text?.isEmpty == false {
            if movie.isHidden == false {
                self.movies.remove(at: indexPath.row)
                movie.isHidden = true
                self.hiddenMovies.append(movie)
                
                MoviePersistenceManager.shared.save(movies: self.hiddenMovies)
            }
        }
        self.collectionView.reloadData()
    }
}

//MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        if Connectivity.isConnectedToInternet {
            getSearchedMovies(with: searchBarText)
        } else {
            self.showAlert(title: "Network Error", message: "The internet Connection appears to be offline")
        }
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.movies.removeAll()
            self.favouriteMovies.removeAll()
            self.getFavouriteMovies()
            self.collectionView.reloadData()
        }
    }
}
