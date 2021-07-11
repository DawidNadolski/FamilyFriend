// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Assets {
	internal enum Colors {
		internal static let accentColor = ColorAsset(name: "AccentColor")
		internal static let action = ColorAsset(name: "Action")
		internal static let backgroundCool = ColorAsset(name: "BackgroundCool")
		internal static let backgroundInteractive = ColorAsset(name: "BackgroundInteractive")
		internal static let backgroundWarm = ColorAsset(name: "BackgroundWarm")
		internal static let buttermilk = ColorAsset(name: "Buttermilk")
		internal static let community = ColorAsset(name: "Community")
		internal static let floofy = ColorAsset(name: "Floofy")
		internal static let goldenrod = ColorAsset(name: "Goldenrod")
		internal static let iron = ColorAsset(name: "Iron")
		internal static let mercury = ColorAsset(name: "Mercury")
		internal static let metabolism = ColorAsset(name: "Metabolism")
		internal static let mossGreen = ColorAsset(name: "MossGreen")
		internal static let movement = ColorAsset(name: "Movement")
		internal static let puertoRico = ColorAsset(name: "PuertoRico")
		internal static let splash = ColorAsset(name: "Splash")
		internal static let streakBackgroundColor = ColorAsset(name: "StreakBackgroundColor")
		internal static let stress = ColorAsset(name: "Stress")
		internal static let textPrimary = ColorAsset(name: "TextPrimary")
		internal static let textSecondary = ColorAsset(name: "TextSecondary")
		internal static let textTertiary = ColorAsset(name: "TextTertiary")
		internal static let warning = ColorAsset(name: "Warning")
		internal static let whiteLilac = ColorAsset(name: "WhiteLilac")
	}
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
