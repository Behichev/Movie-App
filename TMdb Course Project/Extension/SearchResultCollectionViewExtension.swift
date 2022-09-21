//
//  SearchResultCollectionViewExtension.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 23.07.2022.
//

import Foundation
import UIKit

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.searResultCellIdentifier , for: indexPath) as? SearchResultCollectionViewCell {
            
            let item = searchResult[indexPath.item]
            
            switch searchSegmentedControl.selectedSegmentIndex {
            case 0:
                cell.configure(withModelMovie: item)
            case 1:
                cell.configure(withModelShow: item)
            default:
                break
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let lineSpacing: CGFloat = 8
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let interSpacing: CGFloat = 8
        return interSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColums = 2
        let width = collectionView.frame.width
        let height = UIScreen.main.bounds.height / 2.5
        //for old iPhone models CGFloat(numberOfColums)
        let minInterSpacing: CGFloat = 8
        let widthCell = width / CGFloat(numberOfColums) - collectionView.contentInset.left - collectionView.contentInset.right - minInterSpacing
        let size = CGSize(width: widthCell, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = searchResult[indexPath.row]
        
        if let detailsStoryboard = Constants.storyboardName.instantiateViewController(withIdentifier: Constants.detailViewContrillerIdentifier) as?
            DetailMediaViewController {
            
            
            guard let posterPath = item.posterPath else { return }
            guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
            detailsStoryboard.mediaRealm = item
            detailsStoryboard.filmPoster = imageURL
            detailsStoryboard.filmDescription = item.overview ?? "None"
            
            if item.voteAverage == 0.0 {
                detailsStoryboard.filmRating = "No ratings yet"
            } else {
                detailsStoryboard.filmRating = "Rating: " + String(describing: Int(item.voteAverage ?? 0)) + "\\10"
            }
            
            switch searchSegmentedControl.selectedSegmentIndex {
            case 0 :
                detailsStoryboard.filmName = item.title ?? "None"
                detailsStoryboard.filmData = "Realese date: " + (item.releaseDate ?? "No data")
         
                ApiManager.shared.getMovieTrailer(movieID: item.id ?? 0) { trailer in
                    detailsStoryboard.filmTrailer = trailer.results?.first?.key ?? ""
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailsStoryboard, animated: true)
                    }
                }
            case 1:
                detailsStoryboard.filmName = item.name ?? "None"
                detailsStoryboard.filmData = "Realese date: " + (item.firstAirDate ?? "No data")
               
                ApiManager.shared.getTVtrailer(TVid: item.id ?? 0) { trailer in
                    detailsStoryboard.filmTrailer = trailer.results?.first?.key ?? ""
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailsStoryboard, animated: true)
                    }
                }
            default:
                break
            }
        }
    }
}

