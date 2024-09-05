//
//  MovieDetailViewController.swift
//  HelloMovieApp
//
//  Created by Grigory Sapogov on 05.09.2024.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    
    var movieService: MovieService!
    
    private var movieDetail: MovieDetail?
    
    private let movieImageView = UIImageView()
    
    private let movieTitleLabel = UILabel()
    
    private let movieYearLabel = UILabel()
    
    private let movieDurationLabel = UILabel()
    
    private let movieSloganLabel = UILabel()
    
    private let movieDescriptionLabel = UILabel()
    
    private let stackView = UIStackView()
    
    private let scrollView = ScrollViewAutolayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = self.movie.name
        self.setupScrollView()
        self.setupStackView()
        self.setupImageView()
        self.setupLabels()
        self.layoutView()
        self.updateData()
    }
    
}

extension MovieDetailViewController {
    
    private func setupScrollView() {
        self.scrollView.alwaysBounceVertical = true
    }
    
    private func setupStackView() {
        self.stackView.axis = .vertical
        self.stackView.spacing = 8
    }
    
    private func setupImageView() {
        self.movieImageView.contentMode = .scaleAspectFit
    }
    
    private func setupLabels() {
        
        self.movieTitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        self.movieTitleLabel.numberOfLines = 0
        self.movieTitleLabel.lineBreakMode = .byWordWrapping
        
        self.movieYearLabel.textColor = .secondaryLabel
        self.movieDurationLabel.textColor = .secondaryLabel
        
        self.movieSloganLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        self.movieSloganLabel.numberOfLines = 0
        self.movieSloganLabel.lineBreakMode = .byWordWrapping
        
        self.movieDescriptionLabel.numberOfLines = 0
        self.movieDescriptionLabel.lineBreakMode = .byWordWrapping
        
    }
    
    private func layoutView() {
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.scrollView.contentView.addSubview(stackView)
        
        self.stackView.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor, constant: 8).isActive = true
        self.stackView.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor, constant: 8).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: scrollView.contentView.trailingAnchor, constant: -8).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: scrollView.contentView.bottomAnchor, constant: -8).isActive = true
        
        self.stackView.addArrangedSubview(movieImageView)
        
        self.movieImageView.widthAnchor.constraint(equalTo: self.movieImageView.heightAnchor).isActive = true

        self.movieTitleLabel.setContentHuggingPriority(.init(250), for: .vertical)
        
        self.stackView.addArrangedSubview(movieTitleLabel)
        self.stackView.addArrangedSubview(movieYearLabel)
        self.stackView.addArrangedSubview(movieDurationLabel)
        self.stackView.addArrangedSubview(movieSloganLabel)
        self.stackView.addArrangedSubview(movieDescriptionLabel)
        
    }
    
    private func updateData() {
        
        self.movieService.fetchImage(posterUrl: self.movie.posterUrl) { [weak self] result in
            
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
                self?.movieImageView.image = nil
            case let .success(image):
                self?.movieImageView.image = image
            }
            
        }
        
        self.movieService.fetchMovieDetail(movieId: self.movie.id) { [weak self] result in
            
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(movieDetail):
                self?.movieDetail = movieDetail
                self?.updateView()
            }
            
        }
        
    }
    
    private func updateView() {
        guard let movieDetail = self.movieDetail else { return }
        self.movieTitleLabel.text = movieDetail.name
        self.movieTitleLabel.isHidden = movieDetail.name.isEmpty
        self.movieYearLabel.text = "\(movieDetail.year)"
        self.movieYearLabel.isHidden = movieDetail.year == 0
        self.movieDurationLabel.text = movieDetail.durationTitle
        self.movieDurationLabel.isHidden = movieDetail.durationTitle.isEmpty
        self.movieSloganLabel.text = movieDetail.slogan
        self.movieSloganLabel.isHidden = (movieDetail.slogan ?? "").isEmpty
        self.movieDescriptionLabel.text = movieDetail.description
        self.movieDescriptionLabel.isHidden = (movieDetail.description ?? "").isEmpty
    }
    
}
