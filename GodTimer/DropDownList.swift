import SwiftUI

struct DropdownList: View {
	@Namespace private var animationSpace
	@Binding var isDropdownVisible: Bool
	@Binding var selectedCategory: String
	@ObservedObject var timeTracker: TimeTracker
	@Binding var hoveredCategory: String?
	@Binding var timeInterval: TimeInterval
	
	var body: some View {
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
	}
	
	@ViewBuilder
	private func categoryRow(category: String, time: String) -> some View {
		GeometryReader { proxy in
			HStack {
				Text("\(category):")
				Spacer()
				Text(time)
					.font(.title2.weight(.medium).monospacedDigit())
					.shadow(radius: 5)
					.foregroundColor(hoveredCategory == category ? Color.orange : Color.white)
					.onTapGesture {
						withAnimation(.snappy()) {
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
				ZStack {
					if selectedCategory == category {
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.black.opacity(0.5))
							.matchedGeometryEffect(id: "rectangle", in: animationSpace)
					}
				}
			)
		}
		.frame(height: 15)
	}
}

#Preview {
	DropdownList(
		isDropdownVisible: .constant(true),
		selectedCategory: .constant("G"),
		timeTracker: TimeTracker(),
		hoveredCategory: .constant(nil),
		timeInterval: .constant(0)
	)
}
