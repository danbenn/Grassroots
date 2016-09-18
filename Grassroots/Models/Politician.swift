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
  
  fileprivate var facebookID: String = ""
  
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
  fileprivate func findWikipediaInfo() {
    
    let separated_names = name.components(separatedBy: " ")
    
    let first_last = separated_names.first! + " " + separated_names.last!
    
    //print(first_last)
    
    let web_ready_name = first_last.replacingOccurrences(of: " ", with: "%20")
    let summaryURL = "https://en.wikipedia.org/w/api.php!format=json&action=query&prop=extracts" +
      "&redirects=1&exintro=&explaintext=&titles=\(web_ready_name)"
    _ = "https://en.wikipedia.org/w/api.php?action=query" +
      "&redirects=1&titles=\(web_ready_name)&prop=pageimages&format=json&pithumbsize=200"
    
    requestBio(summaryURL)
    
  }
  
  fileprivate func requestBio(_ summaryURL: String) {
    Alamofire
      .request(summaryURL)
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
  fileprivate func bioCompletionHandler(_ response: DataResponse<Any>) {
    let pages = JSON(response.result.value!)["query"]["pages"]
    if !pages["-1"].exists() {
      let first_page = pages.first!.0
      self.full_bio = pages[first_page]["extract"].stringValue
    }
  }
  
  //EFFECTS: loads politician portrait image
  fileprivate func loadImage() {
    if imageURL != nil {
      Alamofire.request(imageURL!)
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
  func imageCompletionHandler(_ response: DataResponse<UIImage>) {
    if let image = response.result.value {
      
      let cropped_image = squareCrop(image as! UIImage)
      
      self.image = cropped_image
    }
  }
  
  fileprivate func initialsOfFullName() -> String {
    let separated_names = self.name.components(separatedBy: " ")
    var lastNameIndex = 0
    
    switch separated_names.count {
    case 2:  lastNameIndex = 1 //John Smith
    case 3:  lastNameIndex = 2 //John W Smith
    case 4:  lastNameIndex = 2 //John W Smith Jr
    default: break //print("unable to parse initials for \(name)")
    }
    
    return separated_names[0][0] + separated_names[lastNameIndex][0]
  }
  
  
  fileprivate func saveImage(_ image: UIImage, filename: String) {
    let documentsURL = FileManager.default.urls(
      for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = documentsURL.appendingPathComponent(filename).path
    
    let pngImageData = UIImagePNGRepresentation(image)
    
    try? pngImageData!.write(to: URL(fileURLWithPath: path), options: [.atomic])
    
  }
  
  fileprivate func squareCrop(_ image: UIImage) -> UIImage {
    
    let bitmapImage: UIImage = UIImage(cgImage: image.cgImage!)
    
    var sideLength = image.size.width * 2
    
    if image.size.width > image.size.height {
      sideLength = image.size.height * 2
    }
    
    let square = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
    
    let imageRef: CGImage = bitmapImage.cgImage!.cropping(to: square)!
    
    let croppedImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    
    return croppedImage
  }
  
  
  
  
}

extension String {
  func replace(_ string:String, replacement:String) -> String {
    return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
  }
  
  func removeWhitespace() -> String {
    return self.replace(" ", replacement: "")
  }
}
