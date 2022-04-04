//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 26.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation
import LocalAuthentication

class LocalAuthorizationService {
    
    init() {
        
        _ = self.laContext.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &self.error
        )
        
    }
    
    private let laContext = LAContext()
    var biometryType: LABiometryType {
        return self.laContext.biometryType
    }
    
    private var error: NSError?
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, LAError?) -> Void) {
        
        DispatchQueue.main.async { [ weak self ] in
            
            guard let self = self else { return }
            
            self.laContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "To access your profile, we need access to your biometrics."
            ) { success, error in
                
                if let error = error as? LAError {
                    print(error.localizedDescription)
                    
                    authorizationFinished(false, error)
                
                    return
                }
                
                authorizationFinished(success, nil)
                
                return
                
            }
                        
        }
        
    }
    
}
