//
//  NavigationCoordinatorTests.swift
//  NavigationCoordinatorTests
//
//  Created by Artemiy Zuzin on 25.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import XCTest
@testable import Navigation


class NavigationCoordinatorTests: XCTestCase {

    private func testSelected_LogInViewController() {
        let coordinator = SecondCoordinatorMock()
        
        coordinator.pushLogInViewController()
        
        XCTAssertEqual(coordinator.selectedViewController, LogInViewController())
        XCTAssertEqual(coordinator.setSelectedViewControllerCount, 1)
    }
    
    private func testSelected_ProfileViewController() {
        let coordinator = SecondCoordinatorMock()
        
        coordinator.pushLogInViewController()
        
        XCTAssertEqual(coordinator.selectedViewController, ProfileViewController())
        XCTAssertEqual(coordinator.setSelectedViewControllerCount, 1)
    }
    
    private func testSelected_PhotosViewController() {
        let coordinator = SecondCoordinatorMock()
        
        coordinator.pushLogInViewController()
        
        XCTAssertEqual(coordinator.selectedViewController, PhotosViewController())
        XCTAssertEqual(coordinator.setSelectedViewControllerCount, 1)
    }
    
}
