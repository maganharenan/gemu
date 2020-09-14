//
//  IGDBClient+NetworkTaskRequest.swift
//  Gemu
//
//  Created by Renan Maganha on 26/08/20.
//  Copyright © 2020 Renan Maganha. All rights reserved.
//

import SwiftUI

extension IGDBClient {
    func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = (body as! Data)
        request.setValue(Endpoints.apiKey, forHTTPHeaderField: "user-key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            #if DEBUG
                print(String(data: data, encoding: .utf8)!)
            #endif
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func taskForDownloadRequest(url: String, completion: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: url)
        
        guard let urlToDownload = url else {
            completion(nil, nil)
            return
        }
        
        let request = URLRequest(url: urlToDownload)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
