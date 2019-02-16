//
//  ViewController.swift
//  ToDo
//
//  Created by Nishit on 13/02/19.
//  Copyright © 2019 Nishit. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // have to add objects of class 'Item' rather than String in itemArray, so making objects, setting its title & appending it
        
        let newItem1 = Item()
        newItem1.title = "random text1"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "random text2"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "random text3"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    // MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // if the .done == true, checkmark will be shown else it won't
        // Ternary operator syntax: Value = condition ? valueIfTrue : valueIfFalse
        // Same thing is done by one line of code rather than below's four/five
        
        cell.accessoryType = item.done ? .checkmark : .none     // Here only item.done means if item.done == true
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        // On selecting row, if .done is false, then it'll changed to true & vice versa
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Same thing is done by above's one line of code rather than below's four/five
        
        //        if itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        } else {
        //            itemArray[indexPath.row].done = false
        //        }
        
        tableView.reloadData() //called this method here as cellForRowAt method needs to trigger otherwise it won't change to checkmark when we select row
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // also here, making object of class 'Item', setting its title to textfield's text & appending object to array
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

