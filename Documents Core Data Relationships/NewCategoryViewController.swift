//
//  NewCategoryViewController.swift
//  Documents Core Data Relationships
//
//  Created by Brock Gibson on 2/25/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    var existingCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        
        titleTextField.text = existingCategory?.title
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveCategory(_ sender: Any) {
        let categoryName = titleTextField.text ?? "".trimmingCharacters(in: .whitespaces)
        if (categoryName == "") {
            alertNotifyUser(message: "Category not saved. A name is required.")
            return
        }
        
        var category: Category?
        
        if let existingCategory = existingCategory {
            existingCategory.title = categoryName
            category = existingCategory
        } else {
            category = Category(title: categoryName)
        }
        
        if let category = category {
            do {
                try category.managedObjectContext?.save()
                self.navigationController?.popViewController(animated: true)
            }
            catch {
                print("Could not save category!")
            }
        }
        
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
