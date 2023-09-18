//
//  CourseVC.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 9/14/23.
//

import UIKit

class CourseVC: UIViewController {
    
    var list: [String] = [
        "Course 1",
        "Course 2",
        "Course 3",
        "Course 4",
        "Course 5",
        "Course 6"
    ]
    
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
    
    
}


extension CourseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomViewCellTableViewCell", for: indexPath) as! customViewCellTableViewCell
        
        cell.courseName.text = list[indexPath.row]
        
        return cell
    }
    
}
