//
//  MoviesTableViewController.swift
//  DIONISIOi95TestApp
//
//  Created by Paul Dionisio on 7/16/17.
//  Copyright © 2017 Paul Dionisio. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController, UISearchBarDelegate{
    
    private var movies : NSMutableArray!
    private var myTableView: UITableView!
    lazy var searchBar:UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tableView.registerNib(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        self.tableView.backgroundColor = UIColor(colorLiteralRed: 0.2, green: 0.4, blue: 1, alpha: 1)
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.movies = NSMutableArray()
        self.addSearchBar()
        
    }
    
    func addSearchBar() -> Void
    {
        searchBar.searchBarStyle = UISearchBarStyle.Prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.translucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        let rightNavBarButton = UIBarButtonItem(title: "Search", style: .Plain, target: self, action:#selector(self.searchButton))
        
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        navigationItem.titleView = searchBar
    }
    
    func searchButton ()
    {
        // retrieve movies search results
        let req = HTTPRequests()
        let search = searchBar.text
        let escapedString = search!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let path = iTunesSearch.appendSearchURL(escapedString!)
        let url: NSURL = NSURL(string: path)!
        let request = NSMutableURLRequest(URL: url)
        
        
        req.httpGet(request) { string, error in
            guard error == nil && string != nil else {
                print("httpGet: ", error?.localizedDescription)
                return
            }
            self.movies.removeAllObjects()
            //dispatch_async(dispatch_get_main_queue(), {
            let movies = HTTPRequests.convertStringToDictionary(string!)
            print("response: ", string!)
            for (key, value) in movies! {
                if(key == "results")
                {
                    
                    for var i in (0..<value.count)
                    {
                        let par = value.objectAtIndex(i) as! NSDictionary
                        self.movies.addObject(HTTPRequests.convertMoviesDataModel(par))
                        
                    }
                }
            }
            // for debugging only
            for var i in (0..<self.movies!.count)
            {
                var movie : Movies
                movie = self.movies!.objectAtIndex(i) as! Movies
                print("i was here", movie.artistName)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.rowHeight=140
        let cell = tableView.dequeueReusableCellWithIdentifier("MoviesTableViewCell", forIndexPath: indexPath) as! MoviesTableViewCell
        
        
        var movie : Movies!
        movie = Movies()
        movie = self.movies.objectAtIndex(indexPath.row) as! Movies
        cell.movieTitle?.text = movie.trackName
        cell.movieDescription?.text = movie.longDescription
        
        let url: NSURL = NSURL(string: movie.artworkUrl100!)!
        let request = NSMutableURLRequest(URL: url)
        
        
        HTTPRequests.httpGetImage(request) { string, error in
            guard error == nil && string != nil else {
                print(error?.localizedDescription)
                return
            }
            let _image = UIImage(data: string!)
            dispatch_async(dispatch_get_main_queue(), {
                cell.imageView!.image = _image!
                tableView.reloadData()
            })
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newViewController = DetailsViewController()
        newViewController.movie = self.movies.objectAtIndex(indexPath.row) as! Movies
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
