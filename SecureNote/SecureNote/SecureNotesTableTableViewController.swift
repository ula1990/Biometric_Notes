//
//  SecureNotesTableTableViewController.swift
//  SecureNote
//
//  Created by Ulad Daratsiuk-Demchuk on 2017-11-06.
//  Copyright © 2017 Uladzislau Daratsiuk. All rights reserved.
//

import UIKit
import CoreData

class SecureNotesTableTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   // var userNotes = [["name":"Welcome","image":"exampleimg","item":"Secure Notes"]]
    
    
    var  notes = [Note]()
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let image:UIImage = UIImage.init(named: "lockicon")!
        let image_view:UIImageView = UIImageView.init(image: image)
        self.navigationItem.titleView = image_view
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
        
    }
    
    func loadData() {
        
        let noteReuqest:NSFetchRequest<Note> = Note.fetchRequest()
        
        do{
            notes = try managedObjectContext.fetch(noteReuqest)
            self.tableView.reloadData()
        }catch{
            
            print("Could not load the data from Database\(error.localizedDescription)")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotesTableViewCell

        let noteItem = notes[indexPath.row]
        
        if let noteImage = UIImage(data: noteItem.image as Data!){
            cell.backgroundImg.image = noteImage
            
        }
        
        
        cell.nameLbl.text = noteItem.titleNote
        cell.itemLbl.text = noteItem.note
        
        return cell
    }

    //ADD Image
    
    @IBAction func addNote(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        self.present(imagePicker, animated: true,completion: nil)
    }
    
    
    //LOCK SCREEN
    
    @IBAction func lockScreen(_ sender: Any) {
        
        self.performSegue(withIdentifier: "Lock", sender: self)
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            picker.dismiss(animated: true, completion: {
                self.createNoteItem(with: image)
            } )
            
        }
        
        
    }
    
    // Create a note
    
    func createNoteItem (with image: UIImage){
        
        let noteItem = Note(context: managedObjectContext)
        noteItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!) as Data
        
        let inputAlert = UIAlertController(title: "New Note", message: "Enter title and context of the note", preferredStyle: .alert)
        inputAlert.addTextField {(textfield: UITextField) in textfield.placeholder = "Title"}
        inputAlert.addTextField {(textfield: UITextField) in textfield.placeholder = "Context"}
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action:UIAlertAction) in
            
            let titleTextField = inputAlert.textFields?.first
            let contextTextField = inputAlert.textFields?.last
            
            if titleTextField?.text != "" && contextTextField?.text != "" {
                noteItem.titleNote = titleTextField?.text
                noteItem.note = contextTextField?.text
                
                do {
                    try self.managedObjectContext.save()
                    self.loadData()
                }catch{
                    print("Could not save data\(error.localizedDescription)")
                    
                }
                
                
            }
            
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(inputAlert, animated: true, completion: nil)
        
    }
    
    //Delete note
    
    override func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDel.persistentContainer.viewContext
            let contxt = managedObjectContext
            contxt.delete(notes[indexPath.row])
            notes.remove(at: indexPath.row)
            
            let _ : NSError! = nil
            do {
                try contxt.save()
                self.tableView.reloadData()
            } catch {
                print("error : \(error)")
            }
        
    }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   

}
