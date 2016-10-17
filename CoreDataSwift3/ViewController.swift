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
        
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documents = directories.first {
            if let urlDocuments = NSURL(string: documents) {
                let urlStudents = urlDocuments.appendingPathComponent("students.plst")
                print("File Path: ")
                print(urlStudents)
                
                let student = [name.text!, compid.text!] as NSArray!
                
                student?.write(toFile: urlStudents!.path, atomically: true)
                
               
            }
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
        
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documents = directories.first {
            if let urlDocuments = NSURL(string: documents) {
                let urlStudents = urlDocuments.appendingPathComponent("students.plst")
        
                let loadedStudents = NSArray(contentsOf: urlStudents!)
                if let students = loadedStudents {
                    print(students)
                }
            }
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

