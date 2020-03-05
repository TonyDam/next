//
//  MovieService.swift
//  NextMovie
//
//  Created by TonyDam on 12/12/2019.
//  Copyright © 2019 TonyDam. All rights reserved.
//

import Foundation
import SwiftyJSON

//Création d'une class qui effectuera les requetes vers l'API de dbmovie
class MovieService {
//    Récupération des films
    private let movieApi = "https://api.themoviedb.org/3"
//    Récupération des affiches de film
    private let picture = "https://image.tmdb.org/t/p/w200"
//    Renseignement de notre clé API obtenu sur dbmovie
    private let apiKey = "c41ea1cbc433b4b5a985db3338b8b7a4"
    // private let discoverUrl = URL(string: "\(movieApi)/discover/movie?api_key=\(apiKey)&region=FR")!
    private var discoverUrl : URL {
        return URL(string: "\(movieApi)/discover/movie?api_key=\(apiKey)&region=FR")!
    }

    static let shared = MovieService()
    private init() {}
    
    enum MovieError {
        case connection
        case undefined
        case response
        case statusCode
        case data
        case pictures
    }
    
    
    func getDiscoverMovies(completion: @escaping (MovieError?, [Movie]?) -> Void) {
        let task = URLSession.shared.dataTask(with: discoverUrl) { (data, response, error) in
            
//            traiter error
            if let error = error as? URLError {
                if error.code == URLError.Code.notConnectedToInternet {
                    print("ERROR BECAUSE NOT CONNECTED TO INTERNET")
                    completion(MovieError.connection, nil)
                    return
                } else {
                    print("UNDEFINED PICTURE ERROR")
                    completion(MovieError.undefined, nil)
                    return
                }
            }
            
//            Traiter response
            guard let response = response as? HTTPURLResponse else {
                completion(MovieError.response, nil)
                return
            }
            guard response.statusCode == 200 else {
                completion(MovieError.statusCode, nil)
                return
            }
            
//            Traiter data
            guard let data = data else {
                completion(MovieError.data, nil)
                return
            }
//            Récupérer la propriété "results" du JSON
            let results = JSON(data)["results"]
            
//            Créer un tableau vide
            var movies = [(title: String, posterPath: String, releaseDate: String, releaseYear: String, id: String, description: String )]()
            
//            Remplir le tableau // Verifier si aucune propriété n'est égale à null - todo
            for movie in results.arrayValue {
                let title = movie["title"].stringValue
                let posterPath = movie["poster_path"].stringValue
                let id = movie["id"].stringValue
                let description = movie["description"].stringValue
                let releaseDate = movie["release_date"].stringValue
                let releaseYear = "(\(releaseDate.split(separator: "-")[0]))" // 2019-01-17 deviens ["2019", "01", "17"], on veut le numéro 0 de l'Array donc c'est 2019
                
                movies.append((title: title, posterPath: posterPath, releaseDate: releaseDate, id: id, description: description, releaseYear: releaseYear))
                
            }
//            Pour chaque film de movies, récupérer le poster puis créer une instance de Movie
//            Cela se fera dans une boucle for movie in movies {...}
            var discoverMovies = [Movie]()
            
//            Créer un groupe de tâche (GCP) pour gérer l'asynchrone sur SWIFT
            let group = DispatchGroup()
            for movie in movies {
                group.enter()
//                Obtenir un poster
                self.getPoster(movie.posterPath) { (poster) in
//                    Je verifie si sa existe, que poster ne vaut pas nil
                    guard let poster = poster else {
                        completion(MovieError.pictures, nil)
                        group.leave()
                        return
                    }
//                Créer l'instance de movie que j'appel discoverMovies avec le poster, le title etc.
                    let discoverMovie = Movie(title: movie.title, poster: poster, releaseDate: movie.releaseYear, isLiked: nil, id: movie.releaseDate, description: movie.id, releaseYear: movie.description)
//                Ajouter ce movie à un tableau discoverMovies
                    discoverMovies.append(discoverMovie)
                    group.leave()
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                completion(nil, discoverMovies)
            }
        }
        task.resume()
    }
    private func getPoster(_ posterPath: String, pictureCompletionHandler: @escaping (Data?) -> Void) {
        let posterUrl = URL(string: "\(picture)\(posterPath)")!
        let task = URLSession.shared.dataTask(with: posterUrl) { (data, response, error) in
            if let error = error as? URLError {
                if error.code == URLError.Code.notConnectedToInternet {
                    print("ERROR BECAUSE NOT CONNECTED TO INTERNET")
                    pictureCompletionHandler(nil)
                    return
                } else {
                    print("UNDEFINED ERROR")
                    pictureCompletionHandler(nil)
                    return
                }
            }
            guard let response = response as? HTTPURLResponse else {
                print("PICTURE ERROR WITH THE RESPONSE")
                pictureCompletionHandler(nil)
                return
            }
            guard response.statusCode == 200 else {
                print("PICTURE ERROR WITH THE STATUS CODE:", response.statusCode )
                pictureCompletionHandler(nil)
                return
            }
            guard let poster = data else {
                print("PICTURE ERROR WITH THE DATA")
                pictureCompletionHandler(nil)
                return
            }
            pictureCompletionHandler(poster)
            
        }
        task.resume()
    }
}
