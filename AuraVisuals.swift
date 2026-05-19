import SwiftUI

// MARK: - Cosmic Background

struct CosmicBackground: View {
    let magnitude: Double
    let fluctuation: Double
    let hue: Double

    var body: some View {
        ZStack {
            Color.magneticaDeep
                .ignoresSafeArea()

            // Nebula gradient
            RadialGradient(
                colors: [
                    Color(hue: hue, saturation: 0.6, brightness: 0.15).opacity(0.5),
                    Color(hue: hue + 0.15, saturation: 0.5, brightness: 0.08).opacity(0.3),
                    Color.clear
                ],
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()

            // Starfield
            Canvas { context, size in
                let starCount = 80
                for i in 0..<starCount {
                    let seed = Double(i * 7919 + 1) // Prime-based pseudo-random
                    let x = CGFloat(fmod(seed * 0.618033, 1.0)) * size.width
                    let y = CGFloat(fmod(seed * 0.381966, 1.0)) * size.height
                    let brightness = fmod(seed * 0.292893, 1.0)
                    let starSize = 1.0 + brightness * 2.0

                    let flickerPhase = fmod(seed * 0.141421, 1.0)
                    let alpha = 0.3 + brightness * 0.5 + fluctuation * flickerPhase * 0.2

                    context.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: starSize, height: starSize)),
                        with: .color(.white.opacity(alpha))
                    )
                }
            }
            .ignoresSafeArea()

            // Subtle nebula clouds
            GeometryReader { geo in
                ZStack {
                    Ellipse()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.magneticaViolet.opacity(0.06 + magnitude * 0.08),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 30,
                                endRadius: 250
                            )
                        )
                        .frame(width: 400, height: 300)
                        .offset(x: -geo.size.width * 0.2, y: -geo.size.height * 0.15)

                    Ellipse()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.magneticaCyan.opacity(0.04 + fluctuation * 0.06),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 200
                            )
                        )
                        .frame(width: 350, height: 250)
                        .offset(x: geo.size.width * 0.25, y: geo.size.height * 0.2)
                }
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Aura Orb (Aura mode)

struct AuraOrbView: View {
    let magnitude: Double
    let fluctuation: Double
    let hue: Double

    @State private var animationPhase: Double = 0

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let baseRadius: CGFloat = 60 + CGFloat(magnitude) * 40

                // Outer aura layers
                for layer in stride(from: 5, through: 1, by: -1) {
                    let layerFactor = CGFloat(layer) / 5.0
                    let radius = baseRadius + layerFactor * 50 + CGFloat(sin(time * 1.5 + Double(layer)) * fluctuation * 15)
                    let alpha = 0.03 + (1 - layerFactor) * 0.12

                    let layerHue = hue + Double(layer) * 0.04
                    let color = Color(hue: fmod(layerHue, 1.0), saturation: 0.7, brightness: 0.9)

                    let rect = CGRect(
                        x: center.x - radius,
                        y: center.y - radius,
                        width: radius * 2,
                        height: radius * 2
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(color.opacity(alpha)))
                }

                // Core glow
                let coreRadius = baseRadius * 0.6
                let coreRect = CGRect(
                    x: center.x - coreRadius,
                    y: center.y - coreRadius,
                    width: coreRadius * 2,
                    height: coreRadius * 2
                )

                context.fill(
                    Path(ellipseIn: coreRect),
                    with: .radialGradient(
                        Gradient(colors: [
                            .white.opacity(0.9),
                            Color(hue: hue, saturation: 0.5, brightness: 1.0).opacity(0.6),
                            Color(hue: hue, saturation: 0.8, brightness: 0.7).opacity(0.2),
                            .clear
                        ]),
                        center: center,
                        startRadius: 0,
                        endRadius: coreRadius
                    )
                )

                // Energy particles
                let particleCount = 24
                for i in 0..<particleCount {
                    let angle = (Double(i) / Double(particleCount)) * 2 * .pi + time * 0.3
                    let dist = baseRadius + 30 + sin(time * 2 + Double(i) * 0.8) * 20 * fluctuation
                    let px = center.x + CGFloat(cos(angle) * dist)
                    let py = center.y + CGFloat(sin(angle) * dist)
                    let particleSize = 2.0 + fluctuation * 3.0
                    let particleAlpha = 0.3 + magnitude * 0.4

                    let particleHue = fmod(hue + Double(i) * 0.03, 1.0)

                    context.fill(
                        Path(ellipseIn: CGRect(x: px - particleSize / 2, y: py - particleSize / 2, width: particleSize, height: particleSize)),
                        with: .color(Color(hue: particleHue, saturation: 0.6, brightness: 1.0).opacity(particleAlpha))
                    )
                }
            }
        }
    }
}

// MARK: - Meditation Orb

struct MeditationOrbView: View {
    let magnitude: Double
    let breathPhase: Double
    let hue: Double

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let breathScale = 0.85 + breathPhase * 0.15
                let baseRadius: CGFloat = CGFloat(80 * breathScale)

                // Calm outer rings
                for ring in stride(from: 8, through: 1, by: -1) {
                    let ringFactor = CGFloat(ring) / 8.0
                    let radius = baseRadius + ringFactor * 70
                    let alpha = 0.02 + (1 - ringFactor) * 0.06
                    let ringHue = fmod(hue + Double(ring) * 0.02 + time * 0.01, 1.0)

                    let rect = CGRect(
                        x: center.x - radius,
                        y: center.y - radius,
                        width: radius * 2,
                        height: radius * 2
                    )

                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(Color(hue: ringHue, saturation: 0.4, brightness: 0.8).opacity(alpha))
                    )
                }

                // Inner core with breath
                let coreRadius = baseRadius * 0.5
                let coreRect = CGRect(
                    x: center.x - coreRadius,
                    y: center.y - coreRadius,
                    width: coreRadius * 2,
                    height: coreRadius * 2
                )

                context.fill(
                    Path(ellipseIn: coreRect),
                    with: .radialGradient(
                        Gradient(colors: [
                            .white.opacity(0.7 + breathPhase * 0.3),
                            Color(hue: hue, saturation: 0.3, brightness: 0.9).opacity(0.5),
                            Color(hue: hue + 0.1, saturation: 0.5, brightness: 0.6).opacity(0.1),
                            .clear
                        ]),
                        center: center,
                        startRadius: 0,
                        endRadius: coreRadius
                    )
                )

                // Slow orbiting particles
                let particleCount = 16
                for i in 0..<particleCount {
                    let angle = (Double(i) / Double(particleCount)) * 2 * .pi + time * 0.15
                    let dist = baseRadius + 40 + sin(time * 0.5 + Double(i)) * 10
                    let px = center.x + CGFloat(cos(angle) * dist)
                    let py = center.y + CGFloat(sin(angle) * dist)
                    let pSize = 1.5 + breathPhase * 1.5

                    context.fill(
                        Path(ellipseIn: CGRect(x: px - pSize / 2, y: py - pSize / 2, width: pSize, height: pSize)),
                        with: .color(Color.magneticaCyan.opacity(0.4 + breathPhase * 0.3))
                    )
                }
            }
        }
    }
}
