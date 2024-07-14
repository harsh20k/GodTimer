import SwiftUI
import Combine

class TimeTracker: ObservableObject {
	@Published var meditationTime: TimeInterval = 0
	@Published var officeTime: TimeInterval = 0
	@Published var idleTime: TimeInterval = 0
	
	func getCategoriesAbbreviated() -> [String] {
		return ["G", "O", "D"]
	}
	
	func getIntervals() -> [TimeInterval] {
		return [meditationTime,officeTime,idleTime]
	}
	
	func getTimeString(for interval: TimeInterval) -> String {
		let minutes = Int(interval) / 60
		let hours = Int(minutes) / 60
		let seconds = Int(interval) % 60
		if(minutes < 60){
			return String(format: "%02d:%02d", minutes, seconds)
		} else {
			return String(format: "%02d:%02d:%02d", hours, minutes%60, seconds)
		}
	}
	
	func getFixedSizeTimeString(for interval: TimeInterval) -> String {
		let minutes = Int(interval) / 60
		let hours = Int(minutes) / 60
		let seconds = Int(interval) % 60
		if(minutes < 60){
			return String(format: "%02d:%02d", minutes, seconds)
		} else {
			return String(format: "%02d:%02d", hours, minutes%60)
		}
	}
}
