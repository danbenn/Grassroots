//
//  Politician.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/19/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class Politician {
  let name: String
  let party: String
  var office: String!
  var full_bio: String!
  var short_bio: String!
  var image: UIImage!
  var imageURL: String!
  
  private var facebookID: String = ""
  
  lazy var initials: String = {
    [unowned self] in
    return self.initialsOfFullName()
    }()
  
  
  //EFFECTS: initializes politician without an image
  //MODIFIES: name, party
  init(name: String, party: String, facebookID: String) {
    self.name = name
    self.party = party
    
    if facebookID != "" {
      imageURL =
        "http://graph.facebook.com/\(facebookID)/picture?type=large"
      
      loadImage()
      
    }
  }
  
  //EFFECTS: initializes politician who has image
  //MODIFIES: name, party, imageURL
  init(name: String, party: String, imageURL: String) {
    self.name = name
    self.party = party
    self.imageURL = imageURL
    loadImage()
  }
  
  init() {
    self.name = ""
    self.party = ""
  }
  
  
  
  
  //EFFECTS:  creates politician bio from wikipedia
  //MODIFIES: bio
  private func findWikipediaInfo() {
    
    let separated_names = name.componentsSeparatedByString(" ")
    
    let first_last = separated_names.first! + " " + separated_names.last!
    
    //print(first_last)
    
    let web_ready_name = first_last.stringByReplacingOccurrencesOfString(" ", withString: "%20")
    let summaryURL = "https://en.wikipedia.org/w/api.php!format=json&action=query&prop=extracts" +
      "&redirects=1&exintro=&explaintext=&titles=\(web_ready_name)"
    _ = "https://en.wikipedia.org/w/api.php?action=query" +
      "&redirects=1&titles=\(web_ready_name)&prop=pageimages&format=json&pithumbsize=200"
    
    requestBio(summaryURL)
    
  }
  
  private func requestBio(summaryURL: String) {
    Alamofire
      .request(.GET, summaryURL)
      .responseJSON { response in
        if response.result.isSuccess {
          self.bioCompletionHandler(response)
        }
        else {
          print("error: unable to process bio API request to MediaWiki")
          //print(response.result.error)
        }
    }
  }
  
  //EFFECTS: sets bio when request is completed
  //MODIFIES: full_bio
  private func bioCompletionHandler(response: Response<AnyObject, NSError>) {
    let pages = JSON(response.result.value!)["query"]["pages"]
    if !pages["-1"].isExists() {
      let first_page = pages.first!.0
      self.full_bio = pages[first_page]["extract"].stringValue
    }
  }
  
  //EFFECTS: loads politician portrait image
  private func loadImage() {
    if imageURL != nil {
      Alamofire.request(.GET, imageURL!)
        .responseImage { response in
          if response.result.isSuccess {
            self.imageCompletionHandler(response)
          }
          else {
            print("error: unable to fetch image for \(self.name)")
          }
      }
    }
  }
  
  //EFFECTS: sets image when download is completed
  //MODIFIES: image
  func imageCompletionHandler(response: Response<UIImage, NSError>) {
    if let image = response.result.value {
      
      let cropped_image = squareCrop(image)
      
      self.image = cropped_image
    }
  }
  
  private func initialsOfFullName() -> String {
    let separated_names = self.name.componentsSeparatedByString(" ")
    var lastNameIndex = 0
    
    switch separated_names.count {
    case 2:  lastNameIndex = 1 //John Smith
    case 3:  lastNameIndex = 2 //John W Smith
    case 4:  lastNameIndex = 2 //John W Smith Jr
    default: break //print("unable to parse initials for \(name)")
    }
    
    return separated_names[0][0] + separated_names[lastNameIndex][0]
  }
  
  
  private func saveImage(image: UIImage, filename: String) {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(
      .DocumentDirectory, inDomains: .UserDomainMask)[0]
    
    let path = documentsURL.URLByAppendingPathComponent(filename)!.path!
    
    let pngImageData = UIImagePNGRepresentation(image)
    
    pngImageData!.writeToFile(path, atomically: true)
    
  }
  
  private func squareCrop(image: UIImage) -> UIImage {
    
    let bitmapImage: UIImage = UIImage(CGImage: image.CGImage!)
    
    var sideLength = image.size.width * 2
    
    if image.size.width > image.size.height {
      sideLength = image.size.height * 2
    }
    
    let square = CGRectMake(0, 0, sideLength, sideLength)
    
    let imageRef: CGImage = CGImageCreateWithImageInRect(bitmapImage.CGImage!, square)!
    
    let croppedImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    
    return croppedImage
  }
  
  
  
  
}

extension String {
  func replace(string:String, replacement:String) -> String {
    return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
  }
  
  func removeWhitespace() -> String {
    return self.replace(" ", replacement: "")
  }
}
