//
//  LaunchViewModel.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/14/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation

struct LaunchViewModel {
    let titleString = "Hello World"
    let loadingTitle = "Loading..."
    let buttonTitle = "buttonTitle"
    let loadingDuration: TimeInterval = 0.33
    let labelTitle = "LabelTitle"
    let defaultPhotosetID = "72157680286729381"

    func loadPhotoset(showLoadingBlock: () -> Void, completion: @escaping (_ photoset: Photoset?) -> Void) {
        showLoadingBlock()

        // fetch photos and in completion return and call hide
        WebService.fetchPhotoset(photosetID: defaultPhotosetID) { (photoset: Photoset?) in
            if let photoset = photoset {
                completion(photoset)
            } else {
                completion(nil)
            }
        }
    }
}
