//
//  NewChatTableViewController.swift
//  SecureChat
//
//  Created by Luis Luna on 5/5/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import UIKit

class NewChatTableViewController: UITableViewController {
    var allFriends = [Friend]()
    var lookingFriends = [Friend]()
    
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllFriends()

        // Uncomment the following line to preserve selection between presentations
         //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getAllFriends() {
        
        
        AppManager.shared.networking.getAllUsers().done {
            friends in
            self.allFriends = friends
            self.tableView.reloadData()
            
            }.catch {
                error in
                let error = error as NSError
                
                
                self.showAlert(title: "Oops", text: error.userInfo["msg"] as! String)
                
                
                
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isSearching {
            return self.lookingFriends.count
        }
        
        return self.allFriends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath) as! FriendTableViewCell
            let f = self.lookingFriends[indexPath.row]
            
            cell.name.text = f.name
            cell.email.text = f.email
            cell.hour.text = "9:40"
            
         
            
            return cell
            
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath) as! FriendTableViewCell
            
            let f = self.allFriends[indexPath.row]
            
            cell.name.text = f.name
            cell.email.text = f.email
            cell.hour.text = "9:40"
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearching {
            let selectedFriend = self.lookingFriends[indexPath.row]
            
            /// Mostrar pantalla de chat
            
        } else {
             let selectedFriend = self.allFriends[indexPath.row]
        }
        
        
        
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showAlert(title: String, text: String) {
        
        let alert = UIAlertController.init(title: title, message: text, preferredStyle: .alert)
        
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
