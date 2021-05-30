//
//  DataViewController.swift
//  EhB-IOS-Werkstuk2
//
//  Created by Arthur Van Remoortel on 29/05/2021.
//

import UIKit

class FAQViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var linkLabel: UILabel!
    @IBOutlet var linkHeader: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var covidFAQ: CovidFAQ?

    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = covidFAQ?.question
        answerLabel.text = covidFAQ?.answer
        // Only support one link right now.
        if (covidFAQ?.links.count != 0){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.openLink))
            linkLabel.isUserInteractionEnabled = true
            linkLabel.text = covidFAQ?.links.first?.absoluteString
            linkLabel.addGestureRecognizer(tap)
            print("added tap")
        } else {
            linkHeader.text = ""
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func openLink(){
        print("Hello???")
        UIApplication.shared.open(covidFAQ!.links.first!)
    }
}
