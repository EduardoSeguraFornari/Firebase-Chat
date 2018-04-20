//
//  CreateAccountViewController.swift
//  Chat
//
//  Created by Eduardo Fornari on 19/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    private var scrollViewScrollIndicatorInsets: UIEdgeInsets!
    private var scrollViewContentInset: UIEdgeInsets!
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var emailUITextField: UITextField!
    @IBOutlet weak var passwordUITextField: UITextField!
    @IBOutlet weak var verifyPasswordUITextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUITextFieldDelegates()
        registerForKeyboardNotifications()
    }
    
    @IBAction func createUIButton(_ sender: UIButton) {
        let email = emailUITextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordUITextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let verifyPassword = verifyPasswordUITextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if email.isEmpty {
            self.present(Alerts.simpleAlert(with: "Enter a Email"), animated: true)
        } else if !email.isValidEmail() {
            self.present(Alerts.simpleAlert(with: "Invalid Email"), animated: true)
        } else if password.isEmpty {
            self.present(Alerts.simpleAlert(with: "Enter a Password"), animated: true)
        } else if password != verifyPassword {
            self.present(Alerts.simpleAlert(with: "Passwords Don't Match"), animated: true)
        } else {
            view.lock()
            view.endEditing(true)
            DataAccess.createAccount(with: email, and: password) { (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: CreateProfileViewController.goToCreateProfileFromCreateAccountSegue, sender: nil)
                } else {
                    self.present(Alerts.simpleAlert(with: "Error Creating Account"), animated: true)
                }
                self.view.unlock()
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CreateProfileViewController.goToCreateProfileFromCreateAccountSegue { }
    }

}

extension CreateAccountViewController: UITextFieldDelegate {
    
    func setUITextFieldDelegates() {
        emailUITextField.delegate = self
        passwordUITextField.delegate = self
        verifyPasswordUITextField.delegate = self
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
        } else if verifyPasswordUITextField.isEditing {
            activeField = verifyPasswordUITextField
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
        } else if passwordUITextField.isEditing {
            verifyPasswordUITextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return true
    }
    
}

extension String {

    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }

}
