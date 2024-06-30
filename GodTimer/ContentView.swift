
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
			VStack() {
				HStack{

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
				Text("\(selectedCategory)")
					.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
					.frame(width:60, height: 60)
					.background(Color.mint.gradient)
				.clipShape(Circle())
				Spacer()
			}
		}
		if isDropdownVisible {
			VStack {
				HStack{
					Text("G:")
					Spacer()
					Text("\(timeTracker.getTimeString(for: timeTracker.meditationTime))")
						.font(.title2.weight(.medium).monospacedDigit())
						.shadow(radius: 5)
						.foregroundColor(hoveredCategory == "G" ? Color.orange : Color.white)
						.onTapGesture {
							selectedCategory = "G"
							timeInterval = timeTracker.meditationTime
						}
						.onHover { hovering in
							hoveredCategory = hovering ? "G" : nil
						}
				}
				HStack{
					Text("O:")
					Spacer()
					Text("\(timeTracker.getTimeString(for: timeTracker.officeTime))")
						.font(.title2.weight(.medium).monospacedDigit())
						.shadow(radius: 5)
						.foregroundColor(hoveredCategory == "O" ? Color.orange : Color.white)
						.onTapGesture {
							selectedCategory = "O"
							timeInterval = timeTracker.officeTime
						}
						.onHover { hovering in
							hoveredCategory = hovering ? "O" : nil
						}
				}
				HStack{
					Text("D:")
					Spacer()
					Text("\(timeTracker.getTimeString(for: timeTracker.idleTime))")
						.font(.title2.weight(.medium).monospacedDigit())
						.shadow(radius: 5)
						.foregroundColor(hoveredCategory == "D" ? Color.orange : Color.white)
						.onTapGesture {
							selectedCategory = "D"
							timeInterval = timeTracker.idleTime
						}
						.onHover { hovering in
							hoveredCategory = hovering ? "D" : nil
						}
					
				}
			}
			.onTapGesture {
				withAnimation {
					isDropdownVisible.toggle()
				}
			}
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
