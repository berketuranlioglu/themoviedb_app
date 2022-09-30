//
//  DetailViewController.swift
//  movie-app
//
//  Created by S69512 on 9/23/22.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var selectedMovie: MovieModel!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializer()
        self.title = movieName.text
    }
    
    func initializer() {
        movieImage.kf.setImage(with: URL(string: selectedMovie.image))
        movieImage.layer.cornerRadius = 15.0
        
        movieName.text = selectedMovie.name
        movieRating.text = String(selectedMovie.rating)
        movieDate.text = selectedMovie.date
        movieOverview.text = selectedMovie.overview
    }
}
