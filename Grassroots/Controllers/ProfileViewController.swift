//
//  ProfileViewController.swift
//  Grassroots
//
//  Created by Daniel Bennett on 12/27/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

import FacebookCore

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var name = String()
  
  var index = 0
  
  var person = Politician()
  
  func setupCollectionView() {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 80, left: 0, bottom: 10, right: 0)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    collectionView?.collectionViewLayout = layout
    collectionView?.alwaysBounceVertical = true
    collectionView?.backgroundColor = UIColor(red: 233/255.0, green: 235/255.0, blue: 238/255.0, alpha: 1)
    
    collectionView?.backgroundColor = customColors.lightGray
    
    collectionView?.register(PictureCell.self, forCellWithReuseIdentifier: "PictureCell")
    collectionView?.register(BiographyCell.self, forCellWithReuseIdentifier: "BiographyCell")
    collectionView?.register(ProfileCell.self, forCellWithReuseIdentifier: "ProfileCell")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
    
    person = model.politicians[index]
    
    self.title = "Profile" //set navigation bar title
    
    print("received index \(index) from parent view controller")
  
    index = 0
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: UINavigationBar().frame.height + viewConstants.MARGIN, left: 0, bottom: 10, right: 0)
  }
  
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch indexPath.row {
    case 0:
      let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureCell
      cell.setupViews(person)
      return cell
    case 1:
      let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
      cell.setupViews(person)
      return cell
    
    default:
      let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "BiographyCell", for: indexPath) as! BiographyCell
      cell.setupViews(person)
      return cell
    }
  }

  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    switch indexPath.row {
    case 0:
      return CGSize(width: view.frame.width, height: 150)
    case 1:
      return CGSize(width: view.frame.width, height: 115)
    case 2:
//      if person.full_bio != "" {
//        let rect = NSString(string: person.full_bio).boundingRect(with: CGSize(width: collectionView.frame.width - 32, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)], context: nil)
//        return CGSize(width: view.frame.width, height: rect.height + 24)
//      }
      
      return CGSize(width: view.frame.width, height: 115)
      

    default:
      return CGSize(width: view.frame.width, height: 0)
    }
    
    

  }
  
}







