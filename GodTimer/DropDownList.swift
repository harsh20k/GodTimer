import SwiftUI
import Charts

struct ChartData: Identifiable {
	let id = UUID()
	let category: String
	var value: Double
}


struct DropdownList: View {
	@Namespace private var animationSpace
	@Binding var isDropdownVisible: Bool
	@Binding var selectedCategory: String
	@ObservedObject var timeTracker: TimeTracker
	@Binding var hoveredCategory: String?
	@Binding var timeInterval: TimeInterval
	
	static private var highlightColor = Color.teal
	static private var transitionDuration = 0.3
	static public var dropDownWidth = 80
	
	@State private var isRightArrowHovered = false
	@State private var isDropDownDetailsVisible = false
	@State private var hoveredData: ChartData?
	
	private var chartData: [ChartData] {
		[
			ChartData(category: "G", value: timeTracker.meditationTime),
			ChartData(category: "O", value: timeTracker.officeTime),
			ChartData(category: "D", value: timeTracker.idleTime)
		]
	}
	
	var body: some View {
		VStack {
			HStack {
					// Three rows for timers
				VStack {
					categoryRow(category: "G", time: timeTracker.getFixedSizeTimeString(for: timeTracker.meditationTime))
					categoryRow(category: "O", time: timeTracker.getFixedSizeTimeString(for: timeTracker.officeTime))
					categoryRow(category: "D", time: timeTracker.getFixedSizeTimeString(for: timeTracker.idleTime))
					barChartView
				}
				.onTapGesture {
					withAnimation {
						isDropdownVisible.toggle()
					}
				}
				.frame(width: CGFloat(DropdownList.dropDownWidth))
				
					// Empty HStack to push the right arrow to the right
				HStack { }
					.frame(width: 1)
				
				ZStack {
					if isRightArrowHovered {
						Capsule()
							.fill(Color.black.opacity(0.4))
							.overlay(
								Capsule()
									.stroke(Color.white.opacity(0.7), lineWidth: 1)
							)
					} else {
						Capsule()
							.fill(Color.black.opacity(0.1))
							.overlay(
								Capsule()
									.stroke(Color.white.opacity(0.2), lineWidth: 1)
							)
					}
					Image(systemName: "arrowshape.right.fill")
						.foregroundStyle(isRightArrowHovered ? DropdownList.highlightColor : Color.white)
						.frame(width: 5)
				}
				.onHover { hovering in
					isRightArrowHovered = hovering
				}
				.frame(width: 20, height: 65)
				.onTapGesture {
					withAnimation {
						isDropDownDetailsVisible.toggle()
					}
				}
				
				if isDropDownDetailsVisible {
					VStack {
						barChartView
					}
				}
			}
		}
	}
	
	@ViewBuilder
	private func categoryRow(category: String, time: String) -> some View {
		GeometryReader { proxy in
			HStack {
				Text("\(category):")
					.font(selectedCategory == category ? .body.weight(.bold) : .body)
				Spacer()
				Text(time)
					.font(.title2.weight(.medium).monospacedDigit())
					.shadow(radius: 5)
					.foregroundColor(hoveredCategory == category ? DropdownList.highlightColor : Color.white)
					.onTapGesture {
						withAnimation(.easeInOut(duration: DropdownList.transitionDuration)) {
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
						withAnimation {
							hoveredCategory = hovering ? category : nil
						}
					}
			}
			.background(
				ZStack {
					if selectedCategory == category {
						Capsule()
							.fill(Color.black.opacity(0.9))
							.overlay(
								Capsule()
									.stroke(Color.white.opacity(0.5), lineWidth: 1)
							)
							.matchedGeometryEffect(id: "rectangle", in: animationSpace)
					}
				}
					.frame(width: 95, height: 30)
			)
		}
		.frame(height: 15)
	}
	
	private var barChartView: some View {
		VStack(spacing: 0) {
			ZStack(alignment: .leading) {
				GeometryReader { geometry in
					let totalTime = chartData.map { $0.value }.reduce(0, +)
					HStack(spacing: 0) {
						ForEach(chartData) { data in
							Rectangle()
								.fill(color(for: data.category))
								.frame(width: CGFloat(data.value) / CGFloat(totalTime) * geometry.size.width)
								.onHover { hovering in
									hoveredData = hovering ? data : nil
								}
								.overlay(
									GeometryReader { overlayGeometry in
										if let hoveredData = hoveredData, hoveredData.id == data.id {
											TooltipView(text: "\(Int(data.value / totalTime * 100))%")
												.position(x: overlayGeometry.size.width / 2, y: -20)
										}
									}
								)
						}
					}
				}
			}
			.frame(height: 5)
		} // Thinner bar chart
	}
	
	private func color(for category: String) -> Color {
		switch category {
		case "G":
			return .green
		case "O":
			return .blue
		case "D":
			return .red
		default:
			return .gray
		}
	}
}

struct TooltipView: View {
	var text: String
	
	var body: some View {
		Text(text)
			.font(.caption)
			.padding(5)
			.background(Color.black.opacity(0.7))
			.foregroundColor(.white)
			.cornerRadius(5)
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
