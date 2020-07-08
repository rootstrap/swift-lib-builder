//
//  BuilderError.swift
//  SwiftLibraryBuilder
//
//  Created by German on 7/8/20.
//  Copyright © 2020 Rootstrap. All rights reserved.
//

import Foundation

public enum BuilderError: LocalizedError {
  case invalidOutputFolder
  case cannotWrite
  case copySourceFailed
  case sourceFilesMissing
  
  public var errorDescription: String? {
    switch self {
    case .invalidOutputFolder:
      return "Output folder is invalid.".localized
    case .cannotWrite:
      return "Can't write to the destination folder.".localized
    case .copySourceFailed:
      return "Couldn't copy source files to the destination specified.".localized
    case .sourceFilesMissing:
      return "Couldn't locate source files."
    }
  }
}

extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
