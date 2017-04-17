//
//  WebService.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/17/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation
import OAuthSwift
import SAMKeychain

class WebService {

    // MARK: - OAuth Properties

    static let flickrKey = "96ed7003403f50e4a475e91cf172e16d"
    static let flickrSecret = "588dc19e3d8ab9e2"
    static let authenticationURLForMyApp = "https://www.flickr.com/auth-72157680536890821"
    static let requestTokenURL = "https://www.flickr.com/services/oauth/request_token"
    static let authorizeURL = "https://www.flickr.com/services/oauth/authorize"
    static let accessTokenURL = "https://www.flickr.com/services/oauth/access_token"

    // MARK: - Keychain Properties

    static let keychainService = "PhotoSharingAppTokenService"
    static let keychainAccount = "PhotoSharingApp.keychain"

    // MARK: - URL properties

    static let baseURL = "https://api.flickr.com/services/rest/"
    static let methodURL = "?method="
    static let photosGetSizesMethodKey = "flickr.photos.getSizes"
    static let apiURL = "&api_key="
    static let apiKey = "96ed7003403f50e4a475e91cf172e16d"
    static let photoURL = "&photo_id="
    static let userURL = "&user_id="
    static let userID = "34478335@N00"
    static let formatURL = "&format="
    static let formatType = "json&nojsoncallback=1"
    static let authTokenURL = "&auth_token="
    static let apiSigURL = "&api_sig"
    static let apiSigID = "3f23e5c0aa4d3beadcf93661f724bd8f"

    static func makePhotoRequestURL(photoID: String) -> URL? {
        var requestURL = baseURL + methodURL + photosGetSizesMethodKey + apiURL + apiKey + photoURL + photoID + formatURL + formatType + apiSigURL + apiSigID
        requestURL = requestURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        return URL(string: requestURL)
    }

    static func fetchPhoto(identifier: String, completion: @escaping (_ photoURL: String?) -> Void) {
        guard let requestURL = makePhotoRequestURL(photoID: identifier) else {
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
            guard let sizesDictionary = jsonResponse["sizes"] as? [String : Any] else {
                print("parse photo sizes dictionary error")
                completion(nil)
                return
            }
            guard let sizesArray = sizesDictionary["size"] as? [[String : Any]] else {
                print("parse size array error")
                completion(nil)
                return
            }
            let filteredSizes = sizesArray.filter({ (element) -> Bool in
                element["label"] as? String == "Square"
            })
            guard let thing = filteredSizes.first else {
                print("oh shit")
                completion(nil)
                return
            }
            guard let photoURL = thing["source"] as? String else {
                completion(nil)
                return
            }
            print("parse success for \(photoURL)")
            completion(photoURL)
        })

        downloadTask.resume()
    }

    static func oauthSwift() -> OAuth1Swift {
        let oauthSwift = OAuth1Swift(consumerKey: WebService.flickrKey,
                                     consumerSecret: WebService.flickrSecret,
                                     requestTokenUrl: WebService.requestTokenURL,
                                     authorizeUrl: WebService.authorizeURL,
                                     accessTokenUrl: WebService.accessTokenURL)
        return oauthSwift
    }

    static func saveToken(token: String) -> Bool {
        return SAMKeychain.setPassword(token, forService: WebService.keychainService, account: WebService.keychainAccount)
    }

    static func fetchToken() -> String? {
        return SAMKeychain.password(forService: WebService.keychainService, account: WebService.keychainAccount)
    }
}

//let url = "https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=91254bea8c4aa44590f868e76a44bf85&photoset_id=72157680286729381&user_id=34478335%40N00&format=json&nojsoncallback=1&api_sig=3f23e5c0aa4d3beadcf93661f724bd8f"

struct PhotosetFetcher {
    static let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos"
    static let apiURL = "&api_key="
    static let apiKey = "96ed7003403f50e4a475e91cf172e16d"
    static let photosetURL = "&photoset_id="
    static let photosetID = "72157680286729381"
    static let userURL = "&user_id="
    static let userID = "34478335@N00"
    static let formatURL = "&format="
    static let formatType = "json&nojsoncallback=1"
    static let apiSigURL = "&api_sig"
    static let apiSigID = "3f23e5c0aa4d3beadcf93661f724bd8f"

    static func makeRequestURL() -> URL? {
        var requestURL = baseURL + apiURL + apiKey + photosetURL + photosetID + userURL + userID + formatURL + formatType + apiSigURL + apiSigID
        requestURL = requestURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        return URL(string: requestURL)
    }

    static func fetchPhotosets(completion: @escaping (_ photoset: Photoset?) -> Void) {
        guard let requestURL = makeRequestURL() else {
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
            print("parse success for \(photoset)")
            completion(photoset)
        })

        downloadTask.resume()
    }
}
