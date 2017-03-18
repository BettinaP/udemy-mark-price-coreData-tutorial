//
//  ItemDetailsVCViewController.swift
//  DreamLister
//
//  Created by Bettina on 3/18/17.
//  Copyright © 2017 Bettina Prophete. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVCViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    
    var stores = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        //generateTestData()
        getStores()
        
    }
    
    func generateTestData() {
        let store = Store(context: context)
        store.name = "Best Buy"
        
        let store2 = Store(context: context)
        store2.name = "Office Depot"
        
        let store3 = Store(context: context)
        store3.name = "Walmart"
        
        let store4 = Store(context: context)
        store4.name = "Tesla Dealership"
        
        let store5 = Store(context: context)
        store5.name = "Amazon"
        
        let store6 = Store(context: context)
        store6.name = "Target"
        
        ad.saveContext()
    }
    
    func getStores() {
        let storeFetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do{
            self.stores = try context.fetch(storeFetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            //handle error
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    @IBAction func saveItemPressed(_ sender: Any) {
        
        let item = Item(context: context)
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        // toStore is relationship between Item & Store entities. Assigning a store via relationship via this particular item. store is being selected via storePicker.
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
       _ = navigationController?.popViewController(animated: true)
    }
    
}
