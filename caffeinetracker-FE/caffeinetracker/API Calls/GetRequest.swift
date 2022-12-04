//
//  GetRequest.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/27/22.
//

import Foundation

class GetRequest: ObservableObject {
    
    @Published var caffeine: [Caffeine] = []
    @Published var intakes: [DailyIntake] = []
    @Published var intake: DailyIntake = DailyIntake()
    @Published var errorResponse: ErrorModel = ErrorModel()
    
    @Published var caffeineErrorFlag = false
    
    func fetchAllCaffeine(date: DateComponents, tenantId: String, token: String, completion: @escaping () -> Void) {
        
        var strMonth: String = String(date.month!)
        var strDay: String = String(date.day!)
        var strYear: String = String(date.year!)
        
        if strMonth.count == 1 {
            strMonth.insert("0", at: strMonth.startIndex)
        }
        if strDay.count == 1 {
            strDay.insert("0", at: strDay.startIndex)
        }

        guard let url = URL(string: "http://localhost:8080/api/\(tenantId)/intake/caffeine?date=\(strMonth)/\(strDay)/\(strYear)") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self]
            data, responseData, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let httpResponse = responseData as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    var caffeine = try JSONDecoder().decode([Caffeine].self, from: data)
                    
                    DispatchQueue.main.async {
                        caffeine.sort {
                            $0.id < $1.id
                        }
                        self?.caffeine = caffeine
                        self?.caffeineErrorFlag = false
                        completion()
                    }
                } else {
                    let errorMessage = try JSONDecoder().decode(ErrorModel.self, from: data)
                    DispatchQueue.main.async {
                        self?.errorResponse = errorMessage
                        self?.caffeineErrorFlag = true
                        completion()
                    }
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchAllIntakesInRange(startDate: DateComponents, endDate: DateComponents, tenantId: String, token: String, completion: @escaping () -> Void) {
        
        var startMonth: String = String(startDate.month!)
        var startDay: String = String(startDate.day!)
        var startYear: String = String(startDate.year!)
        
        var endMonth: String = String(endDate.month!)
        var endDay: String = String(endDate.day!)
        var endYear: String = String(endDate.year!)
        
        if startMonth.count == 1 {
            startMonth.insert("0", at: startMonth.startIndex)
        }
        if startDay.count == 1 {
            startDay.insert("0", at: startDay.startIndex)
        }
        if endMonth.count == 1 {
            endMonth.insert("0", at: endMonth.startIndex)
        }
        if endDay.count == 1 {
            endDay.insert("0", at: endDay.startIndex)
        }
        

        guard let url = URL(string: "http://localhost:8080/api/\(tenantId)/intake?startDate=\(startMonth)/\(startDay)/\(startYear)&endDate=\(endMonth)/\(endDay)/\(endYear)") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self]
            data, responseData, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let httpResponse = responseData as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    var intakes = try JSONDecoder().decode([DailyIntake].self, from: data)
                    DispatchQueue.main.async {
                        intakes.sort {
                            $0.id < $1.id
                        }
                        self?.intakes = intakes
                        completion()
                    }
                } else {
                    var errorResponse = try JSONDecoder().decode(ErrorModel.self, from: data)
                    DispatchQueue.main.async {
                        self?.errorResponse = errorResponse
                        completion()
                    }
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchIntakeByDate(date: DateComponents, tenantId: String, token: String, completion: @escaping () -> Void) {
        
        var strMonth: String = String(date.month!)
        var strDay: String = String(date.day!)
        var strYear: String = String(date.year!)
        
        if strMonth.count == 1 {
            strMonth.insert("0", at: strMonth.startIndex)
        }
        if strDay.count == 1 {
            strDay.insert("0", at: strDay.startIndex)
        }

        guard let url = URL(string: "http://localhost:8080/api/\(tenantId)/intake/intakedate?date=\(strMonth)/\(strDay)/\(strYear)") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self]
            data, responseData, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let httpResponse = responseData as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    let intake = try JSONDecoder().decode(DailyIntake.self, from: data)
                    DispatchQueue.main.async {
                        
                        self?.intake = intake
                        completion()
                    }
                } else {
                    let errorResponse = try JSONDecoder().decode(ErrorModel.self, from: data)
                    DispatchQueue.main.async {
                        
                        self?.errorResponse = errorResponse
                        completion()
                    }
                }
            }
            catch {
                
                print(error)
            }
        }
        task.resume()
    }
}
