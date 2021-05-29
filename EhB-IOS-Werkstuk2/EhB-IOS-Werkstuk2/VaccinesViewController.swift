//
//  VaccinesViewController.swift
//  EhB-IOS-Werkstuk2
//
//  Created by Arthur Van Remoortel on 29/05/2021.
//

import UIKit

class CentrumTableViewCell: UITableViewCell {
    @IBOutlet var centrumNameLabel: UILabel!
    @IBOutlet var centrumGemeenteLabel: UILabel!
    @IBOutlet var centrumFoto: UIImageView!
    
}

class VaccinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var vlaanderenLogo: UIImageView!
    @IBOutlet var brusselLogo: UIImageView!
    @IBOutlet var wallonieLogo: UIImageView!
    @IBOutlet var centrumTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.openVlaanderenWebsite))
        vlaanderenLogo.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(VaccinesViewController.openBrusselWebsite))
        brusselLogo.addGestureRecognizer(tapGesture2)
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(VaccinesViewController.openWallonieWebsite))
        wallonieLogo.addGestureRecognizer(tapGesture3)
        
        vlaanderenLogo.isUserInteractionEnabled = true
        brusselLogo.isUserInteractionEnabled = true
        wallonieLogo.isUserInteractionEnabled = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CovidDataManager.covidCentra.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "covidCentrumCell", for: indexPath) as! CentrumTableViewCell
        cell.centrumNameLabel?.text = CovidDataManager.covidCentra[indexPath.row].naam
        cell.centrumGemeenteLabel?.text = CovidDataManager.covidCentra[indexPath.row].adres.gemeente
        cell.centrumFoto?.image = UIImage(named: CovidDataManager.covidCentra[indexPath.row].fotoNaam)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @objc func openVlaanderenWebsite(){
        if let url = URL(string: "https://www.vlaanderen.be/gezondheid-en-welzijn/gezondheid/gezondheid-en-preventie-bij-sociaal-contact-tijdens-de-coronacrisis/vaccinatie-tegen-covid-19") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func openWallonieWebsite(){
        if let url = URL(string: "https://www.wallonie.be/fr/actualites/covid-19-strategie-de-vaccination") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func openBrusselWebsite(){
        if let url = URL(string: "https://coronavirus.brussels/nl/vaccinatie-covid-menu/vaccinatiecentra-covid-planning/") {
            UIApplication.shared.open(url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "centrumSegue" {
            if let nextVC = segue.destination as? CentrumViewController {
                let selectedIndex = self.centrumTableView.indexPathForSelectedRow!
                nextVC.covidCentrum = CovidDataManager.covidCentra[selectedIndex.row]
                
            }
        }
    }
}
