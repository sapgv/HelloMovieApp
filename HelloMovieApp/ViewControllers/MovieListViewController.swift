//
//  MovieListViewController.swift
//  HelloMovieApp
//
//  Created by Grigory Sapogov on 05.09.2024.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var movies: [Movie] = []
    
    private let movieService: MovieService = MovieService()
    
    private let refreshControl = UIRefreshControl()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
        self.setupTableView()
        self.layoutView()
        self.updateData()
    }

    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as? MovieListCell else { return UITableViewCell() }
        
        let movie = self.movies[indexPath.row]
        
        cell.setup(movie: movie)
        
        self.fetchImage(posterUrl: movie.posterUrl) { image in
            
            guard cell.movie?.posterUrl == movie.posterUrl else { return }
            
            cell.movieImageView.image = image
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = self.movies[indexPath.row]
        
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movie = movie
        movieDetailViewController.movieService = self.movieService
        
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        
    }

}

extension MovieListViewController {
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellReuseIdentifier: "MovieListCell")
        self.refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc
    private func updateData() {
        
        self.movieService.fetchPremiere { [weak self] result in
            
            self?.refreshControl.endRefreshing()
            
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(array):
                self?.movies = array
                self?.tableView.reloadData()
            }
            
        }
        
    }
    
    private func layoutView() {
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    private func fetchImage(posterUrl: String, completion: @escaping (UIImage) -> Void) {
        
        self.movieService.fetchImage(posterUrl: posterUrl) { result in
            
            switch result {
            case let .success(image):
                completion(image)
            default:
                break
            }
            
        }
        
    }
    
}
