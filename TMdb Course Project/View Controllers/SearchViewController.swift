//
//  SearchViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 21.07.2022.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    @IBOutlet weak var searchSegmentedControl: UISegmentedControl!
    
    let searchController = UISearchController()
    var searchResult: [Result] = []
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    //MARK: - Functions
    func setupInterface() {
        //register Protocols
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        //Setup Search Controller
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.tintColor = .systemYellow
        searchController.searchBar.searchTextField.textColor = .white
        //setup Collection View
        searchResultsCollectionView.backgroundColor = ViewController().blueBackgroundColor
        searchResultsCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        if let layout = searchResultsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        //Setup Segmanted Control
        searchSegmentedControl.tintColor = ViewController().blueBackgroundColor
        searchSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator],
                                                      for: UIControl.State.normal)
        searchSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                      for: UIControl.State.selected)
        searchSegmentedControl.setTitle("Movies", forSegmentAt: 0)
        searchSegmentedControl.setTitle("TV", forSegmentAt: 1)
    }
}


