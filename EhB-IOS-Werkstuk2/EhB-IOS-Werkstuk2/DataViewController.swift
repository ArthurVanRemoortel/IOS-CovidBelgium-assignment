//
//  DataViewController.swift
//  EhB-IOS-Werkstuk2
//
//  Created by Arthur Van Remoortel on 29/05/2021.
//

import UIKit

class DataViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func updateData(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let importViewController = storyBoard.instantiateViewController(withIdentifier: "ImportDataPopupViewController") as! ImportDataPopupViewController
        CovidDataManager.shared.deleteDatabaseContents(context: appDelegate.persistentContainer.viewContext)
        self.present(importViewController, animated: true, completion: nil)
        importViewController.titleLabel.text = "Updating"
        importViewController.descriptionLabel.text = "You chose to update the database. This will download an updated dataset and will not take long."
    }

    
}
