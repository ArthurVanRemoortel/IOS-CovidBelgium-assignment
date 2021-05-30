//
//  HomeViewController.swift
//  EhB-IOS-Werkstuk2
//
//  Created by Arthur Van Remoortel on 26/05/2021.
//

import UIKit
import FSInteractiveMap
import Charts
import CoreData

class HomeViewController: UIViewController, ChartViewDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var chartLabel: UILabel!
    @IBOutlet var dataTypeSegmentControl: UISegmentedControl!
    @IBOutlet var belgiumMapView: UIView!
    @IBOutlet var selectionLineChart: LineChartView!
    @IBOutlet var hintLabel: UILabel!
    var selectedMapRegion: (String, CAShapeLayer?) = ("Belgium", nil)
    var interactiveMapview: FSInteractiveMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
        initInteractiveMap()
        dataTypeChanged()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupChart(){
        selectionLineChart.dragEnabled = false
        selectionLineChart.setScaleEnabled(false)
        selectionLineChart.pinchZoomEnabled = false
        selectionLineChart.drawGridBackgroundEnabled = false
        selectionLineChart.xAxis.drawLabelsEnabled = false
        selectionLineChart.leftAxis.drawGridLinesEnabled = false
        selectionLineChart.xAxis.drawGridLinesEnabled = false
        selectionLineChart.drawGridBackgroundEnabled = false
        selectionLineChart.legend.enabled = false
        selectionLineChart.leftAxis.labelTextColor = LightPinkColor.uiColor
        selectionLineChart.rightAxis.enabled = false
        selectionLineChart.drawBordersEnabled = false
        selectionLineChart.xAxis.drawAxisLineEnabled = false
        selectionLineChart.minOffset = 0
    }
    
    @IBAction func dataTypeChanged() {
        // TODO: Messy duplicate code.
        let index = dataTypeSegmentControl.selectedSegmentIndex
        var values: [ChartDataEntry] = []
        
        do {
            if (index == 0){
                // Cases
                let fetchRequest: NSFetchRequest<Case> = Case.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
                if (self.selectedMapRegion.0 != "Belgium"){
                    fetchRequest.predicate = NSPredicate(format: "province = %@", self.selectedMapRegion.0)
                }
                let dbfetchResult = try context.fetch(fetchRequest)
                var dateIndex = 0
                var currentDate = dbfetchResult.first?.date
                var totalCasesDay = 0
                for covidCase in dbfetchResult {
                    let caseDate = covidCase.date
                    if (caseDate != currentDate){
                        // New day, new entry.
                        values.append(ChartDataEntry(x: Double(dateIndex), y: Double(totalCasesDay)))
                        currentDate = caseDate
                        dateIndex += 1
                        totalCasesDay = 0
                    }
                    // Same day. Accumulate number of cases.
                    totalCasesDay += Int(covidCase.cases)
                }
                chartLabel.text = "Selection: Cases in \(self.selectedMapRegion.0)"
                self.hintLabel.text = ""

            } else if (index == 1){
                // Vaccinations
                let fetchRequest: NSFetchRequest<Vaccination> = Vaccination.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
                let dbfetchResult = try context.fetch(fetchRequest)
                var dateIndex = 0
                var currentDate = dbfetchResult.first?.date
                var totalCasesDay = 0
                for covidVaccination in dbfetchResult {
                    let caseDate = covidVaccination.date
                    if (caseDate != currentDate){
                        // New day, new entry.
                        values.append(ChartDataEntry(x: Double(dateIndex), y: Double(totalCasesDay)))
                        currentDate = caseDate
                        dateIndex += 1
                        totalCasesDay = 0
                    }
                    // Same day. Accumulate number of cases.
                    totalCasesDay += Int(covidVaccination.count)
                }
                chartLabel.text = "Selection: Vaccinations in Belgium"
                hintLabel.text = "(No province specific data)"
                
            } else {
                // Tests
                let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
                if (self.selectedMapRegion.0 != "Belgium"){
                    fetchRequest.predicate = NSPredicate(format: "province = %@", self.selectedMapRegion.0)
                }
                let dbfetchResult = try context.fetch(fetchRequest)
                var dateIndex = 0
                var currentDate = dbfetchResult.first?.date
                var totalCasesDay = 0
                for covidTest in dbfetchResult {
                    let caseDate = covidTest.date
                    if (caseDate != currentDate){
                        // New day, new entry.
                        values.append(ChartDataEntry(x: Double(dateIndex), y: Double(totalCasesDay)))
                        currentDate = caseDate
                        dateIndex += 1
                        totalCasesDay = 0
                    }
                    // Same day. Accumulate number of cases.
                    totalCasesDay += Int(covidTest.test_all)
                }
                chartLabel.text = "Selection: Tests in \(self.selectedMapRegion.0)"
                self.hintLabel.text = ""

            }
            let dataSet = LineChartDataSet(entries: values, label: "DataSet 1")
            setupDataset(dataSet)
            let lineData = LineChartData(dataSet: dataSet)
            selectionLineChart.data = lineData
        } catch {
            print("Loading chart failed")
        }
    }
    
    private func setupDataset(_ dataSet: LineChartDataSet) {
        dataSet.drawCirclesEnabled = false
        dataSet.setColor(GreenColor.uiColor)
        dataSet.lineWidth = 2
        dataSet.valueFont = .systemFont(ofSize: 9)
        dataSet.formLineWidth = 1
        dataSet.formSize = 15
        dataSet.mode = .cubicBezier
        dataSet.drawIconsEnabled = false
        let gradientColors = [DarkestBlueColor.uiColor.cgColor,
                              GreenColor.uiColor.cgColor
        ]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        dataSet.fillAlpha = 0.5
        dataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.cubicIntensity = 0.1
    }
    
    func updateInteractiveMapData(){
        let data = [
            "Antwerpen": colorNumberForProvince(province: "Antwerpen"),
            "BrabantWallon": colorNumberForProvince(province: "BrabantWallon"),
            "Brussels": colorNumberForProvince(province: "Brussels"),
            "Hainaut": colorNumberForProvince(province: "Hainaut"),
            "Liège": colorNumberForProvince(province: "Liège"),
            "Limburg": colorNumberForProvince(province: "Limburg"),
            "Luxembourg": colorNumberForProvince(province: "Luxembourg"),
            "Namur": colorNumberForProvince(province: "Namur"),
            "OostVlaanderen": colorNumberForProvince(province: "OostVlaanderen"),
            "VlaamsBrabant": colorNumberForProvince(province: "VlaamsBrabant"),
            "WestVlaanderen": colorNumberForProvince(province: "WestVlaanderen")
        ]
        let colorAxis: [UIColor] = [
            GreenColor.uiColor,
            UIColor.orange,
            UIColor.red
        ]
        if (interactiveMapview != nil){
            interactiveMapview!.loadMap("belgiumLow", withData: data, colorAxis: colorAxis)
        }
    }
    
    func initInteractiveMap(){
        interactiveMapview = FSInteractiveMapView(frame: CGRect(x: 16, y: 75, width: belgiumMapView.frame.width-64, height: belgiumMapView.frame.height))
        interactiveMapview!.clickHandler = {(identifier: String? , _ layer: CAShapeLayer?) -> Void in
            self.hintLabel.text = ""
            if (self.selectedMapRegion.1 != nil) {
                // Drop current layer.
                self.selectedMapRegion.1!.zPosition = 0;
                self.selectedMapRegion.1!.shadowOpacity = 0;
            }
            if (layer != self.selectedMapRegion.1){
                // Raise new layer if it is not the currently selected one.
                self.selectedMapRegion = (identifier!, layer!)
                layer!.zPosition = 20;
                layer!.shadowOpacity = 0.8;
                layer!.shadowColor = UIColor.black.cgColor;
                layer!.shadowRadius = 15;
                layer!.shadowOffset = CGSize(width: 0, height: 0);
            } else {
                // Reset to all of Belgium.
                self.selectedMapRegion = ("Belgium", nil)
            }
            self.dataTypeChanged()
        }
        belgiumMapView.addSubview(interactiveMapview!)
    }
    
    func colorNumberForProvince(province: String) -> Int{
        // very simple implementation. Calculates cumulative cases for province. Does not consider total population of province. 
        let calendar: Calendar = NSCalendar.current
        let now = Date()
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: now)!
        let startDate = calendar.startOfDay(for: sevenDaysAgo)
        let fetchRequest: NSFetchRequest<Case> = Case.fetchRequest()
        let provincePredicate = NSPredicate(format: "province = %@", province)
        let datePredicate = NSPredicate(format:"date >= %@", startDate as CVarArg)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [provincePredicate, datePredicate])
        fetchRequest.predicate = andPredicate
        do {
            let dbfetchResult = try context.fetch(fetchRequest)
            let cumulativeCases = Int(dbfetchResult.reduce(0, { $0 + $1.cases}))
            return cumulativeCases
        } catch {
            return 0
        }
    }
}
