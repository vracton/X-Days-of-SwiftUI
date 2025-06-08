//
//  ContentView.swift
//  Animations
//
//  Created by vracto on 6/7/25.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    @State private var animAmount = 1.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    @State private var isOrange = false
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Stepper("Scale amount", value: $animAmount.animation(), in: 1...100)
                .padding()
            
            Spacer()
            
            Button("button") {
                enabled.toggle()
                withAnimation {
                    isOrange.toggle()
                }
//                withAnimation {
//                    animAmount += 360
//                }
//                animAmount = 1
            }
            .padding(40)
            .scaleEffect(animAmount)
            .rotation3DEffect(.degrees(animAmount), axis: (x: 0, y: 1, z: 0))
            .background(enabled ? .blue : .red)
            .animation(.default, value: enabled)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: enabled ? 60 : 0))
            .animation(.spring(duration: 1, bounce: 0.6), value: enabled)
            
            
            Spacer()
            if isOrange {
                LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(width: 300, height: 200)
                    .clipShape(.rect(cornerRadius: 10))
                    .offset(dragAmount)
                    .gesture(
                        DragGesture()
                            .onChanged { dragAmount = $0.translation }
                            .onEnded { _ in
                                withAnimation(.bouncy) {
                                    dragAmount = .zero
                                }
                            }
                    )
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
            ZStack {
                        Rectangle()
                            .fill(.blue)
                            .frame(width: 200, height: 200)

                        if isShowingRed {
                            Rectangle()
                                .fill(.red)
                                .frame(width: 200, height: 200)
                                .transition(.pivot)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            isShowingRed.toggle()
                        }
                    }
        }
    }
}

#Preview {
    ContentView()
}
