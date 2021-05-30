//
//  FAQTableViewController.swift
//  EhB-IOS-Werkstuk2
//
//  Created by Arthur Van Remoortel on 30/05/2021.
//

import UIKit


class FAQTableViewCell: UITableViewCell {
    @IBOutlet var questionlabel: UILabel!
    var faq: CovidFAQ?
}

class FAQTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return FAQCategory.allCases.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! FAQTableViewCell
        let faq = CovidDataManager.covidFAQs[indexPath.row]
        cell.faq = faq
        cell.questionlabel.text = faq.question
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CovidDataManager.covidFAQs.filter{$0.category == FAQCategory.allCases[section]}.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FAQCategory.allCases[section].rawValue.capitalized
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = (view as! UITableViewHeaderFooterView)
        header.contentView.backgroundColor = DarkestBlueColor.uiColor
        header.textLabel?.textColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FAQSegue" {
            if let nextVC = segue.destination as? FAQViewController {
                let selectedIndex = self.tableView.indexPathForSelectedRow!
                nextVC.covidFAQ = CovidDataManager.covidFAQs[selectedIndex.row]
            }
        }
    }

}
