//
//  Photo.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/15/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation

struct Photo {
    let photoID: String
    let title: String
    let thumbnailURL: String
    let imageURL: String
    let dateTaken: String
    let viewCount: String
    let tags: String

    init?(dictionary: [String: Any]) {
        guard let photoID = dictionary["id"] as? String,
        let title = dictionary["title"] as? String,
        let thumbnailURL = dictionary["url_sq"] as? String,
        let imageURL = dictionary["url_m"] as? String,
        let dateTaken = dictionary["datetaken"] as? String,
        let viewCount = dictionary["views"] as? String,
        let tags = dictionary["tags"] as? String else {
            print("🤢 failed to init Photo \(String(describing: dictionary["title"]))")
                return nil
        }
        self.photoID = photoID
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
        self.dateTaken = dateTaken
        self.viewCount = viewCount
        self.tags = tags
    }
}
