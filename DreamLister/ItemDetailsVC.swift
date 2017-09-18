//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Sabrina Fletcher on 9/16/17.
//  Copyright © 2017 Sabrina Fletcher. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var thumbImg: UIImageView!
    
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        storePicker.delegate = self
        storePicker.dataSource = self
        
        itemTypePicker.delegate = self
        itemTypePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        
//        let store = Store(context: context)
//        store.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Amazon"
//        let store3 = Store(context: context)
//        store3.name = "Tesla Dealership"
//        let store4 = Store(context: context)
//        store4.name = "Target"
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        let store6 = Store(context: context)
//        store6.name = "Walmart"
        
//        let type1 = ItemType(context: context)
//        type1.type = "Computer"
//        let type2 = ItemType(context: context)
//        type2.type = "Headphones"
//        let type3 = ItemType(context: context)
//        type3.type = "Clothing"
//        let type4 = ItemType(context: context)
//        type4.type = "Monitor"
//        let type5 = ItemType(context: context)
//        type5.type = "Motor Vehicle"
//        let type6 = ItemType(context: context)
//        type6.type = "Digital Cameras"
//        let type7 = ItemType(context: context)
//        type7.type = "Movies, Music, Games"

        ad.saveContext()
        getStores()
        getItemTypes()
        
        if itemToEdit != nil{
            loadItemData()
        }


        // Do any additional setup after loading the view.
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == storePicker{
            let store = stores[row]
            return store.name
        } else if pickerView == itemTypePicker{
            let itemType = itemTypes[row]
            return itemType.type
        }
        return ""

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == storePicker{
            return stores.count
        } else{
            return itemTypes.count
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    
    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do{
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch{
            //handle the error
            
        }
    }
    
    func getItemTypes(){
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do{
            self.itemTypes = try context.fetch(fetchRequest)
            self.itemTypePicker.reloadAllComponents()
        } catch{
            //handle the error
        }
    
    }

    @IBAction func savePressed(_ sender: UIButton) {
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        
        if itemToEdit == nil{
            item = Item(context: context)
        } else{
            item = itemToEdit
            //CoreData automatically knows what item it needs to edit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text{
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text{
            item.details = details
        }
        
        item.created = NSDate()
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = itemTypes[itemTypePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    
    func loadItemData(){
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore{
                var index = 0
                repeat{
                    
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                    
                }while (index < stores.count)
                
            }
            
            if let type = item.toItemType{
                var ndx = 0
                repeat{
                    let t = itemTypes[ndx]
                    if t.type == type.type{
                        itemTypePicker.selectRow(ndx, inComponent: 0, animated: false)
                        break
                    }
                    ndx += 1
                } while (ndx < itemTypes.count)
                
            }
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil{
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
