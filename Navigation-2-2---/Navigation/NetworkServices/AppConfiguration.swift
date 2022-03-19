//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 09.11.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation

enum AppConfiguration: String {
    case firstURL = "https://swapi.dev/api/people/8/?format=json"
    case secondURL = "https://swapi.dev/api/starships/3/?format=json"
    case thirdURL = "https://swapi.dev/api/planets/5/?format=json"
    
    static let allCases: [AppConfiguration] = [.firstURL, .secondURL, .thirdURL]
}
