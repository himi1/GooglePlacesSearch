//
//  DetailsViewController.swift
//  GooglePlacesSearch
//
//  Created by Himanshi Bhardwaj on 8/24/17.
//  Copyright © 2017 Himanshi Bhardwaj. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //--------------------------------------
    // MARK: Outlets
    //--------------------------------------
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var instructionLabel: UILabel!
    
    //--------------------------------------
    // MARK: Variables
    //--------------------------------------
    
    private var placeDetails: [String] = []
    
    open var place: Place? {
        didSet {
            configureTableView()
        }
    }
    
    
    //--------------------------------------
    // MARK: Functions
    //--------------------------------------
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        instructionLabel.isHidden = true
        setupTableView()
    }
    
    //MARK: init setup functions
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 700
    }
    
    private func configureTableView() {
        place?.getDetails(completion: { (details: [String: String]?,error: Error?) in
            if let error = error {
                self.instructionLabel.text = error.errorString
                self.instructionLabel.isHidden = false
                self.tableView.isHidden = true
            }
            else {
                self.placeDetails.append("Name: " + (details?["name"]!)!)
                self.placeDetails.append("Time zone: " + (details?["timeZone"]!)!)
                self.placeDetails.append("Latitude: " + (details?["latitude"]!)!)
                self.placeDetails.append("Longitude: " + (details?["longitude"]!)!)
                self.placeDetails.append("Radius: " + (details?["radius"]!)!)
                
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.instructionLabel.isHidden = true
            }
            
        })
    }
    
    //MARK: table view controller Methods
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeDetails.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        let place = placeDetails[(indexPath as NSIndexPath).row]
        // Configure the cell
        searchCell.textLabel!.text = place.description
        searchCell.backgroundColor = .clear
        searchCell.textLabel?.textColor = .white
        return searchCell
    }
    
}



