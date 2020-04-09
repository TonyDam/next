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
    private var likedGenreIds = [Int]()
    private var genreId = Int()
//    L'APPLICATION RENVOIE PROVISOIREMENT UNE LISTE DE FILMS
    private var genreMovies = [Movie]()
    
    enum State {
        case ongoing, over
    }
    var state: State = .ongoing
    
//    ¡¡¡ LE CAS OÙ IL N'Y A AUCUN FILM N'EST PAS TRAITÉ !!!
//    Le traiter à la consommation du service
    var currentMovie: Movie {
//        Le programme plante si discoverMovies est vide !!
        return discoverMovies[currentIndex]
    }
    func start() {
        print("START!")
        genreId = Int()
        likedGenreIds = [Int]()
        
        currentIndex = 0
        state = .over
                
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
            guard let movies = movies else {
                let notification = Notification(name: .errorUndefined)
                NotificationCenter.default.post(notification)
                return
            }
            self.discoverMovies = Array(movies.shuffled().prefix(3))
            self.state = .ongoing
            
            let notification = Notification(name: .discoverMoviesLoaded)
            NotificationCenter.default.post(notification)
        }
    }
    func finish() {
        state = .over
        
//        LOGIQUE MÉTIER POUR DÉTERMINER LE CHOIX
//              let likedMovies = discoverMovies.filter { $0.isLiked == true }
        
        // Si le film est liké,on fait un tableau des genres likedGenreIds
        for movie in discoverMovies {
            if movie.isLiked == true { likedGenreIds += movie.genreIds }
        }
        
        // donne les genres les plus likés, return array
        let mostCommonGenreIds = getMostCommonGenreIdsOf(array: likedGenreIds)
        
        // Prend un genre au hasard après les avoir mélangés avec .shuffled
        genreId = mostCommonGenreIds.shuffled()[0]
        
        
        MovieService.shared.getMoviesWithGenre(genreId: genreId) { (error, movies) in

            if let error = error {
                var notification: Notification
                if error == MovieService.MovieError.connection {
                    notification = Notification(name: .errorConnection)
                } else {
                    notification = Notification(name: .errorUndefined)
                }
                NotificationCenter.default.post(notification)
            }
            guard let movies = movies else {
                let notification = Notification(name: .errorUndefined)
                NotificationCenter.default.post(notification)
                return
            }
//            GENREMOVIES EST PROVISOIRE, LA SUPPRIMER PLUS TARD
//            self.genreMovies = movies
            
//            ¡¡¡ CHOISIR UN FILM DANS LES MOVIES ET LANCER LA REQUÊTE POUR OBTENIR SON POSTER
            print(movies.shuffled()[0], "Choice movie")
            
//            NotificationCenter.default.post(name: .genreMoviesLoaded, object: self, userInfo: ["genreMovies": movies])
//            NotificationCenter.default.post(name: .genreMoviesLoaded, object: self, userInfo: ["genreMovies": self.discoverMovies])
}
    }
    private func goToNextMovie() {
        currentIndex < discoverMovies.count - 1 ? currentIndex += 1 : finish()
    }
    func setLikeOfCurrentMovie(with userChoice: Bool) {
        currentMovie.setLike(with: userChoice)
        goToNextMovie()
    }
    
    private func getMostCommonGenreIdsOf(array: [Int]) -> [Int] {
        
        var topGenreIds: [Int] = []
        var genreIdsDictionary: [Int: Int] = [:]
        
        for genreId in array {
            if let count = genreIdsDictionary[genreId] {
                genreIdsDictionary[genreId] = count + 1
            } else {
                genreIdsDictionary[genreId] = 1
            }
        }
        
        let highestValue = genreIdsDictionary.values.max()
        
        for (genreId, _) in genreIdsDictionary {
            if genreIdsDictionary[genreId] == highestValue {
                topGenreIds.append(genreId)
            }
        }
        
        return topGenreIds
    }
}


extension Notification.Name {
    static let discoverMoviesLoaded = Notification.Name("discoverMoviesLoaded")
    static let genreMoviesLoaded = Notification.Name("genreMoviesLoaded")
    static let errorUndefined = Notification.Name("errorUndefined")
    static let errorConnection = Notification.Name("errorConnection")
}
