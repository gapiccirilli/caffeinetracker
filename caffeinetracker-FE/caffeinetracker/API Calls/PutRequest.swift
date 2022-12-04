//
//  PutRequest.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/31/22.
//

import Foundation

class PutRequest: ObservableObject {
    @Published var updatedCaffeine = Caffeine()
    @Published var errorResponse: ErrorModel?
    
    func updateCaffeine(caffeine: Caffeine, caffeineId: Int, tenantId: String, token: String) -> Void {
        
        guard let url = URL(string: "http://localhost:8080/api/\(tenantId)/intake/caffeine/\(caffeineId)") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable] = [
            "id": caffeine.id,
            "beverage": caffeine.beverage,
            "amount": caffeine.amount,
            "month": caffeine.month,
            "day": caffeine.day,
            "year": caffeine.year,
            "hour": caffeine.hour,
            "minute": caffeine.minute,
            "seconds": caffeine.seconds
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, responseData, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let httpResponse = responseData as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    let response = try JSONDecoder().decode(Caffeine.self, from: data)
                    print("Successfully Updated!")
                    DispatchQueue.main.async {
                        self?.updatedCaffeine = response
                    }
                } else {
                    let response = try JSONDecoder().decode(ErrorModel.self, from: data)
                    print("Successfully Updated!")
                    DispatchQueue.main.async {
                        self?.errorResponse = response
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
