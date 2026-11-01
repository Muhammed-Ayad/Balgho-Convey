bootstrap:
	flutter clean
	flutter pub get

pod:
	cd ios && pod install && cd ..

pod-update:
	cd ios && rm -rf Pods Podfile.lock .symlinks && pod install --repo-update && cd ..

pod-clean:
	cd ios && rm -rf Pods Podfile.lock .symlinks && cd ..

clean:
	flutter clean

