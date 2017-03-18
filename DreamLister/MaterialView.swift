//
//  MaterialView.swift
//  DreamLister
//
//  Created by Bettina on 3/17/17.
//  Copyright © 2017 Bettina Prophete. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView { //anything that inherits from UIView will have ability to have the styling we're adding here
    
    //IBInspectable : toggling option that's able to be selected within storyboard
    //person can select whether or not they want to use this materialDesign
    
    @IBInspectable var materialDesign: Bool {
    
        get {
            return materialKey
        } set {
            //when somone goes in and adds a new view, can select if they want materialDesign added to view and if it's selected, the below stylings added.
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                self.layer.cornerRadius = 0.0
                self.layer.shadowOpacity = 0.0
                self.layer.shadowRadius = 0.0
                self.layer.shadowColor = nil
            }
        }
    }
    
    

}
