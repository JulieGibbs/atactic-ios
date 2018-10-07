//
//  CampaignListViewController.swift
//  Atactic
//
//  Created by Jaime on 28/12/17.
//  Copyright © 2017 ATACTIC. All rights reserved.
//

import UIKit

class QuestListViewController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet var errorMsgTextView: UITextView!
    
    // Variable holding the list of quest participations to display
    var questParticipationList : [Participation] = []
    
    override func viewDidLoad() {
        print("QuestListViewController - view did load")
        super.viewDidLoad()
        
        // Hide views and show loading indicator
        self.tableView.isHidden = true
        errorMsgTextView.isHidden = true
        showActivityIndicator()
        
        loadQuestParticipations()
        
        // Add refresh control to Table View
        // refreshControl.attributedTitle = NSAttributedString(string: "Actualizar datos")
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refreshTableData(_:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
 
    @objc private func refreshTableData(_ sender: Any) {
        
        print("QuestListViewController - REFRESHING TABLE DATA")
        
        // Hide views and show loading indicator
        self.tableView.isHidden = true
        errorMsgTextView.isHidden = true
        showActivityIndicator()
        
        loadQuestParticipations()
    }
    
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        print("QuestListViewController - view DID appear")
        self.activityIndicator.isHidden = false
        super.viewDidAppear(animated)
    }
    */
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        print("QuestListViewController - view WILL appear")
        super.viewWillAppear(animated)
        
        self.tableView.isHidden = true
        errorMsgTextView.isHidden = true
        showActivityIndicator()
        
        loadQuestParticipations()
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Prepare for the showQuestDetail segue
    // by setting the quest data in the destination QuestDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedQuest = self.questParticipationList[indexPath.row]
                let destinationViewContoller = segue.destination as! QuestDetailViewController
                destinationViewContoller.quest = selectedQuest
            }
        }
    }
    
    private func showActivityIndicator(){
        self.activityIndicatorView.isHidden = false
        self.activityIndicator.isHidden = false
    }
    
    private func hideActivityIndicator(){
        self.activityIndicatorView.isHidden = true
        self.activityIndicator.isHidden = true
    }
    
    public func displayData(data: [Participation]){
        print("QuestListViewController - Updating data to display")
        errorMsgTextView.isHidden = true
        self.questParticipationList = data
        self.tableView.reloadData()
        hideActivityIndicator()
        self.refreshControl.endRefreshing()
        self.tableView.isHidden = false
    }
    
    public func displayError(message: String){
        errorMsgTextView.text = message
        hideActivityIndicator()
        tableView.isHidden = true
        errorMsgTextView.isHidden = false
    }
    
}

//
// This extension makes the view controller implement functions required to display and manage a table and its cells
//
extension QuestListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questParticipationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let participation = questParticipationList[indexPath.row]
        let qID = "QCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: qID, for: indexPath) as! QuestCell
        
        cell.questNameLabel.text = participation.campaign.name
        cell.questSummaryLabel.text = participation.campaign.summary
        // cell.currentStepLabel.text = "\(participation.currentStep)"
        // cell.totalStepsLabel.text = "\(participation.totalSteps)"
        cell.scoreLabel.text = "\(participation.campaign.completionScore)"
        
        // Parse the campaign's end date
        let endDateStr = participation.campaign.endDate
        let endDateSubstr = String(endDateStr.split(separator: "T")[0])
        // print("Will parse String-to-date: " + endDateSubstr)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let endDate = formatter.date(from: endDateSubstr)
        
        // Get current date
        let currentDate = Date()
        
        // Calculate days of difference between the two dates
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: currentDate)
        let date2 = calendar.startOfDay(for: endDate!)
        let daysOfDiff = calendar.dateComponents([.day], from: date1, to: date2).day
        
        cell.deadlineLabel.text = "Faltan \(daysOfDiff!) días"
        
        // Set progress values for progress label text and circular indicator angle
        // let prgr = Double(participation.currentStep) / Double(participation.totalSteps)
        let prgr = Double(participation.currentProgress)
        cell.progressLabel.text = String(format: "%.0f", prgr * 100) + "%"
        cell.progressCircle.angle = prgr * 360.0
        
        return cell
    }

}

//
// This extension incorporates Network features by adding the loadQuestList function
//
extension QuestListViewController {
    
    func loadQuestParticipations() {
        
        // Recover user's Id from UserDefault and send a requiest to the server to load his quest list
        // TODO change User ID with Authentication TOKEN
        let recoveredUserId = UserDefaults.standard.integer(forKey: "uid")
        
        let questListRequest = CampaignListRequest(userId: recoveredUserId)
        
        let task = URLSession.shared.dataTask(with: questListRequest.getRequest()) { (data, response, error) in
            
            // sleep(2)
            
            if let serverResponse = response as? HTTPURLResponse {
                print("QuestListViewController - QuestList service response received - \(serverResponse.statusCode)")
                
                if (serverResponse.statusCode == 200) {
                    
                    // DECODE JSON response
                    print("QuestListViewController - Decoding QuestList from JSON response")
                    // print(String(data: data!, encoding: .utf8)!)
                    // print()
                    let decoder = JSONDecoder()
                    let questList = try! decoder.decode([Participation].self, from: data!)
                    print("QuestListViewController - Loaded \(questList.count) quests from the server")
                    
                    // Run UI updates in the main queue
                    DispatchQueue.main.async { () -> Void in
                        if (questList.isEmpty){
                            self.displayError(message: "No se han encontrado campañas activas")
                        } else {
                            self.displayData(data: questList)
                        }
                    }
                } else {
                    print("QuestListViewController - ERROR: status code \(serverResponse.statusCode)")
                    DispatchQueue.main.async { () -> Void in
                        self.displayError(message: "Se ha producido un error \(serverResponse.statusCode). Por favor, reinicie la aplicación")
                        }
                }
            } else {
                print("QuestListViewController - ERROR: no response from server")
                DispatchQueue.main.async { () -> Void in
                    self.displayError(message: "No se ha podido conectar con el servidor")
                }
            }
        }
        task.resume()
    }
    
}


