//
//  MovieRaw.swift
//  NextMovie
//
//  Created by TonyDam on 09/04/2020.
//  Copyright © 2020 TonyDam. All rights reserved.
//

import Foundation

class MovieRaw {
    var title: String
    var posterPath: String
    var releaseYear: String
    var id: String
    var genreIds: [Int]
    var overview: String
    
    init(title: String, posterPath: String, releaseYear: String, id: String, overview: String, genreIds: [Int]) {
        self.title = title
        self.releaseYear = releaseYear
        self.id = id
        self.overview = overview
        self.genreIds = genreIds
        self.posterPath = posterPath
    }
}
