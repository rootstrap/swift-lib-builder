//
//  main.swift
//  build-library
//
//  Created by German on 7/7/20.
//  Copyright © 2020 Rootstrap. All rights reserved.
//

import Foundation
import SwiftLibraryBuilder

var outputFolder: String?
if CommandLine.argc > 1 {
  outputFolder = CommandLine.arguments[1]
}

let builder = LibraryBuilder(outputFolder: outputFolder)
do {
  try builder.validate()
  try builder.initialize()
  exit(EXIT_SUCCESS)
} catch let error {
  print("The program failed: \(error.localizedDescription)")
  exit(EXIT_FAILURE)
}
