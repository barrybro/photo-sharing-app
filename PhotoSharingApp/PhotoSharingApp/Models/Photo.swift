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

    init?(dictionary: [String: Any]) {
        guard let photoID = dictionary["id"] as? String,
        let secret = dictionary["secret"] as? String,
        let server = dictionary["server"] as? String,
        let farm = dictionary["farm"] as? Int,
        let title = dictionary["title"] as? String,
        let isPrimary = dictionary["isprimary"] as? String,
        let isPublic = dictionary["ispublic"] as? Int,
        let isFriend = dictionary["isfriend"] as? Int,
            let isFamily = dictionary["isfamily"] as? Int else {
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
    }
}
