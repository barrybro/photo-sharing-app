//
//  WebService.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/17/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation

class WebService {

    // MARK: - Flickr API Properties

    static let flickrKey = "96ed7003403f50e4a475e91cf172e16d"
    static let flickrSecret = "588dc19e3d8ab9e2"

    // MARK: - Keychain Properties

    static let keychainService = "PhotoSharingAppTokenService"
    static let keychainAccount = "PhotoSharingApp.keychain"

    // MARK: - URL properties

    static let baseURL = "https://api.flickr.com/services/rest/"
    static let methodURL = "?method="
    static let photosetsGetPhotosMethodKey = "flickr.photosets.getPhotos"
    static let apiURL = "&api_key="
    static let apiKey = "96ed7003403f50e4a475e91cf172e16d"
    static let photosetURL = "&photoset_id="
    static let photosetID = "72157680286729381"

    static let userURL = "&user_id="
    static let userID = "34478335@N00"
    static let extrasURL = "&extras="
    static let extrasParameters = "date_taken%2C+geo%2C+tags%2C+machine_tags%2C+o_dims%2C+views%2C+media%2C+path_alias%2C+url_sq%2C+url_t%2C+url_s%2C+url_m"
    static let formatURL = "&format="
    static let formatType = "json&nojsoncallback=1"

    // MARK: - Fetch Photosets

    static func makePhotosetRequestURL(photosetID: String) -> URL? {
        let requestURL = baseURL + methodURL + photosetsGetPhotosMethodKey + apiURL + apiKey + photosetURL + photosetID + userURL + userID + extrasURL + extrasParameters + formatURL + formatType
        return URL(string: requestURL)
    }

    static func fetchPhotoset(photosetID: String, completion: @escaping (_ photoset: Photoset?) -> Void) {
        guard let requestURL = makePhotosetRequestURL(photosetID: photosetID) else {
            print("Error building request URL")
            completion(nil)
            return
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let downloadTask = session.dataTask(with: requestURL, completionHandler: {(data, response, error) in
            guard let responseData = data else {
                debugPrint("ERROR \(String(describing: error))")
                completion(nil)
                return
            }
            guard let jsonResponse: [String: Any] = try? JSONSerialization.jsonObject(with: responseData) as! [String : Any] else {
                completion(nil)
                return
            }
            guard let photosetDictionary = jsonResponse["photoset"] as? [String : Any] else {
                print("parse photoset dictionary error")
                completion(nil)
                return
            }
            guard let photoset = Photoset(dictionary: photosetDictionary) else {
                print("parse error")
                completion(nil)
                return
            }
            completion(photoset)
        })

        downloadTask.resume()
    }
}
