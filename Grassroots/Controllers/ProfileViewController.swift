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
  
  let cellId = "headshotCell"
  
  let bioText = "Marco Antonio Rubio (born May 28, 1971) is an American politician and attorney, and the junior United States Senator from Florida. Rubio previously served as Speaker of the Florida House of Representatives.\nRubio is a Cuban American from Miami, with degrees from the University of Florida and the University of Miami School of Law. In the late 1990s, he served as a City Commissioner for West Miami and was elected to the Florida House of Representatives in 2000, representing the 111th House district.\nLater in 2000, Rubio was promoted to be one of two majority whips, and in 2002, he was appointed House Majority Leader by Speaker Johnnie Byrd. Subsequently, he was elected Speaker of the Florida House, serving as Speaker for two years beginning in November 2006. Upon leaving the Florida legislature in 2008 due to term limits, Rubio started a new law firm, and also began teaching at Florida International University, where he continues as an adjunct professor.\nRubio successfully ran for United States Senate in 2010. In the U.S. Senate, he chairs the Commerce Subcommittee on Oceans, Atmosphere, Fisheries, and Coast Guard, as well as the Foreign Relations Subcommittee on Western Hemisphere, Transnational Crime, Civilian Security, Democracy, Human Rights and Global Women's Issues. He is one of three Latino Americans serving in the Senate.\nIn April 2015, Rubio announced that he would forgo seeking reelection to the Senate to run for President. He suspended his campaign for President on March 15, 2016, after losing the Republican primary in his home state of Florida to Donald Trump. On June 22, 2016, he reversed his decision not to seek reelection to the Senate and announced a campaign for reelection citing the 2016 Orlando nightclub shooting. Rubio was reelected after defeating Democrat Patrick Murphy in the 2016 general election."
  
  
  
  var name = String()
  
  var index:Int = 0
  
  func setupCollectionView() {
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 80, left: 0, bottom: 10, right: 0)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    collectionView?.collectionViewLayout = layout
    collectionView?.alwaysBounceVertical = true
    collectionView?.backgroundColor = UIColor(red: 233/255.0, green: 235/255.0, blue: 238/255.0, alpha: 1)
    
    collectionView?.backgroundColor = UIColor.yellow
    
    collectionView?.register(PictureCell.self, forCellWithReuseIdentifier: "PictureCell")
    collectionView?.register(BiographyCell.self, forCellWithReuseIdentifier: "BiographyCell")
    collectionView?.register(ProfileCell.self, forCellWithReuseIdentifier: "ProfileCell")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
    
    
    name = "Barack Obama"
    index = 0
    
    self.title = "Profile"
  
        
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 80, left: 0, bottom: 10, right: 0)
  }
  
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch indexPath.row {
    case 0:
      let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureCell
      cell.setupViews()
      return cell
    case 1:
      let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
      cell.setupViews()
      return cell
    
    default:
      let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "BiographyCell", for: indexPath) as! BiographyCell
      cell.setupViews(bioText)
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
      
      let rect = NSString(string: bioText).boundingRect(with: CGSize(width: collectionView.frame.width - 24, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20.5)], context: nil)
      
      return CGSize(width: view.frame.width, height: rect.height + 24)

    default:
      return CGSize(width: view.frame.width, height: 115)
    }
    
    

  }
  
}

class BiographyCell: UICollectionViewCell {
  
  let cardView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.green
    return view
  }()
  
  let textView: UITextView = {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.red
    view.isScrollEnabled = false
    view.isSelectable = false
    
    return view
  }()
  
  
  
  func setupViews(_ bioText: String) {
    backgroundColor = UIColor.blue
    
    addSubview(cardView)
    cardView.addSubview(textView)
    
    addConstraintsWithFormat("H:|-6-[v0]-6-|", views: cardView)
    addConstraintsWithFormat("V:|-6-[v0]-6-|", views: cardView)
    
    cardView.addConstraintsWithFormat("H:|-6-[v0]-6-|", views: textView)
    cardView.addConstraintsWithFormat("V:|-6-[v0]-6-|", views: textView)

    textView.text = bioText
    
    textView.font = UIFont(name: "Avenir", size: 16)

  }
  
 

  
  
}

class PictureCell: UICollectionViewCell {
  let profileImageView: ModifiedImageView = {
    let imageView = ModifiedImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))

    imageView.backgroundColor = UIColor.white
    
    imageView.layer.cornerRadius =
      imageView.frame.size.width / 2;
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  let header: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.purple
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  
  
  func setupViews() {
    
    backgroundColor = UIColor.blue
    addSubview(profileImageView)
    addSubview(header)
    
    profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    sendSubview(toBack: header)
    
    addConstraintsWithFormat("H:|-6-[v0]-6-|", views: header)
    addConstraintsWithFormat("V:|-75-[v0]-0-|", views: header)
    
    
    

  }

}


class ProfileCell: UICollectionViewCell {
  
  let lightGrayBackgroundColor =
    UIColor(red: 233/255.0, green: 235/255.0, blue: 238/255.0, alpha: 1)
  let material_green =
    UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)


  
  let cardView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.green
    return view
  }()
  
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Marco Rubio"
    label.textColor = UIColor.black
    label.font = UIFont(name: "Avenir", size: 20)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let positionLabel: UILabel = {
    let label = UILabel()
    label.text = "United States Senator"
    label.textColor = UIColor.darkGray
    label.font = UIFont(name: "Avenir", size: 18)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let locationLabel: UILabel = {
    let label = UILabel()
    label.text = "Lives in Miami, FL"
    label.textColor = UIColor.darkGray
    label.font = UIFont(name: "Avenir", size: 18)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  func setupViews() {
    addSubview(cardView)
    cardView.addSubview(nameLabel)
    cardView.addSubview(positionLabel)
    cardView.addSubview(locationLabel)
    
    
    addConstraintsWithFormat("H:|-6-[v0]-6-|", views: cardView)
    addConstraintsWithFormat("V:|-0-[v0]-0-|", views: cardView)
    
    
    addConstraintsWithFormat("V:|-6-[v0]-6-[v1]-6-[v2]-12-|", views: nameLabel, positionLabel, locationLabel)
    

    cardView.addConstraintsWithFormat("H:|-6-[v0]-6-|", views: nameLabel)
    cardView.addConstraintsWithFormat("H:|-6-[v0]-6-|", views: positionLabel)
    cardView.addConstraintsWithFormat("H:|-6-[v0]-6-|", views: locationLabel)
    

  }
}


class ModifiedImageView: UIImageView {
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let radius: CGFloat = self.bounds.size.width / 2.0
    
    self.layer.cornerRadius = radius
  }
}


