//
//  Shell.swift
//  
//
//  Created by German on 7/7/20.
//

import Foundation

public typealias ShellExecutionOutput = (output: String, exitCode: Int32)

open class Shell {
  
  @discardableResult
  public class func execute(
    currentFolder: String,
    _ args: String...
  ) -> ShellExecutionOutput {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.currentDirectoryPath = currentFolder
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    return ShellExecutionOutput(output, task.terminationStatus)
  }
  
  public class func prompt(message: String) -> String? {
    print("\n" + message)
    let answer = readLine()
    return answer == nil || answer == "" ? nil : answer!
  }
}
