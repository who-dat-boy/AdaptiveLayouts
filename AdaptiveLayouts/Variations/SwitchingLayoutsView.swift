//
//  SwitchingLayoutsView.swift
//  AdaptiveLayouts
//
//  Created by Arthur ? on 11.04.2023.
//

import SwiftUI

// MARK: About
// This file presents switching between different layouts functionality.

struct ExampleView: View {
    @State private var counter = 0
    let color: Color
    
    var body: some View {
        Button {
            counter += 1
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .overlay(
                    Text(String(counter))
                        .foregroundColor(.white)
                        .font(.largeTitle)
                )
        }
        .frame(width: 100, height: 100)
        .rotationEffect(.degrees(.random(in: -20...20)))
    }
}

struct SwitchingLayoutsView: View {
    let layouts = [AnyLayout(VStackLayout()), AnyLayout(HStackLayout()), AnyLayout(ZStackLayout()), AnyLayout(GridLayout())]
    @State private var currentLayout = 0
    
    var layout: AnyLayout {
        layouts[currentLayout]
    }
    
    var body: some View {
        VStack {
            Spacer()
            layout {
                GridRow {
                    ExampleView(color: .red)
                    ExampleView(color: .green)
                }
                GridRow {
                    ExampleView(color: .blue)
                    ExampleView(color: .yellow)
                }
            }
            Spacer()
            Button("Change layout", action: changeLayout)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    }
    
    func changeLayout() {
        withAnimation {
            currentLayout += 1
            if currentLayout == layouts.count {
                currentLayout = 0
            }
        }
    }
}

struct SwitchingLayoutsView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchingLayoutsView()
    }
}
