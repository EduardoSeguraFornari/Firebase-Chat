//
//  ChatViewController.swift
//  Chat
//
//  Created by Eduardo Fornari on 20/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    // MARK: - Segues

    static let goToChatFromUsersSegue = "goToChatFromUsers"
    static let goToChatFromChatsSegue = "goToChatFromChats"

    public var userChat: UserChat? {
        didSet {
            DataAccess.sharedInstance.fetchNewMessageObservable(for: self.userChat!.chatID, completion: { (message) in
                if let message = message {
                    self.model.append(message)

                    self.model = self.model.sorted(by: { (messageA, messageB) -> Bool in
                        messageA.date.compare(messageB.date) == .orderedAscending
                    })
                    self.tableView.reloadData()
//                    let indexPath = IndexPath(row: self.model.count - 1, section: 0)
//                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.scrollToLastMessage()
                }
            })
        }
    }

    public var profile: Profile! {
        didSet {
            title = profile.firstName
        }
    }

    var model = [Message]()

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var messageUITextView: UITextView!
    @IBOutlet weak var textMessageBottomConstraint: NSLayoutConstraint!
    private var textMessageBottomConstantDefault: CGFloat = 0

    private var keyboardHeight: CGFloat = 0

    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        messageUITextView.layer.cornerRadius = 5

        setTableView()

        textMessageBottomConstantDefault = textMessageBottomConstraint.constant
    }

    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }

    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }

    @objc func keyboardDidShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        keyboardHeight = keyboardRect!.size.height

        textMessageBottomConstraint.constant = textMessageBottomConstantDefault + keyboardHeight
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        textMessageBottomConstraint.constant = textMessageBottomConstantDefault
    }

    @objc func keyboardDidHide(notification: NSNotification) {
        let visibleCells = tableView.visibleCells
        if let lastCell = visibleCells.first {
            let indexPath = tableView.indexPath(for: lastCell)
            if let indexPath = indexPath {
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }

    private func scrollToLastMessage() {
        if model.count > 0 {
            let indexPath = IndexPath(row: model.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    @IBAction func sendButtonTouched(_ sender: UIButton) {
        let message = messageUITextView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        if message != "" {
            // TO-DO Add chat if necessary and send message
            let currentUserProfileID = DataAccess.sharedInstance.currentProfile!.identifier!
            if userChat != nil {
                self.sendMessage(with: message)
            } else {
                let chatID = UUID().description
                let myUserChat = UserChat(chatID: chatID,
                                          firstUserProfileID: currentUserProfileID,
                                          secondUserProfileID: profile.identifier!)
                DataAccess.sharedInstance.save(with: myUserChat) { error in
                    if error == nil {
                        let otherUserChat = UserChat(chatID: chatID,
                                                     firstUserProfileID: self.profile.identifier!,
                                                     secondUserProfileID: currentUserProfileID)
                        DataAccess.sharedInstance.save(with: otherUserChat) { error in
                            if error == nil {
                                self.userChat = myUserChat
                                self.sendMessage(with: message)
                            } else {
                                self.present(Alerts.simpleAlert(with: "Error sending message!"), animated: true)
                            }
                        }
                    } else {
                        self.present(Alerts.simpleAlert(with: "Error sending message!"), animated: true)
                    }
                }
            }
        }
    }

    private func sendMessage(with text: String) {
        self.sendButton.isEnabled = false
        let currentUserProfileID = DataAccess.sharedInstance.currentProfile!.identifier!
        let message = Message(chatID: userChat!.chatID, senderID: currentUserProfileID, text: text)
        DataAccess.sharedInstance.save(message: message) { error in
            if error == nil {
                self.messageUITextView.text = ""
                self.sendButton.isEnabled = true
            } else {
                self.sendButton.isEnabled = true
                self.present(Alerts.simpleAlert(with: "Error sending message!"), animated: true)
            }
        }
    }

}

// MARK: - TableView

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tableView.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = model[indexPath.row]
        var cell: MessageTableViewCell!
        if message.senderID == DataAccess.sharedInstance.currentProfile!.identifier! {
            cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell",
                                                 for: indexPath) as? MessageTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageCell",
                                                 for: indexPath) as? MessageTableViewCell
        }
        cell.message = message
        return cell
    }

}
