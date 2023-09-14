# Sheet Stack
Sheet Stack makes it easy to present sheets from anywhere in your SwiftUI app.

## Provider
The first step is to create a provider type that conforms to `SheetPresentationProvider`. This type generates the contents of every sheet that you present. There are two relevant protocol requirements: the `SheetType` associated type and the `content(sheetType:)` method.

### Sheet Type
A `SheetType` instance identifies a particular type of sheet that your app can present. A great way to implement `SheetType` is to use an enumeration:
```swift
struct MySheetPresentationProvider: SheetPresenationProvider {
	enum SheetType: Hashable, Identifiable {
		case signIn
		case whatsNew
		case upsell(featureName: String)
		…
	}
	…
}
```

`SheetType` must conform to both `Hashable` and `Identifiable`. In many cases, the compiler can synthesize the `Hashable` conformance for you. The easiest way to conform to `Identifiable` is to use `self` as the `id`:
```swift
enum SheetType: Hashable, Identifiable {
	…
	var id: Self {
		get {
			return self
		}
	}
}
```

### Content
The `content(sheetType:)` method returns the content of a sheet given a sheet type. It’s a view builder, so you can use the standard SwiftUI result-builder syntax to build your views. If you’re using an enumeration to satisfy the `SheetType` requirement, then your `content(sheetType:)` implementation might look something like this:
```swift
struct MySheetPresentationProvider: SheetPresentationProvider {
	…
	func content(sheetType: SheetType) -> some View {
		switch sheetType {
		case .signIn:
			NavigationView {
				SignInView()
			}
		case .whatsNew:
			WhatsNewView()
		case .upsell(let featureName):
			UpsellView(featureName: featureName)
				.interactiveDismissDisabled()
		}
	}
}
```

## Sheet Stack
The next step is to create a sheet stack. `SheetStack` is generic over the sheet type, so it’s often helpful to declare a type alias to make it easier to spell:
```swift
typealias MySheetStack = SheetStack<MySheetPresentationProvider.SheetType>
```

In most cases, you’ll want to use a separate `SheetStack` instance per scene so that pushing a sheet in one scene doesn’t unexpectedly present it in a different scene. You can set your sheet stacks as environment objects like so:
```swift
struct MyApp: App {
	static let contentViewSheetStack = MySheetStack()
	static let settingsViewSheetStack = MySheetStack()
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(Self.contentViewSheetStack)
		}
		Settings {
			SettingsView()
				.environmentObject(Self.settingsViewSheetStack)
		}
	}
}
```
In this example, we use the same `SheetStack` specialization (_i.e._, `MySheetStack`) and therefore the same `SheetType` implementation in both scenes. Alternatively, you can use separate `SheetStack` specializations with different `SheetType` implementations if you prefer stronger encapsulation.

Sheet stacks are isolated to the main actor to prevent race conditions while adhering to SwiftUI’s requirement that all view updates occur on the main executor.

## Presentation
To present your sheets, you need to call the `push(_:)` method on your shared sheet stack. If you set your sheet stack as an environment object, then you can use it like so:
```swift
struct ContentView: View {
	@EnvironmentObject private var sheetStack: MySheetStack
	var body: some View {
		Button("Sign In") {
			self.sheetStack.push(.signIn)
		}
		…
	}
}
```

You also need to attach the `sheetPresentation(provider:sheetStack:)` view modifier to every root view that can present sheets:
```swift
struct ContentView: View {
	…
	var body: some View {
		Button("Sign In") { … }
			.sheetPresentation(
				provider: MySheetPresentationProvider(),
				sheetStack: self.sheetStack
			)
	}
}
```

You can present sheets from anywhere in your app, not just views, as long as the currently visible view’s root has a `sheetPresentation(provider:sheetStack:)` modifier.

To dismiss a sheet, call `pop()`:
```swift
…
self.sheetStack.pop()
…
```
