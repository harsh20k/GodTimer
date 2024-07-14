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
	
	struct ChartData: Identifiable {
		let id = UUID()
		let category: String
		var value: Double
	}
	@State private var chartData: [ChartData] = [
		ChartData(category: "G", value: 0),
		ChartData(category: "O", value: 0),
		ChartData(category: "D", value: 0)
	]
	@State private var stateTimer: Timer?

	
	var body: some View {
		VStack {
			HStack {
					// Three rows for timer
				VStack {
					categoryRow(category: "G", time: timeTracker.getFixedSizeTimeString(for: timeTracker.meditationTime))
					categoryRow(category: "O", time: timeTracker.getFixedSizeTimeString(for: timeTracker.officeTime))
					categoryRow(category: "D", time: timeTracker.getFixedSizeTimeString(for: timeTracker.idleTime))
						.padding(.bottom, 8)
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
		.onAppear {
			startTimerForBarChart()
		}
	}
	
	private func invalidateTimers() {
		stateTimer?.invalidate()
		stateTimer = nil
	}
	private func startTimerForBarChart() {
		invalidateTimers()
			// Timer for state variables
		stateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			withAnimation(.easeInOut(duration:1)) {
				chartData[0].value = timeTracker.meditationTime
				chartData[1].value = timeTracker.officeTime
				chartData[2].value = timeTracker.idleTime
			}
		}
	}
	private func totalChartValue() -> Double {
		chartData.map { $0.value }.reduce(0, +)
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
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Capsule()
					.stroke()
				HStack(spacing: 0) {
					ForEach(chartData) { data in
						barView(for: data, totalTime: totalChartValue(), geometryWidth: geometry.size.width)
					}
				}
			}
		}
		.frame(height: 5) // Thinner bar chart
	}
	
	private func barView(for data: ChartData, totalTime: Double, geometryWidth: CGFloat) -> some View {
		let width = CGFloat(data.value) / CGFloat(totalTime) * geometryWidth
		return Capsule()
			.fill(color(for: data.category))
			.frame(width: width.isFinite && width > 0 ? width : 0)
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
	
	private func color(for category: String) -> Color {
		switch category {
		case "G":
			return .orange
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
