//
//  WebServiceTests.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/17/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import XCTest
@testable import PhotoSharingApp

class WebServiceTests: XCTestCase {
    func testMakePhotosetURL() {
        let testPhotosetID = "111"
        let testURL = WebService.makePhotosetRequestURL(photosetID: testPhotosetID)
        let expectedURLString = "https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=96ed7003403f50e4a475e91cf172e16d&photoset_id=111&user_id=34478335@N00&extras=date_taken%2C+geo%2C+tags%2C+machine_tags%2C+o_dims%2C+views%2C+media%2C+path_alias%2C+url_sq%2C+url_t%2C+url_s%2C+url_m&format=json&nojsoncallback=1"
        let expectedURL = URL(string: expectedURLString)

        XCTAssertNotNil(testURL)
        XCTAssertEqual(testURL!, expectedURL!)
    }
}
