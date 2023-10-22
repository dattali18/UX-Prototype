//
//  SemesterViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/18/23.
//

import Foundation
import CoreData


class SemesterViewModel: ObservableObject {
    @Published var selectedType: Int = 0
    @Published var types: [String] = ["Spring", "Summer", "Fall"]
    
    @Published var start: Date = Date.now
    @Published var end: Date = Date.now
    
    @Published var isShowing: Bool = false
    @Published var deleteAlertShowing: Bool = false
    @Published var deleteAlertResponse: Bool = false
    
    
    @Published var navigationtitle: String = "Add Semester"
    
    var mode: Mode = .add
    var semester: Semester?
    
    init(with semester: Semester? = nil) {
        self.semester = semester
        if(semester != nil) {
            mode = .edit
            navigationtitle = "Edit Semester"
        }
        edit()
    }
    
    func edit() {
        if(mode == .add){
            return
        }
        
        selectedType    = types.firstIndex(of: semester?.type ?? "") ?? 0
        start           = semester?.start ?? Date()
        end             = semester?.end ?? Date()
    }
    
    func saveSemester() -> Semester? {
        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        
        if(mode == .add)
        {
            self.semester = Semester(context: managedObjectContext)
        }
        
        let date = start
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        
        semester!.name      = "\(types[selectedType]) \(yearString)"
        semester!.type      = types[selectedType]
        semester!.start     = start
        semester!.end       = end

        do {
          try managedObjectContext.save()
          return semester
        } catch {
          print("Error creating entity: \(error)")
          return nil
        }
    }
    
    func deleteSemester() {
        CoreDataManager.shared.delete(self.semester)
    }
    
    func validateInput() -> Bool{
        return start < end
    }
    
    func showAlert() {
        isShowing = true
    }
    
    func showDeleteAlert() {
        deleteAlertShowing = true
    }
}
