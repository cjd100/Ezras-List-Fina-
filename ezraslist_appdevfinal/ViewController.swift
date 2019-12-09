//
//  ViewController.swift
//  ezraslist_appdevfinal
//
//  Created by Sophia Wang on 12/8/19.
//  Copyright © 2019 Sophia Wang. All rights reserved.
//

protocol addNewListingDelegate: class{
    func addNewListing(listing: Listing)
}

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    // MARK: View vars
    
    var tableView = UITableView()
    let listingCellIdentifier = "ListingCell"
    var searchController: UISearchController!
    let cellHeight: CGFloat = 100
    
    // MARK: Model var
    
    var listings: [Listing] = []
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set navigation bar title
        title = "Ezra's Listings"
        
        //add button
        let addButton = UIBarButtonItem(title: "+", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addListing))
        self.navigationItem.rightBarButtonItem = addButton
        
        // Layout views
        view.addSubview(tableView)
        // Pin the tableview’s anchors to its superview
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Set up tableview logic
        tableView.dataSource = self
        tableView.register(ListingTableViewCell.self, forCellReuseIdentifier: listingCellIdentifier)
        
        // Make tableview cells' height dynamically resize
        //tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        
        // Set up search controller logic
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        //searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search by category (School, Food, etc...)"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.autocapitalizationType = .none
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        NetworkManager.getAllListings(){
            listings in self.listings = listings
            DispatchQueue.main.async {
                self.tableView.reloadData()
            
        }
        }
    }
    @objc func addListing(){
        let viewController = AddNewListingViewController(Listings: listings)
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
        self.tableView.reloadData()
       }
    
    // MARK: UITableView Data Source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listingCellIdentifier, for: indexPath) as! ListingTableViewCell

        cell.titleLabel.text = listings[indexPath.row].name
        cell.userLabel.text = listings[indexPath.row].owner.name
        cell.categoryLabel.text = (listings[indexPath.row].category)
        cell.descriptionLabel.text =  listings[indexPath.row].description
        cell.priceLabel.text = "$ \(listings[indexPath.row].price)"
        return cell
    }
    //swipe right to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
        listings.remove(at: indexPath.row)
        NetworkManager.deleteListing(numberID: listings[indexPath.row].id){
    
        }
        
        self.tableView.reloadData()
     }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    // MARK: UISearchResultsUpdating Protocol
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text{
            if !searchText.isEmpty {
                NetworkManager.getListings(fromSearch: searchText) { listings in self.listings = listings
                    DispatchQueue.main.async{
                    self.tableView.reloadData()
                    }
                    
                }
                
                }
            else{
                NetworkManager.getAllListings(){
                    listings in self.listings = listings
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    
                    }
            }
            
        }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    
}

/// UITableViewDelegate
/// - Tell the table view what height to use for each row
/// - Tell the table view what should happen if we select a row
/// - Tell the table view what should happen if we deselect a row
extension ViewController: UITableViewDelegate {
    
     
}
extension ViewController: addNewListingDelegate {
    func addNewListing(listing: Listing) {
       // NetworkManager.addListing()
    }
}
