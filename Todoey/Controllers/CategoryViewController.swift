//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mayur Vaity on 18/04/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    //category array - a Results container to keep Category objects
    var categoryArray: Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to print location of document directory (this is where data files are kept)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //loading category data
        loadCategories()
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CategoryVC cellForRowAt indexPath called")
        //inheriting from super class 
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categoryArray?[indexPath.row]
        
        //setting value of the text label in this cell to one of the values from array
        cell.textLabel?.text = category?.name ?? "No Categories Added Yet"
        
        //returning cell
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    //to save item to the list 
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        //to reload data in the tableview to include newly added items
        self.tableView.reloadData()
    }
    
    //to perform fetch requests and reloading the tableView,
    //for cases where need to fecth complete data the request parameter is optional and has a default value
    func loadCategories() {
        
        //to get categories data from realm
        categoryArray = realm.objects(Category.self)
        
        //need to reload tableView as categoryArray has changed by above request
        //this calls cellForRowAt IndexPath method
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        //getting category data from categoryarray collection, using cell indexPath
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                //to delete as well, we use write method
                try self.realm.write {
                    //just deleting that category here (within write method), gets synced everywhere (collection and realm db)
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting a category, \(error)")
            }
            //reloading tableview after deletion (no need, as swipecellkit handles this in one of its delegate methods) 
//            self.tableView.reloadData()
        }
    }
    
    //MARK: - TableView Delegate Methods
    //below method gets triggered when clicked on one of the cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //below code will perform segue to go to next page (ie Items page for that category)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //below method will run before performing segue, here we can prepare for actions need to be done before moving to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //creating object of next page's VC, to be able to work with its properties
        let destinationVC = segue.destination as! TodoListViewController
        
        //to get category info of selected cell on category tableview
        if let indexPath = tableView.indexPathForSelectedRow {
            //to assign the category data to the selectedCategory var in next page's VC (TodoListViewController)
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        //create alert
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //create action for above alert
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            //what will happen once user press the Add Item button on our UIAlert
            print(textField.text!)
            
            //created a new object to store category details
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //no need to append to the CategoryArray, as it is an auto-updating container, it will automatically get added
            
            //calling save Items method to save context data into our db table
            self.save(category: newCategory)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        
        //associate above action to the alert
        alert.addAction(action)
        
        //to show our alert
        present(alert, animated: true, completion: nil)
        
    }
}




