//
//  CreateProfileViewController.swift
//  Chat
//
//  Created by Eduardo Fornari on 19/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {

    // MARK: - Segues

    static let goToCreateProfileFromCreateAccountSegue = "goToCreateProfileFromCreateAccount"
    static let goToCreateProfileFromLoginSegue = "goToCreateProfileFromLogin"

    private var scrollViewScrollIndicatorInsets: UIEdgeInsets!
    private var scrollViewContentInset: UIEdgeInsets!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var firstNameUITextField: UITextField!
    @IBOutlet weak var lastNameUITextField: UITextField!

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
        let firstName = firstNameUITextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameUITextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if firstName.isEmpty {
            self.present(Alerts.simpleAlert(with: "Enter a First Name"), animated: true)
        } else if lastName.isEmpty {
            self.present(Alerts.simpleAlert(with: "Invalid a Last Name"), animated: true)
        } else {
            let profile = Profile(firstName: firstName, lastName: lastName)
            view.lock()
            view.endEditing(true)
            DataAccess.sharedInstance.save(with: profile) { error in
                if error == nil {
                    DataAccess.sharedInstance.currentProfile = profile
                    self.performSegue(withIdentifier: UsersViewController.goToUsersFromCreateProfileSegue, sender: nil)
                } else {
                    self.present(Alerts.simpleAlert(with: "Error Creating Profile"), animated: true)
                }
                self.view.unlock()
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == UsersViewController.goToUsersFromCreateProfileSegue { }
    }

}

// MARK: - UITextFieldDelegate

extension CreateProfileViewController: UITextFieldDelegate {

    func setUITextFieldDelegates() {
        firstNameUITextField.delegate = self
        lastNameUITextField.delegate = self
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

        if firstNameUITextField.isEditing {
            activeField = firstNameUITextField
        } else if lastNameUITextField.isEditing {
            activeField = lastNameUITextField
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
        if firstNameUITextField.isEditing {
            lastNameUITextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }

}
