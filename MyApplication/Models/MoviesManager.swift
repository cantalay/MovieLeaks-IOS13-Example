//
//  MoviesManager.swift
//  MyApplication
//
//  Created by Can Talay on 29.12.2019.
//  Copyright © 2019 Can Talay. All rights reserved.
//

import Foundation

protocol MoviesManagerDelegate {
    func didUpdateMovies(movies: [Movies]?)
    func didFailWithError(error: Error?)
    func didSelectMovies(movie: MoviesDetail)
}

struct MoviesManager {
    var moviesURL = "https://www.omdbapi.com/?apikey=45b8f250"
    
    var delegate: MoviesManagerDelegate?
    func fetchMovie(search: String) {
        let urlString = "\(moviesURL)&s=\(search)"
        performRequest(with: urlString, isImdbId: false)
    }
    func fetchMovie(imdbID: String) {
        let urlString = "\(moviesURL)&i=\(imdbID)&plot=full"
        performRequest(with: urlString, isImdbId: true)
    }
    
    func performRequest(with urlString: String, isImdbId: Bool) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url){(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                if let optionalData = data {
                    if isImdbId {
                        if let moviesModel = self.parseJson(moviesImdbData: optionalData) {
                            print("MOVIE MODEL : \(moviesModel.title)")
                            self.delegate?.didSelectMovies(movie: moviesModel)
                        //self.delegate?.didUpdateMovies(movies: moviesModel)
                        }
                    }else{
                        if let moviesModel = self.parseJson(moviesData: optionalData){
                            self.delegate?.didUpdateMovies(movies: moviesModel)
                        }
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJson(moviesData: Data) -> [Movies]? {
        let decoder = JSONDecoder()
        do{
            print("SEARCH")
            var moviesModelList: [Movies] = []
            let decodedData = try decoder.decode(MoviesData.self, from: moviesData)
            for item in decodedData.Search {
                let title = item.Title
                let year = item.Year
                let imdbID = item.imdbID
                let type = item.Type
                let poster = item.Poster
                let moviesModel = Movies(title: title, year: year, imdbID: imdbID,Type: type, poster: poster)
                moviesModelList.append(moviesModel)
            }
            
            return moviesModelList
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseJson(moviesImdbData: Data) -> MoviesDetail? {
        let decoder = JSONDecoder()
        do{
            print("IMDB")
            let decodedData = try decoder.decode(MoviesDetailData.self, from: moviesImdbData)
            let title = decodedData.Title
            let genre = decodedData.Genre
            let writer = decodedData.Writer
            let actors = decodedData.Actors
            let imdbRating = decodedData.imdbRating
            let metaScore = decodedData.Metascore
            let imdbVotes = decodedData.imdbVotes
            let poster = decodedData.Poster
            let plot = decodedData.Plot
            
            let moviesDetailModel = MoviesDetail(title: title, genre: genre, writer: writer, actors: actors, imdbRating: imdbRating, metaScore: metaScore, imdbVotes: imdbVotes, poster: poster, plot: plot)
            
            return moviesDetailModel
            
        }catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
