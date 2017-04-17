//
//  Photoset.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/15/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation

struct Photoset {
    let photosetID: String
    let primary: String
    let owner: String
    let ownerName: String
    let photosetTitle: String
    let photos: [Photo]

    init?(dictionary: [String: Any]) {
        guard let photosArray: [[String: Any]] = dictionary["photo"] as? [[String: Any]] else {
            return nil
        }

        let photos = photosArray.map { (photoDictionary: [String: Any]) -> Photo? in
            return Photo(dictionary: photoDictionary)
            }.flatMap { $0 }

        guard let id = dictionary["id"] as? String,
        let primary = dictionary["primary"] as? String,
        let owner = dictionary["owner"] as? String,
        let ownerName = dictionary["ownername"] as? String,
        let title = dictionary["title"] as? String else {
            return nil
        }

        photosetID = id
        self.primary = primary
        self.owner = owner
        self.ownerName = ownerName
        self.photos = photos
        self.photosetTitle = title
    }
}
