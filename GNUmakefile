-: init
	@echo "TODO"
init: submodules
submodule: submodules
submodules:
	git submodule update --init

shared-components:
	# install -v damus/damus/Components/* App/Shared/Components
	install -v damus/damus/Components/* nostr.swift/Sources/nostr.swift/Components
shared-models:
	# install -v damus/damus/Models/* App/Shared/Models
	install -v damus/damus/Models/* nostr.swift/Sources/nostr.swift/Models
shared-nostr:
	# install -v damus/damus/Nostr/* App/Shared/Nostr
	install -v damus/damus/Nostr/* nostr.swift/Sources/nostr.swift/Nostr
shared-screens:
	# install -v damus/damus/Screens/* App/Shared/Screens
	# install -v damus/damus/Screens/* nostr.swift/Sources/nostr.swift/Screens
shared-support:
	# install -v damus/damus/Support/* App/Shared/Support
	# install -v damus/damus/Support/* nostr.swift/Sources/nostr.swift/Support
shared-utils:
	# install -v damus/damus/Util/* App/Shared/Util
	install -v damus/damus/Util/* nostr.swift/Sources/nostr.swift/Util
shared-views:
	# install -v damus/damus/Views/* App/Shared/Views
	install -v damus/damus/Views/* nostr.swift/Sources/nostr.swift/Views
shared-contentview:
	# install -v damus/damus/ContentView.swift App/Shared/Views/ContentView.swift
	install -v damus/damus/ContentView.swift nostr.swift/Sources/nostr.swift/ContentView.swift
	
update-package: shared-components shared-models shared-nostr shared-screens shared-support shared-utils shared-views shared-contentview

