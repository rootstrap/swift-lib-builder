import Foundation

open class LibraryBuilder {

  static let libNamePlaceholder = "{{ libName }}"
  static let baseProjectName = "SourceProject"
  private(set) var projectName = "NewLibrary"
  
  static let githubUserPlaceholder = "{{ githubUser }}"
  static let defaultGithubUser = "rootstrap"
  private(set) var githubUser = LibraryBuilder.defaultGithubUser
  
  static let companyNamePlaceholder = "{{ companyName }}"
  static let baseCompany = "Rootstrap Inc."
  private(set) var companyName = LibraryBuilder.baseCompany
  
  static let bundleDomainPlaceholder = "{{ bundleDomain }}"
  static let baseDomain = "com.rootstrap"
  private(set) var bundleDomain = LibraryBuilder.baseDomain

  let whiteList: [String] = [
    ".DS_Store",
    "UserInterfaceState.xcuserstate",
    "build-library"
  ]
  let fileManager = FileManager.default
  var outputFolder: String?
  var currentFolder: String {
    fileManager.currentDirectoryPath
  }
  var outputPath: String {
    outputFolder ?? currentFolder
  }
  var finalOutputFolder: String {
    "\(outputPath)/\(projectName)"
  }
  var sourceFilesPath: String {
    "\(currentFolder)/\(LibraryBuilder.baseProjectName)/"
  }
  
  public init(outputFolder: String?) {
    self.outputFolder = outputFolder
  }

  enum SetupStep: Int {
    case nameEntry = 1
    case bundleDomainEntry
    case companyNameEntry
    case githubUserEntry
    
    var question: String {
      switch self {
      case .nameEntry:
        return "Enter a name for the project"
      case .bundleDomainEntry:
        return "Enter the reversed domain of your organization"
      case .companyNameEntry:
        return "Enter the Company name to use on file's headers"
      case .githubUserEntry:
        return "Enter the GitHub user that will host your repo"
      }
    }
  }

  //MARK: Helper methods
  
  func setup(step: SetupStep, defaultValue: String) -> String {
    let result = Shell.prompt(
      message: "\(step.rawValue). " + step.question + " (leave blank for \(defaultValue))."
    )
    guard let res = result else {
      print(defaultValue)
      return defaultValue
    }
    return res
  }
  
  public func validate() throws {
    if !fileManager.fileExists(atPath: sourceFilesPath) {
      throw BuilderError.sourceFilesMissing
    }
    if !fileManager.fileExists(atPath: outputPath) {
      throw BuilderError.invalidOutputFolder
    }
    if !fileManager.isWritableFile(atPath: outputPath) {
      throw BuilderError.cannotWrite
    }
  }

  public func initializeLibrary() throws {
    print("""
    +-----------------------------------------+
    |       < Setup New Swift Library >       |
    +-----------------------------------------+
    """)
     
    projectName = setup(step: .nameEntry, defaultValue: projectName)
    bundleDomain = setup(step: .bundleDomainEntry, defaultValue: LibraryBuilder.baseDomain)
    companyName = setup(step: .companyNameEntry, defaultValue: LibraryBuilder.baseCompany)
    githubUser = setup(step: .githubUserEntry, defaultValue: LibraryBuilder.defaultGithubUser)

    print("Copying source files...")
    try copySourceToOutputFolder()
    guard fileManager.changeCurrentDirectoryPath(finalOutputFolder) else {
      throw BuilderError.invalidOutputFolder
    }
    print("Processing files...")
    changeOrganizationNameIfNeeded()
    let directories = prepareLibraryFiles()
    renameLibraryFolders(directories)

    print("Opening new project...")
    Shell.execute(
      currentFolder: currentFolder,
      "open", "\(projectName).xcodeproj"
    )
    print("************** ALL SET! *******************")
  }
  
  private func prepareLibraryFiles() -> [URL] {
    guard
      let enumerator = fileManager.enumerator(
        at: URL(fileURLWithPath: currentFolder),
        includingPropertiesForKeys: [.nameKey, .isDirectoryKey]
      )
    else { return [] }
    var directories: [URL] = []
    
    while let itemURL = enumerator.nextObject() as? URL {
      guard !whiteList.contains(itemURL.fileName) else { continue }
      if itemURL.isDirectory {
        directories.append(itemURL)
      } else {
        do {
          try itemURL.processForNewLibrary(
            newLibraryName: projectName,
            newBundleDomain: bundleDomain,
            newGithubUser: githubUser,
            newCompanyName: companyName
          )
        } catch {
          print("Warning: We couldn't process the file \(itemURL.absoluteURL)")
        }
      }
    }
    
    return directories
  }
  
  private func renameLibraryFolders(_ directories: [URL]) {
    let topLevelFolder = URL(fileURLWithPath: currentFolder)
    var allDirectories = directories
    allDirectories.reverse()
    allDirectories.append(topLevelFolder)
    
    for dir in allDirectories {
      do {
        try dir.rename(from: LibraryBuilder.baseProjectName, to: projectName)
      } catch {
        print("Warning: We couldn't process the folder \(dir.absoluteString)")
      }
    }
  }
  
  private func changeOrganizationNameIfNeeded() {
    let baseName = LibraryBuilder.baseProjectName
    let pbxProjectPath = "\(currentFolder)/\(baseName)/\(baseName).xcodeproj/project.pbxproj"
    guard
      fileManager.fileExists(atPath: pbxProjectPath),
      companyName != LibraryBuilder.baseCompany
    else { return }

    print("\nUpdating company name to '\(companyName)'...")
    
    let filterKey = "ORGANIZATIONNAME"
    let organizationNameFilter = "\(filterKey) = \"\(LibraryBuilder.baseCompany)\""
    let organizationNameReplacement = "\(filterKey) = \"\(companyName)\""
    let fileUrl = URL(fileURLWithPath: pbxProjectPath)
    do {
      try fileUrl.replaceOccurrences(
        of: organizationNameFilter,
        with: organizationNameReplacement
      )
    } catch (let error) {
      print("Couldn't rename the organization: \(error)")
    }
  }
  
  private func copySourceToOutputFolder() throws {
    do {
      try fileManager.copyItem(atPath: sourceFilesPath, toPath: finalOutputFolder)
    } catch {
      throw BuilderError.copySourceFailed
    }
  }
}
