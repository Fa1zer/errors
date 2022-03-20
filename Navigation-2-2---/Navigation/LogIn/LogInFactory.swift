//
//  LogInFactory.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 31.08.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation

protocol LogInFactory {
    
    func createInspector() -> LogInInspector
}

final class MyLogInFactory: LogInFactory {
    func createInspector() -> LogInInspector { LogInInspector() }
}
