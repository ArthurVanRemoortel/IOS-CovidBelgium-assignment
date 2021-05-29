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
    @IBOutlet var activitySpinner: UIActivityIndicatorView!
    
    var completedDownloads: Int = 0
    
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var rootTabBarController: RootTabBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadData()
    }
    
    func checkDownloadCompleted(){
        completedDownloads += 1
        if (completedDownloads == CovidDataManager.shared.apiUrls.count){
            // All downlaods completed.
            DispatchQueue.main.async {
                self.activitySpinner.stopAnimating()
                self.activitySpinner.isHidden = true
                self.continueButton.isHidden = false
                if (self.rootTabBarController != nil){
                    // TODO: Will break if order of tabs changes. 
                    let homeVC = (self.rootTabBarController!.viewControllers?.first as! HomeViewController)
                    homeVC.dataTypeChanged()
                }
                
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
