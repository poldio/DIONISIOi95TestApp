//
//  HTTPRequests.swift
//  DIONISIOi95TestApp
//
//  Created by Paul Dionisio on 7/14/17.
//  Copyright © 2017 Paul Dionisio. All rights reserved.
//

import Foundation
import UIKit

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
    
    static func httpGetImage(request: NSURLRequest, callback: (NSData?, NSError?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                callback(nil, error)
                return
            }
            
            callback(NSData(data: data!), nil)
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
        
        movie.artistName = par.objectForKey("artistName") as? String
        movie.artworkUrl100 = par.objectForKey("artworkUrl100") as? String
        movie.artworkUrl30 = par.objectForKey("artworkUrl30") as? String
        movie.artworkUrl60 = par.objectForKey("artworkUrl60") as? String
        movie.collectionExplicitness = par.objectForKey("collectionExplicitness") as? String
        movie.contentAdvisoryRating = par.objectForKey("contentAdvisoryRating") as? String
        movie.country = par.objectForKey("contentAdvisoryRating") as? String
        movie.currency = par.objectForKey("contentAdvisoryRating") as? String
        movie.longDescription = par.objectForKey("longDescription") as? String
        movie.primaryGenreName = par.objectForKey("primaryGenreName") as? String
        movie.releaseDate = par.objectForKey("releaseDate") as? String
        movie.trackCensoredName = par.objectForKey("trackCensoredName") as? String
        movie.trackExplicitness = par.objectForKey("trackExplicitness") as? String
        movie.trackName = par.objectForKey("trackName") as? String
        movie.trackViewUrl = par.objectForKey("trackViewUrl") as? String
        movie.wrapperType = par.objectForKey("wrapperType") as? String
        
        return movie
    }
    
    static func readPropertyList() -> NSArray {
        let path = NSBundle.mainBundle().pathForResource("Bookmarks", ofType: "plist")!
        let arr = NSArray(contentsOfFile: path)
        
        return arr!
    }
    
    static func readPListFromDocuments() -> NSArray
    {
        let filePath = HTTPRequests.getDirectoryPath().URLByAppendingPathComponent("/Bookmarks.plist").path!
        
        let arr = NSArray(contentsOfFile: filePath)
        
        return arr!
    }
    
    static func saveToPlist(movie : NSDictionary) -> NSArray
    {
        let filePath = HTTPRequests.getDirectoryPath().URLByAppendingPathComponent("/Bookmarks.plist").path!
        let fileManager = NSFileManager.defaultManager()
        var arr : NSMutableArray
        arr = NSMutableArray()

        if fileManager.fileExistsAtPath(filePath) {
            print("FILE AVAILABLE \(filePath)")
            arr.setArray(self.readPListFromDocuments() as [AnyObject])
            
        } else {
            print("FILE NOT AVAILABLE \(filePath)")
            arr.setArray(self.readPropertyList() as [AnyObject])
        }
        
        arr.addObject(movie)
        return arr
    }
    
    static func applicationDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let basePath = paths.first ?? ""
        return basePath
    }
    
    static func getDirectoryPath() -> NSURL {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        return url
    }
    
    static func saveImageDocumentDirectory() -> Void{
        let fileManager = NSFileManager.defaultManager()
        let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("apple.jpg")
        let image = UIImage(named: "apple.jpg")
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFileAtPath(paths as String, contents: imageData, attributes: nil)
    }
}