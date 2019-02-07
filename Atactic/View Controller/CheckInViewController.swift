//
//  CheckInViewController.swift
//  Atactic
//
//  Created by Jaime Lucea on 15/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import UIKit

class CheckInViewController : UIViewController, UITextViewDelegate {
    
    @IBOutlet var accountPicker: UIPickerView!
    @IBOutlet var comments: UITextView!
    @IBOutlet var dateLabel: UILabel!
    
    // private let examples = ["Uno", "Dos" , "Tres"]
    
    var eligibleAccounts : [AccountStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CheckInViewController - did load")
        
        accountPicker.dataSource = self
        accountPicker.delegate = self
        
        comments.delegate = self
        
        print("CheckInViewController - Requesting eligible accounts to CheckInHandler")
        let handler = CheckInHandler(view: self)
        handler.getAccountsEligibleForCheckIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dateLabel.text = DateUtils.toDateAndTimeString(date: Date.init())
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("CheckInViewController - Cancel button pressed")
        performSegue(withIdentifier: "backToMapSegue", sender: self)
    }
    
    @IBAction func checkInButtonPressed(_ sender: Any) {
        
        print("CheckInViewController - CheckIn button pressed")
        
        let selectedIndex = accountPicker.selectedRow(inComponent: 0)
        let selectedAccountId = eligibleAccounts[selectedIndex].id
        
        print("CheckInViewController - Selected Index = \(selectedIndex)")
        print("CheckInViewController - Selected Account Id = \(selectedAccountId)")
        
        // Perform check-in
        let handler = CheckInHandler(view: self)
        print("CheckInViewController - Calling CheckInHandler.doCheckin")
        handler.doCheckIn(visitedAccountId: selectedAccountId, meetingNotes: comments.text)        
    }
    
    func setEligibleAccounts(accounts: [AccountStruct]){
        // Add Accounts to Account Picker
        self.eligibleAccounts = accounts
        accountPicker.reloadAllComponents()
    }
    
    
    func checkInOk(){
        print("CheckInViewController - Check-in OK, returning to Map screen")
        self.navigationController?.popViewController(animated: true)
    }
    
    func displayError(message: String){
        
        // TODO
        print("CheckInViewController - Error")
        print(message)
    }
    
    
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n" {     //Check if last char is newline
            textView.text.removeLast()      //Remove newline
            textView.resignFirstResponder() //Dismiss keyboard
        }
    }
    
}



extension CheckInViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eligibleAccounts.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eligibleAccounts[row].name
    }
}
