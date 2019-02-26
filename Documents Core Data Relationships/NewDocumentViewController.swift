//
//  NewDocumentViewController.swift
//  Documents Core Data Relationships
//
//  Created by Brock Gibson on 2/25/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit

class NewDocumentViewController: UIViewController {
    
    var existingDocument: Document?
    var category: Category?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var titleBar: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self

        nameTextField.text = existingDocument?.name
        titleBar.title = existingDocument?.name
        contentTextField.text = existingDocument?.content
        
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveDocument(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let content = contentTextField.text ?? ""
        let dateModified = Date()
        
        let documentName = name.trimmingCharacters(in: .whitespaces)
        if (documentName == "") {
            alertNotifyUser(message: "Document not saved. A name is required.")
            return
        }
        
        var document: Document?
        
        if let exisitingDocument = existingDocument {
            existingDocument?.name = name
            existingDocument?.content = content
            existingDocument?.date = dateModified
            exisitingDocument.size = Int64(content.utf8.count)
            
            document = exisitingDocument
        } else {
            document = Document(name: name, content: content, date: dateModified, size: content)
            if let document = document {
                category?.addToRawDocuments(document)
            }
        }
        
        if let document = document {
            
            do {
                let managedContext = document.managedObjectContext
                
                try managedContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            }
            catch {
                print("context could not be saved")
            }
        }
    }
    
    @IBAction func titleChanged(_ sender: Any) {
        titleBar.title = nameTextField.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        contentTextField.resignFirstResponder()
    }

}

extension NewDocumentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
