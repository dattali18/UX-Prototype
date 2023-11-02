class Course {
  + credits: Float
  + id: UUID
  + name: String
  + number: Int32
  + assignments: [Assignment]
  + projects: [Project]
  + resources: [Resource]
  + semester: Semester
}

class Assignment {
  + name: String?
  + descriptions: String?
  + due: Date?
  + id: UUID
  + importance: Int32
  + type: String?
  + course: Course
}

class Project {
  + icon: String?
  + id: UUID
  + url: String?
  + name: String
  + number: Int32
  + course: Course
}

class Resource {
  + descriptions: String?
  + id: UUID
  + name: String
  + course: Course
  + links: [Link]
}

class Link {
  + name: String?
  + url: String?
  + resource: Resource
}

class Semester {
  + end: Date?
  + id: UUID
  + start: Date?
  + name: String?
  + type: String?
  + courses: [Course]
}

class GradeItem {
+ id: UUID
+ name: String
+ weight: Float
+ grade: Float
}
