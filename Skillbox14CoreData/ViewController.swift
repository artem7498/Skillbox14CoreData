//
//  ViewController.swift
//  Skillbox14CoreData
//
//  Created by Артём on 6/2/20.
//  Copyright © 2020 Artem A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tasks = CoreDataWork.shared.tasks
    
    func reloadTable() {
        tasks = CoreDataWork.shared.getData()
        tableView.reloadData()
    }

    @IBOutlet weak var tableView: UITableView!
    
//    var tasks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToDo list"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        print()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
        print(tasks)
    }

    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Task", message: "Add a new task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default){
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let taskToSave = textField.text else {return}
            CoreDataWork.shared.save(taskName: taskToSave)
            self.reloadTable()
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataWork.shared.getData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = CoreDataWork.shared.getData()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = task.value(forKey: "taskName") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            CoreDataWork.shared.remove(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()

        }
    }
    
    
}

