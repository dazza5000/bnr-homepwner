//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Darran Kelinske on 6/7/18.
//  Copyright © 2018 whereisdarran. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item = itemStore.allItems[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message =  "Are you sure you want to delte this item?"
            
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
                                             handler: { (action) -> Void in
                                                
                                                self.itemStore.removeItem(item)
                                                self.imageStore.deleteImage(forKey: item.itemKey)
                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            
            ac.addAction(deleteAction)
        
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showItem"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detailViewController
                    = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        default:
            preconditionFailure("Enexpected segue identifier.")
        }
    }
}
