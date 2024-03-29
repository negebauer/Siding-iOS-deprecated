//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(identifier: "com.negebauer.Siding") ?? Bundle.main
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 0 files.
  struct file {
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 0 images.
  struct image {
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 3 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `CourseCell`.
    static let courseCell: Rswift.ReuseIdentifier<Siding.CourseCell> = Rswift.ReuseIdentifier(identifier: "CourseCell")
    /// Reuse identifier `CourseDataCell`.
    static let courseDataCell: Rswift.ReuseIdentifier<Siding.CourseDataCell> = Rswift.ReuseIdentifier(identifier: "CourseDataCell")
    /// Reuse identifier `CourseFileCell`.
    static let courseFileCell: Rswift.ReuseIdentifier<Siding.CourseDataCell> = Rswift.ReuseIdentifier(identifier: "CourseFileCell")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 2 view controllers.
  struct segue {
    /// This struct is generated for `CourseViewController`, and contains static references to 1 segues.
    struct courseViewController {
      /// Segue identifier `showCourseFolder`.
      static let showCourseFolder: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, CourseViewController, CourseFolderViewController> = Rswift.StoryboardSegueIdentifier(identifier: "showCourseFolder")
      
      /// Optionally returns a typed version of segue `showCourseFolder`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showCourseFolder(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, CourseViewController, CourseFolderViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.courseViewController.showCourseFolder, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    /// This struct is generated for `SidingViewController`, and contains static references to 2 segues.
    struct sidingViewController {
      /// Segue identifier `ShowAppInfo`.
      static let showAppInfo: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, SidingViewController, InfoTableViewController> = Rswift.StoryboardSegueIdentifier(identifier: "ShowAppInfo")
      /// Segue identifier `showCourse`.
      static let showCourse: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, SidingViewController, CourseViewController> = Rswift.StoryboardSegueIdentifier(identifier: "showCourse")
      
      /// Optionally returns a typed version of segue `ShowAppInfo`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showAppInfo(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, SidingViewController, InfoTableViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.sidingViewController.showAppInfo, segue: segue)
      }
      
      /// Optionally returns a typed version of segue `showCourse`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showCourse(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, SidingViewController, CourseViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.sidingViewController.showCourse, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try main.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let courseFolderDetail = StoryboardViewControllerResource<CourseFolderViewController>(identifier: "courseFolderDetail")
      let name = "Main"
      
      func courseFolderDetail(_: Void = ()) -> CourseFolderViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: courseFolderDetail)
      }
      
      static func validate() throws {
        if _R.storyboard.main().courseFolderDetail() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'courseFolderDetail' could not be loaded from storyboard 'Main' as 'CourseFolderViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}