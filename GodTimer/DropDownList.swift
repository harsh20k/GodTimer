import SwiftUI

struct DropdownList: View {
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
						let frame = proxy.frame(in: .global)
						print("""
							frame.minx \(frame.minX)
							frame.miny \(frame.minY)
							frame.width \(frame.width)
							frame.height \(frame.height)
						""")
					}
			}
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(selectedCategory == category ? Color.gray.opacity(0.5) : Color.clear)
					.animation(.snappy, value: selectedCategory)
			)
		}
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
