//
//  CampaignListViewController.swift
//  Atactic
//
//  Created by Jaime on 28/12/17.
//  Copyright © 2017 ATACTIC. All rights reserved.
//

import UIKit

/*
 * Holder class for quest data
 */
class Quest {
    var title: String!
    var briefing: String!
    var longDescription: String!
    var currentStep: Int!
    var totalSteps: Int!
    var administratorName: String!
    var administratorTitle: String!
    var deadline: Date!
    
    init(questName: String, questSummary: String, fullDescription: String,
         currentProgress: Int, maxProgress: Int,
         adminName: String, adminTitle: String,
         endDate: Date) {
        
        self.title = questName
        self.briefing = questSummary
        self.longDescription = fullDescription
        self.currentStep = currentProgress
        self.totalSteps = maxProgress
        self.administratorName = adminName
        self.administratorTitle = adminTitle
        self.deadline = endDate
    }
    
}

class CampaignListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // Variable holding the list of quests to display
    var questList : [Quest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Campaign List View Controller loaded")
        
        var q = Quest(questName: "Captación Navidad",
                      questSummary: "Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.",
                      fullDescription: "Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.\n\nVisita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.\n\nVisita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.\n\nVisita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.",
                      currentProgress: 14, maxProgress: 55,
                      adminName: "Héctor Conget Vicente", adminTitle: "Jefe de Zona Norte",
                      endDate: Date.init())
        questList.append(q)
        
        q = Quest(questName: "Fidelización Estratégica",
                  questSummary: "Acude a los clientes considerados estratégicos y realiza una oferta específica de fidelización.",
                  fullDescription: "Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.",
                  currentProgress: 27, maxProgress: 40,
                  adminName: "Héctor Conget Vicente", adminTitle: "Jefe de Zona Norte",
                  endDate: Date.init())
        questList.append(q)
        
        q = Quest(questName: "Recuperación Semestre",
                  questSummary: "Visita a todos los clientes de tu zona cuyo volumen de pedidos se redujese en más de un 20% en el semestre anterior.",
                  fullDescription: "Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.",
                  currentProgress: 35, maxProgress: 69,
                  adminName: "Héctor Conget Vicente", adminTitle: "Jefe de Zona Norte",
                  endDate: Date.init())
        questList.append(q)
        
        q = Quest(questName: "Venta Cruzada Q1",
                  questSummary: "Presenta a los clientes del producto A las novedades en el portafolio de 2018 y oferta las líneas D y E.",
                  fullDescription: "Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.",
                  currentProgress: 8, maxProgress: 10,
                  adminName: "Héctor Conget Vicente", adminTitle: "Jefe de Zona Norte",
                  endDate: Date.init())
        questList.append(q)
        
        q = Quest(questName: "Desarrollo Alto Potencial",
                  questSummary: "Visita a los clientes de alto potencial de desarrollo intentando aumentar el tamaño medio de sus pedidos.",
                  fullDescription: "Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.",
                  currentProgress: 92, maxProgress: 200,
                  adminName: "Héctor Conget Vicente", adminTitle: "Jefe de Zona Norte",
                  endDate: Date.init())
        questList.append(q)
        
        q = Quest(questName: "Intensidad semanal",
                  questSummary: "Realiza y reporta al menos 20 visitas cada semana.",
                  fullDescription: "Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.",
                  currentProgress: 3, maxProgress: 20,
                  adminName: "Héctor Conget Vicente", adminTitle: "Jefe de Zona Norte",
                  endDate: Date.init())
        questList.append(q)
        
        q = Quest(questName: "Intensidad trimestral",
                  questSummary: "Reporta al menos 200 visitas antes del 1 de abril de 2018",
                  fullDescription: "Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.Visita a los clientes potenciales de las líneas de producto de alto consumo en temporada festiva.",
                  currentProgress: 5, maxProgress: 200,
                  adminName: "Héctor Conget Vicente", adminTitle: "Jefe de Zona Norte",
                  endDate: Date.init())
        questList.append(q)
        
        print("Trabajando con \(questList.count) misiones")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedQuest = self.questList[indexPath.row]
                let destinationViewContoller = segue.destination as! QuestDetailViewController
                destinationViewContoller.quest = selectedQuest
            }
        }
    }

}

//
// This extension makes the view controller implement functions required to display and manage a table and its cells
//
extension CampaignListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quest = questList[indexPath.row]
        let qID = "QCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: qID, for: indexPath) as! QuestCell
        
        cell.questNameLabel.text = quest.title
        cell.questSummaryLabel.text = quest.briefing
        cell.currentStepLabel.text = "\(quest.currentStep!)"
        cell.totalStepsLabel.text = "\(quest.totalSteps!)"

        // Set progress values for progress label text and circular indicator angle
        let prgr = Double(quest.currentStep!) / Double(quest.totalSteps!)
        cell.progressLabel.text = String(format: "%.0f", prgr * 100) + "%"
        cell.progressCircle.angle = prgr * 360.0
        
        return cell
    }
    
}



