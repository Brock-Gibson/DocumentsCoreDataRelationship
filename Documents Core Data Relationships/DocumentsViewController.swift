//
//  DocumentsViewController.swift
//  Documents Core Data Relationships
//
//  Created by Brock Gibson on 2/25/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController {

    @IBOutlet weak var documentsTableView: UITableView!
    
    let dateFormatter = DateFormatter()
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.documentsTableView.reloadData()
    }
    
    @IBAction func addDocument(_ sender: Any) {
        performSegue(withIdentifier: "showDocument", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NewDocumentViewController else {
                return
        }

        //send category no matter what
        destination.category = category
        
        //only send existing document if there is actually a row selected
        if let selectedRow = self.documentsTableView.indexPathForSelectedRow?.row {
            destination.existingDocument = category?.documents?[selectedRow]
        }
        
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        guard let document = category?.documents?[indexPath.row],
            let managedContext = document.managedObjectContext else {
                return
        }
        
        managedContext.delete(document)
        
        do {
            try managedContext.save()
            
            documentsTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        catch {
            print("expense could not be deleted")
            
            documentsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

}

extension DocumentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.documents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentsTableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        guard let document = category?.documents?[indexPath.row] else {
            return cell
        }
        
        if let cell = cell as? DocumentTableViewCell, let date = document.date {
            cell.titleLabel.text = document.name
            cell.sizeLabel.text = "Size:  \(document.size) bytes"
            cell.dateModifiedLabel.text = "Modified: " + dateFormatter.string(from: date)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDocument(at: indexPath)
        }
    }
}

extension DocumentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDocument", sender: self)
    }
}
