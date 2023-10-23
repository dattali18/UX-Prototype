#  Tree Structrue of the app

``` bash
./
├── COREDATA.md
├── README.md
├── TREE.md
├── UX-Prototype/
│   ├── AppDelegate.swift
│   ├── Assets.xcassets/
│   │   ├── AccentColor.colorset/
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset/
│   │   │   ├── Contents.json
│   │   │   └── PHOTO-2023-10-23-13-15-40.jpg
│   │   ├── Contents.json
│   │   ├── Git.imageset/
│   │   │   ├── Contents.json
│   │   │   └── Vector-2.pdf
│   │   └── GitHub.imageset/
│   │       ├── Contents.json
│   │       └── Vector.pdf
│   ├── Base.lproj/
│   │   ├── LaunchScreen.storyboard
│   │   └── Main.storyboard
│   ├── Controllers/
│   │   ├── CoreDataManager.swift
│   │   └── CourseDataManager.swift
│   ├── Info.plist
│   ├── Model.xcdatamodeld/
│   │   └── Model.xcdatamodel/
│   │       └── contents
│   ├── Models/
│   │   └── Model.swift
│   ├── SceneDelegate.swift
│   ├── ScreenShot/
│   │   ├── IMG_8073.PNG
│   │   ├── IMG_8074.PNG
│   │   ├── IMG_8075.PNG
│   │   ├── IMG_8076.PNG
│   │   ├── IMG_8077.PNG
│   │   ├── IMG_8078.PNG
│   │   ├── IMG_8079.PNG
│   │   ├── IMG_8080.PNG
│   │   ├── IMG_8086.PNG
│   │   ├── IMG_8087.PNG
│   │   ├── IMG_8088.PNG
│   │   ├── IMG_8089.PNG
│   │   ├── IMG_8090.PNG
│   │   ├── IMG_8091.PNG
│   │   ├── IMG_8092.PNG
│   │   ├── IMG_8093.PNG
│   │   ├── IMG_8094.PNG
│   │   ├── IMG_8095.PNG
│   │   ├── IMG_8096.PNG
│   │   ├── IMG_8097.PNG
│   │   ├── IMG_8098.PNG
│   │   ├── IMG_8099.PNG
│   │   ├── IMG_8100.PNG
│   │   ├── IMG_8101.PNG
│   │   ├── IMG_8102.PNG
│   │   ├── IMG_8103.PNG
│   │   ├── IMG_8104.PNG
│   │   ├── IMG_8105.PNG
│   │   └── IMG_8106.PNG
│   ├── Utils/
│   │   ├── Authentication/
│   │   │   └── UserLogin.swift
│   │   ├── CustomDelegate/
│   │   │   └── CustomDelegate.swift
│   │   ├── Enums/
│   │   │   ├── AssignmentEnum.swift
│   │   │   ├── ModeEnum.swift
│   │   │   └── SemesterEnum.swift
│   │   ├── Event/
│   │   │   └── Event.swift
│   │   └── Extenstions/
│   │       ├── UIAlerts+extention.swift
│   │       └── UITouch+extention.swift
│   └── Views/
│       ├── CustomViews/
│       │   ├── CustomSectionHeader/
│       │   │   ├── CourseSectionHeaderView.swift
│       │   │   ├── CourseSectionHeaderView.xib
│       │   │   ├── ResourcesSectionHeaderView.swift
│       │   │   └── ResourcesSectionHeaderView.xib
│       │   └── CustomTableViewCell/
│       │       ├── AssignmentTVC.swift
│       │       ├── AssignmentTVC.xib
│       │       ├── Assignments.swift
│       │       ├── Assignments.xib
│       │       ├── AssignmentsListTVC.swift
│       │       ├── AssignmentsListTVC.xib
│       │       ├── CourseTVC.swift
│       │       ├── CourseTVC.xib
│       │       ├── LinkTVC.swift
│       │       ├── LinkTVC.xib
│       │       ├── ResourcesTVC.swift
│       │       └── ResourcesTVC.xib
│       ├── Login/
│       │   └── LoginVC/
│       │       ├── AuthNC.swift
│       │       ├── HostingLoginVC.swift
│       │       ├── HostingSignUpVC.swift
│       │       ├── LoginVC.swift
│       │       └── SignUpVC.swift
│       ├── Main/
│       │   ├── MainNC/
│       │   │   ├── AssignmentsNC.swift
│       │   │   ├── CalendarNC.swift
│       │   │   ├── CourseNC.swift
│       │   │   └── ProjectsNC.swift
│       │   ├── MainTabBarVC.swift
│       │   └── MainVC/
│       │       ├── Assignments/
│       │       │   ├── AssignmentsInfoVC.swift
│       │       │   └── AssignmentsVC.swift
│       │       ├── Calendar/
│       │       │   ├── CalendarVC.swift
│       │       │   └── EKWrapper.swift
│       │       ├── Course/
│       │       │   ├── CourseInfoVC.swift
│       │       │   ├── CourseVC.swift
│       │       │   └── Depraceted/
│       │       │       ├── AddCourseVC.swift
│       │       │       ├── AddResourcesVC.swift
│       │       │       ├── EditCourseVC.swift
│       │       │       ├── EditSemesterVC.swift
│       │       │       └── NewSemesterVC.swift
│       │       ├── Project/
│       │       │   └── ProjectsVC.swift
│       │       └── ViewController.swift
│       └── SwiftUIViews/
│           ├── AssignmentView/
│           │   ├── AssignmentView.swift
│           │   └── AssignmentViewModel.swift
│           ├── CourseView/
│           │   ├── CourseView.swift
│           │   └── CourseViewModel.swift
│           ├── ProjectsView/
│           │   ├── AddProjectView/
│           │   │   ├── AddProjectView.swift
│           │   │   └── AddProjectViewModel.swift
│           │   ├── ProjectView/
│           │   │   ├── ProjectView.swift
│           │   │   └── ProjectViewModel.swift
│           │   └── ShowProjectView/
│           │       ├── ProjectsView.swift
│           │       └── ProjectsViewModel.swift
│           ├── ResourceView/
│           │   ├── ResourceView.swift
│           │   └── ResourceViewModel.swift
│           ├── SemesterView/
│           │   ├── SemesterView.swift
│           │   └── SemesterViewModel.swift
│           ├── SignInView/
│           │   └── SignInView.swift
│           └── SingUpView/
│               └── SignUpView.swift
└── UX-Prototype.xcodeproj/
    ├── project.pbxproj
    ├── project.xcworkspace/
    │   ├── contents.xcworkspacedata
    │   ├── xcshareddata/
    │   │   ├── IDEWorkspaceChecks.plist
    │   │   └── swiftpm/
    │   │       ├── Package.resolved
    │   │       └── configuration/
    │   └── xcuserdata/
    │       └── danielattali.xcuserdatad/
    │           └── UserInterfaceState.xcuserstate
    └── xcuserdata/
        └── danielattali.xcuserdatad/
            ├── xcdebugger/
            │   └── Breakpoints_v2.xcbkptlist
            └── xcschemes/
                └── xcschememanagement.plist

55 directories, 119 files
```

