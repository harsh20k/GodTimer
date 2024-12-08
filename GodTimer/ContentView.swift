import SwiftUI

struct ContentView: View {
	@State var timeTracker = TimeTracker()
	@State private var selectedCategory: String = "G"
	@State private var timeInterval: TimeInterval = 0
	@State private var isDropdownVisible: Bool = false
	@State private var timer: Timer?
	@State private var hoveredCategory: String?
	
	var body: some View {
		ZStack {
				// DropdownList
			PushCardView(isVisible: isDropdownVisible, alignment: .vertical, placement: .bottom) {
				DropdownList(
					isDropdownVisible: $isDropdownVisible,
					selectedCategory: $selectedCategory,
					timeTracker: timeTracker,
					hoveredCategory: $hoveredCategory,
					timeInterval: $timeInterval
				)
			}
			
//			PushCardView(isVisible: isDropdownVisible, alignment: .horizontal, placement: .right) {
//				DropdownList(
//					isDropdownVisible: $isDropdownVisible,
//					selectedCategory: $selectedCategory,
//					timeTracker: timeTracker,
//					hoveredCategory: $hoveredCategory,
//					timeInterval: $timeInterval
//				)
//			}
			
//			PushCardView(isVisible: isDropdownVisible, alignment: .vertical, placement: .top) {
//				List(0..<3){ i in
//					Text ("item number \(i)")
//				}
//			}
//			PushCardView(isVisible: isDropdownVisible, alignment: .vertical, placement: .bottom) {
//			}
			
			ZStack {
				Grid {
					GridRow {
						HStack {
							Text("\(timeTracker.getTimeString(for: timeInterval))")
								.font(.title.weight(.heavy).monospacedDigit())
								.padding()
								.frame(minWidth: 200)
								.background(Color.black.opacity(0.8))
								.cornerRadius(12)
								.onTapGesture {
									withAnimation(.easeInOut(duration: 0.2)) {
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
				}
				
					// Circle with category name
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
					HStack{}.frame(width: 200)
				}
			}
			.background(
				GeometryReader { geometry in
					Color.clear
						.onAppear {
							print("zstack size: \(geometry.size)")
						}
				}
			)
		}
	}
	
	func startTimer() {
		stopTimer() // Stop any existing timer before starting a new one
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			timeInterval += 1
			withAnimation(.easeInOut){
				updateCategoryTime()
			}
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
