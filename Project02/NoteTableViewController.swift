//
//  NoteTableViewController.swift
//  Project02
//
//  Created by swucomputer on 22/06/2019.
//  Copyright © 2019 swucomputer. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {

    var notes: [NSManagedObject] = []
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func EditPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing{
            sender.title = "Edit"
            tableView.setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            tableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func LogoutPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "로그아웃 하시겠습니까?",message: "오늘의 하루는 기록하셨나요?",preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { action in
            let urlString: String = "http://localhost:8888/login/logout.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return } }
            task.resume()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginView = storyboard.instantiateViewController(withIdentifier: "LoginView")
            self.present(loginView, animated: true, completion: nil)
    }))
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
    
        do{
            notes = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Colud not fetch. \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
        
        let sortDescriptor = NSSortDescriptor (key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note Cell", for: indexPath)

        let note = notes[indexPath.row]
        var display: String = ""
        if let noteLabel = note.value(forKey: "note") as? String {
            display = noteLabel
        }
        
        cell.textLabel?.text = display
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let context = getContext()
            context.delete(notes[indexPath.row])
            do {
                try context.save()
                print("delete")
            } catch let error as NSError {
                print("Colud not delete \(error), \(error.userInfo)")
            }
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
