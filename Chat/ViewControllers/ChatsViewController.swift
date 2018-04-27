//
//  ChatsViewController.swift
//  Chat
//
//  Created by Eduardo Fornari on 20/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {

    private var model = [UserChat]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        view.lock()
        DataAccess.sharedInstance.fetchUserChatsForCurrentProfileObservable { (userChats) in
            if let userChats = userChats {
                DataAccess.sharedInstance.currentUserChats = userChats
                self.view.unlock()
                self.loadChats()
            }
        }
    }

    @objc private func loadChats() {
        if let userChats = DataAccess.sharedInstance.currentUserChats {
            model = userChats
        } else {
            model = []
        }
        tableView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ChatViewController.goToChatFromChatsSegue {
            if let destination = segue.destination as? ChatViewController {
                if let indexPath = sender as? IndexPath {
                    destination.userChat = model[indexPath.row]
                    if let cell = tableView.cellForRow(at: indexPath) as? ChatTableViewCell {
                        if let profile = cell.profile {
                            destination.profile = profile
                        }
                    }
                }
            }
        }
    }

}

// MARK: - TableView

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {

    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chat", for: indexPath) as? ChatTableViewCell
        cell!.userChat = model[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ChatViewController.goToChatFromChatsSegue, sender: indexPath)
    }

}
