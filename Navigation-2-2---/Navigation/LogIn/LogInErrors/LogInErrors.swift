//
//  LogInErrors.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 28.11.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation


enum LogInErrors: Error {
    case fieldsIsEmpty
    case passwordIsShort
}
