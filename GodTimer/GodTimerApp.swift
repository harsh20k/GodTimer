import SwiftUI

@main
struct TimeTrackerApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.frame(width: 240, height: 400)
				.background(WindowAccessor { window in
					if let window = window {
						window.title = "GodTimer"
						window.isOpaque = false
						window.backgroundColor = .clear
						window.standardWindowButton(.closeButton)?.isHidden = true
						window.standardWindowButton(.miniaturizeButton)?.isHidden = true
						window.standardWindowButton(.zoomButton)?.isHidden = true
						window.styleMask.remove(.titled)
						window.styleMask.insert(.fullSizeContentView)
						window.hasShadow = true
						window.level = .statusBar
					}
				})
		}
	}
}

struct WindowAccessor: NSViewRepresentable {
	var callback: (NSWindow?) -> Void

	func makeNSView(context: Context) -> NSView {
		return NSView()
	}

	func updateNSView(_ nsView: NSView, context: Context) {
		DispatchQueue.main.async {
			guard let window = nsView.window else { return }
			// Strip the default NSVisualEffectView background SwiftUI adds
			if let hostingView = window.contentView {
				hostingView.wantsLayer = true
				hostingView.layer?.backgroundColor = NSColor.clear.cgColor
				for sub in hostingView.subviews {
					if let vev = sub as? NSVisualEffectView {
						vev.isHidden = true
					}
				}
			}
			self.callback(window)
		}
	}
}

struct DraggableWindow: NSViewRepresentable {
	func makeNSView(context: Context) -> NSView {
		let view = NSView()
		DispatchQueue.main.async {
			if let window = view.window {
				window.isMovableByWindowBackground = true
				window.titleVisibility = .hidden
				window.titlebarAppearsTransparent = true
				window.styleMask.insert(.fullSizeContentView)
			}
		}
		return view
	}
	
	func updateNSView(_ nsView: NSView, context: Context) {}
}
