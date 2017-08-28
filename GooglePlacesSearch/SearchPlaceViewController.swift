//
//  SearchPlaceViewController.swift
//  GooglePlacesSearch
//
//  Created by Himanshi Bhardwaj on 8/24/17.
//  Copyright © 2017 Himanshi Bhardwaj. All rights reserved.
//


import UIKit

class SearchPlaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //--------------------------------------
    // MARK: Outlets
    //--------------------------------------
    
    @IBOutlet weak private var searchBarContainerView: UIView!
    @IBOutlet weak private var instructionLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    
    
    //--------------------------------------
    // MARK: UI elements created programmatically
    //--------------------------------------
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    //--------------------------------------
    // MARK: Variables
    //--------------------------------------
    
    private var searchText = ""
    private var instructionText = "Welcome, search for a place here"
    private var api = GooglePlacesAutocompleteApi()
    private var places: [Place] = []
    
    
    //--------------------------------------
    // MARK: Functions
    //--------------------------------------
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
    }
    
    override internal func viewWillAppear(_ animated: Bool) {
        tableView.isHidden = true
        instructionLabel.isHidden = false
        instructionLabel.text = instructionText
        super.viewWillAppear(animated)
    }
    
    //MARK: init setup functions
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = .clear
        searchBarContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
    }
    
    //MARK: table view controller Methods
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        let place = places[(indexPath as NSIndexPath).row]
        // Configure the cell
        searchCell.textLabel!.text = place.description
        searchCell.accessoryType = .disclosureIndicator
        searchCell.backgroundColor = .themeColor
        searchCell.textLabel?.textColor = .white
        
        return searchCell
    }
    
    // MARK: Search bar Methods
    fileprivate func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchText.isEmpty {
            tableView.isHidden = true
            instructionLabel.text = "Welcome, search for a place here"
            instructionLabel.isHidden = false
            places = []
        }
        else {
            self.searchText = searchText
            //fetch data from google API
            api.getPlaces(searchText, completion: {(places: [Place]?,error: Error?) in
                if places == nil {
                    self.places = []
                    self.instructionLabel.text = error?.errorString
                    self.instructionLabel.isHidden = false
                    self.tableView.isHidden = true
                }
                else {
                    self.places = places!
                    self.tableView.reloadData()
                    self.instructionLabel.isHidden = true
                    self.tableView.isHidden = false
                }
            })
        }
    }
    
    // MARK: Segue to details page
    override internal func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaceDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let place = places[(indexPath as NSIndexPath).row]
                let controller = segue.destination as! DetailsViewController
                controller.place = place
            }
        }
    }
    
    
    //--------------------------------------
    // MARK: IBAction functions
    //--------------------------------------
    
    @IBAction func placeTypeSegmentedViewValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: GooglePlaceAutoCompleteData.updatePlaceType(to: PlaceType.Cities)
        case 1: GooglePlaceAutoCompleteData.updatePlaceType(to: PlaceType.Address)
        case 2: GooglePlaceAutoCompleteData.updatePlaceType(to: PlaceType.Establishment)
        case 3: GooglePlaceAutoCompleteData.updatePlaceType(to: PlaceType.Geocode)
        case 4: GooglePlaceAutoCompleteData.updatePlaceType(to: PlaceType.Regions)
            
        default: GooglePlaceAutoCompleteData.updatePlaceType(to: PlaceType.Cities)
        }
        api = GooglePlacesAutocompleteApi()
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    @IBAction private func onTap(_ sender: UITapGestureRecognizer) {
        searchController.searchBar.endEditing(true)
    }
}


//--------------------------------------
// MARK: Extensions
//--------------------------------------

extension SearchPlaceViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    internal func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
