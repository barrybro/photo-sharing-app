//
//  PhotosListViewModelTests.swift
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

    func testPhotoCount() {
        let photoset = mockPhotoset()
        let viewModel = PhotosListViewModel(photoset: photoset)
        let expectedPhotoCount = 39
        XCTAssertEqual(expectedPhotoCount, viewModel.photoCount())
    }

    func testReuseIdentifier() {
        let photoset = mockPhotoset()
        let viewModel = PhotosListViewModel(photoset: photoset)
        let expectedReuseIdentifier = "photoCell"
        XCTAssertEqual(expectedReuseIdentifier, viewModel.photoCellReuseIdentifier)
    }

    func testNumberOfSections() {
        let photoset = mockPhotoset()
        let viewModel = PhotosListViewModel(photoset: photoset)
        let expectedNumberOfSections = 1
        XCTAssertEqual(expectedNumberOfSections, viewModel.numberOfSections)
    }

    func testPhotoInBoundsAtIndex() {
        let photoset = mockPhotoset()
        let viewModel = PhotosListViewModel(photoset: photoset)
        XCTAssertNotNil(viewModel.photo(index: 1))
    }

    func testPhotoAtOutOfBoundsAtIndex() {
        let photoset = mockPhotoset()
        let viewModel = PhotosListViewModel(photoset: photoset)
        XCTAssertNil(viewModel.photo(index: 99))
    }

    // MARK: - Private

    fileprivate func loadDictionaryFromJSONFile(_ path: String) -> [String: Any] {
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
        let dictionary = loadDictionaryFromJSONFile("photoset-extras")
        return Photoset(dictionary: dictionary)!
    }
}
