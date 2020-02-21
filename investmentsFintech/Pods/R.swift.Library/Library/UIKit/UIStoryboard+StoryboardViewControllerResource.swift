//
//  UIViewController+StoryboardViewControllerResource.swift
//  R.swift.Library
//
//  Created by Mathijs Kadijk on 13-03-16.
//  From: https://github.com/mac-cain13/R.swift.Library
//  License: MIT License
//

import Foundation
import UIKit

public extension UIStoryboard {
  /**
   Instantiates and returns the view controller with the specified resource (R.storyboard.*.*).

   - returns: The view controller corresponding to the specified resource (R.storyboard.*.*). If no view controller is associated, this method throws an exception.
   */
  func instantiateViewController<ViewControllerResource: StoryboardViewControllerResourceType>(withResource resource: ViewControllerResource) -> ViewControllerResource.ViewControllerType? {
    return self.instantiateViewController(withIdentifier: resource.identifier) as? ViewControllerResource.ViewControllerType
  }
}
