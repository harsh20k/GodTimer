import SwiftUI
import Charts

struct DropdownList: View {
	@Namespace private var animationSpace
	@Binding var isDropdownVisible: Bool
	@Binding var selectedCategory: String
	@ObservedObject var timeTracker: TimeTracker
	@Binding var hoveredCategory: String?
	@Binding var timeInterval: TimeInterval

	static private var highlightColor = Color.white.opacity(0.9)
	static private var transitionDuration = 0.35
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
		VStack(spacing: 0) {
			HStack(alignment: .center, spacing: 8) {
			// Category rows + bar chart
			VStack(spacing: 6) {
				categoryRow(category: "G", time: timeTracker.getFixedSizeTimeString(for: timeTracker.meditationTime))
				categoryRow(category: "O", time: timeTracker.getFixedSizeTimeString(for: timeTracker.officeTime))
				categoryRow(category: "D", time: timeTracker.getFixedSizeTimeString(for: timeTracker.idleTime))
				Spacer().frame(height: 10)
				barChartView
			}
				.onTapGesture {
					withAnimation(.spring(duration: 0.4, bounce: 0.25)) {
						isDropdownVisible.toggle()
					}
				}
				.frame(width: CGFloat(DropdownList.dropDownWidth))

				HStack {}.frame(width: 1)

			// Right-arrow details button
			ZStack {
				Capsule()
					.fill(.clear)
					.glassEffect(
						isRightArrowHovered ? .regular.tint(.white) : .regular,
						in: Capsule()
					)
				Image(systemName: "arrowshape.right.fill")
					.foregroundStyle(isRightArrowHovered ? DropdownList.highlightColor : Color.white.opacity(0.6))
			}
			.frame(width: 20, height: 65)
			.contentShape(Rectangle())
			.onHover { hoveredIn in
				withAnimation(.spring(duration: 0.3, bounce: 0.2)) {
					isRightArrowHovered = hoveredIn
				}
			}
			.onTapGesture {
				withAnimation(.spring(duration: 0.4, bounce: 0.25)) {
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
		stateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			withAnimation(.easeInOut(duration: 1)) {
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
		HStack {
			Text("\(category):")
				.font(selectedCategory == category ? .body.weight(.bold) : .body)
				.foregroundStyle(.white)
			Spacer()
			Text(time)
				.font(.title2.weight(.medium).monospacedDigit())
				.foregroundStyle(hoveredCategory == category ? DropdownList.highlightColor : Color.white.opacity(0.85))
				.shadow(radius: 3)
		}
		.frame(height: 28)
		.padding(.horizontal, 6)
		.background(
			ZStack {
				if selectedCategory == category {
					Capsule()
						.fill(.clear)
						.glassEffect(.regular.tint(color(for: category)), in: Capsule())
						.matchedGeometryEffect(id: "selection", in: animationSpace)
				}
			}
		)
		.contentShape(Rectangle())
		.onTapGesture {
			withAnimation(.spring(duration: DropdownList.transitionDuration, bounce: 0.2)) {
				selectedCategory = category
				switch category {
				case "G": timeInterval = timeTracker.meditationTime
				case "O": timeInterval = timeTracker.officeTime
				case "D": timeInterval = timeTracker.idleTime
				default: break
				}
			}
		}
		.onHover { hovering in
			withAnimation(.spring(duration: 0.2, bounce: 0.1)) {
				hoveredCategory = hovering ? category : nil
			}
		}
	}

	private var barChartView: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Capsule()
					.stroke(Color.white.opacity(0.25), lineWidth: 1)
				HStack(spacing: 0) {
					ForEach(chartData) { data in
						barView(for: data, totalTime: totalChartValue(), geometryWidth: geometry.size.width)
					}
				}
				.clipShape(Capsule())
			}
		}
		.frame(height: 5)
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
		case "G": return .orange
		case "O": return Color(hue: 0.72, saturation: 0.8, brightness: 1.0)
		case "D": return Color(hue: 0.95, saturation: 0.85, brightness: 1.0)
		default:  return .gray
		}
	}
}

struct TooltipView: View {
	var text: String

	var body: some View {
		Text(text)
			.font(.caption)
			.foregroundStyle(.white)
			.padding(.horizontal, 8)
			.padding(.vertical, 4)
			.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
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
