//
//  PhotoDetailViewModel.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/17/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation

struct PhotoDetailViewModel {

    let photo: Photo

    let shareButtonTitle = "Share Photo"

    // Tags?
    func photoTitle() -> String {
        return photo.title
    }

    func photoURL() -> String {
        return photo.imageURL
    }

    func photoDateTaken() -> String {
        // Convert date string from API to Date object
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: photo.dateTaken) else {
            fatalError()
        }

        // Format Date object
        let newFormatter = DateFormatter()
        newFormatter.dateStyle = .medium

        return "Taken on " + newFormatter.string(from: date)
    }

    func photoViewCount() -> String {
        guard let viewNumber = Int(photo.viewCount) else {
            return "0"
        }
        var countString = photo.viewCount + " view"
        if viewNumber != 1 {
            countString += "s"
        }
        return countString
    }
}
