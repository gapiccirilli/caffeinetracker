//
//  DeleteRequest.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/31/22.
//

import Foundation

class DeleteRequest: ObservableObject {
    @Published var deleteMessage = ""
    
    func deleteCaffeine(date: DateComponents, caffeineId: Int, tenantId: String, token: String, completion: @escaping () -> Void) -> Void {
        
        var strMonth: String = String(date.month!)
        var strDay: String = String(date.day!)
        let strYear: String = String(date.year!)
        
        if strMonth.count == 1 {
            strMonth.insert("0", at: strMonth.startIndex)
        }
        if strDay.count == 1 {
            strDay.insert("0", at: strDay.startIndex)
        }
        
        guard let url = URL(string: "http://localhost:8080/api/\(tenantId)/intake/caffeine/\(caffeineId)?date=\(strMonth)/\(strDay)/\(strYear)") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, responseData, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let httpResponse = responseData as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    let response = try JSONDecoder().decode(String.self, from: data)
                    print("Successfully Deleted!")
                    DispatchQueue.main.async {
                        self?.deleteMessage = response
                        completion()
                    }
                } else {
                    let response = try JSONDecoder().decode(ErrorModel.self, from: data)
                    print("Successfully Deleted!")
                    DispatchQueue.main.async {
                        self?.deleteMessage = response.message
                        completion()
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
