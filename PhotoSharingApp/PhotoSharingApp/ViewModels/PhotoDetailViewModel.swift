//
//  PhotoDetailViewModel.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/17/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation
import UIKit

struct PhotoDetailViewModel {

    let photo: Photo

    let shareButtonTitle = "Share Photo"
    let alertTitle = "Uh oh!"
    let alertMessage = "Image missing."
    let alertButtonTitle = "OK"

    func photoTitle() -> NSAttributedString {
        return NSAttributedString(string: photo.title,
                                  attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)])
    }

    func photoURL() -> String {
        return photo.imageURL
    }

    func photoDateTaken() -> NSAttributedString {
        // Convert date string from API to Date object
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: photo.dateTaken) else {
            fatalError()
        }

        // Format Date object
        let newFormatter = DateFormatter()
        newFormatter.dateStyle = .medium

        let takenOnMessage = "Taken on " + newFormatter.string(from: date)
        return NSAttributedString(string: takenOnMessage,
                                  attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .subheadline)])
    }

    func photoViewCount() -> NSAttributedString {
        let viewNumber = Int(photo.viewCount) ?? 0
        var countString = photo.viewCount + " view"
        if viewNumber != 1 {
            countString += "s"
        }
        return NSAttributedString(string: countString,
                                  attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption1)])
    }
}
