//
//  Marquee.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 02/07/2022.
//

import Foundation
import CoreGraphics
import SwiftUI


public enum MarqueeDirection {
    case right2left
    case left2right
}

private enum MarqueeState {
    case idle
    case ready
    case animating
}

public struct Marquee<Content> : View where Content : View {
    @Environment(\.marqueeDuration) var duration
    @Environment(\.marqueeAutoreverses) var autoreverses: Bool
    @Environment(\.marqueeDirection) var direction: MarqueeDirection
    @Environment(\.marqueeWhenNotFit) var stopWhenNotFit: Bool
    @Environment(\.marqueeIdleAlignment) var idleAlignment: HorizontalAlignment
    
    private var content: () -> Content
    @State private var state: MarqueeState = .idle
    @State private var contentWidth: CGFloat = 0
    @State private var isAppear = false
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack {
                if isAppear {
                    content()
                        .background(GeometryBackground())
                        .fixedSize()
                        .myOffset(x: offsetX(proxy: proxy), y: 0)
                        .frame(maxHeight: .infinity)
                } else {
                    Text("")
                }
            }
            .onPreferenceChange(WidthKey.self, perform: { value in
                self.contentWidth = value
                resetAnimation(duration: duration, autoreverses: autoreverses, proxy: proxy)
            })
            .onAppear {
                self.isAppear = true
                resetAnimation(duration: duration, autoreverses: autoreverses, proxy: proxy)
            }
            .onDisappear {
                self.isAppear = false
            }
            .onChange(of: duration) { [] newDuration in
                resetAnimation(duration: newDuration, autoreverses: self.autoreverses, proxy: proxy)
            }
            .onChange(of: autoreverses) { [] newAutoreverses in
                resetAnimation(duration: self.duration, autoreverses: newAutoreverses, proxy: proxy)
            }
            .onChange(of: direction) { [] _ in
                resetAnimation(duration: duration, autoreverses: autoreverses, proxy: proxy)
            }
        }.clipped()
    }
    
    private func offsetX(proxy: GeometryProxy) -> CGFloat {
        switch self.state {
        case .idle:
            switch idleAlignment {
            case .center:
                return 0.5*(proxy.size.width-contentWidth)
            case .trailing:
                return proxy.size.width-contentWidth
            default:
                return 0
            }
        case .ready:
            return (direction == .right2left) ? proxy.size.width : -contentWidth
        case .animating:
            return (direction == .right2left) ? -contentWidth : proxy.size.width
        }
    }
    
    private func resetAnimation(duration: Double, autoreverses: Bool, proxy: GeometryProxy) {
        if duration == 0 || duration == Double.infinity {
            stopAnimation()
        } else {
            startAnimation(duration: duration, autoreverses: autoreverses, proxy: proxy)
        }
    }
    
    private func startAnimation(duration: Double, autoreverses: Bool, proxy: GeometryProxy) {
        let isNotFit = contentWidth < proxy.size.width
        if stopWhenNotFit && isNotFit {
            stopAnimation()
            return
        }
        
        withAnimation(.instant) {
            self.state = .ready
            withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: autoreverses)) {
                self.state = .animating
            }
        }
    }
    
    private func stopAnimation() {
        withAnimation(.instant) {
            self.state = .idle
        }
    }
}

struct Marquee_Previews: PreviewProvider {
    static var previews: some View {
        Marquee {
            Text("Hello World!")
                .fontWeight(.bold)
                .font(.system(size: 40))
        }
    }
}



struct DurationKey: EnvironmentKey {
    static var defaultValue: Double = 2.0
}

struct AutoreversesKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

struct DirectionKey: EnvironmentKey {
    static var defaultValue: MarqueeDirection = .right2left
}

struct StopWhenNotFitKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

struct AlignmentKey: EnvironmentKey {
    static var defaultValue: HorizontalAlignment = .leading
}

extension EnvironmentValues {
    var marqueeDuration: Double {
        get {self[DurationKey.self]}
        set {self[DurationKey.self] = newValue}
    }
    
    var marqueeAutoreverses: Bool {
        get {self[AutoreversesKey.self]}
        set {self[AutoreversesKey.self] = newValue}
    }
    
