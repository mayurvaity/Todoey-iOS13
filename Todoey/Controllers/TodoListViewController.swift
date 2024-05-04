//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift


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
    //update example
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //printing selected cells value from array by using index postion from selected cell
        if let cellDetails = todoItems?[indexPath.row] {
            print(cellDetails)
        }
        
        //getting item data from todoItems collection, using cell indexPath
        if let item = todoItems?[indexPath.row] {
            do {
                //to update as well, we use write method
                try realm.write {
                    //just updating that item here (within write method), gets synced everywhere (collection and realm db)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        //to reload all the data in tableview
        tableView.reloadData()
        
        //to deselect the row after clicking
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //delete example
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //printing selected cells value from array by using index postion from selected cell
//        if let cellDetails = todoItems?[indexPath.row] {
//            print(cellDetails)
//        }
//        
//        //getting item data from todoItems collection, using cell indexPath
//        if let item = todoItems?[indexPath.row] {
//            do {
//                //to update as well, we use write method
//                try realm.write {
//                    //just deleting that item here (within write method), gets synced everywhere (collection and realm db)
//                    realm.delete(item)
//                }
//            } catch {
//                print("Error saving done status, \(error)")
//            }
//        }
//        //to reload all the data in tableview
//        tableView.reloadData()
//        
//        //to deselect the row after clicking
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //create alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //create action for above alert
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //what will happen once user press the Add Item button on our UIAlert
            print(textField.text!)
            
            //checking if selectedCategory is available
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        //creating new item (within write method) allows us to write this new item to items colln as well as in realm db
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date() 
                        //for relationship need to add this item in that category, this gets synced with realm db
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        //add text field in the alert (pop-up) to specify new item name
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

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //filtering todo items colln
        //filter - using this filter with created predicate (on the fly)
        //sorted - sorting can be specified here
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
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
