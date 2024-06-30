
import SwiftUI

struct ContentView: View {
	@StateObject var timeTracker = TimeTracker()
	@State private var selectedCategory: String = "G"
	@State private var timeInterval: TimeInterval = 0
	@State private var isDropdownVisible: Bool = false
	@State private var timer: Timer?

	var body: some View {
		ZStack {
			VStack() {
				HStack{

					Spacer()
					Text("\(timeTracker.getTimeString(for: timeInterval))")
				}
				.padding()
				.frame(minWidth: 100)
				.background(Color.black.opacity(0.8))
				.cornerRadius(8)
				.onTapGesture {
					withAnimation {
						isDropdownVisible.toggle()
					}
				}
			}
			.background(DraggableWindow())
			.onAppear(perform: startTimer)
			.contextMenu {
				Button(action: { 
					selectedCategory = "G"
					timeInterval = timeTracker.meditationTime
				}) { Text("Meditation") }
					Button(action: {
					selectedCategory = "O"
					timeInterval = timeTracker.officeTime
				 }) { Text("Office") }
					Button(action: {
					selectedCategory = "D"
					timeInterval = timeTracker.idleTime
				 }) { Text("Idle") }
		}
			HStack {
				Text("\(selectedCategory):")
					.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
					.frame(width:50, height: 50)
					.background(Color.mint.gradient)
				.clipShape(Circle())
				Spacer()
			}
		}
		if isDropdownVisible {
			VStack {
				Text("G: \(timeTracker.getTimeString(for: timeTracker.meditationTime))")
				Text("O: \(timeTracker.getTimeString(for: timeTracker.officeTime))")
				Text("D: \(timeTracker.getTimeString(for: timeTracker.idleTime))")
			}
			.onTapGesture {
				withAnimation {
					isDropdownVisible.toggle()
				}
			}
			.padding()
			.background(Color.gray.opacity(0.8))
			.cornerRadius(8)
		}
	}
	
	func startTimer() {
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			timeInterval += 1
			updateCategoryTime()
		}
	}
	
	func updateCategoryTime() {
		switch selectedCategory {
		case "G":
			timeTracker.meditationTime += 1
		case "O":
			timeTracker.officeTime += 1
		case "D":
			timeTracker.idleTime += 1
		default:
			break
		}
	}
}

#Preview {
    ContentView()
}
