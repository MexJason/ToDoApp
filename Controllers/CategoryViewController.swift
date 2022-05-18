//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jason Dubon on 5/11/22.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    

    let realm = try! Realm() // Valid because it can only fail once, on intial start up
    
    var categories: Results<Category>?
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        readData()
    }
    

    //MARK: -- Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var catTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Categories For Your Adventure", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            // what happens once the add item button is pressed
            
            
            //let newCat = Category(context: self.context) since we were using NSManagedObject
            let newCat = Category()
            newCat.name = catTextField.text!
            
            
           // self.categoryArray.append(newCat)
            
            self.saveData(cat: newCat)
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add It Here"
            catTextField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: -- TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    //MARK: -- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
        
        
    }
    
    //MARK: -- Data Manipulation Methods
    
    func saveData(cat: Category) {
        
        do {
            //try context.save()
            try realm.write {
                realm.add(cat)
            }
        } catch {
            print("error saving category")
        }
        tableView.reloadData()
    }
    
    func readData() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let catForDelete = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(catForDelete)
                }
            } catch {
                print("error deleting category")
            }
        }
        
    }
    
    
}

