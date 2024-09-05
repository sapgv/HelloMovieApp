//
//  MovieListCell.swift
//  HelloMovieApp
//
//  Created by Grigory Sapogov on 05.09.2024.
//

import UIKit

class MovieListCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieYearLabel: UILabel!
    
    @IBOutlet weak var movieDurationLabel: UILabel!
    
    var movie: Movie?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieImageView.image = nil
    }
    
    func setup(movie: Movie) {
        self.movie = movie
        self.movieTitleLabel.text = movie.name
        self.movieYearLabel.text = "\(movie.year)"
        self.movieDurationLabel.text = movie.durationTitle
    }
    
}
