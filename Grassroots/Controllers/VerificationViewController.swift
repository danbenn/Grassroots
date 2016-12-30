//
//  VerificationViewController.swift
//  Grassroots
//
//  Created by Daniel Bennett on 10/31/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class VerificationViewController: UIViewController {

  let WIDTH_PADDING: CGFloat = -24
  let STANDARD_VIEW_HEIGHT: CGFloat = 50

  let model = PoliticianDataModel()
  var address = String()

  let firstLineOfAddress: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Thanks!"
    label.font = UIFont.systemFont(ofSize:20)
    label.textAlignment = .center
    return label
  }()

  let cityAndState: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Verifying address..."
    label.font = UIFont.systemFont(ofSize: 20)
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "square_logo")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  let confirmationButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = UIColor(red: 76.0/255.0,
      green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 5
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize:20)
    button.setTitle("Yep, that's me", for: .normal)
    button.addTarget(nil, action: #selector(verificationDone),
      for: .touchUpInside)
    return button
  }()
  
  let cancellationButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 5
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize:20)
    button.setTitle("No, take me back", for: .normal)
    button.addTarget(nil, action: #selector(reenterAddress),
      for: .touchUpInside)
    button.backgroundColor = UIColor.red
    return button
  }()
  
  
  func stylizeButton(button: UIButton) {
    button.backgroundColor = UIColor(red: 76.0/255.0,
      green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 5
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize:20)
  }
  
  func reenterAddress() {
    performSegue(withIdentifier: "reenterAddress", sender: self)
  }

  func verificationDone() {
    UserDefaults.standard.set(true, forKey: "launched")
    performSegue(withIdentifier: "verificationDone", sender: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(profileImageView)
    view.addSubview(firstLineOfAddress)
    view.addSubview(cityAndState)
    view.addSubview(confirmationButton)
    view.addSubview(cancellationButton)
    
    setupProfileImageView()
    setupfirstLineOfAddressLabel()
    setupCityStateLabel()
    setupConfirmationButton()
    setupCancellationButton()

    //Fetch full address using Geocoder
    address = UserDefaults.standard.object(forKey: "address") as! String
    print("requesting voterinfo for address \(address)...")
    model.address = address
    model.politiciansAtAddress(addressCompletionHandler)
  }

  func setupProfileImageView() {
    //need x, y, width, height constraints
    profileImageView.centerXAnchor.constraint(equalTo:
      view.centerXAnchor).isActive = true
    profileImageView.bottomAnchor.constraint(equalTo:
      firstLineOfAddress.topAnchor, constant: -12).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
  }

  func setupfirstLineOfAddressLabel() {
    firstLineOfAddress.centerXAnchor.constraint(equalTo:
      view.centerXAnchor).isActive = true
    firstLineOfAddress.centerYAnchor.constraint(equalTo:
      view.centerYAnchor).isActive = true
    firstLineOfAddress.widthAnchor.constraint(equalTo:
      view.widthAnchor, constant: WIDTH_PADDING).isActive = true
    firstLineOfAddress.heightAnchor.constraint(equalToConstant:
      STANDARD_VIEW_HEIGHT).isActive = true
  }

  func setupCityStateLabel() {
    cityAndState.centerXAnchor.constraint(equalTo:
      view.centerXAnchor).isActive = true
    cityAndState.topAnchor.constraint(equalTo:
      firstLineOfAddress.bottomAnchor, constant: -12).isActive = true
    //Make the width the same as the address labels
    cityAndState.widthAnchor.constraint(equalTo:
      firstLineOfAddress.widthAnchor).isActive = true
    //Set the height to be same as address labels
    cityAndState.heightAnchor.constraint(equalToConstant:
      STANDARD_VIEW_HEIGHT).isActive = true
  }

  func setupConfirmationButton() {
    confirmationButton.centerXAnchor.constraint(equalTo:
      view.centerXAnchor).isActive = true
    confirmationButton.topAnchor.constraint(equalTo:
      cityAndState.bottomAnchor, constant: 12).isActive = true

    //Make the width the same as the address labels
    confirmationButton.widthAnchor.constraint(equalTo:
    firstLineOfAddress.widthAnchor).isActive = true
    //Set the height to be same as address labels
    confirmationButton.heightAnchor.constraint(equalToConstant:
      STANDARD_VIEW_HEIGHT).isActive = true
  }
  
  func setupCancellationButton() {
    cancellationButton.centerXAnchor.constraint(equalTo:
      view.centerXAnchor).isActive = true
    cancellationButton.topAnchor.constraint(equalTo:
      confirmationButton.bottomAnchor, constant: 12).isActive = true
    
    //Make the width the same as the address labels
    cancellationButton.widthAnchor.constraint(equalTo:
      firstLineOfAddress.widthAnchor).isActive = true
    //Set the height to be same as address labels
    cancellationButton.heightAnchor.constraint(equalToConstant:
      STANDARD_VIEW_HEIGHT).isActive = true
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  fileprivate func addressCompletionHandler(_ response:
    DataResponse<Any>) {
    let result: JSON = JSON(response.result.value!)
    if result["normalizedInput"].exists() {
      print("API response successfully recovered by VerificationViewController")
      firstLineOfAddress.text = result["normalizedInput"]["line1"].stringValue
      cityAndState.text = result["normalizedInput"]["city"].stringValue +
        ", " + result["normalizedInput"]["state"].stringValue
    }
    else {
      firstLineOfAddress.text = "something broke, try again"
      cityAndState.text = ""
    }
  }

  //EFFECTS: initializes view controller
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
