//
//  PostRequest.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/30/22.
//

import Foundation

class PostRequest: ObservableObject {
    @Published var createdCaffeine = Caffeine()
    @Published var user = UserModel()
    @Published var token: String?
    @Published var errorResponse: ErrorModel?
    
    func createCaffeine(caffeine: Caffeine, tenantId: String, token: String, completion: @escaping (_ caffeineObj: Caffeine?, _ errorDetails: ErrorModel?) -> Void) -> Void {
        
        guard let url = URL(string: "http://localhost:8080/api/\(tenantId)/intake/caffeine") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable] = [
            "id": String(caffeine.id),
            "beverage": caffeine.beverage,
            "amount": String(caffeine.amount),
            "month": String(caffeine.month),
            "day": String(caffeine.day),
            "year": String(caffeine.year),
            "hour": String(caffeine.hour),
            "minute": String(caffeine.minute),
            "seconds": String(caffeine.seconds)
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) {data, responseData, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let httpResponse = responseData as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if statusCode == 201 {
                    let response = try JSONDecoder().decode(Caffeine.self, from: data)
                    print("Successfully Created!")
                    DispatchQueue.main.async {
                        completion(response, nil)
                        
                    }
                } else {
                    let response = try JSONDecoder().decode(ErrorModel.self, from: data)
                    print("Successfully Created!")
                    DispatchQueue.main.async {
                        completion(nil, response)
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func login(credentials: LoginModel, completion: @escaping (_ user: UserModel?, _ auth: String?, _ errorDetails: ErrorModel?) -> Void) -> Void {
        
        guard let url = URL(string: "http://localhost:8080/api/user/login") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "userName": credentials.userName,
            "email": credentials.email,
            "password": credentials.password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) {data, responseData, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let httpResponse = responseData as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    let response = try JSONDecoder().decode(UserModel.self, from: data)
                    let headers = httpResponse.allHeaderFields
                    let auth = headers["Jwt-Token"] as? String
                    print("Successfully Logged In!")
                    DispatchQueue.main.async {
                        completion(response, auth ?? "No Token", nil)
                    }
                } else {
                    let response = try JSONDecoder().decode(ErrorModel.self, from: data)
                    print("Authentication Error")
                    DispatchQueue.main.async {
                        completion(nil, nil, response)
                    }
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func register(registerDetails: RegisterModel, completion: @escaping (_ user: UserModel?, _ errorDetails: ErrorModel?) -> Void) -> Void {
        
        guard let url = URL(string: "http://localhost:8080/api/user/signup") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "firstName": registerDetails.firstName,
            "lastName": registerDetails.lastName,
            "userName": registerDetails.userName,
            "email": registerDetails.email,
            "password": registerDetails.password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) {data, responseData, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let httpResponse = responseData as! HTTPURLResponse
                if httpResponse.statusCode == 201 {
                    let response = try JSONDecoder().decode(UserModel.self, from: data)
                    print("Successfully Logged In!")
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                } else {
                    let response = try JSONDecoder().decode(ErrorModel.self, from: data)
                    print("Successfully Logged In!")
                    DispatchQueue.main.async {
                        completion(nil, response)
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
