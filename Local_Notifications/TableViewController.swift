//
//  TableTableViewController.swift
//  Local_Notifications
//
//  Created by Leena 1418 on 22/12/2021.
//

import UIKit

class TableViewController: UITableViewController {
    var allNotifications: [LocalNotification]?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 100
        tableView.separatorColor = .systemMint
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allNotifications?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let allNotifications = allNotifications else {
            return cell
        }

        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        let timeStarted = formatter.string(from: allNotifications[indexPath.row].dateItStarted)
        
        cell.textLabel?.text = "\(timeStarted): \(allNotifications[indexPath.row].state)"
        


        return cell
    }


}

