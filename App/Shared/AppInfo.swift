// DO NOT EDIT, // IT IS A MACHINE GENERATED FILE

// AppInfo.swift ri Aug 12 01:18:03 2022 -0400

import Foundation
class AppInfo {
let version: String
let build: String
let gitCommitSHA: String = "2edcd13"
init?() {
    guard let version =
Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return nil }
    self.version = version
    self.build = build }
}
