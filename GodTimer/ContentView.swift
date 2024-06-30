
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
				categoryRow(category: "G", time: timeTracker.getTimeString(for: timeTracker.meditationTime))
				categoryRow(category: "O", time: timeTracker.getTimeString(for: timeTracker.officeTime))
				categoryRow(category: "D", time: timeTracker.getTimeString(for: timeTracker.idleTime))
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
	
	
	@ViewBuilder
	private func categoryRow(category: String, time: String) -> some View {
		GeometryReader{ proxy in
			HStack {
				Text("\(category):")
				Spacer()
				Text(time)
					.font(.title2.weight(.medium).monospacedDigit())
					.shadow(radius: 5)
					.foregroundColor(hoveredCategory == category ? Color.orange : Color.white)
					.onTapGesture {
						withAnimation {
							selectedCategory = category
							switch category {
							case "G":
								timeInterval = timeTracker.meditationTime
							case "O":
								timeInterval = timeTracker.officeTime
							case "D":
								timeInterval = timeTracker.idleTime
							default:
								break
							}
						}
					}
					.onHover { hovering in
						hoveredCategory = hovering ? category : nil
						
					}
			}
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(selectedCategory == category ? Color.gray.opacity(0.5) : Color.clear)
					.animation(.snappy, value: selectedCategory)
			)
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
