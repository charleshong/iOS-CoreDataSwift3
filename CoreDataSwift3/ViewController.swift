//
//  ViewController.swift
//  CoreDataSwift3
//
//  Created by sherriff on 10/17/16.
//  Copyright © 2016 Mark Sherriff. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var compid: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(textToShow: String) {
        let alertController = UIAlertController(title: "Thing To Save", message: textToShow, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    func saveToTextFile() {
        
        let fileName = "students.txt"
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        // Set the contents
        let fileContentToWrite = name.text! + " " + compid.text!
        
        do {
            // Write contents to file
            try fileContentToWrite.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
                
    }

    
    @IBAction func saveStudent(_ sender: UIButton){
        
        // Setting Defaults (like shared preferences)
        let userDefaults = UserDefaults.standard
        userDefaults.set(name.text!, forKey: "name")
        
        saveToTextFile()
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Student", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(name.text!, forKey: "name")
        transc.setValue(compid.text!, forKey: "compid")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }

    }
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func printFromTextFile() {
        
        let fileName = "students.txt"
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        
        do {
            // Read file content
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            print(contentFromFile)
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
    }
    
    @IBAction func printStudents(_ sender: UIButton) {
        
        //Loading defaults
        let userDefaults = UserDefaults.standard
        
        let currentName = userDefaults.object(forKey: "name") as! String
        
        print("From Defaults: " + currentName)
        
        printFromTextFile()
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for student in searchResults as [NSManagedObject] {
                
                print("\(student.value(forKey: "compid"))")
            }
        } catch {
            print("Error with request: \(error)")
        }

    }
    
}

