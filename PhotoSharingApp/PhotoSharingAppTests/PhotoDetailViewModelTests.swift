//
//  PhotoDetailViewModelTests.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/17/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import XCTest
@testable import PhotoSharingApp

class PhotoDetailViewModelTests: XCTestCase {
    func testButtonTitle() {
        let viewModel = mockViewModel()
        let expectedTitle = "Share Photo"
        XCTAssertEqual(expectedTitle, viewModel.shareButtonTitle)
    }

    func testPhotoTitle() {
        let viewModel = mockViewModel()
        let expectedTitle = "title"
        XCTAssertEqual(expectedTitle, viewModel.photoTitle())
    }

    func testPhotoURL() {
        let viewModel = mockViewModel()
        let expectedValue = "url_m"
        XCTAssertEqual(expectedValue, viewModel.photoURL())
    }

    func testPhotoDateTaken() {
        let viewModel = mockViewModel()
        let expectedString = "Taken on Mar 4, 2017"
        XCTAssertEqual(expectedString, viewModel.photoDateTaken())
    }

    func testPhotoViewCountSingleView() {
        let viewModel = mockViewModel(viewCount: "1")
        let expectedString = "1 view"
        XCTAssertEqual(expectedString, viewModel.photoViewCount())
    }

    func testPhotoViewCountMultipleViews() {
        let viewModel = mockViewModel()
        let expectedString = "4 views"
        XCTAssertEqual(expectedString, viewModel.photoViewCount())
    }

    func testAlertTitle() {
        let expectedTitle = "Uh oh!"
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedTitle, viewModel.alertTitle)
    }

    func testAlertMessage() {
        let expectedTitle = "Image missing."
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedTitle, viewModel.alertMessage)
    }

    func testAlertButtonTitle() {
        let expectedTitle = "OK"
        let viewModel = LaunchViewModel()
        XCTAssertEqual(expectedTitle, viewModel.alertButtonTitle)
    }

    // MARK: - Private

    fileprivate func mockViewModel(viewCount: String = "4") -> PhotoDetailViewModel {
        let dictionary: [String: Any] = ["id": "123",
                                         "title": "title",
                                         "url_sq": "url_sq",
                                         "url_m": "url_m",
                                         "datetaken": "2017-03-04 09:59:55",
                                         "views": viewCount,
                                         "tags": "tags wedding"]
        let photo = Photo(dictionary: dictionary)!
        return PhotoDetailViewModel(photo: photo)
    }
}
