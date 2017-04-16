//
//  PhotosetTests.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/15/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import XCTest
@testable import PhotoSharingApp

class PhotosetTests: XCTestCase {
    func testPhotosetInstantiation() {
        let photoset = mockPhotoset()

        let expectedPhotosetID = "72157680286729381"
        let expectedPrimary = "33720404102"
        let expectedOwner = "34478335@N00"
        let expectedOwnerName = "Barry Brown "
        let expectedPhotoCount = 39
        let expectedPhotosetTitle = "Chee Yi and Zen-zi's Wedding"

        XCTAssertEqual(photoset.photosetID, expectedPhotosetID)
        XCTAssertEqual(photoset.primary, expectedPrimary)
        XCTAssertEqual(photoset.owner, expectedOwner)
        XCTAssertEqual(photoset.ownerName, expectedOwnerName)
        XCTAssertEqual(photoset.photos.count, expectedPhotoCount)
        XCTAssertEqual(photoset.photosetTitle, expectedPhotosetTitle)
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
