//
//  MovieCell.swift
//  movie-app
//
//  Created by S69512 on 9/21/22.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: MovieCell.self)
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
}
