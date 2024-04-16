//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
//import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //declare defaults object (using NS User Defaults object)
    let defaults = UserDefaults.standard
    
    //to get location of NS User defaults plist file
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    //UIApplication.shared is singleton which is ref to when app is actually running on iphone
    //its delegate (this is a delegate of the App Object) is casted as AppDelegate and then ViewContext is used to create a staging db
    //casting works bc they both inherit from superclass UIApplicationDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//        
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//        
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
        //getting array from user defaults plist file and setting its value to above created itemArray (which is used to keep list)
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        //to populate itemArray using Item.plist (1st decoding then
//        loadItems()
        
    }
    
    //MARK: - TableView Datasource Mathods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //this method gets called number of times based on above method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAt indexPath called")
        
        //creating a cell (UITableViewCellz) to pass at tableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        //setting value of the text label in this cell to one of the values from array
        cell.textLabel?.text = item.title
        
        //setting done property to each cell
        cell.accessoryType = item.done ? .checkmark : .none
        
        //returning cell
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //printing selected cells value from array by using index postion from selected cell
        print(itemArray[indexPath.row])
        
        //setting done property of selected item in the array
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //to write updated check mark to Item.plist and reload tableView data
        saveItems()
        
//        //checking if selected cell has accessory type checkmark already assigned
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            //setting accessorytype of the cell to none as it already had accessorytype checkmark
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            //activating checkmark accessorytype for selected cell
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //to deselect the row after clicking
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //create alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //create action for above alert
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //what will happen once user press the Add Item button on our UIAlert
            print(textField.text!)
            
            //above context is used while creating object of Item
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            //need to do the validation later to get only text not nils
            self.itemArray.append(newItem)
            
            
            //updating this array in User Defaults
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //associate above action to the alert
        alert.addAction(action)
        
        //to show our alert
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Model Manipulation Methods
    //to store item array to Item.plist file
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        //to reload data in the tableview to include newly added items
        self.tableView.reloadData()
    }
    
    //to get data from Item.plist file into item array
//    func loadItems() {
//        //getting data from Item.plist path
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            
//            //initialize the decoder
//            let decoder = PropertyListDecoder()
//            do {
//                //assigning values by decoding data got from above step
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding item array, \(error)")
//            }
//            
//        }
//    }
    
}

