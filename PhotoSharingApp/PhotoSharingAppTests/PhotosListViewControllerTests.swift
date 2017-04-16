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
        let photoset = mockPhotoset()
        let viewModel = PhotosListViewModel(photoset: photoset)
        let expectedScreenTitle = "Chee Yi and Zen-zi's Wedding"
        XCTAssertEqual(expectedScreenTitle, viewModel.photosetTitle())
    }

    // MARK: - Private

    fileprivate func loadDictionaryFromJSONFile(path: String) -> [String: Any] {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: path, withExtension: "json") else {
            XCTFail("unable to generate filePath")
            return [String: Any]()
        }

        guard let data = try? Data(contentsOf: fileURL) else {
            XCTFail("unable to load file")
            return [String: Any]()
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) else {
            XCTFail("unable to parse JSON from data")
            return [String: Any]()
        }

        guard let dictionary = json as? [String: Any] else {
            XCTFail("unable to parse into dictionary")
            return [String: Any]()
        }

        guard let photosetDictionary = dictionary["photoset"] as? [String: Any] else {
            XCTFail("photoset dictionary not found")
            return [String: Any]()
        }

        return photosetDictionary
    }

    fileprivate func mockPhotoset() -> Photoset {
        let dictionary = loadDictionaryFromJSONFile(path: "photoset")
        return Photoset(dictionary: dictionary)!
    }
}
