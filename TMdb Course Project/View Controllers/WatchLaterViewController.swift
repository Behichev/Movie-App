//
//  WatchLaterViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 30.07.2022.
//

import UIKit

class WatchLaterViewController: UIViewController {
    //MARK: - Constants
    var moviesArray: [Media] = []
    //MARK: - Outlets
    @IBOutlet weak var watchLaterTableView: UITableView!
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //register protocols
        watchLaterTableView.delegate = self
        watchLaterTableView.dataSource = self
        //setup colors
        view.backgroundColor = ViewController().blueBackgroundColor
        watchLaterTableView.separatorStyle = .none
        watchLaterTableView.backgroundColor = ViewController().blueBackgroundColor
        watchLaterTableView.showsVerticalScrollIndicator = false
    }
    override func viewWillAppear(_ animated: Bool) {
        moviesArray = DataManager().getMedia()
        watchLaterTableView.reloadData()
    }
}


