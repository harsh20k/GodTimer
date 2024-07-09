import SwiftUI

struct ContentView: View {
	@StateObject var timeTracker = TimeTracker()
	@State private var selectedCategory: String = "G"
	@State private var timeInterval: TimeInterval = 0
	@State private var isDropdownVisible: Bool = false
	@State private var timer: Timer?
	@State private var hoveredCategory: String?
	
	var body: some View {
		ZStack{
				//Dropdownlist
			VStack{
				//empty vstack to push the dropdown down
				VStack{}.frame(height: 170)
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
					.frame(maxWidth: CGFloat(DropdownList.dropDownWidth+255), minHeight: 90)
					.transition(AnyTransition.opacity
						.combined(with: .move(edge: .top))
						.combined(with: .verticalScale)) // Custom transition
				}
			}
			ZStack {
				Grid {
					GridRow{
						HStack{//empty view just to push the timer to the right
						}.frame(width: 30)
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

		}
	}
	
	func startTimer() {
		stopTimer() // Stop any existing timer before starting a new one
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			timeInterval += 1
			withAnimation{
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

import SwiftUI

extension AnyTransition {
	static var verticalScale: AnyTransition {
		AnyTransition.modifier(
			active: ScaleEffectModifier(scale: 0.2, isHorizontal: false),
			identity: ScaleEffectModifier(scale: 1.0, isHorizontal: false)
		)
	}
	
	static var horizontalScale: AnyTransition {
		AnyTransition.modifier(
			active: ScaleEffectModifier(scale: 0.2, isHorizontal: true),
			identity: ScaleEffectModifier(scale: 1.0, isHorizontal: true)
		)
	}
	
	struct ScaleEffectModifier: ViewModifier {
		var scale: CGFloat
		var isHorizontal: Bool
		
		func body(content: Content) -> some View {
			if isHorizontal {
				content.scaleEffect(CGSize(width: scale, height: 1.0), anchor: .leading)
			} else {
				content.scaleEffect(CGSize(width: 1.0, height: scale), anchor: .top)
			}
		}
	}
}


#Preview {
	ContentView()
}
