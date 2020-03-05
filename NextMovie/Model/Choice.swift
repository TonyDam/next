//
//  Choice.swift
//  NextMovie
//
//  Created by TonyDam on 09/01/2020.
//  Copyright © 2020 TonyDam. All rights reserved.
//

import Foundation

class Choice {
    private var discoverMovies = [Movie]()
    private var currentIndex = 0
    private var likedMovies = [Movie]()
    
    enum State {
        case ongoing, over
    }
    var state: State = .ongoing
    
    var currentMovie: Movie {
        return discoverMovies[currentIndex]
    }
    func start() {
        likedMovies = [Movie]()
        currentIndex = 0
        state = .ongoing
        
        MovieService.shared.getDiscoverMovies { (error, movies) in
            if let error = error {
                var notification: Notification
                if error == MovieService.MovieError.connection {
                    notification = Notification(name: .errorConnection)
                } else {
                    notification = Notification(name: .errorUndefined)
                }
                NotificationCenter.default.post(notification)
            }
            // Informer que nous avons les films
//            Je déballe movies
            guard let movies = movies else {
                let notification = Notification(name: .errorUndefined)
                NotificationCenter.default.post(notification)
                return
            }
            movies.forEach { (movie) in
                print(movie.title)
            }
//            Sert à récupérer 10 films dans le désordre parmis les 20 que l'API nous renvoi avec .prefix(10) le set le met dans le desordre
            self.discoverMovies = Array(movies.shuffled().prefix(10))
            self.discoverMovies.forEach { (movie) in
                print(movie.title)
            }
            self.state = .ongoing
            
            let notification = Notification(name: .discoverMoviesLoaded)
            NotificationCenter.default.post(notification)
        }
    }
    func finish() {

    }
    private func goToNextMovie() {
        currentIndex < discoverMovies.count - 1 ? currentIndex += 1 : finish()
    }
    private func setLikeOfCurrentMovie(with userChoice: Bool) {
        currentMovie.setLike(with: userChoice)
        goToNextMovie()
    }
}

extension Notification.Name {
    static let discoverMoviesLoaded = Notification.Name("discoverMoviesLoaded")
    static let errorUndefined = Notification.Name("errorUndefined")
    static let errorConnection = Notification.Name("errorConnection")
}