    var marqueeDirection: MarqueeDirection {
        get {self[DirectionKey.self]}
        set {self[DirectionKey.self] = newValue}
    }
    
    var marqueeWhenNotFit: Bool {
        get {self[StopWhenNotFitKey.self]}
        set {self[StopWhenNotFitKey.self] = newValue}
    }
    
    var marqueeIdleAlignment: HorizontalAlignment {
        get {self[AlignmentKey.self]}
        set {self[AlignmentKey.self] = newValue}
    }
}

public extension View {
    /// Sets the marquee animation duration to the given value.
    ///
    ///     Marquee {
    ///         Text("Hello World!")
    ///     }.marqueeDuration(3.0)
    ///
    /// - Parameters:
    ///   - duration: Animation duration, default is `2.0`.
    ///
    /// - Returns: A view that has the given value set in its environment.
    func marqueeDuration(_ duration: Double) -> some View {
        environment(\.marqueeDuration, duration)
    }
    
    /// Sets the marquee animation autoreverses to the given value.
    ///
    ///     Marquee {
    ///         Text("Hello World!")
    ///     }.marqueeAutoreverses(true)
    ///
    /// - Parameters:
    ///   - autoreverses: Animation autoreverses, default is `false`.
    ///
    /// - Returns: A view that has the given value set in its environment.
    func marqueeAutoreverses(_ autoreverses: Bool) -> some View {
        environment(\.marqueeAutoreverses, autoreverses)
    }
    
    /// Sets the marquee animation direction to the given value.
    ///
    ///     Marquee {
    ///         Text("Hello World!")
    ///     }.marqueeDirection(.right2left)
    ///
    /// - Parameters:
    ///   - direction: `MarqueeDirection` enum, default is `right2left`.
    ///
    /// - Returns: A view that has the given value set in its environment.
    func marqueeDirection(_ direction: MarqueeDirection) -> some View {
        environment(\.marqueeDirection, direction)
    }
    
    /// Stop the marquee animation when the content view is not fit`(contentWidth < marqueeWidth)`.
    ///
    ///     Marquee {
    ///         Text("Hello World!")
    ///     }.marqueeWhenNotFit(true)
    ///
    /// - Parameters:
    ///   - stopWhenNotFit: Stop the marquee animation when the content view is not fit(`contentWidth <  marqueeWidth`), default is `false`.
    ///
    /// - Returns: A view that has the given value set in its environment.
    func marqueeWhenNotFit(_ stopWhenNotFit: Bool) -> some View {
        environment(\.marqueeWhenNotFit, stopWhenNotFit)
    }
    
    /// Sets the marquee alignment  when idle(stop animation).
    ///
    ///     Marquee {
    ///         Text("Hello World!")
    ///     }.marqueeIdleAlignment(.center)
    ///
    /// - Parameters:
    ///   - alignment: Alignment  when idle(stop animation), default is `.leading`.
    ///
    /// - Returns: A view that has the given value set in its environment.
    func marqueeIdleAlignment(_ alignment: HorizontalAlignment) -> some View {
        environment(\.marqueeIdleAlignment, alignment)
    }
}

struct GeometryBackground: View {
    var body: some View {
        GeometryReader { geometry in
            return Color.clear.preference(key: WidthKey.self, value: geometry.size.width)
        }
    }
}

struct WidthKey: PreferenceKey {
    static var defaultValue = CGFloat(0)

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }

    typealias Value = CGFloat
}

extension Animation {
    static var instant: Animation {
        return .linear(duration: 0.01)
    }
}

// Refference:  https://swiftui-lab.com/swiftui-animations-part2/
extension View {
    func myOffset(x: CGFloat, y: CGFloat) -> some View {
        return modifier(_OffsetEffect(offset: CGSize(width: x, height: y)))
    }

    func myOffset(_ offset: CGSize) -> some View {
        return modifier(_OffsetEffect(offset: offset))
    }
}

struct _OffsetEffect: GeometryEffect {
    var offset: CGSize
    
    var animatableData: CGSize.AnimatableData {
        get { CGSize.AnimatableData(offset.width, offset.height) }
        set { offset = CGSize(width: newValue.first, height: newValue.second) }
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: offset.width, y: offset.height))
    }
}
