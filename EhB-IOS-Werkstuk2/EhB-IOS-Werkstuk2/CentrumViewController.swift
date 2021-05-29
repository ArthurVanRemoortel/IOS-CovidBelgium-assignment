//
//  CentrumViewController.swift
//  EhB-IOS-Werkstuk 1
//
//  Created by Arthur Van Remoortel on 24/05/2021.
//

import UIKit
import MapKit
import CoreLocation


class CentrumViewController: UIViewController, MKMapViewDelegate {
    var covidCentrum:CovidCentrum?
    var locationManager = CLLocationManager()
    

    @IBOutlet var centrumNaamLabel: UILabel!
    @IBOutlet var centrumGemeenteLabel: UILabel!
    @IBOutlet var centrumAdresLabel: UILabel!
    @IBOutlet var centrumTelefoonLabel: UILabel!
    @IBOutlet var centrumFoto: UIImageView!
    @IBOutlet var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.centrumFoto.image = UIImage(named: self.covidCentrum!.fotoNaam)
        self.centrumNaamLabel.text = self.covidCentrum!.naam
        self.centrumGemeenteLabel.text = self.covidCentrum!.adres.gemeente
        self.centrumTelefoonLabel.text = self.covidCentrum!.telefoon
        self.centrumAdresLabel.text = self.covidCentrum!.adres.straat + " " + self.covidCentrum!.adres.huisNr
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.covidCentrum!.coordinaat.0, longitude: self.covidCentrum!.coordinaat.1)
        myMapView.addAnnotation(annotation)
        centerMapOn(location: annotation.coordinate)
    }
    
    func centerMapOn(location: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.myMapView.setRegion(region, animated: true)
    }
}
