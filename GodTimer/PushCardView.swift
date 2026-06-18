import SwiftUI

struct PushCardView<Content: View>: View {
	enum Alignment {
		case horizontal, vertical
	}

	enum Placement {
		case top, bottom, left, right
	}

	var isVisible: Bool
	var alignment: Alignment
	var placement: Placement
	var spacing: CGFloat?
	var glassNamespace: Namespace.ID
	@ViewBuilder var content: () -> Content

	@State private var contentSize: CGSize = .zero

	var body: some View {
		Group {
			switch alignment {
			case .vertical:
				verticalLayout
			case .horizontal:
				horizontalLayout
			}
		}
	}

	private var verticalLayout: some View {
		VStack(spacing: 0) {
			if placement == .top {
				contentWithTransition(from: .bottom)
				spacerView(height: spacing ?? 190)
			} else {
				spacerView(height: spacing ?? 190)
				contentWithTransition(from: .top)
			}
		}
	}

	private var horizontalLayout: some View {
		HStack(spacing: 0) {
			if placement == .left {
				contentWithTransition(from: .trailing)
				spacerView(width: spacing ?? 430)
			} else {
				spacerView(width: spacing ?? 390)
				contentWithTransition(from: .leading)
			}
		}
	}

	@ViewBuilder
	private func spacerView(height: CGFloat? = nil, width: CGFloat? = nil) -> some View {
		if let height = height {
			VStack {}.frame(height: height)
		} else if let width = width {
			HStack {}.frame(width: width)
		}
	}

	private func contentWithTransition(from edge: Edge) -> some View {
		contentView
			.transition(
				AnyTransition.opacity
					.combined(with: .move(edge: edge))
					.combined(with: edge == .top || edge == .bottom ? .verticalScale : .horizontalScale)
			)
	}

	private var contentView: some View {
		Group {
			if isVisible {
				content()
					.padding()
					.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
					.glassEffectID("panel", in: glassNamespace)
					.frame(maxWidth: CGFloat(DropdownList.dropDownWidth + 260), minHeight: 110)
			}
		}
		.background(Color.clear)
	}
}

#Preview {
	@Previewable @Namespace var ns
	PushCardView(isVisible: true, alignment: .vertical, placement: .top, glassNamespace: ns) {
		Text("Placeholder for DropdownList")
	}
}
