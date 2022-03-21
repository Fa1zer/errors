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
    func inspect(emailOrPhone: String,
                 password: String,
                 logInCompletion: @escaping () -> Void,
                 notLogInCompletion: @escaping () -> Void)
}

final class LogInInspector: LogInViewControllerDelegate {
    
    func inspect(emailOrPhone: String, password: String, logInCompletion: @escaping () -> Void,
                 notLogInCompletion: @escaping () -> Void) {
        
        FirebaseAuth.Auth.auth().signIn(withEmail: emailOrPhone, password: password) { result, error in
            
            if let _ = error {
               
                notLogInCompletion()
            
            } else {
                
                logInCompletion()
            }
        }
    }
}
