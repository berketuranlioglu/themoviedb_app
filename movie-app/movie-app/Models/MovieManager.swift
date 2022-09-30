//
//  MovieManager.swift
//  movie-app
//
//  Created by S69512 on 9/21/22.
//

import Foundation

protocol MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, _ movieList: [MovieModel]?)
}

var movieSearchList: [MovieModel] = []

struct MovieManager {
    // when nothing is searched
    var mainPageURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=11459cff1c1ce00e3202addab99f3a91&language=en-US&page=1"
    var searchURLBase = "https://api.themoviedb.org/3/search/movie?api_key=11459cff1c1ce00e3202addab99f3a91&page=1"
    let imageURLBase = "https://image.tmdb.org/t/p/w200"
    
    var delegate: MovieManagerDelegate?
    
    func mainPageLoader() {
        performRequest(mainPageURL)
    }
    
    func fetchMovie(_ movieName: String) {
        let newMovieName = movieName.replacingOccurrences(of: " ", with: "+")
        let searchURLString = "\(searchURLBase)&query=\(newMovieName)"
        print(searchURLString)
        performRequest(searchURLString)
    }
    
    func performRequest(_ URLString: String) {
        if let url = URL(string: URLString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("error")
                }
                if let safeData = data {
                    if let movieList = parseJSON(safeData) {
                        movieSearchList += movieList
                        delegate?.didUpdateMovie(self, movieSearchList)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ movieData: Data) -> [MovieModel]? {
        let decoder = JSONDecoder()
        var movieSearchList: [MovieModel]? = []
        do {
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            for res in decodedData.results {
                let title = res.title
                print(title)
                let imageURL = imageURLBase + res.poster_path
                print(imageURL)
                let rating = res.vote_average
                print(rating)
                let date = res.release_date
                print(date)
                let overview = res.overview
                print(overview)
                
                let movie = MovieModel(name: title, image: imageURL, rating: rating, date: date, overview: overview)
                movieSearchList?.append(movie)
            }
            return movieSearchList
        } catch {
            print(error)
            return nil
        }
    }
}
