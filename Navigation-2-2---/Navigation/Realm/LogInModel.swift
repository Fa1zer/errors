//
//  LogInModel.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 27.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import RealmSwift

class LogInModel: Object {
    @objc dynamic var email = ""
    @objc dynamic var password = ""
}
