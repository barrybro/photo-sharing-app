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
        let expectedButtonTitle = "View Photo Set"
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedButtonTitle, viewModel.buttonTitle)
    }

    func testTitleString() {
        let expectedTitle = "Flickr Photoset Viewer"
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedTitle, viewModel.titleString)
    }

    func testLoadingTitle() {
        let expectedTitle = "Loading..."
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedTitle, viewModel.loadingTitle)
    }

    func testLoadingDuration() {
        let expectedDuration: TimeInterval = 0.33
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedDuration, viewModel.loadingDuration)
    }

    func testDefaultPhotosetID() {
        let expectedPhotosetID = "72157680286729381"
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedPhotosetID, viewModel.defaultPhotosetID)
    }

    func testAlertTitle() {
        let expectedTitle = "Uh oh!"
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedTitle, viewModel.alertTitle)
    }

    func testAlertMessage() {
        let expectedTitle = "Something went wrong fetching your photos."
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedTitle, viewModel.alertMessage)
    }

    func testAlertButtonTitle() {
        let expectedTitle = "OK"
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedTitle, viewModel.alertButtonTitle)
    }
}
