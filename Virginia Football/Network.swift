//
//  Network.swift
//  Virginia Football
//
//  Created by Samuel Cummings on 10/23/21.
//

import UIKit
import SwiftUI

class Network: ObservableObject {
    @State var dataReturn : String
    let url : URL
    var request: URLRequest
    
    init(url: String) {
        self.dataReturn = ""
        self.url = URL(string: url)!
        request = URLRequest(url: self.url)
        request.httpMethod = "GET"
        request.setValue("e76b29b3cc1e46a7b28c3346389bead4", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    }
    
    public func getRequest() {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("There was an error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Response Status Code: \(response.statusCode)")
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                DispatchQueue.main.async {
                    self.dataReturn = dataString
                }
            }
        }
        task.resume()
    }
}
