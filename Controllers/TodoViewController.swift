//
//  ViewController.swift
//  Todoey
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemCollection: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            readData()
        }
    }
    
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    // PATH where data is being stored: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.barTintColor = .darkGray
        
    }
    
    //MARK: -- Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCollection?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemCollection?[indexPath.row] {
            cell.textLabel?.attributedText = removeStrikeText(item.title)
            
            let emptyImage = UIImage(systemName: "circle")
            let fillImage = UIImage(systemName: "circle.fill")
            var trueImage = UIImageView(image: fillImage)
            var falseImage = UIImageView(image: emptyImage)
        
            trueImage.tintColor = .cyan
            falseImage.tintColor = .cyan
            
            if item.done == true {
                cell.accessoryView = trueImage
                cell.textLabel?.attributedText = strikeThroughText(item.title)
                
            } else {
                cell.accessoryView = falseImage
                cell.textLabel?.attributedText = removeStrikeText(item.title)
            }
            
        } else {
            cell.textLabel?.text = "No Items Found"
        }
        
        
        return cell
    }
 
    func strikeThroughText (_ text:String) -> NSAttributedString {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            return attributeString
        }

    func removeStrikeText(_ text: String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughColor, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    
//MARK: -- TablewView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row)
        
        //itemCollection[indexPath.row].done = !itemCollection[indexPath.row].done
        //saveData()
        
        if let item = itemCollection?[indexPath.row] {
            do {
                try realm.write {
                item.done = !item.done
            }
            } catch {
                print("error with checkmark")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -- Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Quest For Your Adventure", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // what happens once the add item button is pressed
            
            
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//
//            self.itemCollection.append(newItem)
//
//            self.saveData()
            
            
            if let currCat = self.selectedCategory { // have to check which category we are in and save it in that category
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currCat.items.append(newItem)
                    }
                } catch {
                    print("error saving item")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add It Here"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: -- Model Manipulation Methods
    
    func saveData(with item: Item) {

        do {
            //try context.save()
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("error saving item")
        }
        tableView.reloadData()
        
        
//        do {
//            try context.save()
//        } catch {
//            print("error saving context")
//        }
//        self.tableView.reloadData()
   }
    
    
    func readData() {
        
        itemCollection = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        
        
    //func readData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        // let request: NSFetchRequest<Item> = Item.fetchRequest() // Need to specifiy the data type NSFetchRequest<Item>

//        let catPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let addPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [addPredicate, catPredicate])
//        } else {
//            request.predicate = catPredicate
//        }
//
//        do {
//           itemCollection = try context.fetch(request)
//        } catch {
//            print("error fetching data")
//        }
        
        tableView.reloadData()
    }
    
    
//    func loadData() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemCollection = try decoder.decode([Item].self, from: data)
//            } catch {
//                print(error)
//            }
//
//        }
//
//
//    }
//
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDelete = self.itemCollection?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDelete)
                }
            } catch {
                print("error deleting item")
            }
        }
        
    }
    
    
}

//MARK: -- Search Bar Methods

extension TodoViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        itemCollection = itemCollection?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        // let request: NSFetchRequest<Item> = Item.fetchRequest()

        //let filter = searchBar.text!

      //  let predicate = NSPredicate(format: "title CONTAINS[cd] %@", filter)

     //   request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // sortDescriptors expects array

      //  readData(with: request, predicate: predicate)

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            readData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

        
//        if searchBar.text?.count == 0 {
//            readData()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//        else {
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//            let filter = searchBar.text!
//
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", filter)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            // sortDescriptors expects array
//
//            readData(with: request)
//        }
        
        
    }
    
    
}


