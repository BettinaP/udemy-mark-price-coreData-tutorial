//
//  MainVC.swift
//  DreamLister
//
//  Created by Bettina on 3/17/17.
//  Copyright © 2017 Bettina Prophete. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var controller: NSFetchedResultsController <Item>! //telling it we're fetching Item entity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        attemptFetch()
        //generateTestData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func configureCell(cell: ItemCell, indexPath: IndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.primaryConfigureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as IndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // anytime someon clicks on an item it tableview, this function is called. Checking to see if objects exist in our fetchedResults controller and there's at least one of them. Setting item to specific item selected from list/array
        if let objects = controller.fetchedObjects, objects.count > 0{
            let item = objects[indexPath.row]
            //sending selected item's details to be shown in itemDetailsVC via segue for editing
            performSegue(withIdentifier: "toShowItemDetails", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowItemDetails" {
            //passing selected item to be edited in ItemDetailsVC (sending info from original view to new view)
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "createdAt", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segmentedControl.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segmentedControl.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller = fetchedResultsController
        
        controller.delegate = self //must set controller as its delegate so it can listen for changes to update tableview as per willChange/didChangeContent functions far below
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
    }
    
    
    //NFRcontroller will listen for you whenever tableView is about to update with some changes and will handle it for you
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as IndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    
   
    
    func generateTestData() {
        
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "I can't wait until the septmeber event, i hope they release new MBPs"
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 350
        item2.details = "Silence, finally! It's so nice to be able to block out everyone with noise cancelling tech"
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "Beautiful car, hope to own it one day."
        
        ad.saveContext()
    }
    
}

