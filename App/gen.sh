#/bin/sh

version=$(git rev-parse --verify HEAD | cut -c 1-7)

fileContent="// DO NOT EDIT, // IT IS A MACHINE GENERATED FILE

// AppInfo.swift

import Foundation
class AppInfo {
let version: String
let build: String
let gitCommitSHA: String = \"$version\"
init?() {
	guard let version =
Bundle.main.infoDictionary?[\"CFBundleShortVersionString\"] as? String, let build = Bundle.main.infoDictionary?[\"CFBundleVersion\"] as? String else { return nil }
	self.version = version
	self.build = build }
}"

echo "$fileContent" > /Users/Shared/Vinux.app/App/Shared/AppInfo.swift
