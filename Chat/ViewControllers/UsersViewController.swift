//
//  UsersViewController.swift
//  Chat
//
//  Created by Eduardo Fornari on 20/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    // MARK: - Segues

    static let goToUsersFromLoginSegue = "goToUsersFromLogin"
    static let goToUsersFromCreateProfileSegue = "goToUsersFromCreateProfile"

    @IBOutlet weak var tableView: UITableView!

    private var model: [Profile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        view.lock()
        DataAccess.sharedInstance.fetchProfilesObservable { (profiles) in
            if let profiles = profiles {
                self.model = profiles.filter({ (profile) -> Bool in
                    profile.identifier != DataAccess.sharedInstance.currentProfile?.identifier
                })
                self.tableView.reloadData()
                self.view.unlock()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
        view.lock()
        DataAccess.sharedInstance.fetchUserChatsForCurrentProfileObservable { (userChats) in
            if let userChats = userChats {
                DataAccess.sharedInstance.currentUserChats = userChats
                self.view.unlock()
            }
        }
    }

    @objc private func userChatsDidChange() {
        if DataAccess.sharedInstance.currentUserChats != nil {
            print("Users Chat Did Change")
        }
    }

    @IBAction func logoutButtonTouched(_ sender: UIBarButtonItem) {
        DataAccess.sharedInstance.logout()
        performSegue(withIdentifier: LoginViewController.unwindToLoginFromUsersSegue, sender: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ChatViewController.goToChatFromUsersSegue {
            if let destination = segue.destination as? ChatViewController {
                if let profile = sender as? Profile {
                    let userchat = DataAccess.sharedInstance.currentUserChats?.first(where: { (userChat) -> Bool in
                        userChat.secondUserProfileID == profile.identifier
                    })
                    if userchat != nil {
                        destination.userChat = userchat
                    }
                    destination.profile = profile
                }
            }
        } else if segue.identifier == LoginViewController.unwindToLoginFromUsersSegue { }
    }

}

// MARK: - TableView

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {

    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Profile", for: indexPath)
        cell.textLabel?.text = model[indexPath.row].firstName
        cell.detailTextLabel?.text = nil
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ChatViewController.goToChatFromUsersSegue, sender: model[indexPath.row])
    }
}
