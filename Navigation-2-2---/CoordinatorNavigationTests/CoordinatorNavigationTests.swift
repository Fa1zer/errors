//
//  CoordinatorNavigationTests.swift
//  CoordinatorNavigationTests
//
//  Created by Artemiy Zuzin on 11.04.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import XCTest
@testable import Navigation

class CoordinatorNavigationTests: XCTestCase {

    func testSelected_LogInViewController() {
            let coordinator = SecondCoordinatorMock()
            
            coordinator.pushLogInViewController()
            
            XCTAssertTrue(coordinator.selectedViewController is LogInViewController)
            XCTAssertEqual(coordinator.setSelectedViewControllerCount, 1)
        }
        
        func testSelected_ProfileViewController() {
            let coordinator = SecondCoordinatorMock()

            coordinator.pushProfileViewController()

            XCTAssertTrue(coordinator.selectedViewController is ProfileViewController)
            XCTAssertEqual(coordinator.setSelectedViewControllerCount, 1)
        }

        func testSelected_PhotosViewController() {
            let coordinator = SecondCoordinatorMock()

            coordinator.pushPhotosViewController()

            XCTAssertTrue(coordinator.selectedViewController is PhotosViewController)
            XCTAssertEqual(coordinator.setSelectedViewControllerCount, 1)
        }

}
