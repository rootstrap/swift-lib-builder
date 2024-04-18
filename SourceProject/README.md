
# {{ libName }}

[![CI Status](https://img.shields.io/travis/{{ githubUser }}/{{ libName }}.svg?style=flat)](https://travis-ci.org/{{ githubUser }}/{{ libName }})
[![Version](https://img.shields.io/cocoapods/v/{{ libName }}.svg?style=flat)](https://cocoapods.org/pods/{{ libName }})
[![License](https://img.shields.io/cocoapods/l/{{ libName }}.svg?style=flat)](https://cocoapods.org/pods/{{ libName }})
[![Platform](https://img.shields.io/cocoapods/p/{{ libName }}.svg?style=flat)](https://cocoapods.org/pods/{{ libName }})
[![Carthage](https://img.shields.io/badge/Carthage-compatible-success)](#installation)
[![SPM](https://img.shields.io/badge/SPM-compatible-success)](#installation)
[![Swift Version](https://img.shields.io/badge/Swift%20Version-5.7-orange)](https://cocoapods.org/pods/{{ libName }})

## What is it?

## Installation

#### 1. Cocoapods

```ruby

pod '{{ libName }}', '~> 1.0.0'

```

#### 2. Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.
Add the following line to your `Cartfile` and follow the [installation instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

```
github "{{ githubUser }}/{{ libName }}" ~> 1.0.0
```

#### 3. Swift Package Manager

- In XCode 11+, go to File -> Swift Packages -> Add Package Dependency.
- Enter the repo URL (https://github.com/{{ githubUser }}/{{ libName }}) and click Next.
- Select the version rule desired (you can specify a version number, branch or commit) and click Next.
- Finally, select the target where you want to use the framework.

That should be it. **{{ libName }}** should appear in the navigation panel as a dependency and the framework will be linked automatically to your target.


**Note:** It is always recommended to lock your external libraries to a specific version.

## Usage

Description on how to use your library.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## License

**{{ libName }}** is available under the MIT license. See the LICENSE file for more info.
