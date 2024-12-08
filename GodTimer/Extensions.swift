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
