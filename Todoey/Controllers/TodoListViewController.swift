//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
//import CoreData

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    //a variable to store category info when selected on category page
    var selectedCategory : Category? {
        //didset gets called when some value has been assigned to the variable
        didSet{
            loadItems()
        }
    }
    
    //declare defaults object (using NS User Defaults object)
    let defaults = UserDefaults.standard
        
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
//        loadItems()
        
    }
    
    //MARK: - TableView Datasource Mathods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //this method gets called number of times based on above method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAt indexPath called")
        
        //creating a cell (UITableViewCellz) to pass at tableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            //setting value of the text label in this cell to one of the values from array
            cell.textLabel?.text = item.title
            
            //setting done property to each cell
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //printing selected cells value from array by using index postion from selected cell
        if let cellDetails = todoItems?[indexPath.row] {
            print(cellDetails)
        }
//        //setting done property of selected item in the array
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        
//        //to write updated check mark to Item.plist and reload tableView data
//        saveItems()
        
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
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
 
    
    //to perform fetch requests and reloading the tableView,
    //for cases where need to fecth complete data the request parameter is optional and has a default value
    func loadItems() {
        
        //to get items from realm db
        //selectedCatgeory - where condition for category name
        //items - name of the relationship created in Category class
        //soreted - to sort
        todoItems = selectedCategory?.items.sorted(byKeyPath:"title", ascending: true)
        
        //need to reload tableView as itemArray has changed by above request
        //this calls cellForRowAt IndexPath method
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Delegate Methods

//extension TodoListViewController : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        //create a request to fetch data from db
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        
//        //prepare query using predicate
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        
//        //to specify sorting for the fetch request, below specifying column on which this needs to be sorted
//        //request can accept sorting on multiple cols, so it is expecting an array of NSSortDescriptors
//        //in below example we r sorting single col only
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        //calling load items with above fetched request data
//        loadItems(with: request, predicate: predicate)
//    }
//    
//    //to get a full list in the tableView when search bar is made empty
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //to check if searchbar has zero text count
//        if searchBar.text?.count == 0 {
//            loadItems()
//            
//            //to make it stop editing and disabling the keyboard
//            //also need to run this in dispatchqueue, so that this won't freeze searchBar (and will keep app responsive)
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//            
//        }
//    }
//    
//    
//}
