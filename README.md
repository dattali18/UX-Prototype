# UX-Prototype

## Overview
This project is a UX prototype for a course management application. The prototype is designed to be easy to use and navigate, and it provides a variety of features for managing courses and semesters.

This project was inspired by a course in `UX`/`UI` design, in which we had to present a prototype of an original app idea. This is the real-life project built from that prototype

## Technologies Used

* `Swift`: The prototype is written in `Swift`, which is a modern programming language developed by Apple. `Swift` is known for its speed, performance, and safety.
* `UIKit:` The app uses `UIKit`, which is Apple's framework for developing user interfaces for `iOS` applications. `UIKit` provides a variety of controls and views that can be used to create complex and interactive user interfaces.
* `SwiftUI`: The app uses `SwiftUI`, wich is Apple's framwork for develping user iterfaces for `iOS` applications.
* `Model-View-Controller (MVC)` : The prototype follows the `Model-View-Controller (MVC)` design pattern. `MVC` is a design pattern that separates the user interface, the data model, and the application logic into three separate components. This makes the code more modular and easier to maintain.
* `CalendarKit` a framwork used in the calendar tab for creating editing and deleting event.
* `CoreData` Apple's framwork to have persistante data, please see the `COREDATA.md` file to see the data structure for the project.

## Features

The course management application offers a range of features to help students manage their courses and semesters effectively:

1. **Course and Semester Management:**
   - Create new courses and semesters effortlessly by tapping the plus button in the navigation bar. Fill out the necessary details in a form and save.
   - Edit existing courses and semesters with ease. Simply swipe left and click the edit button. You can modify course or semester details and save your changes.
   - Delete unwanted courses directly from the list by swiping left.

2. **Filter Courses:**
   - Quickly find the courses you're looking for using the filter feature. Filter by semester or view all courses. Access the filter button on the left side of the navigation bar in the CourseVC view.

3. **Assignment Management:**
   - Assignments are seamlessly linked to courses and categorized as "Homework," "Midterm," "Final," or "Others."
   - Create assignments with the option to add events, which are also viewable in your iPhone calendar as well as within the app's calendar.

4. **Resource Handling:**
   - Add resources associated with your courses, including a name, description, and links to online resources. While the app doesn't handle files, it allows you to organize and access online materials.

5. **GitHub Integration:**
   - The ProjectsVC feature allows you to create and manage projects. You can specify project details like name and URL and link them to specific courses.
   - In the ProjectView, you can view the last five commits on the GitHub repository if it's public.

## Core Data

```mermaid
classDiagram

Semester  <|--  Course
Course  <|--  Assignment
Course  <|--  Project
Course  <|--  GradeItem
Course  <|--  Resource
Resource  <|--  Link

class Course {
  + credits: Float?
  + id: UUID
  + name: String?
  + number: Int32?
  + assignments: [Assignment]
  + projects: [Project]
  + resources: [Resource]
  + gradeItem: [GradeItem]
  + semester: Semester?
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
+ name: String?
+ weight: Float?
+ grade: Float?
}
```


## Data Flow (IA - Information Arcitecture)

```mermaid
graph LR

Main[Main Tab Bar] --> Courses((Courses))
Main --> Assignment((Assignment))
Main --> Project((Projects))

Courses --> AddCourse{Edit/Add Course}
Courses --> AddSemester{Edit/Add Semester}
Courses --> InfoCourse{Course Info}
Courses --> InfoSemester{Semester Info}

InfoCourse --> Resources((Resources))

Resources --> AddResource{Edit/Add Resources}

Assignment --> AddAssignment{Edit/Add Assignment}
Assignment --> InfoAssignment{Assignment Info}

Project --> AddProject{Edit/Add Project}
Project --> InfoProject{Project Info}
```

## Installation

To install the prototype, simply clone the repository and open the project in Xcode.

## Usage

To install the prototype, simply clone the repository and open the project in `Xcode`. run the application on an `iOS` device. The prototype will open to a list of all courses and semesters. You can tap on a course or semester to view its details.

To add a new course or semester, tap on the `+` button in the top right corner of the screen. To edit or delete a course or semester, swipe left on the course or semester and tap on the `Edit` or `Delete` button.

## Author

I am Daniel Attali, a third-year Software Engineering `B.Sc`. student at `JCT` (Jerusalem College of Technology). I am passionate about learning and building innovative and user-friendly software applications. I have experience in a variety of programming languages and technologies, including `Swift`, `UIKit`, and the Model-View-Controller (`MVC`) design pattern. I am also interested in `machine learning` and `artificial intelligence`.

I am a highly motivated and skilled individual with a strong work ethic. I am eager to learn and grow, and I am always looking for new challenges. I am confident that my skills and experience will make me a valuable asset to any team.

Please contact me if you have any question about the project or me.

## Screenshots

### Course/Semester + Resource

**Filtering course by semesters**

<img height="400" src="/UX-Prototype/ScreenShot/fillteringCourses.PNG"><img height="400" src="/UX-Prototype/ScreenShot/fillteringCoursesD.PNG">

**Course Info**

<img height="400" src="/UX-Prototype/ScreenShot/courseInfo.PNG"><img height="400" src="/UX-Prototype/ScreenShot/courseInfoD.PNG">

**Editing course**

<img height="400" src="/UX-Prototype/ScreenShot/editCourse.PNG"><img height="400" src="/UX-Prototype/ScreenShot/editCourseD.PNG">

**Adding course**

<img height="400" src="/UX-Prototype/ScreenShot/addCourse.PNG"><img height="400" src="/UX-Prototype/ScreenShot/addCourseD.PNG">

**Swipe Action course**

