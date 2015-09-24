//
//  ViewController.swift
//  GurtamTest
//
//  Created by Denis Gavrilenko on 9/23/15.
//  Copyright © 2015 denis.gavrilenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cashArray: Array <Int>!
    var tableDataArray: Array<Int>!
    var elementCount: Int = 0
    
    struct GlobalConstants {
        static let kCellIdentifier = "MyIdentifier"
        static let kMininumSimpleNumber = 2
        static let kMininumDevider = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableDataArray = Array<Int>()
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.elementCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.kCellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = String(self.tableDataArray[indexPath.row])
        
        return cell
    }
    
    // MARK: - Action

    @IBAction func onStartButton(sender: UIButton) {
        checkInputStringAndStart(textField.text)
        view.endEditing(true)
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return checkInputStringAndStart(textField.text)
    }
    
    // MARK: - Generation
    
    func startGeneration(limit: Int) {
        if limit > GlobalConstants.kMininumSimpleNumber
        {
            self.activityIndicator.startAnimating()
            
            self.formResultArray(limit, completion: { (count: Int) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.presentResultsWithElementCount(count)
                })
            })
        }
        else
        {
            self.presentResultsWithElementCount(0);
        }
    }
    
    func presentResultsWithElementCount(count: Int) {
        print(NSDate());
        self.elementCount = count
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
    }
    
    func formResultArray(limit: Int, completion: (count: Int) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            print(NSDate());
            
            if self.hasAllSimpleCashedValues(self.tableDataArray, limit: limit)
            {
                completion(count: self.simpleValueCountInCashedArray(self.tableDataArray, limit: limit))
            }
            else
            {
                var startValue = GlobalConstants.kMininumDevider
                if self.tableDataArray.count > 0
                {
                    startValue = self.tableDataArray.last! + 2
                }
                else
                {
                    self.tableDataArray.append(GlobalConstants.kMininumSimpleNumber)
                }
                for var i = startValue; i < limit; i += 2
                {
                    if self.isSimple(i)
                    {
                        self.tableDataArray.append(i)
                    }
                }
                completion(count: self.tableDataArray.count)
            }
        }
    }
    
    func simpleValueCountInCashedArray(cashedArray: Array<Int>, limit: Int) -> Int {
        for var i = cashedArray.count-1; i >= 0; i--
        {
            if (limit > cashedArray[i])
            {
                return i + 1
            }
        }
        return 0
    }
    
    func hasAllSimpleCashedValues(cashArray : Array<Int>, limit : Int) -> Bool {
        if cashArray.count > 0
        {
            let lastCashedValue = cashArray.last
            if lastCashedValue > limit
            {
                return true
            }
        }
        return false
    }
    
    func isSimple(value: Int) -> Bool {
        let sValue = sqrt(Double(value)) + 1
        for var j = 0; j < self.tableDataArray.count; j++
        {
            let devider = self.tableDataArray[j]
            if sValue < Double(devider)
            {
                return true
            }
            if (value % devider) == 0
            {
                return false
            }
        }
        return true
    }
    
    // MARK: - Input
    
    func checkInputStringAndStart(inputString: String?) -> Bool {
        if isValidInput(inputString)
        {
            let value = NSInteger(inputString!)
            self.startGeneration(value!)
            return true
        }
        else
        {
            return false
        }
    }
    
    func isValidInput(text: String?) -> Bool {
        if (text == nil)
        {
            return false
        }
        let regex = "^[0-9]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluateWithObject(text)
        {
            return true
        }
        return false
    }
}

