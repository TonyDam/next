//
//  PosterView.swift
//  NextMovie
//
//  Created by TonyDam on 23/01/2020.
//  Copyright © 2020 TonyDam. All rights reserved.
//

import UIKit

class PosterView: UIView {

    // 1
    @IBOutlet private var imageView: UIImageView!
    
    // Création d'une énumération permettant d'appliquer les couleurs que l'on a précédemment créer dans mon Assets
    // 2. "Style" commence par un majuscule car il s'agit d'une classe
    enum Style {
        case liked, unliked, neutral
    }
    
    // on peut aussi l'écrire avec uns tyle déduit var style = Style.neutral
    var style: Style = .neutral {
        // 2 getters : didSet, willSet
        didSet {
            switch style {
            case .liked: backgroundColor = UIColor.nmGreen
            case .unliked: backgroundColor = UIColor.nmRed
            case .neutral: backgroundColor = UIColor.nmBgWhite
            }
        }
    }
    
    // 3. permet de modifier la data de l'image en fond
    var poster = Data() {
        didSet {
            imageView.image = UIImage(data: poster)
        }
    }
    
}