<img height="400" src="/UX-Prototype/ScreenShot/deletingCourse.PNG"><img height="400" src="/UX-Prototype/ScreenShot/deletingCourseD.PNG">

<img height="400" src="/UX-Prototype/ScreenShot/editingCourse.PNG"><img height="400" src="/UX-Prototype/ScreenShot/editingCourseD.PNG">

**Adding Grade** 

<img height="400" src="/UX-Prototype/ScreenShot/addingGrade.PNG"><img height="400" src="/UX-Prototype/ScreenShot/addingGradeD.PNG">

**Editing Grade**

<img height="400" src="/UX-Prototype/ScreenShot/editingGrade.PNG"><img height="400" src="/UX-Prototype/ScreenShot/editingGradeD.PNG">

**Deleting Grade**

<img height="400" src="/UX-Prototype/ScreenShot/deletingGrade.PNG"><img height="400" src="/UX-Prototype/ScreenShot/deletingGradeD.PNG">

**Semester Info** 

<img height="400" src="/UX-Prototype/ScreenShot/semesterInfo.PNG"><img height="400" src="/UX-Prototype/ScreenShot/semesterInfoD.PNG">

**Editing semester**

<img height="400" src="/UX-Prototype/ScreenShot/editSemester.PNG"><img height="400" src="/UX-Prototype/ScreenShot/editSemesterD.PNG">


**Adding semester**

<img height="400" src="/UX-Prototype/ScreenShot/addSemester.PNG"><img height="400" src="/UX-Prototype/ScreenShot/addSemesterD.PNG">


**Resources list**

<img height="400" src="/UX-Prototype/ScreenShot/resources.PNG"><img height="400" src="/UX-Prototype/ScreenShot/resourcesD.PNG">

**Editing resource**

<img height="400" src="/UX-Prototype/ScreenShot/editResource.PNG"><img height="400" src="/UX-Prototype/ScreenShot/editResourceD.PNG">

**Editing Link**

<img height="400" src="/UX-Prototype/ScreenShot/editingLink.PNG"> <img height="400" src="/UX-Prototype/ScreenShot/editingLinkD.PNG">

**Editing Link Alert**

<img height="400" src="/UX-Prototype/ScreenShot/editingAlert.PNG"><img height="400" src="/UX-Prototype/ScreenShot/editingAlertD.PNG">

### Assigments

**Filtering assignmetn by type**

<img height="400" src="/UX-Prototype/ScreenShot/fillteringAssignment.PNG"><img height="400" src="/UX-Prototype/ScreenShot/fillteringAssignmentD.PNG">

**Assignment List**

<img height="400" src="/UX-Prototype/ScreenShot/assignments.PNG"><img height="400" src="/UX-Prototype/ScreenShot/assignmentsD.PNG">

**Adding assignment**

<img height="400" src="/UX-Prototype/ScreenShot/addAssignmant.PNG"><img height="400" src="/UX-Prototype/ScreenShot/addAssignmantD.PNG">

**Compelting assignmet**

<img height="400" src="/UX-Prototype/ScreenShot/completingAssignment.PNG"><img height="400" src="/UX-Prototype/ScreenShot/completingAssignmentD.PNG">

**Uncompleting assignment**

<img height="400" src="/UX-Prototype/ScreenShot/uncompletingAssignment.PNG"><img height="400" src="/UX-Prototype/ScreenShot/uncompletingAssignmentD.PNG">

**Swipe Action resources**

<img height="400" src="/UX-Prototype/ScreenShot/editingAssignment.PNG"><img height="400" src="/UX-Prototype/ScreenShot/editingAssignmentD.PNG">


### Calendar

**creating a calendar event**

<img height="400" src="/UX-Prototype/ScreenShot/addEvent.PNG"><img height="400" src="/UX-Prototype/ScreenShot/addEventD.PNG">

**Seeing calendar event**

<img height="400" src="/UX-Prototype/ScreenShot/calendar.PNG"><img height="400" src="/UX-Prototype/ScreenShot/calendarD.PNG">

**Event details in the calendar**

<img height="400" src="/UX-Prototype/ScreenShot/editEvent.PNG"><img height="400" src="/UX-Prototype/ScreenShot/editEventD.PNG">


## Projects

**Projects list**

<img height="400" src="/UX-Prototype/ScreenShot/projects.PNG"><img height="400" src="/UX-Prototype/ScreenShot/projectsD.PNG">

**Adding project**

<img height="400" src="/UX-Prototype/ScreenShot/addProject.PNG"><img height="400" src="/UX-Prototype/ScreenShot/addProjectD.PNG">

**Editing project**

<img height="400" src="/UX-Prototype/ScreenShot/editProject.PNG"><img height="400" src="/UX-Prototype/ScreenShot/editProjectD.PNG">

**Swipe Action project**

<img height="400" src="/UX-Prototype/ScreenShot/editingProject.PNG"><img height="400" src="/UX-Prototype/ScreenShot/editingProjectD.PNG">

<img height="400" src="/UX-Prototype/ScreenShot/deletingProject.PNG"><img height="400" src="/UX-Prototype/ScreenShot/deletingProjectD.PNG">

**Seeing last 5 commits on project**

<img height="400" src="/UX-Prototype/ScreenShot/projectView.PNG"><img height="400" src="/UX-Prototype/ScreenShot/projectViewD.PNG">

**Commits loading**

<img height="400" src="/UX-Prototype/ScreenShot/projectLoading.PNG"><img height="400" src="/UX-Prototype/ScreenShot/projectLoadingD.PNG">

## Conclusion

This UX prototype is a valuable tool for designing and developing a course management application. The prototype is easy to use and navigate, and it provides a variety of features for managing courses and semesters.
