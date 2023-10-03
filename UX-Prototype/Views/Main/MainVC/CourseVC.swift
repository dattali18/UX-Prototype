//
//  CourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit
import CoreData

class CourseVC: UIViewController {
    
    var list: [Course]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nib = UINib(nibName: "CustomViewCellTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomViewCellTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 44
 
        // Do any additional setup after loading the view.
        self.title = "Courses"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        do {
            let courses = try CoreDataStack.shared.managedObjectContext.fetch(fetchRequest)
            // Process fetched courses
            list = courses
            tableView.reloadData()
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    
}


extension CourseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomViewCellTableViewCell", for: indexPath) as! customViewCellTableViewCell
        
        cell.courseName.text = list?[indexPath.row].name
        
        return cell
    }
    
}
