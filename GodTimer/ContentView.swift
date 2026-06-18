import SwiftUI

struct ContentView: View {
	@State var timeTracker = TimeTracker()
	@State private var selectedCategory: String = "G"
	@State private var timeInterval: TimeInterval = 0
	@State private var isDropdownVisible: Bool = false
	@State private var timer: Timer?
	@State private var hoveredCategory: String?
	@Namespace private var glassNamespace

	var body: some View {
		ZStack {
			Color.clear
			PushCardView(isVisible: isDropdownVisible, alignment: .vertical, placement: .bottom, glassNamespace: glassNamespace) {
				DropdownList(
					isDropdownVisible: $isDropdownVisible,
					selectedCategory: $selectedCategory,
					timeTracker: timeTracker,
					hoveredCategory: $hoveredCategory,
					timeInterval: $timeInterval
				)
			}

			GlassEffectContainer(spacing: 16) {
				ZStack {
					// Timer pill
					Text(timeTracker.getTimeString(for: timeInterval))
						.font(.system(size: 28, weight: .heavy, design: .monospaced))
						.foregroundStyle(.primary)
						.padding(.horizontal, 20)
						.padding(.vertical, 12)
						.glassEffect(.regular.interactive(), in: Capsule())
						.glassEffectID("timer", in: glassNamespace)
						.onTapGesture {
							withAnimation(.spring(duration: 0.4, bounce: 0.25)) {
								isDropdownVisible.toggle()
							}
						}
						.onAppear(perform: startTimer)
						.background(DraggableWindow())
						.contextMenu {
							Button("Meditation") {
								withAnimation(.spring(duration: 0.4, bounce: 0.25)) {
									selectedCategory = "G"
									timeInterval = timeTracker.meditationTime
								}
							}
							Button("Office") {
								withAnimation(.spring(duration: 0.4, bounce: 0.25)) {
									selectedCategory = "O"
									timeInterval = timeTracker.officeTime
								}
							}
							Button("Idle") {
								withAnimation(.spring(duration: 0.4, bounce: 0.25)) {
									selectedCategory = "D"
									timeInterval = timeTracker.idleTime
								}
							}
						}

					// Category badge
					HStack {
						Text(selectedCategory)
							.font(.title.bold())
							.foregroundStyle(.white)
							.frame(width: 56, height: 56)
							.glassEffect(.regular.tint(categoryColor(for: selectedCategory)), in: Circle())
							.glassEffectID("badge", in: glassNamespace)
						Spacer().frame(width: 200)
					}
				}
			}
		}
	}

	private func categoryColor(for category: String) -> Color {
		switch category {
		case "G": return .orange
		case "O": return Color(hue: 0.72, saturation: 0.8, brightness: 1.0)
		default:  return Color(hue: 0.95, saturation: 0.85, brightness: 1.0)
		}
	}

	func startTimer() {
		stopTimer()
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			timeInterval += 1
			withAnimation(.easeInOut) {
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
		case "G": timeTracker.meditationTime = timeInterval
		case "O": timeTracker.officeTime = timeInterval
		case "D": timeTracker.idleTime = timeInterval
		default: break
		}
	}
}

#Preview {
	ContentView()
}
