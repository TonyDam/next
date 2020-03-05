//
//  ViewController.swift
//  NextMovie
//
//  Created by TonyDam on 12/12/2019.
//  Copyright © 2019 TonyDam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var posterView: PosterView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBAction func dragPosterView(_ sender: UIPanGestureRecognizer) {
        // Récupérer les coordonnés du doigt dans l'écran
        // Donner ces coordonnées au posterView pour qu'il suive le doigt
        // Le doigt déplace le posterView
        // Appliquer une légère rotation quand le posterView se déplace
        // Cette rotation sera faite avec une animation
        
    }
    
    
    var choice = Choice()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterView.layer.cornerRadius = 4
        posterView.clipsToBounds = true

        posterView.layer.shadowColor = UIColor.nmBlack.cgColor
        posterView.layer.shadowOffset = CGSize(width: 0, height: 3)
        posterView.layer.shadowOpacity = 0.1
        posterView.layer.shadowRadius = 4
        posterView.layer.masksToBounds = false
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(discoverMoviesLoaded), name: Notification.Name.discoverMoviesLoaded, object: nil)
        
        choice.start()
    }
    @objc func discoverMoviesLoaded() {
        posterView.poster = choice.currentMovie.poster
        movieTitleLabel.text = choice.currentMovie.title
        releaseYear.text = choice.currentMovie.releaseDate
    }


}

