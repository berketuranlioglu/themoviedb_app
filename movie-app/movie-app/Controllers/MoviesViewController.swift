//
//  ViewController.swift
//  movie-app
//
//  Created by S69512 on 9/21/22.
//

import UIKit
import Kingfisher

class MoviesViewController: UIViewController {

    enum Section {
        case main
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var singleCellButton: UIButton!
    @IBOutlet weak var doubleCellButton: UIButton!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MovieModel>!
    
    // to fetch the data
    var movieManager = MovieManager()
    
    var isAnythingSearched = false
    var itemSizeWidth = 1.0
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    var movieModelForSegue: [MovieModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieManager.delegate = self
        searchTextField.delegate = self
        // shows popular movies on main page on launch
        movieManager.performRequest(movieManager.mainPageURL)
        isAnythingSearched = false
        
        collectionView.collectionViewLayout = configureLayout()
        
        self.title = "The Movie DB"
    }

    func configureLayout() -> UICollectionViewCompositionalLayout {
        let groupSizeHeight = Double(screenHeight) / 4
        let horizontalSpacing = Double(screenWidth) / 16
        let verticalSpacing = Double(screenHeight) / 45.0
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemSizeWidth), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(groupSizeHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(horizontalSpacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = verticalSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontalSpacing, bottom: 0, trailing: horizontalSpacing)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource(_ movieList: [MovieModel]?) {
        dataSource = UICollectionViewDiffableDataSource<Section, MovieModel>(collectionView: self.collectionView) {
            (collectionView, indexPath, movie) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath)  as? MovieCell else {
                fatalError("Error")
            }
            
            self.movieModelForSegue = movieList
            
            let finalURL = URL(string: movie.image.description)
            
            cell.movieLabel.text = movie.name.description
            cell.movieImage.kf.setImage(with: finalURL)
            
            cell.layer.cornerRadius = 15.0
            return cell
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, MovieModel>()
        initialSnapshot.appendSections([.main])
        // kind of null-check
        if movieList!.count > 0 {
            for i in 1...movieList!.count {
                initialSnapshot.appendItems([movieList![i-1]])
            }
        }
        
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    @IBAction func gridButtonPressed(_ sender: UIButton) {
        if sender == singleCellButton {
            itemSizeWidth = 1.0
            collectionView.collectionViewLayout = configureLayout()
            // collectionView.setContentOffset(.zero, animated: false)
        } else {
            itemSizeWidth = 0.45
            collectionView.collectionViewLayout = configureLayout()
            // collectionView.setContentOffset(.zero, animated: false)
        }
    }
    
    @IBAction func loadMorePressed(_ sender: UIButton) {
        if !isAnythingSearched {
            let separatedArray = movieManager.mainPageURL.components(separatedBy: "&page=")
            let firstPartOfURL = "\(separatedArray[0])&page="
            let secondPartOfURL = Int(separatedArray[1])! + 1
            let newURL = firstPartOfURL + String(secondPartOfURL)
            movieManager.performRequest(newURL)
        } else {
            let separatedArray = movieManager.searchURLBase.components(separatedBy: "&page=")
            let firstPartOfURL = "\(separatedArray[0])&page="
            let secondPartOfURL = Int(separatedArray[1])! + 1
            movieManager.searchURLBase = firstPartOfURL + String(secondPartOfURL)
            movieManager.fetchMovie(searchTextField.text!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController, let index = collectionView.indexPathsForSelectedItems?.first {
            destination.selectedMovie = movieModelForSegue[index.row]
        }
    }
}

// MARK: UITextFieldDelegate
extension MoviesViewController: UITextFieldDelegate {
    
    // magnifier button on top right
    @IBAction func searchPressed(_ sender: UIButton) {
        // min char limit is 3
        if searchTextField.text!.count >= 3 {
            searchTextField.endEditing(true)
        }
    }
    
    // does the job when the user hits return button on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // min char limit is 3
        if searchTextField.text!.count >= 3 {
            searchTextField.endEditing(true)
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isAnythingSearched = true
        if searchTextField.text!.count >= 3 {
            movieSearchList = []
            if let movie = searchTextField.text {
                movieManager.fetchMovie(movie)
            }
        } else if searchTextField.text! == "" {
            movieManager.performRequest(movieManager.mainPageURL)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searchTextField.text!.count >= 3 {
            movieSearchList = []
            if let movie = searchTextField.text {
                movieManager.fetchMovie(movie)
            }
        }
    }
}

// MARK: MovieManagerDelegate
extension MoviesViewController: MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, _ movieList: [MovieModel]?) {
        DispatchQueue.main.async {
            self.configureDataSource(movieList)
        }
    }
}
