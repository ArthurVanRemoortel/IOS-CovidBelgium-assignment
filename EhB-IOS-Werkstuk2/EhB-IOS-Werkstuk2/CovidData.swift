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
    
    var apiUrls: [String : ([[String: AnyObject]], NSManagedObjectContext)->Void] = [:]
    
    static let shared: CovidDataManager = {
        let instance = CovidDataManager()
        instance.dateFormatter.dateFormat = "yyyy-MM-dd"
        instance.apiUrls = [
            "https://epistat.sciensano.be/Data/COVID19BE_CASES_AGESEX.json" : instance.saveCasesToCoreData,
            "https://epistat.sciensano.be/Data/COVID19BE_tests.json" : instance.saveTestsToCoreData,
            "https://epistat.sciensano.be/Data/COVID19BE_VACC.json" : instance.saveVaccinationsToCoreData,
        ]
        return instance
    }()
    
    func getAllData(context: NSManagedObjectContext, mainCompletionHandler: @escaping () -> Void){
        // TODO: Sometimes concurrency problem??? https://stackoverflow.com/questions/25812268/core-data-error-exception-was-caught-during-core-data-change-processing
        // Only when trying to insert data while reset is still active.
        for (urlString, saveFunction) in apiUrls{
            makeGetCall(url: URL(string: urlString)!, completionHandler: {data in
                saveFunction(data, context)
                mainCompletionHandler()
            })
        }
    }
    
    func saveCasesToCoreData(data : [[String: AnyObject]], context: NSManagedObjectContext){
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
    }
    
    func saveTestsToCoreData(data : [[String: AnyObject]], context: NSManagedObjectContext){
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
    }
    
    func saveVaccinationsToCoreData(data : [[String: AnyObject]], context: NSManagedObjectContext){
        for vaccData in data{
            if (vaccData.keys.count == 7){ // API sometimes returns incomplete data. Ignore it.
                let vacc = Vaccination(context: context)
                vacc.date = self.dateFormatter.date(from: vaccData["DATE"] as! String)!
                vacc.region = vaccData["REGION"] as? String
                vacc.agegroup = vaccData["AGEGROUP"] as? String
                vacc.sex = vaccData["SEX"] as? String
                vacc.brand = vaccData["BRAND"] as? String
                vacc.dose = vaccData["DOSE"] as? String
                vacc.count = (vaccData["COUNT"]?.int16Value)!
            }
        }
        do {
            try context.save()
        } catch {
        }
    }
    
    func makeGetCall(url: URL, completionHandler: @escaping ([[String: AnyObject]])->(), completionOnMainThread: Bool = true){
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
                completionHandler(parsedData)
//                if (completionOnMainThread){
//                    DispatchQueue.main.async {
//                        completion(parsedData)
//                    }
//                } else {
//                    completion(parsedData)
//                }
//                completion(parsedData)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
}
