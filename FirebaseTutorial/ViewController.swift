//
//  ViewController.swift
//  FirebaseTutorial
//
//  Created by MAC-OBS-26 on 31/05/22.
//

import UIKit
import Firebase
import FirebaseDatabase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var designationTextField: UITextField!
    @IBOutlet weak var nameListTableView: UITableView!
    
    @IBAction func submitButton(_ sender: Any) {
        addName()
        showAlert()
        self.nameTextField.text = ""
        self.designationTextField.text = ""
    }
    
    var nameList = [NameModel]()
    
    var ref: DatabaseReference!
    
    let refResource = Database.database().reference().child("resource")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameListTableView.delegate = self
        nameListTableView.dataSource = self
        
        loadName()
     
//        ref = Database.database().reference().child("resource")
//        ref.queryOrdered(byChild: "resource").observe(.childAdded, with: { (snapshot) in
//            let results = snapshot.value as! [String: AnyObject]
//            let nameName = results["name"]
//            let nameId = results["id"]
//            let nameDesignation = results["designation"]
//            let namee = NameModel(id: nameId as! String?, name: nameName as! String?, designation: nameDesignation as! String?)
//            self.nameList.append(namee)
//            DispatchQueue.main.async {
//                self.nameListTableView.reloadData()
//            }
//        })
        
//        ref.observe(.value, with: { [self] (snapshot) in
//            if snapshot.childrenCount > 0 {
//                self.nameList.removeAll()
//
//                for names in snapshot.children.allObjects as! [DataSnapshot] {
//                    let nameObject = names.value as? [String: AnyObject]
//                    let nameName = nameObject?["name"]
//                    let nameId = nameObject?["id"]
//                    let nameDesignation = nameObject?["designation"]
//
//                    let namee = NameModel(id: nameId as! String?, name: nameName as! String?, designation: nameDesignation as! String?)
//
//                    self.nameList.append(namee)
//                }
//                self.nameListTableView.reloadData()
//            }
//        })
        
//        ref.observe(.value, with: { snapshot in
//            print(snapshot.value as Any)
//            self.nameListTableView.reloadData()
//        })
    }
    
//    func loadName() {
//        ref = Database.database().reference()
//        //let userID = Auth.auth().currentUser?.uid
//        ref.child("names").queryOrdered(byChild: "names").observe(.childAdded, with: { (snapshot) in
//                    let results = snapshot.value as? [String : AnyObject]
//                    let nameNa = results?["name"]
//                    let nameId = results?["id"]
//                    let nameDesgn = results?["designation"]
//                    let namee = NameModel(id: nameId as! String?, name: nameNa as! String?, designation: nameDesgn as! String?)
//                    //let myCalls = Calls(callType: type as! String?, callHospital: hospital as! String?)
//                    self.nameList.append(namee)
//                    debugPrint(namee)
//                    DispatchQueue.main.async {
//                        self.nameListTableView.reloadData()
//                    }
//            })
//    }
    
    func loadName() {
        ref = Database.database().reference().child("resource")
                ref.observe(.value, with: { [self] (snapshot) in
                    if snapshot.childrenCount > 0 {
                        self.nameList.removeAll()
        
                        for names in snapshot.children.allObjects as! [DataSnapshot] {
                            let nameObject = names.value as? [String: AnyObject]
                            let nameName = nameObject?["name"]
                            let nameId = nameObject?["id"]
                            let nameDesignation = nameObject?["designation"]
        
                            let namee = NameModel(id: nameId as! String?, name: nameName as! String?, designation: nameDesignation as! String?)
        
                            self.nameList.append(namee)
                        }
                        self.nameListTableView.reloadData()
                    }
                })
    }
    
    
    //MARK: - adding data to the firebase database
    func addName() {
        let key = refResource.childByAutoId().key
        
        let name = ["id": key,
                     "name": nameTextField.text! as String,
                     "designation": designationTextField.text! as String
                    ]
        refResource.child(key!).setValue(name)
    }
    
    //MARK: - Update Resource
    func updateName(id: String, name: String, designation: String) {
        let name = ["id": id,
                    "name": name,
                    "designation": designation
                    ]
        refResource.child(id).setValue(name)
        showUpdateAlert()
        loadName()
    }
    
    //MARK: - Delete Resource
    func deleteResource(id:String){
        refResource.child(id).setValue(nil)
        showDeleteAlert()
        loadName()
    }
    

    //MARK: - Alert message
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "Resource Added", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func showUpdateAlert() {
        let alert = UIAlertController(title: "Update Alert", message: "Resource Updated", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func showDeleteAlert() {
        let alert = UIAlertController(title: "Delete Alert", message: "Resource Deleted", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    
    //MARK: - Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let name: NameModel
        
        name = nameList[indexPath.row]
        cell.labelName.text = name.name
        cell.labelDesignation.text = name.designation
        
        return cell
    }
    
    //MARK: - Row Select to update
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = nameList[indexPath.row]
        
        let alertcontroller = UIAlertController(title: name.name, message: "Give new values to update", preferredStyle: .alert)
        let confirmaction = UIAlertAction(title: "Update", style: .default) { (_) in
            let id = name.id
            let name = alertcontroller.textFields?[0].text
            let desgn = alertcontroller.textFields?[1].text
            
            self.updateName(id: id!, name: name!, designation: desgn!)
        }
        
        let cancelaction = UIAlertAction(title: "Delete", style: .cancel) { (_) in
            self.deleteResource(id: name.id!)
        }
        alertcontroller.addTextField { (textField) in
                textField.text = name.name
        }
        alertcontroller.addTextField { (textField) in
                textField.text = name.designation
        }
        
        alertcontroller.addAction(confirmaction)
        alertcontroller.addAction(cancelaction)
        
        present(alertcontroller, animated: true, completion: nil)
    }
}

