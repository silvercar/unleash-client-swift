# Unleash client for Swift
[![codecov](https://codecov.io/gh/silvercar/unleash-client-swift/branch/master/graph/badge.svg)](https://codecov.io/gh/silvercar/unleash-client-swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This is the unofficial Swift client for Unleash. Read more about the [Unleash project](https://github.com/Unleash/unleash)
**Version 3.x of the client requires `unleash-server` >= v3.x**

## Installation
### Using [Carthage](https://github.com/Carthage/Carthage)
Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh) using the following command:
```
$ brew update
$ brew install carthage
```

To add the Unleash Swift Client into your Xcode project using Carthage, add the following to your `Cartfile`:
```
github "silvercar/unleash-client-swift" ~> 1.0 
```

Run `carthage update --platform ios` to build the framework and drag the built `Unleash.framework` into your Xcode project.

## Development
### Requirements:
* [Carthage](https://github.com/Carthage/Carthage)
* [Codecov](https://docs.codecov.io/docs/quick-start)
* [Swiftlint](https://github.com/realm/SwiftLint)

### Carthage
This project uses carthage for dependency management. See the [Carthage Project](https://github.com/Carthage/Carthage) for more info. 

#### Pre-requisite:
Your github account needs to be configured for SSH access from your development machine.

#### Quickstart:
If you have [Homebrew](https://brew.sh) installed on your Mac, you can install Carthage and get started contributing to the library by running the following commands in your terminal shell.
```
brew install carthage
carthage bootstrap --platform ios --no-use-binaries
```

### Codecov
#### TODO

### Swiftlint
#### TODO