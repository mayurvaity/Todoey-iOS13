//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mayur Vaity on 18/04/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]() 
    
    //UIApplication.shared is singleton which is ref to when app is actually running on iphone
    //its delegate (this is a delegate of the App Object) is casted as AppDelegate and then ViewContext is used to create a staging db
    //casting works bc they both inherit from superclass UIApplicationDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to print location of document directory
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //loading category data
        loadCategories()

    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CategoryVC cellForRowAt indexPath called")
        
        //creating a cell (UITableViewCellz) to pass at tableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        //setting value of the text label in this cell to one of the values from array
        cell.textLabel?.text = category.name 
        
        //returning cell
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    //to save item to the list 
    func saveCategories() {
        
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
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        //then use context to fetch
        do {
            //fetched data will be in the form of an array of Item, and will be stored in itemArray
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        //need to reload tableView as itemArray has changed by above request
        //this calls cellForRowAt IndexPath method
        tableView.reloadData()
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
            destinationVC.selectedCategory = categoryArray[indexPath.row] 
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
            
            //above context is used while creating object of Category
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            //need to do the validation later to get only text not nils
            //appending this new category to the categoryArray
            self.categoryArray.append(newCategory)
            
            //calling save Items method to save context data into our db table
            self.saveCategories()
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
