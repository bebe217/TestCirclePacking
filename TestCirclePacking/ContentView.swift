//
//  ContentView.swift
//  TestCirclePacking
//
//  Created by bebe on 5/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var state: CircleState = CircleState()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(state.circles.indices, id: \.self) { index in
                    let circle = state.circles[index]
                    Circle()
                        .frame(width: circle.r * 2, height: circle.r * 2)
                        .foregroundStyle(circle.color)
                        .position(circle.center)
                    Text(String(circle.index + 1))
                        .font(.system(size: 6))
                        .foregroundColor(.white)
                        .position(circle.center)
                }
            }
            .background(.black)
            .onAppear {
                state.load(on: geo.size)
            }
        }
    }
}

struct CircleState {
    var circles: [Circle] = []
    var count = 2000

    func distanceBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        return sqrt(dx * dx + dy * dy)
    }
    
    mutating func load(on size: CGSize) {
        while (circles.count < count) {
            var newCircle = Circle(index: circles.count, size: size, end: count)
            for circle in circles {
                let dist = distanceBetween(newCircle.center, circle.center)
                if dist < newCircle.r + circle.r {
                    newCircle.r = dist - circle.r
                }
            }
            if (newCircle.r > 0) {
                circles.append(newCircle)
            }
        }
    }
    
    struct Circle {
        var index: Int
        var center: CGPoint
        var r: Double
        var color: Color

        init(index: Int, size: CGSize, end: Int) {
            self.index = index
            self.center = CGPoint(
                x: CGFloat.random(in: 0..<size.width),
                y: CGFloat.random(in: 0..<size.height)
            )
            self.r = Circle.getr(curr: index, end: end)
            self.color = Circle.colors[index % Circle.colors.count]
        }
        
        static func getr(curr: Int, end: Int) -> Double {
            let maxR = 100.0
            let minR = 5.0
            let progress = Double(curr) / Double(end)
            let max = maxR - (maxR - minR) * progress
            return CGFloat.random(in: minR..<max)
        }
        
        static let colors: [Color] = (0..<16).map {
            Color(hue: Double($0) / 16.0, saturation: 0.8, brightness: 0.9)
        }
    }
}

#Preview {
    ContentView()
}
