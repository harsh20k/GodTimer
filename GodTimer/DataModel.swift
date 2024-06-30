import SwiftUI
import Combine

class TimeTracker: ObservableObject {
	@Published var meditationTime: TimeInterval = 0
	@Published var officeTime: TimeInterval = 0
	@Published var idleTime: TimeInterval = 0
	
	func getTimeString(for interval: TimeInterval) -> String {
		let minutes = Int(interval) / 60
		let seconds = Int(interval) % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
}
