import SwiftUI

struct ContentView: View {
	@StateObject var timeTracker = TimeTracker()
	@State private var selectedCategory: String = "G"
	@State private var timeInterval: TimeInterval = 0
	@State private var isDropdownVisible: Bool = false
	@State private var timer: Timer?
	@State private var hoveredCategory: String?
	
	var body: some View {
		ZStack {
			Grid {
				GridRow{
					HStack{
						
					}
					.frame(width: 30)
					HStack {
						Spacer()
						Text("\(timeTracker.getTimeString(for: timeInterval))")
					}
					.font(.title.weight(.heavy).monospacedDigit())
					.padding()
					.frame(minWidth: 200)
					.background(Color.black.opacity(0.8))
					.cornerRadius(12)
					.onTapGesture {
						withAnimation {
							isDropdownVisible.toggle()
						}
					}
					.background(DraggableWindow())
					.onAppear(perform: startTimer)
					.contextMenu {
						Button(action: {
							withAnimation {
								selectedCategory = "G"
								timeInterval = timeTracker.meditationTime
							}
						}) { Text("Meditation") }
						Button(action: {
							withAnimation {
								selectedCategory = "O"
								timeInterval = timeTracker.officeTime
							}
						}) { Text("Office") }
						Button(action: {
							withAnimation {
								selectedCategory = "D"
								timeInterval = timeTracker.idleTime
							}
						}) { Text("Idle") }
					}
				}
			}
			
				//Circle with category name
			HStack {
				if selectedCategory == "G" {
					Text("\(selectedCategory)")
						.font(.title.bold())
						.frame(width: 65, height: 65)
						.background(Color.orange.gradient)
						.clipShape(Circle())
				} else if selectedCategory == "O" {
					Text("\(selectedCategory)")
						.font(.title.bold())
						.frame(width: 65, height: 65)
						.background(Color.blue.gradient)
						.clipShape(Circle())
				} else {
					Text("\(selectedCategory)")
						.font(.title.bold())
						.frame(width: 65, height: 65)
						.background(Color.red.gradient)
						.clipShape(Circle())
				}
				Spacer()
			}
		}
		if isDropdownVisible {
			DropdownList(
				isDropdownVisible: $isDropdownVisible,
				selectedCategory: $selectedCategory,
				timeTracker: timeTracker,
				hoveredCategory: $hoveredCategory,
				timeInterval: $timeInterval
			)
			.padding()
			.background(Color.mint.gradient.opacity(0.8))
			.cornerRadius(8)
			.frame(maxWidth: 105)
		}
	}
	
	func startTimer() {
		stopTimer() // Stop any existing timer before starting a new one
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			timeInterval += 1
			updateCategoryTime()
		}
	}
	
	func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	func updateCategoryTime() {
		switch selectedCategory {
		case "G":
			timeTracker.meditationTime = timeInterval
		case "O":
			timeTracker.officeTime = timeInterval
		case "D":
			timeTracker.idleTime = timeInterval
		default:
			break
		}
	}
}

#Preview {
	ContentView()
}
