//
//  CategoryTableViewController.swift
//  ToDo
//
//  Created by Nishit on 18/02/19.
//  Copyright © 2019 Nishit. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoriesArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No Categories Added Yet!"
        
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
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
        }
        
    }
    
    // MARK: Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        // REALM CODE (READ)
        
        categoriesArray = realm.objects(Category.self)

        // CORE DATA CODE (READ)
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//            categoriesArray = try context.fetch(request)
//        } catch {
//            print("Error loading category \(error)")
//        }

        tableView.reloadData()

    }
    
    // MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alert) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
//            self.categoriesArray.append(newCategory)
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Name for new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
