//
//  HomeViewController.swift
//  EhB-IOS-Werkstuk2
//
//  Created by Arthur Van Remoortel on 26/05/2021.
//

import UIKit
import FSInteractiveMap

class HomeViewController: UIViewController {

    @IBOutlet weak var belgiumMapView: UIView!
    
    var selectedMapLayer: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        initInteractiveMap()
        // Do any additional setup after loading the view.
    }
    
    
    func initInteractiveMap(){
        let dataOLD = [
            "Antwerp": 1,
            "alloon Brabant ": 2,
            "Brussels Capital Region": 3,
            "Hainaut": 4,
            "Liege": 5,
            "Limburg": 6,
            "Luxembourg": 7,
            "Namur": 8,
            "East Flanders": 9,
            "Flemish Brabant": 10,
            "West Flanders": 11
        ]
        let data = [
            "BE-VAN": 0,
            "BE-WBR": 2,
            "BE-BRU": 3,
            "BE-WHT": 4,
            "BE-WLG": 5,
            "BE-VLI": 6,
            "BE-WLX": 7,
            "BE-WNA": 8,
            "BE-VOV": 9,
            "BE-VBR": 10,
            "BE-VWV": 11
        ]
        var colorAxis: [Any] = []
                for _ in 0...data.keys.count {
                    colorAxis.append(UIColor.green)
                }
        
        let map = FSInteractiveMapView(frame: CGRect(x: 16, y: 50, width: belgiumMapView.frame.width-32, height: belgiumMapView.frame.height))
        map.loadMap("belgiumLow", withData: data, colorAxis: colorAxis)
        map.clickHandler = {(identifier: String? , _ layer: CAShapeLayer?) -> Void in
            if(self.selectedMapLayer != nil) {
                self.selectedMapLayer!.zPosition = 0;
                self.selectedMapLayer!.shadowOpacity = 0;
            }
            self.selectedMapLayer = layer
            layer!.zPosition = 10;
            layer!.shadowOpacity = 0.5;
            layer!.shadowColor = UIColor.black.cgColor;
            layer!.shadowRadius = 5;
            layer!.shadowOffset = CGSize(width: 0, height: 0);
        }
        
        belgiumMapView.addSubview(map)
        

        
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
