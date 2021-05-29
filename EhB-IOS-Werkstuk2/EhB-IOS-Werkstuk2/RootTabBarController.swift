//
//  ViewController.swift
//  EhB-IOS-Werkstuk2
//
//  Created by Arthur Van Remoortel on 26/05/2021.
//

import UIKit
import Charts
import FSInteractiveMap

class RootTabBarController: UITabBarController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (appDelegate.isFirstLauch || true){ // TODO: Dev Only
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ImportDataPopupViewController") as! ImportDataPopupViewController
            newViewController.rootTabBarController = self
            self.present(newViewController, animated: true, completion: nil)
        }
    }
}

