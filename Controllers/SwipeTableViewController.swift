//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Jason Dubon on 5/12/22.
//
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
        
        view.backgroundColor = .darkGray
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        
       SwipeTableViewController.awakeFromNib(cell: cell)
        
        cell.backgroundColor = .darkGray
        return cell
    }
    
    class func awakeFromNib(cell: SwipeTableViewCell) {
        super.awakeFromNib()
        
        // add shadow on cell
        cell.backgroundColor = .clear // very important
        //cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.8
        cell.layer.shadowRadius = 8
        //cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor

        // add corner radius on `contentView`
        cell.layer.backgroundColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 10
    }
//        
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // this will turn on `masksToBounds` just before showing the cell
//        cell.contentView.layer.masksToBounds = true
//    }
//    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.updateModel(at: indexPath)
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")

            return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }

    
}


