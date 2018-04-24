//
//  UsersViewController.swift
//  Chat
//
//  Created by Eduardo Fornari on 20/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    static let goToUsersFromLoginSegue = "goToUsersFromLogin"
    static let goToUsersFromCreateProfileSegue = "goToUsersFromCreateProfile"
    
    @IBOutlet weak var tableView: UITableView!
    
    private var model: [Profile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        DataAccess.fetchProfilesObservable { (profiles) in
            if let profiles = profiles {
                self.model = profiles.filter({ (profile) -> Bool in
                    profile.id != DataAccess.currentProfile?.id
                })
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ChatViewController.goToChatFromUsersSegue {
            if let destination = segue.destination as? ChatViewController {
                if let profile = sender as? Profile {
                    destination.profile = profile
                }
            }
        }
    }

}

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
