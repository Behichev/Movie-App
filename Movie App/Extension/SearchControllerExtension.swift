//
//  SearchControllerExtension.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 28.07.2022.
//

import Foundation
import UIKit

extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        if searchSegmentedControl.selectedSegmentIndex == 0 {
            ApiManager.shared.searchMovie(search: text.replacingOccurrences(of: " ", with: "%20")) { TrandingMovies in
                self.searchResult = TrandingMovies.results ?? []
                DispatchQueue.main.async {
                    self.searchResultsCollectionView.reloadData()
                }
            }
        } else {
            ApiManager.shared.searchShow(search: text.replacingOccurrences(of: " ", with: "%20")) { TrandingMovies in
                self.searchResult = TrandingMovies.results ?? []
                DispatchQueue.main.async {
                    self.searchResultsCollectionView.reloadData()
                }
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)

        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
}
