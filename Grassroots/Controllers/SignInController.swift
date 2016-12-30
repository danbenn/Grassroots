//
//  SignInController.swift
//  Grassroots
//
//  Created by Daniel Bennett on 9/10/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

//Note: the following code is partially adapted from a project by
//Brian Voong, https://videos.letsbuildthatapp.com/course/Firebase-Chat-Messenger

class SignInController: UIViewController, UITextFieldDelegate {

  let WIDTH_PADDING: CGFloat = -24
  let INPUT_VIEW_HEIGHT: CGFloat = 50

  let inputContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 5
    view.layer.masksToBounds = true
    return view

  }()

  let nameTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Your registered voter address"
    UITextField.appearance().tintColor = UIColor.black
    tf.returnKeyType = UIReturnKeyType.done
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()

  let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "square_logo")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  let loginRegisterButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    button.setTitle("Continue", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 5

    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize:20)
    button.addTarget(nil, action: #selector(addressSubmitted), for: .touchUpInside)
    return button
  }()

  func addressSubmitted() {
    performSegue(withIdentifier: "showVerification", sender: self)
  }

  //EFFECTS: initializes view controller
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    if segue.identifier == "showVerification" {
      if let nextVC =
        segue.destination as? VerificationViewController {
        if let address = nameTextField.text {
          print("recovered address from text field: \(address)")
          UserDefaults.standard.set(address, forKey: "address")
        }
        else {
          print("unable to fetch text from text field")
        }
      }
      else {
        print("error: unable to set segue destination")
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()

    //view.backgroundColor = UIColor.white

    view.addSubview(inputContainerView)
    view.addSubview(loginRegisterButton)
    view.addSubview(profileImageView)

    setupInputContainerView()
    setupLoginRegisterButton()
    setupProfileImageView()
  }

  func setupProfileImageView() {
    //need x, y, width, height constraints
    profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    profileImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
  }


  func setupInputContainerView() {
    inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: WIDTH_PADDING).isActive = true
    inputContainerView.heightAnchor.constraint(equalToConstant: INPUT_VIEW_HEIGHT).isActive = true

    inputContainerView.addSubview(nameTextField)

    //need x, y, width, height constraints
    nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
    nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true

    nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1).isActive = true
    nameTextField.delegate = self

  }

  func setupLoginRegisterButton() {
    //need x, y, width, height constraints
    loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
    loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }



}
// Put this piece of code anywhere you like
extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  func dismissKeyboard() {
    view.endEditing(true)
  }
}
