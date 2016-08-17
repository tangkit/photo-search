//
//  ViewController.swift
//  Photo Search Example
//
//  Created by tkit on 8/14/16.
//  Copyright © 2016 Tang Kit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        let manager = AFHTTPSessionManager()
        super.viewDidLoad()
        let searchParameters = ["method": "flickr.photos.search",
                                "api_key": "58a7e16367b1babeb646fb4ff9eabcac",
                                "format": "json",
                                "nojsoncallback": 1,
                                "text": "dogs",
                                "extras": "url_m",
                                "per_page": 5]
        
        manager.GET("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: NSURLSessionDataTask,responseObject: AnyObject?) in
                        if let responseObject = responseObject {
                            print("Response: " + responseObject.description)
                            if let photos = responseObject["photos"] as? [String: AnyObject] {
                                if let photoArray = photos["photo"] as? [[String: AnyObject]] {
                                    self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(photoArray.count))
                                    for (i,photoDictionary) in photoArray.enumerate() {                             //1
                                        if let imageURLString = photoDictionary["url_m"] as? String {               //2
                                            let imageView = UIImageView(frame: CGRectMake(0, 320*CGFloat(i), 320, 320))     //#1
                                            if let url = NSURL(string: imageURLString) {
                                                imageView.setImageWithURL( url)                                             //#2
                                                self.scrollView.addSubview(imageView)
                                            }
                                        }
                                    }
                                }
                            }
                        }
            },
                    failure: { (operation: NSURLSessionDataTask?,error: NSError) in
                        print("Error: " + error.localizedDescription)
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

