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
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPrimary: String
    let isPublic: Int
    let isFriend: Int
    let isFamily: Int
    let thumbnailURL: String
    let imageURL: String
    let dateTaken: String
    let viewCount: String
    let tags: String

    init?(dictionary: [String: Any]) {
        guard let photoID = dictionary["id"] as? String,
        let secret = dictionary["secret"] as? String,
        let server = dictionary["server"] as? String,
        let farm = dictionary["farm"] as? Int,
        let title = dictionary["title"] as? String,
        let isPrimary = dictionary["isprimary"] as? String,
        let isPublic = dictionary["ispublic"] as? Int,
        let isFriend = dictionary["isfriend"] as? Int,
        let isFamily = dictionary["isfamily"] as? Int,
        let thumbnailURL = dictionary["url_sq"] as? String,
        let imageURL = dictionary["url_m"] as? String,
        let dateTaken = dictionary["datetaken"] as? String,
        let viewCount = dictionary["views"] as? String,
        let tags = dictionary["tags"] as? String else {
            print("🤢 failed to init Photo \(String(describing: dictionary["title"]))")
                return nil
        }
        self.photoID = photoID
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.isPrimary = isPrimary
        self.isPublic = isPublic
        self.isFriend = isFriend
        self.isFamily = isFamily
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
        self.dateTaken = dateTaken
        self.viewCount = viewCount
        self.tags = tags
    }
}
