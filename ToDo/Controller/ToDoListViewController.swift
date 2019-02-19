//
//  ViewController.swift
//  ToDo
//
//  Created by Nishit on 13/02/19.
//  Copyright © 2019 Nishit. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var todoItems : Results<Item>?
    
    var realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // By using Codable method, implementation & steps: have to add objects of class 'Item' rather than String in itemArray, so making objects, setting its title & appending it
        
        //        let newItem1 = Item()
        //        newItem1.title = "random text1"
        //        itemArray.append(newItem1)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "random text2"
        //        itemArray.append(newItem2)
        //
        //        let newItem3 = Item()
        //        newItem3.title = "random text3"
        //        itemArray.append(newItem3)
        
    }
    
    // MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // if the .done == true, checkmark will be shown else it won't
            
            // Ternary operator syntax: Value = condition ? valueIfTrue : valueIfFalse
            // Same thing is done by one line of code rather than below's four/five
            
            cell.accessoryType = item.done ? .checkmark : .none     // Here item.done means if item.done == true
            
            //        if item.done == true {
            //            cell.accessoryType = .checkmark
            //        } else {
            //            cell.accessoryType = .none
            //        }
        } else {
            cell.textLabel?.text = "No Items Added!"
        }
        
        return cell
    }
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // On selecting row, if .done is false, then it'll changed to true & vice versa
        
        // REALM CODE (UPDATE & DELETE)
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)               // --- delete
                    item.done = !item.done         // --- update
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        // CORE DATA CODE (UPDATE)
        
        //        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        // Same thing is done by above's one line of code rather than below's four/five
        
        //        if itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        } else {
        //            itemArray[indexPath.row].done = false
        //        }
        
        tableView.reloadData()
        
        // CORE DATA CODE (DELETE)
        
        // first delete data code from persistent container & then updating the array, as sequence of code matters
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        //        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // here, making object of class 'Item', setting its title to textfield's text & appending object to array, for using with userDefautls or Codable, but for using CoreData we need different implementataion which is below that
            //  let newItem = Item()
            
            // CORE DATA CODE (CREATE)
            
            //            let newItem = Item(context: self.context)
            //            newItem.title = textField.text!
            //            newItem.done = false
            //            newItem.parentCategory = self.selectedCategory
            //            self.itemArray.append(newItem)
            //
            //            self.saveItems()
            
            //REALM CODE FOR SAVEITEMS METHOD (CREATE)
            
            // As selectedCategory is optional we need to do optional binding
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error in saving \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Model Manipulating Methods
    
    // REALM CODE FOR SAVEITEMS WILL BE DONE IN ADDBUTTONS RATHER THAN CREATING SAVEITEMS METHOD
    
    // CORE DATA CODE (CREATE)
    
    //    func saveItems() {
    //
    //        do {
    //            try context.save()
    //        } catch {
    //            print("Error saving context \(error)")
    //        }
    //
    //
    //        tableView.reloadData()      //  Called this method as cellForRowAt method needs to trigger otherwise it won't change to checkmark when we select row
    //    }
    
    
    
    //    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) -- CORE DATA declaration
    
    // REALM CODE (READ)
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        // CORE DATA CODE (READ)
        
        //   -----------------------------------  initial loadItem predicate ---------------------------------------------
        
        //        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        request.predicate = predicate --- predicate for loadItems method only
        
        //   ------------------------------------  compound predicate ----------------------------------------------------
        
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //        (renamed which earlier was predicate, to identify it different for category)
        
        //        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        
        //        request.predicate = compoundPredicate --- compoundPredicate will be of categoryPredicate & predicate (of search bar)
        //        but here we've to check if predicate (which comes from argument) is not nil (check below code)
        
        //   -----------------------------------  if let check compound predicate  ----------------------------------------
        
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        if let additionalPredicate = predicate {
        //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        //        } else {
        //            request.predicate = categoryPredicate
        //        }
        //
        //        do {
        //            itemArray = try context.fetch(request)
        //        } catch {
        //            print("Error fetching data from context \(error)")
        //        }
        
        tableView.reloadData()
        
    }
    
}

// MARK: Search bar methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // REALM CODE

//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        // CORE DATA CODE
        //
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // %@ will be replaced by searchBar.text
        //
        //        request.predicate = predicate
        //
        //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //
        //        loadItems(with: request, predicate: predicate)

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

