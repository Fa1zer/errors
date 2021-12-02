//
//  LogInInspector.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 31.08.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol LogInViewControllerDelegate {
    func inspect(emailOrPhone: String, password: String)
}

final class LogInInspector: LogInViewControllerDelegate {
    
    func inspect(emailOrPhone: String, password: String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: emailOrPhone, password: password) { result, error in
            
            if let _ = error {
                NotificationCenter.default.post(name: Notification.Name("notLogIn"), object: nil)
            } else {
                NotificationCenter.default.post(name: Notification.Name("logIn"), object: nil)
            }
        }
    }
}
