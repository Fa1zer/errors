//
//  NetworkService.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 09.11.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation

struct NetworkService {
    static func dataTaskFromURL(URL: URL) {
        let URLSesion = URLSession.shared
        
        URLSesion.dataTask(with: URL) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")// error code: -1009
                
                return
            }
            
            guard let data = data else { return }
            
            if let stringData = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("\nData:\n\(stringData)")
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            print("\nHeaders:\n\(response.allHeaderFields)")
            print("\nStatus code: \(response.statusCode)")
        }.resume()
    }
}
