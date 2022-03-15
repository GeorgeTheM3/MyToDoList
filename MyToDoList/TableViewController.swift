//
//  TableViewController.swift
//  MyToDoList
//
//  Created by Георгий Матченко on 27.02.2022.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var context: NSManagedObjectContext!
    var tasks: [Task] = []
    var pageViewController = PageViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPresentatiion()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell

        let object = tasks[indexPath.row]
        
        if !object.status {
            cell.taskColor.backgroundColor = .systemGreen
            cell.taskColor.text = "✓"
            object.status = true
        } else {
            cell.taskColor.backgroundColor = .black
            cell.taskColor.text = "DO"
            object.status = false
        }
        saveContext()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TableViewCell
        cell.taskName.text = tasks[indexPath.row].title
        cell.taskComment.text = tasks[indexPath.row].comment
        cell.taskColor.textColor = .white
        cell.taskColor.text = "DO"
        
        let object = tasks[indexPath.row]
        if object.status {
            cell.taskColor.backgroundColor = .systemGreen
            cell.taskColor.text = "✓"
        } else {
            cell.taskColor.backgroundColor = .black
            cell.taskColor.text = "DO"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = tasks[indexPath.row]
            context.delete(object)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    private func saveTask(withTitle title: String, withComment comment: String) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        taskObject.comment = comment
        taskObject.status = false
        
        do {
            try context.save()
            tasks.append(taskObject)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    private func errorAlert() {
        let allertController = UIAlertController(title: "Error", message: "Title can not be empty", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        allertController.addAction(ok)
        
        present(allertController, animated: true, completion: nil)
    }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New", message: "Add new task", preferredStyle: .alert)

        let add = UIAlertAction(title: "Add", style: .default) { action in
            let textFieldTitle = alertController.textFields![0]
            let textFieldCommnet = alertController.textFields![1]
            if let taskTitle = textFieldTitle.text,
               let taskComment = textFieldCommnet.text {
                guard !taskTitle.isEmpty else { return self.errorAlert() }
                self.saveTask(withTitle: taskTitle, withComment: taskComment)
                self.tableView.reloadData()
            }
        }
        alertController.addTextField { textField in textField.placeholder = "Title"}
        alertController.addTextField { textField in textField.placeholder = "Comment"}

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

        alertController.addAction(add)
        alertController.addAction(cancel)

        present(alertController, animated: true, completion: nil)
    }
    
    func startPresentatiion () {
        
        let userDefaults = UserDefaults.standard
        let presentationWasViewed = userDefaults.bool(forKey: "PresentetionWasViewed")
        if presentationWasViewed == false {
                if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageController") as? PageViewController {
                present(pageViewController, animated: true, completion: nil)
            }
        }
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! PresentationViewController).currentPage
        pageNumber -= 1
        return showViewControllerAtIndex(pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! PresentationViewController).currentPage
        pageNumber += 1
        return showViewControllerAtIndex(pageNumber)
    }
}
