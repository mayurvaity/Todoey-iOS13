//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
//import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //declare defaults object (using NS User Defaults object)
    let defaults = UserDefaults.standard
        
    //UIApplication.shared is singleton which is ref to when app is actually running on iphone
    //its delegate (this is a delegate of the App Object) is casted as AppDelegate and then ViewContext is used to create a staging db
    //casting works bc they both inherit from superclass UIApplicationDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to print location of document directory
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        
        //to populate table view using itemArray
        loadItems()
        
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
        
        //for delete example
//        //deleting from context, bc if we del from itemarray 1st then we won't b able to del from context
//        //delete method needs entire object as parameter to delete from core data
//        context.delete(itemArray[indexPath.row])
//        //removing from itemArray
//        itemArray.remove(at: indexPath.row)
        
        
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
    
    //to perform fetch requests and reloading the tableView,
    //for cases where need to fecth complete data the request parameter is optional and has a default value
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        //then use context to fetch
        do {
            //fetched data will be in the form of an array of Item, and will be stored in itemArray
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        //need to reload tableView as itemArray has changed by above request
        //this calls cellForRowAt IndexPath method
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Delegate Methods

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //create a request to fetch data from db
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //prepare query using predicate
        //adding query (predicate) to the request
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //to specify sorting for the fetch request, below specifying column on which this needs to be sorted
        //request can accept sorting on multiple cols, so it is expecting an array of NSSortDescriptors
        //in below example we r sorting single col only
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //calling load items with above fetched request data
        loadItems(with: request)
    }
    
    //to get a full list in the tableView when search bar is made empty
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //to check if searchbar has zero text count
        if searchBar.text?.count == 0 {
            loadItems()
            
            //to make it stop editing and disabling the keyboard
            //also need to run this in dispatchqueue, so that this won't freeze searchBar (and will keep app responsive)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}
