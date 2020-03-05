//
//  Movie.swift
//  NextMovie
//
//  Created by TonyDam on 12/12/2019.
//  Copyright © 2019 TonyDam. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var poster: Data
    var releaseDate: String
    var isLiked: Bool?
    var id: String
    var description: String
    var releaseYear: String
//   Obtenir l'année du film dans le releaseDate
//    var releaseYear: String {
//        return poster.
//    }
    
    init(title: String, poster: Data, releaseDate: String, isLiked: Bool?, id: String, description: String, releaseYear: String ) {
        self.title = title
        self.poster = poster
        self.releaseDate = releaseDate
        self.isLiked = isLiked
        self.id = id
        self.description = description
        self.releaseYear = releaseYear
    }
    
    func setLike(with userChoice: Bool) {
        isLiked = userChoice
    }
    
}
