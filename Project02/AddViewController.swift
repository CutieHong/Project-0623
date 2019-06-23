//
//  AddViewController.swift
//  Project02
//
//  Created by swucomputer on 22/06/2019.
//  Copyright © 2019 swucomputer. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var textNote: UITextField!
    @IBOutlet var textDetail: UITextView!
    @IBOutlet var labelStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getContext () -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        if textNote.text == "" {
            labelStatus.text = "한줄을 입력하세요"; return; }
        if textDetail.text == "" {
            labelStatus.text = "일기를 입력하세요"; return; }
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName:
            "Note", in: context)
    
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        object.setValue(textNote.text, forKey: "note")
        object.setValue(textDetail.text, forKey: "detail")
        object.setValue(Date(), forKey: "date")
        
        do {
            try context.save()
            print("saved")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
        
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
