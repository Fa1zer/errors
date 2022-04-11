//
//  SecondCoordinatorMock.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 11.04.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

final class SecondCoordinatorMock: Coordinator {
    
    var setSelectedViewControllerCount = 0
    var selectedViewController: UIViewController? {
        
        didSet {
            
            self.setSelectedViewControllerCount += 1
            
        }
        
    }
    
    func pushLogInViewController() {
        self.selectedViewController = LogInViewController()
    }
    
    func pushProfileViewController() {
        self.selectedViewController = ProfileViewController()
    }
    
    func pushPhotosViewController(images: [UIImageView] = []) {
        self.selectedViewController = PhotosViewController()
    }
    
}
