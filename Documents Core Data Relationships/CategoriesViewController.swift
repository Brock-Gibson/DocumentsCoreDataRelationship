//
//  CategoriesViewController.swift
//  Documents Core Data Relationships
//
//  Created by Brock Gibson on 2/25/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {

    @IBOutlet weak var categoriesTableView: UITableView!
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try managedContext.fetch(fetchRequest)
            categoriesTableView.reloadData()
        }
        catch {
            print("Fetch of categories failed")
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDocuments" {
            guard let destination = segue.destination as? DocumentsViewController,
                let selectedRow = self.categoriesTableView.indexPathForSelectedRow?.row else {
                    return
            }
            
            destination.category = categories[selectedRow]
            
        }
        if segue.identifier == "showCategory" {
            
            guard let indexPath = sender as? NSIndexPath else {
                return
            }
            
            if let controller = segue.destination as? NewCategoryViewController {
                controller.existingCategory = categories[indexPath.row]
            }
        }
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        guard let managedContext = category.managedObjectContext else {
            return
        }
        
        managedContext.delete(category)
        do {
            try managedContext.save()
            categories.remove(at: indexPath.row)
            categoriesTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        catch {
            print("could not delete category")
            categoriesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action, indexPath)  in
            print("edit segue")
            self.performSegue(withIdentifier: "showCategory", sender: indexPath)
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            print("deleted")
            self.handleDelete(at: indexPath)
        })
        
        return [deleteAction, editAction]
    }
    
    func handleDelete(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        let dialogMessage = UIAlertController(title: "Confirm Delete", message: "There are documents in this category! Are you sure you want to delete this category?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in
            print("confirm delete")
            self.deleteCategory(at: indexPath)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancelled delete")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user if there is documents
        if category.documents?.count ?? 0 > 0 {
            self.present(dialogMessage, animated: true, completion: nil)
        } else {
            deleteCategory(at: indexPath)
        }
    }
}
