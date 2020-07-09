//
//  URLExtension.swift
//  
//
//  Created by German on 7/7/20.
//

import Foundation

extension URL {
  var fileName: String {
    let urlValues = try? resourceValues(forKeys: [.nameKey])
    return urlValues?.name ?? ""
  }
  
  var isDirectory: Bool {
    let urlValues = try? resourceValues(forKeys: [.isDirectoryKey])
    return urlValues?.isDirectory ?? false
  }
  
  func rename(
    from oldName: String,
    to newName: String,
    using fileManager: FileManager = .default
  ) throws {
    if fileName.contains(oldName) {
      let newName = fileName.replacingOccurrences(of: oldName, with: newName)
      try fileManager.moveItem(
        at: self,
        to: URL(fileURLWithPath: newName, relativeTo: deletingLastPathComponent())
      )
    }
  }
  
  func replaceOccurrences(of value: String, with newValue: String) throws {
    guard
      let fileContent = try? String(contentsOfFile: path, encoding: .utf8)
    else {
      print("Unable to read file at: \(absoluteString)")
      return
    }
    let updatedContent = fileContent.replacingOccurrences(of: value, with: newValue)
    try updatedContent.write(to: self, atomically: true, encoding: .utf8)
  }
  
  func processForNewLibrary(
    baseProjectName: String = LibraryBuilder.baseProjectName,
    newLibraryName: String,
    baseDomain: String = LibraryBuilder.baseDomain,
    newBundleDomain: String,
    newGithubUser: String = LibraryBuilder.defaultGithubUser,
    newCompanyName: String = LibraryBuilder.baseCompany
  ) throws {
    try replaceOccurrences(of: LibraryBuilder.libNamePlaceholder, with: newLibraryName)
    try replaceOccurrences(of: LibraryBuilder.githubUserPlaceholder, with: newGithubUser)
    try replaceOccurrences(of: LibraryBuilder.companyNamePlaceholder, with: newCompanyName)
    try replaceOccurrences(of: baseProjectName, with: newLibraryName)
    try replaceOccurrences(of: baseDomain, with: newBundleDomain)
    try replaceOccurrences(of: LibraryBuilder.bundleDomainPlaceholder, with: newBundleDomain)
    try rename(from: baseProjectName, to: newLibraryName)
  }
}
