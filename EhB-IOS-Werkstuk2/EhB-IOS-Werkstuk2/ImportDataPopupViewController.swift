//
//  ImportDataPopupViewController.swift
//  EhB-IOS-Werkstuk2
//
//  Created by Arthur Van Remoortel on 28/05/2021.
//

import UIKit
import CoreData

class ImportDataPopupViewController: UIViewController {

    @IBOutlet var continueButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var activitySpinner: UIActivityIndicatorView!
    
    var completedDownloads: Int = 0
    
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadData()
    }
    
    func checkDownloadCompleted(){
        completedDownloads += 1
        if (completedDownloads == CovidDataManager.shared.apiUrls.count){
            // All downlaods completed.
            DispatchQueue.main.async {
                UserDefaults.standard.set(Date(), forKey: "lastUpdateDate")
                
                let rootViewController = UIApplication.shared.windows.first!.rootViewController as! RootTabBarController
                self.activitySpinner.stopAnimating()
                self.activitySpinner.isHidden = true
                self.continueButton.isHidden = false
                // TODO: Will break if order of tabs changes.
                let homeVC = (rootViewController.viewControllers?.first as! HomeViewController)
                homeVC.updateInteractiveMapData()
                homeVC.dataTypeChanged()
                homeVC.updateLastUpdateDateLabel()
            }
        }
    }
    
    func downloadData(){
        CovidDataManager.shared.getAllData(context: persistentContainer.viewContext, mainCompletionHandler: checkDownloadCompleted)
    }
    
    @IBAction func openSciensanoWebsite() {
        if let url = URL(string: "https://www.sciensano.be/en") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }

}
