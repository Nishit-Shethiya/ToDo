//
//  CategoryTableViewController.swift
//  ToDo
//
//  Created by Nishit on 18/02/19.
//  Copyright © 2019 Nishit. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoriesArray = [Category]()
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        
        return cell
        
    }
    
    // MARK: TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItmes", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // grabbing destination of segue
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        // Now,for grabbing category we need to know which cell is selected
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
        
    }
    
    // MARK: Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoriesArray = try context.fetch(request)
        } catch {
            print("Error loading category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    // MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alert) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoriesArray.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Name for new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
