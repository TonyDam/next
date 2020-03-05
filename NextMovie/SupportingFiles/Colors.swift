//
//  Colors.swift
//  NextMovie
//
//  Created by TonyDam on 23/01/2020.
//  Copyright © 2020 TonyDam. All rights reserved.
//
// Après avoir importer et définie toutes les couleurs dans mes Assets, je dis ici que je souhaite les utiliser (à travers "extension") pour mon app. On peut ainsi faire un seul fichier "extension" regroupant les typo etc.

import Foundation

import UIKit

extension UIColor {
    public class var nmRed : UIColor {
        return UIColor(named: "NM_Red")!
    }
    public class var nmGreen : UIColor {
        return UIColor(named: "NM_Green")!
    }
    public class var nmBgWhite : UIColor {
        return UIColor(named: "NM_BgWhite")!
    }
    public class var nmBlack : UIColor {
        return UIColor(named: "NM_Black")!
    }
}
