//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Bettina on 3/18/17.
//  Copyright © 2017 Bettina Prophete. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    
    @IBOutlet weak var imagePick: UIImageView!
    
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
       // generateTestData()
        getStores()
        
        if itemToEdit != nil { // if we've passed an already existing item for editing into this view then load that item's data
            loadItemData()
        }
        
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
    
    @IBAction func deletePressed(_ sender: Any) {
    //only want to delete if item passed is one that already exists so create a check
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        //pop back to main view once done deleting
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveItemPressed(_ sender: UIButton) {
        var item : Item!
        
        let picture = Image(context: context)
        picture.picture = imagePick.image
        
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture
        
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
    
    
    func loadItemData() {
        
            if let item = itemToEdit {
                titleField.text = item.title
                priceField.text = "\(item.price)"
                detailsField.text = item.details
                imagePick.image = item.toImage?.picture as? UIImage //image/picture attribute under our Image entity was set as a type of transformable because we wanted to directly save images to the attribute/property which is of type NSObject so no need to convert to data
                
                // itemToEdit's saved store is a string. Must loop to check and compare name one by one to store options in storePicker view and assign that value to pickerView to then save in edit
                if let store = item.toStore {
                    var index = 0
                    repeat {
                        let s = stores[index]
                        if s.name == store.name {
                            storePicker.selectRow(index, inComponent: 0, animated: false)
                            break
                        }
                        index += 1
                    } while (index < stores.count)
                }
            }
    }
    
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //instead of returning just an image, returns dictionary of any object, so actual image must be extracted by going into info dictionary Apple provides and cast it
       
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePick.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil) //to dismiss camera roll
    }
}

//modify to include itemType. add/editVC  type textfiel, modify load & save item details in itemCell and vc and add typeSort and segment control
