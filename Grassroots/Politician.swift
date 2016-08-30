//
//  Politician.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/19/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class Politician {
    dynamic var name: String = ""
    dynamic var office: String!
    dynamic var full_bio: String!
    dynamic var short_bio: String!
    //dynamic var image: UIImage!
    dynamic var imageURL: String!
    dynamic var party: String = ""
    
    
    //EFFECTS: initializes politician without an image
    //MODIFIES: name, party
    init(name: String, party: String) {
        self.name = name
        self.party = party 
        //createBio()
    }
    
    //EFFECTS: initializes politician who has image
    //MODIFIES: name, party, imageURL
    init(name: String, party: String, imageURL: String) {
        self.name = name
        self.party = party
        self.imageURL = imageURL
        //createBio()
        loadImage()

    }
    
    //EFFECTS:  creates politician bio from wikipedia
    //MODIFIES: bio
    private func createBio() {
        
        let web_ready_name = name.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        let wikiURL = "https://en.wikipedia.org/w/api.php!format=json&action=query&prop=extracts" +
            "&redirects=1&exintro=&explaintext=&titles=\(web_ready_name)"
        
        Alamofire
            .request(.GET, wikiURL)
            
            .responseJSON { response in
                
                if response.result.isSuccess {
                    self.bioCompletionHandler(response)
                }
                else {
                    print("error: unable to process API request to MediaWiki")
                    print(response.result.error)
                }
                
               
        }
        
    }

    //EFFECTS: sets bio when request is completed
    //MODIFIES: full_bio
    private func bioCompletionHandler(response: Response<AnyObject, NSError>) {
        let pages = JSON(response.result.value!)["query"]["pages"]
        if pages["-1"] == nil {

            let first_page = pages.first!.0
            let full_bio = pages[first_page]["extract"].stringValue
            
            createShortBio(full_bio)
        }
        
    }

    //EFFECTS: creates a one sentence biography
    //MODIFIES: short_bio
    private func createShortBio(full_bio: String) {
        var full_bio = full_bio
        let name_removal_array = full_bio.componentsSeparatedByString(")")
        
        if name_removal_array.count > 1 {
           full_bio = name_removal_array[1] 
        }
        
        let sentences = full_bio.componentsSeparatedByString(". ")
        let first_sentence = sentences[0]
        
        if first_sentence.containsString("is an ") {
            short_bio = first_sentence.componentsSeparatedByString("is an ").last
        }
        else if first_sentence.containsString("is the ") {
            short_bio = first_sentence.componentsSeparatedByString("is the ").last
        }
        else {
            short_bio = first_sentence
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
                        print("error: unable to fetch image")
                    }
            }
        }
    }

    //EFFECTS: sets image when download is completed
    //MODIFIES: image
    private func imageCompletionHandler(response: Response<UIImage, NSError>) {
        if let image = response.result.value {
            
            let filename = self.name.removeWhitespace()
            
            let cropped_image = squareCrop(image)
            
            saveImage(cropped_image, filename: filename)
            
        }
    }
    
    private func saveImage(image: UIImage, filename: String) {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        let path = documentsURL.URLByAppendingPathComponent(filename).path!
        
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