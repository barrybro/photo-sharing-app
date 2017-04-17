//
//  LaunchViewModelTests.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/14/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import XCTest
@testable import PhotoSharingApp

class LaunchViewModelTests: XCTestCase {

    func testButtonTitle() {
        let expectedButtonTitle = "buttonTitle"
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedButtonTitle, viewModel.buttonTitle)
    }

    func testTitleString() {
        let expectedTitle = "Hello World"
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedTitle, viewModel.titleString)
    }

    func testLabelTitle() {
        let expectedTitle = "LabelTitle"
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedTitle, viewModel.labelTitle)
    }
}
