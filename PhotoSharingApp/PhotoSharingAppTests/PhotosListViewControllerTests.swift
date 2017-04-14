//
//  PhotosListViewControllerTests.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/14/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import XCTest
@testable import PhotoSharingApp

class PhotosListViewModelTests: XCTestCase {

    func testTitle() {
        let viewModel = PhotosListViewModel()
        let expectedScreenTitle = "Photos List"
        XCTAssertEqual(expectedScreenTitle, viewModel.screenTitle)
    }
}
