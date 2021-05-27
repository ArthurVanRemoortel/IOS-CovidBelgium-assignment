//
//  CovidData.swift
//  EhB-IOS-Werkstuk2
//
//  Created by Arthur Van Remoortel on 27/05/2021.
//

import Foundation
import CoreData


class CovidDataManager {
    let dateFormatter = DateFormatter()

    static let sharedInstance: CovidDataManager = {
        let instance = CovidDataManager()
        instance.dateFormatter.dateFormat = "yyyy-MM-dd"
        return instance
    }()
    
    
    func getCases(context: NSManagedObjectContext){
        let url = URL(string: "https://epistat.sciensano.be/Data/COVID19BE_CASES_AGESEX.json")!
        makeGetCall(url: url, completion:  {(data : [[String: AnyObject]]) -> () in
            for caseData in data{
                if (caseData.keys.count == 6){ // API sometimes returns incomplete data. Ignore it.
                    let covidCase = Case(context: context)
                    covidCase.date = self.dateFormatter.date(from: caseData["DATE"] as! String)!
                    covidCase.province = caseData["PROVINCE"] as? String
                    covidCase.region = caseData["REGION"] as? String
                    covidCase.agegroup = caseData["AGEGROUP"] as? String
                    covidCase.sex = caseData["SEX"] as? String
                    covidCase.cases = (caseData["CASES"]?.int16Value)!
                }
            }
            do {
                try context.save()
            } catch {
            }
        })
    }
    
    func getTests(context: NSManagedObjectContext){
        let url = URL(string: "https://epistat.sciensano.be/Data/COVID19BE_tests.json")!
        makeGetCall(url: url, completion:  {(data : [[String: AnyObject]]) -> () in
            for testData in data{ 
                if (testData.keys.count == 5){ // API sometimes returns incomplete data. Ignore it.
                    let test = Test(context: context)
                    test.date = self.dateFormatter.date(from: testData["DATE"] as! String)!
                    test.province = testData["PROVINCE"] as? String
                    test.region = testData["REGION"] as? String
                    test.test_all = (testData["TESTS_ALL"]?.int16Value)!
                    test.test_all_pos = (testData["TESTS_ALL_POS"]?.int16Value)!
                }
            }
            do {
                try context.save()
            } catch {
            }
        })
    }
    
    
    func getVaccinations(context: NSManagedObjectContext){
        let url = URL(string: "https://epistat.sciensano.be/Data/COVID19BE_VACC.json")!
        makeGetCall(url: url, completion:  {(data : [[String: AnyObject]]) -> () in
            for vaccData in data{
                if (vaccData.keys.count == 8){ // API sometimes returns incomplete data. Ignore it.
                    let vacc = Vaccination(context: context)
                    vacc.date = self.dateFormatter.date(from: vaccData["DATE"] as! String)!
                    vacc.region = vaccData["REGION"] as? String
                    vacc.agegroup = vaccData["AGEGROUP"] as? String
                    vacc.sex = vaccData["SEX"] as? String
                    vacc.brand = vaccData["BRAND"] as? String
                    vacc.dose = vaccData["DOSE"] as? String
                    vacc.agegroup = vaccData["AGEGROUP"] as? String
                    vacc.count = (vaccData["COUNT"]?.int16Value)!
                }
            }
            do {
                try context.save()
            } catch {
            }
        })
    }
    

    func makeGetCall(url: URL, completion: @escaping ([[String: AnyObject]])->()){
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let parsedData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: AnyObject]] else {
                    print("error trying to convert data to JSON")
                    return
                }
                DispatchQueue.main.async {
                    completion(parsedData)
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    }
