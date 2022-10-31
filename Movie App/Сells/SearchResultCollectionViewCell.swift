//
//  SearchResultCollectionViewCell.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 23.07.2022.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
//    MARK: Configure
    func configureCell(withModel model: Result) {
        self.movieNameLabel.text = model.title ?? model.name
        self.mediaTypeLabel.text = model.overview
        guard let posterPath = model.posterPath else { return }
        guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
        moviePoster.sd_setImage(with: imageURL)
        moviePoster.layer.cornerRadius = 24
    }
    
    override func prepareForReuse() {
        self.movieNameLabel.text = nil
        self.moviePoster.image = nil
        self.mediaTypeLabel.text = nil
    }
    
}
