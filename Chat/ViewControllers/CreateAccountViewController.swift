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
    }

    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
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
            DataAccess.sharedInstance.createAccount(with: email, and: password) { (_, error) in
                if error == nil {
                    self.performSegue(withIdentifier:
                        CreateProfileViewController.goToCreateProfileFromCreateAccountSegue,
                                      sender: nil)
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

// MARK: - UITextFieldDelegate

extension CreateAccountViewController: UITextFieldDelegate {

    func setUITextFieldDelegates() {
        emailUITextField.delegate = self
        passwordUITextField.delegate = self
        verifyPasswordUITextField.delegate = self
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
        } else if verifyPasswordUITextField.isEditing {
            activeField = verifyPasswordUITextField
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
        } else if passwordUITextField.isEditing {
            verifyPasswordUITextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }

}
