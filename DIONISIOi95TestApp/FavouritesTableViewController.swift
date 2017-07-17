//
//  FavouritesTableViewController.swift
//  DIONISIOi95TestApp
//
//  Created by Paul Dionisio on 7/16/17.
//  Copyright © 2017 Paul Dionisio. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController,UISearchBarDelegate {
    
    lazy var searchBar:UISearchBar = UISearchBar()
    var movies : NSArray!
    
    override func viewWillAppear(animated: Bool) {
        
        self.title = "Bookmarks"

        // set navigationbar title
        var lblTitle : UILabel
        lblTitle = UILabel()
        lblTitle.textColor = UIColor(colorLiteralRed: 0.2, green: 0.4, blue: 1, alpha: 1)
        lblTitle.text = "Favourites"
        self.navigationItem.titleView?.addSubview(lblTitle)
        
        // check if Bookmarks.plist is already created in Documents directory
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.URLByAppendingPathComponent("Bookmarks.plist").path!
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {
            print("FILE AVAILABLE \(filePath)")
            self.movies = HTTPRequests.readPListFromDocuments()
            
        } else {
            print("FILE NOT AVAILABLE \(filePath)")
            self.movies = HTTPRequests.readPropertyList()
            
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        self.tableView.backgroundColor = UIColor(colorLiteralRed: 0.2, green: 0.4, blue: 1, alpha: 1)
        
        self.title = "Bookmarks"
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.URLByAppendingPathComponent("Bookmarks.plist").path!
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filePath) {
            print("FILE AVAILABLE \(filePath)")
            self.movies = HTTPRequests.readPListFromDocuments()

        } else {
            print("FILE NOT AVAILABLE \(filePath)")
            self.movies = HTTPRequests.readPropertyList()

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.movies.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        tableView.rowHeight=140
        let cell = tableView.dequeueReusableCellWithIdentifier("MoviesTableViewCell", forIndexPath: indexPath) as! MoviesTableViewCell
        
        cell.movieTitle.text = self.movies.objectAtIndex(indexPath.row).objectForKey("title") as? String
        cell.movieDescription.text = self.movies.objectAtIndex(indexPath.row).objectForKey("description") as? String
        
        let ico = self.movies.objectAtIndex(indexPath.row).objectForKey("imageico") as? String
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let destinationPath = documentsPath.stringByAppendingString(ico!)
        print("dest \(destinationPath)")
        
        dispatch_async(dispatch_get_main_queue(), {
            
            cell.movieImage!.image = UIImage(contentsOfFile: String(UTF8String: destinationPath)!)
            self.tableView.reloadData()
        })
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newViewController = DetailsViewController()
        var movie : Movies
        movie = Movies()
        
        var arr : NSDictionary
        arr = NSDictionary()
        arr = self.movies.objectAtIndex(indexPath.row) as! NSDictionary
        
        movie.trackName = arr.objectForKey("title") as? String
        movie.releaseDate = arr.objectForKey("year") as? String
        movie.primaryGenreName = arr.objectForKey("genre") as? String
        movie.artistName = arr.objectForKey("actor") as? String
        movie.longDescription = arr.objectForKey("description") as? String
        movie.artworkUrl100 = arr.objectForKey("image") as? String        
        
        newViewController.movie = movie
        newViewController.ifLocal = true
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
