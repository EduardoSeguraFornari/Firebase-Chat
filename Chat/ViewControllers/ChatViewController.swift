//
//  ChatViewController.swift
//  Chat
//
//  Created by Eduardo Fornari on 20/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var messageUITextView: UITextView!
    
    static let goToChatFromUsersSegue = "goToChatFromUsers"
    static let goToChatFromChatsSegue = "goToChatFromChats"
    
    public var profile: Profile! {
        didSet {
            title = profile.firstName
        }
    }
    
    var model = [Message]()

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textMessageBottomConstraint: NSLayoutConstraint!
    private var keyboardHeight: CGFloat = 0
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageUITextView.layer.cornerRadius = 5
        
        sendButton.layer.cornerRadius = 5
        
        model.append(Message(senderID: "12345", text: "Hi"))
        model.append(Message(senderID: DataAccess.currentProfile!.id!, text: "Hi, how are you?"))
        model.append(Message(senderID: "12345", text: "I'm fine and you?"))
        model.append(Message(senderID: DataAccess.currentProfile!.id!, text: "Wow, nice! I'm very fine, too!"))
        setTableView()
        registerForKeyboardNotifications()
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
        
        var info = notification.userInfo!
        let keyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        keyboardHeight = keyboardRect!.size.height
        
        textMessageBottomConstraint.constant += keyboardHeight
    }
    
    @objc func keyboardDidHide(notification: NSNotification){
        textMessageBottomConstraint.constant -= keyboardHeight
    }
    
    @IBAction func sendButtonTouched(_ sender: UIButton) {
        if model.count > 0 {
            let indexPath = IndexPath(row: model.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = model[indexPath.row]
        var cell: MessageTableViewCell!
        if message.senderID == DataAccess.currentProfile!.id! {
            cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MessageTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageCell", for: indexPath) as! MessageTableViewCell
        }
        cell.message = message
        return cell
    }
    
}
