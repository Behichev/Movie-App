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
    //MARK: - Colors
    let blueBackgroundColor = UIColor(r: 49, g: 54, b: 76, a: 1)
    let blueHeaderColor = UIColor(r: 14, g: 17, b: 40, a: 1)
    //MARK: - Data
    var arrayMovies: [Result] = []
    var actors: [Result] = []
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        //Network request
        ApiManager.shared.getTrandingMovies { show in
            self.arrayMovies = show.results ?? []
            DispatchQueue.main.async {
                self.tableViewMain.reloadData()
            }
        }
    }
    //MARK: - Functions
    func setupInterface() {
        //Setup Background
        view.backgroundColor = blueBackgroundColor
        //Setup Table View
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        tableViewMain.separatorStyle = .none
        tableViewMain.backgroundColor = blueBackgroundColor
        tableViewMain.showsVerticalScrollIndicator = false
        //Setup Segmented Control
        segmentedControl.tintColor = blueBackgroundColor
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



