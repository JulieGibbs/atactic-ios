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
    
    // Variable holding the list of quest participations to display
    var questParticipationList : [QuestParticipationStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        print("Campaign List View Controller loaded")
        
        // createSampleQuests()
        
        // Recover user's Id from UserDefault and send a requiest to the server to load his quest list
        // TODO change User ID with Authentication TOKEN
        let recoveredUserId = UserDefaults.standard.integer(forKey: "uid")
        loadQuestList(uid: recoveredUserId)
        
        print("Quest List controller loaded")
    }
    
    
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
        cell.currentStepLabel.text = "\(participation.currentStep)"
        cell.totalStepsLabel.text = "\(participation.totalSteps)"
        
        // Set progress values for progress label text and circular indicator angle
        let prgr = Double(participation.currentStep) / Double(participation.totalSteps)
        cell.progressLabel.text = String(format: "%.0f", prgr * 100) + "%"
        cell.progressCircle.angle = prgr * 360.0
        
        return cell
    }

}

//
// This extension incorporates Network features by adding the loadQuestList function
//
extension QuestListViewController {
    
    func loadQuestList(uid: Int) {
        
        let questListRequest = QuestListRequest(userId: uid)
        
        let task = URLSession.shared.dataTask(with: questListRequest.getRequest()) { (data, response, error) in
            
            if let serverResponse = response as? HTTPURLResponse {
                print("QuestList service response received - \(serverResponse.statusCode)")
                
                if (serverResponse.statusCode == 200) {
                    
                    // DECODE JSON response
                    print("Decoding QuestList from JSON response")
                    // print(String(data: data!, encoding: .utf8)!)
                    // print()
                    let decoder = JSONDecoder()
                    let questList = try! decoder.decode([QuestParticipationStruct].self, from: data!)
                    print("QuestListViewController - Loaded \(questList.count) quests from the server")
                    
                    // Run UI updates on main queue
                    DispatchQueue.main.async { () -> Void in
                        print("QuestListViewController: reloading table view data")
                        self.questParticipationList = questList
                        self.tableView.reloadData()
                    }
                } else {
                    print("Error code \(serverResponse.statusCode)")
                }
            } else {
                print("No response from server")
            }
        }
        task.resume()
    }
    
}


