//
//  ViewController.swift
//  Chat
//
//  Created by Eduardo Fornari on 18/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private var scrollViewScrollIndicatorInsets: UIEdgeInsets!
    private var scrollViewContentInset: UIEdgeInsets!

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var emailUITextField: UITextField!
    @IBOutlet weak var passwordUITextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUITextFieldDelegates()
        registerForKeyboardNotifications()
        
        if DataAccess.currentUser() != nil {
            verifyLogin()
        }
        
    }
    
    func verifyLogin() {
        view.lock()
        view.endEditing(true)
        DataAccess.fetchCurrentUserProfile(completion: { (finished, profile) in
            if finished {
                if profile != nil {
                    DataAccess.currentProfile = profile
                    self.performSegue(withIdentifier: UsersViewController.goToUsersFromLoginSegue, sender: nil)
                } else {
                    self.performSegue(withIdentifier: CreateProfileViewController.goToCreateProfileFromLoginSegue, sender: nil)
                }
                self.view.unlock()
            }
        })
    }

    @IBAction func loginUIButton(_ sender: UIButton) {
        let email = emailUITextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordUITextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email.isEmpty {
            self.present(Alerts.simpleAlert(with: "Enter a Email"), animated: true)
        } else if password.isEmpty {
            self.present(Alerts.simpleAlert(with: "Invalid a Password"), animated: true)
        }else {
            view.lock()
            view.endEditing(true)
            DataAccess.login(email: email, password: password) { (user, error) in
                if error == nil {
                    self.verifyLogin()
                } else {
                    self.view.unlock()
                    self.present(Alerts.simpleAlert(with: "Error Login"), animated: true)
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func setUITextFieldDelegates() {
        emailUITextField.delegate = self
        passwordUITextField.delegate = self
    }
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification){
        
        scrollViewContentInset = scrollView.contentInset
        scrollViewScrollIndicatorInsets = scrollView.scrollIndicatorInsets
        
        var activeField: UITextField? = nil
        
        
        
        
        if emailUITextField.isEditing {
            activeField = emailUITextField
        } else if passwordUITextField.isEditing {
            activeField = passwordUITextField
        }
        
        var info = notification.userInfo!
        let keyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardSize = keyboardRect!.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        
        if let field = activeField {
            scrollView.scrollRectToVisible(field.frame, animated: true)
        }
        
    }
    
    @objc func keyboardDidHide(notification: NSNotification){
        
        if let contentInset = self.scrollViewContentInset, let scrollIndicatorInsets = self.scrollViewScrollIndicatorInsets {
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = scrollIndicatorInsets
            self.scrollViewContentInset = nil
            self.scrollViewScrollIndicatorInsets = nil
            self.view.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if emailUITextField.isEditing {
            passwordUITextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return true
    }
    
}
