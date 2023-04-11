//
//  EqualWidthHStackView.swift
//  AdaptiveLayouts
//
//  Created by Arthur ? on 11.04.2023.
//

import SwiftUI

// MARK: About
// This file presents a layout where all views in a HStack have the same available width.

struct EqualWidthHStack: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxSize = maximumSize(across: subviews)
        let spacing = spacing(for: subviews)
        let totalSpacing = spacing.reduce(0, +)
        
        return CGSize(
            width: maxSize.width * Double(subviews.count) + totalSpacing,
            height: maxSize.height
        )
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxSize = maximumSize(across: subviews)
        let spacing = spacing(for: subviews)
        
        let proposal = ProposedViewSize(width: maxSize.width, height: maxSize.height)
        var x = bounds.minX + maxSize.width / 2
        
        for index in subviews.indices {
            subviews[index].place(at: CGPoint(x: x, y: bounds.midY), anchor: .center, proposal: proposal)
            x += maxSize.width + spacing[index]
        }
    }
    
    private func maximumSize(across subviews: Subviews) -> CGSize {
        var maximumSize = CGSize.zero
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            
            if size.width > maximumSize.width {
                maximumSize.width = size.width
            }
            
            if size.height > maximumSize.height {
                maximumSize.height = size.height
            }
        }
        
        return maximumSize
        
//        - ALTERNATIVE short -
//        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
//
//        return sizes.reduce(.zero) { largest, next in
//            CGSize(width: max(largest.width, next.width), height: max(largest.height, next.height))
//        }
    }
    
    private func spacing(for subviews: Subviews) -> [Double] {
        var spacing = [Double]()

        for index in subviews.indices {
            if index == subviews.count - 1 {
                spacing.append(0)
            } else {
                let distance = subviews[index].spacing.distance(to: subviews[index + 1].spacing, along: .horizontal)
                spacing.append(distance)
            }
        }

        return spacing
        
//        - ALTERNATIVE short -
//        subviews.indices.map { index in
//            guard index < subviews.count else { return 0 }
//            return subviews[index].spacing.distance(to: subviews[index + 1].spacing, along: .horizontal)
//        }
    }
}

struct EqualWidthHStackView: View {
    var body: some View {
        EqualWidthHStack {
            Text("Hello")
                .padding(.horizontal, 5)
                .background(Color.blue)
            Text("Big text")
                .padding(.horizontal, 5)
                .background(Color.green)
            Text("Ultra big size")
                .padding(.horizontal, 5)
                .background(Color.red)
        }
        .foregroundColor(.white)
    }
}

struct EqualWidthHStackView_Previews: PreviewProvider {
    static var previews: some View {
        EqualWidthHStackView()
    }
}
