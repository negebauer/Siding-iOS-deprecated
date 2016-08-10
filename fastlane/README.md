fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
## iOS
### ios testnotification
```
fastlane ios testnotification
```
Show a test notification
### ios snap
```
fastlane ios snap
```
Take some snapshots

Upload them with deliver
### ios metadata
```
fastlane ios metadata
```
Upload metadata
### ios store_review
```
fastlane ios store_review
```
Updates metada and app icon

Submits for review
### ios test
```
fastlane ios test
```
Runs all the tests
### ios alpha
```
fastlane ios alpha
```
 * Call from dev branch

Submit a new Alpha Build to Apple TestFlight

Adds a alpha badge

Adds a version-build shield
### ios beta
```
fastlane ios beta
```
 * Call from dev branch

Submit a new Beta Build to Apple TestFlight

Adds a beta dark badge

Adds a version-build shield
### ios testflight
```
fastlane ios testflight
```
 * Call from dev branch

Just upload to testflight

May send to testers
### ios store
```
fastlane ios store
```
 * Call from master branch

Deploy a new version to the App Store

 - Bump build

 - Bump version

 - Build

 - Deliver with review

----

This README.md is auto-generated and will be re-generated every time to run [fastlane](https://fastlane.tools).
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).