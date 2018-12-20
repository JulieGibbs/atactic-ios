//
//  TargetListViewController.swift
//  Atactic
//
//  Created by Jaime on 4/2/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit

class AccountListViewController : UIViewController, AccountListPresenter {
    
    @IBOutlet var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var errorMsgTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var dataHandler : AccountListDataHandler?
    var accounts : [AccountStruct] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        print("AccountListViewController - Did load")
        
        self.tableView.isHidden = true
        self.activityIndicator.isHidden = false
        
        dataHandler = AccountListDataHandler(presenter: self)
        
        let userId = UserDefaults.standard.integer(forKey: "uid")
        dataHandler!.getAccounts(userId: userId)
        
        // Add refresh control to Table View
        print("AccountListViewController - Adding refresh control to table view")
        // refreshControl.attributedTitle = NSAttributedString(string: "Actualizar datos")
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        print("AccountListViewController - Refresh control added and registered")
    }

    
    @objc private func reloadData() {
        let userId = UserDefaults.standard.integer(forKey: "uid")
        dataHandler!.getAccounts(userId: userId)
    }
    
    //
    // Set the data to display in the view
    //
    func displayData(accountList: [AccountStruct]) {
        
        print("AccountListViewController - Received data to display")
        
        self.accounts = accountList
        print("\(accounts.count) accounts will be displayed")
        
        self.activityIndicator.isHidden = true
        self.tableView.isHidden = false
        self.refreshControl.endRefreshing()
        
        self.tableView.reloadData()
    }
    
    func displayError(message: String) {
        self.tableView.isHidden = true
        self.activityIndicator.isHidden = true
        self.errorMsgTextView.text = message
        self.errorMsgTextView.isHidden = false
    }
    
    // Prepare for the showAccountDetail segue
    // by setting the quest data in the destination QuestDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAccountDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedAccount = self.accounts[indexPath.row]
                let destinationViewContoller = segue.destination as! AccountDetailViewController
                destinationViewContoller.account = selectedAccount
            }
        }
    }
    
}

//
// This extension makes the view controller implement functions required to display and manage a table and its cells
//
extension AccountListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.row]
        let qID = "AccCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: qID, for: indexPath) as! AccountCell
        
        cell.accountNameLabel.text = account.name
        cell.accountAddressLabel.text = account.address + ", " + account.city
        
        if let relevanceScore = account.relevance {
            cell.accountScoreLabel.text = "\(relevanceScore)"
            if relevanceScore > 80 {
                cell.accountScoreLabel.textColor = UIColor.red
            } else{
                cell.accountScoreLabel.textColor = UIColor.darkGray
            }
        }else{
            cell.accountScoreLabel.isHidden = true
        }
        
        if (account.distance == -1) {
            cell.distanceToAccountLabel.text = ""
        } else {
            cell.distanceToAccountLabel.text = formatDistance(meters: account.distance)
        }
        return cell
    }
    
    
    func formatDistance(meters: Float) -> String {
        if (meters < 1000){
            return "\(Int(round(meters))) m"
        }else if (meters >= 1000 && meters < 10000){
            return String(format: "%.1f Km", meters/1000)
        } else {
            return "\(Int(round(meters/1000))) Km"
        }
    }
    
}










