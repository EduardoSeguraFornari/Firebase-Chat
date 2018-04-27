//
//  ViewController.swift
//  Chat
//
//  Created by Eduardo Fornari on 18/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Segue

    static let unwindToLoginFromUsersSegue = "unwindToLoginFromUsers"
    static let unwindToLoginFromChatsSegue = "unwindToLoginFromChats"
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        emailUITextField.text = ""
        passwordUITextField.text = ""
    }

    private var scrollViewScrollIndicatorInsets: UIEdgeInsets!
    private var scrollViewContentInset: UIEdgeInsets!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var emailUITextField: UITextField!
    @IBOutlet weak var passwordUITextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUITextFieldDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        if DataAccess.sharedInstance.currentUser() != nil {
            verifyProfile()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }

    func verifyProfile() {
        view.lock()
        view.endEditing(true)
        DataAccess.sharedInstance.fetchCurrentUserProfile(completion: { profiles in
            if let profile = profiles?.first {
                DataAccess.sharedInstance.currentProfile = profile
                self.performSegue(withIdentifier: UsersViewController.goToUsersFromLoginSegue, sender: nil)
            } else {
                self.performSegue(withIdentifier: CreateProfileViewController.goToCreateProfileFromLoginSegue,
                                  sender: nil)
            }
            self.view.unlock()
        })
    }

    @IBAction func loginUIButton(_ sender: UIButton) {
        let email = emailUITextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordUITextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if email.isEmpty {
            self.present(Alerts.simpleAlert(with: "Enter a Email"), animated: true)
        } else if password.isEmpty {
            self.present(Alerts.simpleAlert(with: "Invalid a Password"), animated: true)
        } else {
            view.lock()
            view.endEditing(true)
            DataAccess.sharedInstance.login(email: email, password: password) { (_, error) in
                if error == nil {
                    self.verifyProfile()
                } else {
                    self.present(Alerts.simpleAlert(with: "Error Login"), animated: true)
                }
                self.view.unlock()
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func setUITextFieldDelegates() {
        emailUITextField.delegate = self
        passwordUITextField.delegate = self
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }

    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }

    @objc func keyboardDidShow(notification: NSNotification) {
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

        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)

        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        if let field = activeField {
            scrollView.scrollRectToVisible(field.frame, animated: true)
        }

    }

    @objc func keyboardDidHide(notification: NSNotification) {
        if let contentInset = self.scrollViewContentInset,
            let scrollIndicatorInsets = self.scrollViewScrollIndicatorInsets {

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
