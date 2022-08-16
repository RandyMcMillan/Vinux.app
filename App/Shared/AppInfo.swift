// DO NOT EDIT, // IT IS A MACHINE GENERATED FILE

// AppInfo.swift ue Aug 16 07:12:32 2022 +0100

import Foundation
class AppInfo {
let version: String
let build: String
let gitCommitSHA: String = "dace173"
init?() {
    guard let version =
Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return nil }
    self.version = version
    self.build = build }
}
