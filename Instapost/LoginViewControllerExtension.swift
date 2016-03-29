//
//  LoginViewControllerExtension.swift
//  Instapost
//
//  Created by Douglas on 3/28/16.
//  Copyright © 2016 Dougli. All rights reserved.
//

import UIKit

extension LoginViewController{

/* Funcitons of picker View*/
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(component){
        case 0:
            return monthArray.count
        case 1:
            switch(dayCheck){
            case 0:
                return dayArray1.count
            case 1:
                return dayArray2.count
            case 2:
                return dayArrayLeap.count
            case 3:
                return dayArrayNonLeap.count
            default:
                break
            }//end inner switch
        case 2:
            return yearArray.count
        default:
            break
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(component){
        case 0:
            return monthArray[row]
        case 1:
            switch(dayCheck){
            case 0:
                return dayArray1[row]
            case 1:
                return dayArray2[row]
            case 2:
                return dayArrayLeap[row]
            case 3:
                return dayArrayNonLeap[row]
            default:
                break
            }//end inner switch
        case 2:
            return yearArray[row]
        default:
            break
        }
        return dayArray1[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component)
        switch(component){
        case 0:
            switch(row){
            case 0:
                dayCheck = 0
                feb = false
            case 1:
                dayCheck = 0
                feb = false
            case 2:
                if(leap){
                    dayCheck = 2
                }else{
                    dayCheck = 3
                }
                feb = true
                //FEB STUFF
            case 3:
                dayCheck = 0
                feb = false
            case 4:
                dayCheck = 1
                feb = false
            case 5:
                dayCheck = 0
                feb = false
            case 6:
                dayCheck = 1
                feb = false
            case 7:
                dayCheck = 0
                feb = false
            case 8:
                dayCheck = 0
                feb = false
            case 9:
                dayCheck = 1
                feb = false
            case 10:
                dayCheck = 0
                feb = false
            case 11:
                dayCheck = 1
                feb = false
            case 12:
                dayCheck = 0
                feb = false
            default:
                break
            }
            changeDobLabel(0, row: row)
        case 1:
            changeDobLabel(1, row: row)
        case 2:
            if(feb){
                var year = 9 + row //9 is to match the array hard coding
                year = year % 4
                if(year == 0){
                    //leap year
                    leap = true
                    dayCheck = 2
                }
                else{
                    leap = false
                    dayCheck = 3
                }//end if year
            }//end if feb
            changeDobLabel(2, row: row)
        default:
            break
        }
        dobPicker.reloadComponent(1)
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = "Potato"
        switch(component){
        case 0:
            string = monthArray[row]
        case 1:
            switch(dayCheck){
            case 0:
                string = dayArray1[row]
            case 1:
                string = dayArray2[row]
            case 2:
                string =  dayArrayLeap[row]
            case 3:
                string = dayArrayNonLeap[row]
            default:
                break
            }//end inner switch
        case 2:
            string = yearArray[row]
        default:
            break
        }
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func changeDobLabel(type: Int, row: Int){
        print("Start change: \(mutatingString)")
        //var sum = 0
        switch(type){
        case 0:
            mutatingString.0 = row
        case 1:
            mutatingString.1 = row
        case 2:
            mutatingString.2 = row
        default:
            break
        }
        //sum = mutatingString.0 + mutatingString.1 + mutatingString.2
        print("End change: \(mutatingString)")
        if(mutatingString.0 != 0 && mutatingString.1 != 0 && mutatingString.2 != 0){
            labelString = String("\(monthArray[mutatingString.0]) \(dayArray1[mutatingString.1]), \(yearArray[mutatingString.2])")
            dobLabel.text = labelString
        }else{
            dobLabel.text = defaultString
        }
    }

}
