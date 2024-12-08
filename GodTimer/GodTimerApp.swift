import SwiftUI

@main
struct TimeTrackerApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.frame(width: 200, height: 160)
				.background(WindowAccessor { window in
					if let window = window {
						window.title = "Circular Window"
						window.isOpaque = true
						window.backgroundColor = .clear
						window.standardWindowButton(.closeButton)?.isHidden = true
						window.standardWindowButton(.miniaturizeButton)?.isHidden = true
						window.standardWindowButton(.zoomButton)?.isHidden = true
						window.styleMask.remove(.titled)
						window.styleMask.insert(.fullSizeContentView)
						window.hasShadow = false 
						window.level = .statusBar // This line keeps the window always on top
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
			self.callback(nsView.window)
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
