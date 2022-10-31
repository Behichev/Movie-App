//
//  Constants.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 18.09.2022.
//

import Foundation
import UIKit

struct Constants {
    
    static let detailViewContrillerIdentifier = "DetailViewControllerID"
    static let storyboardName = UIStoryboard(name: "Main", bundle: nil)
    static let mainScreenTableViewCellNib = UINib(nibName: "MainScreenTableViewCell", bundle: nil)
    static let mainScreenTableViewCellIdentifier = "MainScreenTableViewCell"
    static let searchResultIdentifier = "SearchResultCollectionViewCell"
    static let imageURLpath = "https://image.tmdb.org/t/p/w1280/"
    
    struct Colors {
        static let blueBackgroundColor = UIColor(r: 49, g: 54, b: 76, a: 1)
        static let blueHeaderColor = UIColor(r: 14, g: 17, b: 40, a: 1)
    }
    
}
