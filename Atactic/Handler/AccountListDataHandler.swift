//
//  AccountListDataHandler.swift
//  Atactic
//
//  Created by Jaime Lucea on 08/12/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import CoreLocation

class AccountListDataHandler {
    
    let presenter : AccountListPresenter
    
    init(presenter: AccountListPresenter){
        self.presenter = presenter
    }
    
    func getAccounts(userId: Int){
        
        let httpRequest = AccountListRequest(userId: userId)
        
        // Declare an asynchronous task that sends an HTTP request and handles the response
        let httpRequestTask = URLSession.shared.dataTask(with: httpRequest.request) { (data, response, error) in
            self.handleServerResponse(data: data, response: response, error: error)
        }
        // Execute asnychronous task, decoding the response and returning control to the ViewController
        httpRequestTask.resume()
    }
    
    
    private func presentMessage(message: String){
        DispatchQueue.main.async { () -> Void in
            self.presenter.displayError(message: message)
        }
    }
    
    private func presentData(accounts: [AccountStruct]){
        DispatchQueue.main.async { () -> Void in
            if let currentLocation = LocationController.global.getMostRecentLocation() {
                // Calculate distance to each account
                let accountListWithDistances = self.setDistances(location: currentLocation, list: accounts)
                self.presenter.displayData(accountList: accountListWithDistances)
            }else{
                self.presenter.displayData(accountList: accounts)
            }
        }
    }
    
    
    private func handleServerResponse(data: Data?, response: URLResponse?, error: Error?) {
        
        // Try cast to HTTP Response
        if let httpResponse = response as? HTTPURLResponse {
            
            print("AccountListDataHandler - HTTP response received - \(httpResponse.statusCode)")
            if (httpResponse.statusCode == 200) {
                
                // Decode JSON response
                let decoder = JSONDecoder()
                do{
                    let accountList = try decoder.decode([AccountStruct].self, from: data!)
                    
                    // Return data or status message to presenter
                    if (accountList.isEmpty) {
                        print("AccountListDataHandler - Empty list of targets received")
                        self.presentMessage(message: "No se han encontrado objetivos prioritarios")
                    } else {
                        print("AccountListDataHandler - Returning data to view controller")
                        self.presentData(accounts: accountList)
                    }
                    
                } catch {
                    // JSON Error
                    self.presentMessage(message: "Se ha producido un error al descodificar los datos del servidor")
                }
            } else {
                print("AccountListDataHandler - Response error code \(httpResponse.statusCode)")
                self.presentMessage(message: "Se ha producido un error \(httpResponse.statusCode). Por favor, reinicie la aplicación")
            }
        } else {
            print("AccountListDataHandler - No response from server")
            self.presentMessage(message: "No se ha podido conectar con el servidor")
        }
    }
    
    
    private func setDistances(location: CLLocation, list : [AccountStruct]) -> [AccountStruct] {
        var newList : [AccountStruct] = []
        for account in list {
            var nacc = account
            let accountLocation = CLLocation(latitude: account.latitude, longitude: account.longitude)
            nacc.distance = Float(location.distance(from: accountLocation))
            newList.append(nacc)
        }
        return newList
    }
    
    
}

