//
//  RelativeHStackView.swift
//  AdaptiveLayouts
//
//  Created by Arthur ? on 11.04.2023.
//

import SwiftUI

// MARK: - About
// This file presents a horizontal layout where you can specify view available width by hand with '.layoutPriority(Int)'.

struct RelativeHStack: Layout {
    var spacing = 0.0
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.replacingUnspecifiedDimensions().width
        let viewFrames = frames(for: subviews, in: width)
        let lowestView = viewFrames.max { $0.maxY < $1.maxY } ?? .zero
        
        return CGSize(width: width, height: lowestView.maxY)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let viewFrames = frames(for: subviews, in: bounds.width)
        
        for index in subviews.indices {
            let frame = viewFrames[index]
            let position = CGPoint(x: bounds.minX + frame.minX, y: bounds.midY)
            subviews[index].place(at: position, anchor: .leading, proposal: ProposedViewSize(frame.size))
        }
    }
    
    func frames(for subviews: Subviews, in totalWidth: Double) -> [CGRect] {
        let totalSpacing = spacing * Double(subviews.count - 1)
        let availableWidth = totalWidth - totalSpacing
        let totalPriorities = subviews.reduce(0) { $0 + $1.priority }
        
        var viewFrames = [CGRect]()
        var x = 0.0
        
        for subview in subviews {
            let subviewWidth = availableWidth * subview.priority / totalPriorities
            let proposal = ProposedViewSize(width: subviewWidth, height: nil)
            let size = subview.sizeThatFits(proposal)
            
            let frame = CGRect(x: x, y: 0, width: size.width, height: size.height)
            viewFrames.append(frame)
            
            x += size.width + spacing
        }
        
        return viewFrames
    }
}

struct RelativeHStackView: View {
    var body: some View {
        RelativeHStack(spacing: 10) {
            Text("1st")
                .frame(maxWidth: .infinity)
                .background(.red)
                .layoutPriority(2)
            Text("2nd")
                .frame(maxWidth: .infinity)
                .background(.blue)
                .layoutPriority(1)
            Text("3rd")
                .frame(maxWidth: .infinity)
                .background(.green)
                .layoutPriority(4)
        }
        .foregroundColor(.white)
    }
}

struct RelativeHStackView_Previews: PreviewProvider {
    static var previews: some View {
        RelativeHStackView()
    }
}
