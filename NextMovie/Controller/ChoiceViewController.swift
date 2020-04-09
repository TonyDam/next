//
//  ViewController.swift
//  NextMovie
//
//  Created by TonyDam on 12/12/2019.
//  Copyright © 2019 TonyDam. All rights reserved.
//

import UIKit
class ChoiceViewController: UIViewController {
    
    @IBOutlet weak var posterView: PosterView!

    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var releaseYear: UILabel!
  
    @IBAction func dragPosterView(_ sender: UIPanGestureRecognizer) {
          switch sender.state {
                case .began, .changed : transformPosterViewWith(gesture: sender)
                case .ended, .cancelled : setUserChoiceFrom(gesture: sender)
                default: break
        }
    }
    
    
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
        choice.start()
        NotificationCenter.default.addObserver(self, selector: #selector(discoverMoviesLoaded), name: Notification.Name.discoverMoviesLoaded, object: nil)
    }
    
    @objc func discoverMoviesLoaded() {
        posterView.poster = choice.currentMovie.poster
        print("CURRENT MOVIE",choice.currentMovie.title)
        movieTitleLabel.text = choice.currentMovie.title
        releaseYear.text = choice.currentMovie.releaseYear
    }
    
    var choice = Choice()
    
    
    private func transformPosterViewWith(gesture: UIPanGestureRecognizer) {
        // Création du déplacement
        let gestureTranslation = gesture.translation(in: posterView)
        let translationTransform = CGAffineTransform(translationX: gestureTranslation.x,
            y: gestureTranslation.y)
        
        // Création de la rotation
        let screenWidth = UIScreen.main.bounds.width
        let ratioOfTranslationAndScreenWidth = gestureTranslation.x / (screenWidth / 2)
        let rotationAngle = (CGFloat.pi / 6) * ratioOfTranslationAndScreenWidth
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        // Combinaison du déplacement et de la rotation
        let transform = translationTransform.concatenating(rotationTransform)
        
        // Application de la combinaison des deux transformations à la PosterView
        posterView.transform = transform

        posterView.style = gestureTranslation.x > 0 ? .liked : .unliked
    }

    private func setUserChoiceFrom(gesture: UIPanGestureRecognizer) {
        let gestureTranslation = gesture.translation(in: posterView)
        let screenWidth = UIScreen.main.bounds.width
        let ratioOfTranslationAndScreenWidth = gestureTranslation.x / (screenWidth / 4)
        
        guard ratioOfTranslationAndScreenWidth < -1 || ratioOfTranslationAndScreenWidth > 1 else {
            posterView.transform = .identity
            return
        }
        
        switch posterView.style {
        case .liked:
            choice.setLikeOfCurrentMovie(with: true)
        case .unliked:
            choice.setLikeOfCurrentMovie(with: false)
        case .neutral:
            break
        }

        var translationTransform: CGAffineTransform
        if posterView.style == .liked {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.posterView.transform = translationTransform
        }) { (success) in
            guard success else { return }
            self.showPoster()
        }
        
    }
    
//    private func showPoster() {
//        posterView.transform = .identity
//
//        posterView.transform = CGAffineTransform(scaleX: 0.01 , y: 0.01)
//        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: [], animations: {
//            self.posterView.transform = .identity
//        })
//    }
    
    private func showPoster(){
    //Replacer le posterView à sa place d'origine et passer un film suivant
             posterView.transform = .identity
             posterView.style = .neutral
             
             switch choice.state {
             case .ongoing:
                 posterView.poster = choice.currentMovie.poster
                 movieTitleLabel.text = choice.currentMovie.title
                 releaseYear.text = choice.currentMovie.releaseYear
             case .over:
                //performSegue(withIdentifier: "toResult", sender: nil)
                 posterView.poster = Data()
                 movieTitleLabel.text = ""
                 releaseYear.text = ""
         }
        
        // Animer l'apparition du posterView
        posterView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: [], animations: {
            self.posterView.transform = .identity
        })
     }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


/* import UIKit

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
        switch sender.state {
        case .began, .changed : transformPosterViewWith(gesture: sender)
        case .ended, .cancelled : setUserChoiceFrom(gesture: sender)
        default: break
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
        /* NotificationCenter.default.addObserver(self, selector: #selector(discoverMoviesLoaded), name: Notification.Name.discoverMoviesLoaded, object: nil) */
        
        choice.start()
    }
    /* @objc func discoverMoviesLoaded() {
        posterView.poster = choice.currentMovie.poster
        movieTitleLabel.text = choice.currentMovie.title
        releaseYear.text = choice.currentMovie.releaseDate
    } */

}

*/
