//
//  ViewController.swift
//  iCocoa
//
//  Created by Thomas Crawford on 2/14/17.
//  Copyright © 2017 VizNetwork. All rights reserved.
//

import UIKit
import ConfettiView
import Parse

class ViewController: UIViewController {
    
    var confettiView    :ConfettiView!
    var toDoArray = [ToDoItem]()
    var selectedToDo    :ToDoItem?
    
    @IBOutlet var descTextField         :UITextField!
    @IBOutlet var priorityTextField     :UITextField!
    @IBOutlet var toDoTableView         :UITableView!
    
    //MARK: - Parse Methods
    
    func save(toDo: ToDoItem) {
        toDo.saveInBackground { (success, error) in
            print("Object Saved")
            self.fetchToDos()
        }
    }
    
    @IBAction func addToDo(button: UIButton) {
        let toDo = ToDoItem(desc: descTextField.text!, priority: Int(priorityTextField.text!)!)
        save(toDo: toDo)
    }
    
    @IBAction func updateToDo(button: UIButton) {
        guard let toDo = selectedToDo else {
            return
        }
        toDo.itemDesc = descTextField.text!
        toDo.priorityLevel = Int(priorityTextField.text!)!
        save(toDo: toDo)
    }
    
    func fetchToDos() {
        let query = PFQuery(className: "ToDoItem")
        query.limit = 1000
        query.order(byAscending: "isComplete")
        query.order(byDescending: "priorityLevel")
        query.findObjectsInBackground { (results, error) in
            if let err = error {
                print("Got error \(err.localizedDescription)")
            } else {
                self.toDoArray = results as! [ToDoItem]
                print("Count: \(self.toDoArray.count)")
                self.toDoTableView.reloadData()
            }
        }
    }
    
    @IBAction func fetchToDosPressed(button: UIButton) {
        fetchToDos()
    }
    
    //MARK: - Confetti Methods
    
    @IBAction func toggleConfetti(button: UIBarButtonItem) {
        if confettiView.isAnimating {
            confettiView.stopAnimating() } else {
                confettiView.startAnimating()
            }
    }
    
    func setupConfettiView() {
        confettiView = ConfettiView()
        confettiView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        confettiView.clipsToBounds = true
        self.view.addSubview(confettiView)
    }
    
    //MARK: - Test Methods
    
    func testParse() {
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackground { (success, error) in
            print("Object was saved.")
        }
    }
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupConfettiView()
//        testParse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentToDo = toDoArray[indexPath.row]
        cell.textLabel!.text = currentToDo.itemDesc
        cell.detailTextLabel!.text = "\(currentToDo.priorityLevel)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedToDo = toDoArray[indexPath.row]
        descTextField.text = selectedToDo!.itemDesc
        priorityTextField.text = "\(selectedToDo!.priorityLevel)"
    }
    
}

