//
//  Politician.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/19/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//
import Foundation
import UIKit
import CoreImage
import SwiftyJSON
import Alamofire
import AlamofireImage

class Politician {
  let name: String
  var last_name = String()
  let runningMate: String
  let party: String
  var office: String!
  var full_bio: String!
  var short_bio: String!
  var image: UIImage!
  var imageURL: String!
  var faceBox = UIView()
  
  fileprivate var facebookID: String = ""
  
  lazy var initials: String = {
    [unowned self] in
    return self.initialsOfFullName()
    }()

  
  //EFFECTS: initializes politician without an image
  //MODIFIES: name, party
  init(name: String, party: String, facebookID: String) {
    
    var revised_name = name
    
    //REMOVE RUNNING MATE'S NAME
    if name.contains("/") {
      let names = name.components(separatedBy: "/")
      revised_name = names[0]
      self.runningMate = names[1]
    }
    else {
      self.runningMate = ""
    }
  
    //REMOVE MIDDLE NAME e.g., Lawrence R. Stelma
    var components = revised_name.components(separatedBy: " ")
    if components.count == 3 {
      revised_name = components[0] + " " + components[2]
    }
    
    
    
    self.name = revised_name
    
    if party.contains("Republican") {
      self.party = "Republican"
    }
    else if party.contains("Democrat") {
      self.party = "Democrat"
    }
    else if party.contains("Libertarian") {
      self.party = "Libertarian"
    }
    else {
      self.party = party
    }
    
    if facebookID != "" {
      imageURL =
        "http://graph.facebook.com/\(facebookID)/picture?type=large"
      
      loadImage()
      
    }
    findLastName(full_name: name)
  }
  
  fileprivate func findLastName(full_name: String) {
    let components = name.components(separatedBy: " ")
    if components.count > 1 {
      last_name = name.components(separatedBy: " ")[1]
    }
    else {
      print("error: unable to parse last name for \(name)")
      last_name = ""
    }

  }
  
  //EFFECTS: initializes politician who has image
  //MODIFIES: name, party, imageURL
  init(name: String, party: String, imageURL: String) {
    self.name = name
    self.runningMate = ""
    self.party = party
    self.imageURL = imageURL
    loadImage()
    findLastName(full_name: name)
  }
  
  init() {
    self.name = ""
    self.runningMate = ""
    self.party = ""
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
            print("error: unable to fetch image for \(self.name) at \(self.imageURL)")
          }
      }
    }
  }
  
  //REQUIRES: self.image has been initialized to a valid image
  //EFFECTS:  crops self.image to be centered on the face
  fileprivate func cropImageToFace() {
    let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)!
    if let ciImage = CIImage(image: image) {
      let faces = faceDetector.features(in: ciImage)
      if faces.count == 0 {
        print("error: no faces detected for portrait of \(name)")
      }
      else if (faces.count > 1) {
        print("error: more than one face detected for portrait of \(name)")
      }
      else {
        //There is just one face
        if let face = faces.first as? CIFaceFeature {
          print("Found face in \(name) portrait at \(face.bounds)")
          
          var faceDimensions = face.bounds
          
          //scaleBoundsByFactor(bounds: &faceDimensions, scalingFactor: 1.2)
          
          //cropImageToBounds(bounds: faceDimensions)
        }
      }
    }
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
  
  
  
  //EFFECTS: sets image when download is completed
  //MODIFIES: image
  func imageCompletionHandler(_ response: DataResponse<UIImage>) {
    if let image = response.result.value {
      self.image = image
      cropImageToSquare()
      print("image loaded for \(self.name)")
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
  
  fileprivate func cropImageToSquare() {
    
    let bitmapImage: UIImage = UIImage(cgImage: image.cgImage!)
    
    var sideLength = image.size.width * 2
    
    if image.size.width > image.size.height {
      sideLength = image.size.height * 2
    }
    
    let square = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
    
    let imageRef: CGImage = bitmapImage.cgImage!.cropping(to: square)!
    
    image = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
  }
  
  fileprivate func cropImageToBounds(bounds: CGRect) {
    let imageRef: CGImage = image.cgImage!.cropping(to: bounds)!
    image = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
  }
  
  fileprivate func scaleBoundsByFactor(bounds: inout CGRect, scalingFactor: CGFloat) {
    let startWidth = bounds.width
    let startHeight = bounds.height
    let adjustmentWidth = (startWidth * scalingFactor) / 2.0
    let adjustmentHeight = (startHeight * scalingFactor) / 2.0
    bounds = bounds.insetBy(dx: -adjustmentWidth, dy: -adjustmentHeight)
  }


  
  
  
  
}

extension String {
  
  func contains(find: String) -> Bool {
    return self.range(of: find, options: .caseInsensitive) != nil
  }
  func replace(_ string:String, replacement:String) -> String {
    return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
  }
  
  func removeWhitespace() -> String {
    return self.replace(" ", replacement: "")
  }
}
