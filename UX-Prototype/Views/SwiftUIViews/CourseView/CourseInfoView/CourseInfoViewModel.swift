//
//  CourseInfoViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/26/23.
//
import Foundation

class CourseInfoViewModel : ObservableObject {
    @Published var course: Course?
    
    @Published var gradeitems: [GradeItem] = []
    
    @Published var name: String = ""
    @Published var weight: Float?
    @Published var grade: Float?
    
    @Published var finalGrade: Float = 0
    
    @Published var showingForm: Bool = false
    
    init(course: Course?) {
        self.course = course
        fetchData()
    }
    
    func fetchData() {
        let grades = CoreDataManager.shared.fetch(entity: GradeItem.self)
        gradeitems = grades?.filter { $0.course == course } ?? []
        
        calcFinal()
    }
    
    func showForm() {
        self.showingForm = true
    }
    
    func addGradeItem() {
        if(name == "") {
            return
        }
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        
        let gradeitem = GradeItem(context: managedObjectContext)
        gradeitem.name = self.name
        gradeitem.weight = self.weight ?? 0.0
        gradeitem.grade = self.grade ?? 0.0
        gradeitem.id = UUID()

        course?.addToGradeItems(gradeitem)
        
        do {
          try managedObjectContext.save()
        } catch {
          print("Error creating entity: \(error)")
        }
        
        fetchData()
        
        self.name = ""
        self.weight = 0
        self.grade = 0
    }
    
    func calcFinal() {
        var res: Float = 0
        
        for item in gradeitems {
            res += item.grade * item.weight
        }
        self.finalGrade = res
    }
    
    func deleteItem(gradeitem: GradeItem) {
        self.gradeitems.removeAll { $0 == gradeitem }
        CoreDataManager.shared.delete(gradeitem)
    }
    
    func editItem(gradeitem: GradeItem) {
        self.name = gradeitem.name ?? ""
        self.weight = gradeitem.weight
        self.grade = gradeitem.grade
        
        deleteItem(gradeitem: gradeitem)
        
        showForm()
    }
    
    func saveCourse() {
        if(self.course?.grade == self.finalGrade) {
            return
        }
        
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        self.course?.grade = self.finalGrade
        
        do {
          try managedObjectContext.save()
        } catch {
          print("Error creating entity: \(error)")
        }
    }
}
