//
//  ViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 28.06.2022.
//

import UIKit


class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableViewMain: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    //MARK: - Data
    var arrayMovies: [Media] = []
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        networkRequest()

    }
    //MARK: - Functions
    func networkRequest() {
        ApiManager.shared.getTrandingMovies { show in
            self.arrayMovies = show.results ?? []
            DispatchQueue.main.async {
                self.tableViewMain.reloadData()
            }
        }
    }
    
    private func setupInterface() {
        //Setup Background
        view.backgroundColor = Constants.Colors.blueBackgroundColor
        //Setup Table View
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        tableViewMain.separatorStyle = .none
        tableViewMain.backgroundColor = Constants.Colors.blueBackgroundColor
        tableViewMain.showsVerticalScrollIndicator = false
        //Setup Segmented Control
        segmentedControl.tintColor = Constants.Colors.blueBackgroundColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator],
                                                for: UIControl.State.normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                for: UIControl.State.selected)
        segmentedControl.setTitle("Movies", forSegmentAt: 0)
        segmentedControl.setTitle("TV", forSegmentAt: 1)
    }
  
    //MARK: - Actions
    @IBAction func WhenSelected(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            ApiManager.shared.getTrandingMovies { show in
                self.arrayMovies = show.results ?? []
                DispatchQueue.main.async {
                    self.tableViewMain.reloadData()
                }
            }
        case 1:
            ApiManager.shared.getTrandingShows { show in
                self.arrayMovies = show.results ?? []
                DispatchQueue.main.async {
                    self.tableViewMain.reloadData()
                }
            }
        default:
            break
        }
    }
}



