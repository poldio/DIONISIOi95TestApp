//
//  HTTPRequests.swift
//  DIONISIOi95TestApp
//
//  Created by Paul Dionisio on 7/14/17.
//  Copyright © 2017 Paul Dionisio. All rights reserved.
//

import Foundation

class HTTPRequests {

    func httpGet(request: NSURLRequest, callback: (String?, NSError?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                callback(nil, error)
                return
            }
            
            callback(String(data: data!, encoding: NSUTF8StringEncoding), nil)
        }
        task.resume()
    }
    
   static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    static func convertMoviesDataModel(par: NSDictionary) -> Movies {
        
        var movie : Movies!
        movie = Movies()
        
        movie.artistName = par.objectForKey("artistName") as! String
        movie.artworkUrl100 = par.objectForKey("artworkUrl100") as! String
        movie.artworkUrl30 = par.objectForKey("artworkUrl30") as! String
        movie.artworkUrl60 = par.objectForKey("artworkUrl60") as! String
        movie.collectionExplicitness = par.objectForKey("collectionExplicitness") as! String
        movie.contentAdvisoryRating = par.objectForKey("contentAdvisoryRating") as! String
        movie.country = par.objectForKey("contentAdvisoryRating") as! String
        movie.currency = par.objectForKey("contentAdvisoryRating") as! String
        movie.longDescription = par.objectForKey("longDescription") as! String
        movie.primaryGenreName = par.objectForKey("primaryGenreName") as! String
        movie.releaseDate = par.objectForKey("releaseDate") as! String
        movie.trackCensoredName = par.objectForKey("trackCensoredName") as! String
        movie.trackExplicitness = par.objectForKey("trackExplicitness") as! String
        movie.trackName = par.objectForKey("trackName") as! String
        movie.trackViewUrl = par.objectForKey("trackViewUrl") as! String
        movie.wrapperType = par.objectForKey("wrapperType") as! String
        //movie.trackHdRentalPrice = par.objectForKey("trackHdRentalPrice") as! String
        //movie.trackId = par.objectForKey("trackId") as! String
        //movie.trackRentalPrice = par.objectForKey("trackRentalPrice") as! String
        
        return movie
    }
}