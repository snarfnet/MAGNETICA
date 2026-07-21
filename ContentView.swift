import SwiftUI

enum AppMode: String, CaseIterable {
    case aura = "AURA"
    case meditate = "MEDITATE"
}

struct ContentView: View {
    @StateObject private var magnetometer = MagnetometerEngine()
    @StateObject private var meditation = MeditationEngine()
    @State private var mode: AppMode = .aura
    @State private var showDiagnosis = false
    @State private var diagnosis: AuraDiagnosis?
    @State private var isJapanese = Locale.current.language.languageCode?.identifier == "ja"

    var body: some View {
        ZStack {
            CosmicBackground(
                magnitude: magnetometer.currentReading?.normalizedMagnitude ?? 0,
                fluctuation: magnetometer.fluctuation,
                hue: magnetometer.currentReading?.auraHue ?? 0.7
            )

            VStack(spacing: 0) {
                header
                modeSelector

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        switch mode {
                        case .aura:
                            auraView
                        case .meditate:
                            meditateView
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 80)
                }
            }
        }
        .onAppear {
            magnetometer.start()
        }
        .onDisappear {
            magnetometer.stop()
            meditation.stop()
        }
        .onChange(of: magnetometer.currentReading?.magnitude ?? 0) { newValue in
            if meditation.isActive {
                meditation.updateFromMagneticField(
                    magnitude: newValue,
                    fluctuation: magnetometer.fluctuation
                )
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 6) {
            Image("MysticOrb")
                .resizable()
                .scaledToFit()
                .frame(width: 58, height: 58)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.magneticaGold.opacity(0.38), lineWidth: 1)
                )
                .shadow(color: .magneticaCyan.opacity(0.35), radius: 18)

            Text("MAGNETICA")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .tracking(6)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.magneticaFrost, .magneticaViolet, .magneticaGold],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: .magneticaViolet.opacity(0.8), radius: 20)

            Text(isJapanese ? "磁気オーラリーダー" : "MAGNETIC AURA READER")
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .tracking(2)
                .foregroundColor(.magneticaGold.opacity(0.7))
        }
        .padding(.top, 14)
        .padding(.bottom, 8)
    }

    // MARK: - Mode Selector

    private var modeSelector: some View {
        HStack(spacing: 0) {
            ForEach(AppMode.allCases, id: \.self) { m in
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) { mode = m }
                    if m == .aura { meditation.stop() }
                } label: {
                    Text(m.rawValue)
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .tracking(2)
                        .foregroundColor(mode == m ? .black : .magneticaFrost.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(
                            mode == m
                            ? AnyShapeStyle(LinearGradient(
                                colors: [.magneticaGold, .magneticaCyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            : AnyShapeStyle(Color.white.opacity(0.07))
                        )
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .background(Color.black.opacity(0.28), in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.magneticaGold.opacity(0.24), lineWidth: 1))
        .shadow(color: .magneticaCyan.opacity(0.12), radius: 14)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Aura Mode

    private var auraView: some View {
        VStack(spacing: 16) {
            // Aura orb
            AuraOrbView(
                magnitude: magnetometer.currentReading?.normalizedMagnitude ?? 0,
                fluctuation: magnetometer.fluctuation,
                hue: magnetometer.currentReading?.auraHue ?? 0.7
            )
            .frame(height: 280)

            // Live readings
            cosmicPanel(title: isJapanese ? "磁場データ" : "FIELD DATA") {
                HStack(spacing: 12) {
                    ReadingTile(
                        label: isJapanese ? "強度" : "INTENSITY",
                        value: String(format: "%.1f µT", magnetometer.currentReading?.magnitude ?? 0),
                        color: .magneticaViolet
                    )
                    ReadingTile(
                        label: isJapanese ? "揺らぎ" : "FLUX",
                        value: String(format: "%.0f%%", magnetometer.fluctuation * 100),
                        color: .magneticaGold
                    )
                    ReadingTile(
                        label: isJapanese ? "軸" : "AXIS",
                        value: magnetometer.currentReading?.dominantAxis ?? "-",
                        color: .magneticaCyan
                    )
                }

                // XYZ bars
                VStack(spacing: 8) {
                    AxisBar(label: "X", value: magnetometer.currentReading?.x ?? 0, maxVal: 200, color: .magneticaViolet)
                    AxisBar(label: "Y", value: magnetometer.currentReading?.y ?? 0, maxVal: 200, color: .magneticaGold)
                    AxisBar(label: "Z", value: magnetometer.currentReading?.z ?? 0, maxVal: 200, color: .magneticaCyan)
                }
            }

            // Magnitude history
            cosmicPanel(title: isJapanese ? "磁場の波形" : "FIELD WAVEFORM") {
                MagnitudeWaveView(history: magnetometer.readingHistory)
                    .frame(height: 80)
            }

            // Diagnose button
            Button {
                if let reading = magnetometer.currentReading {
                    diagnosis = AuraDiagnostics.diagnose(
                        magnitude: reading.magnitude,
                        fluctuation: magnetometer.fluctuation,
                        dominantAxis: reading.dominantAxis
                    )
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showDiagnosis = true
                    }
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .bold))
                    Text(isJapanese ? "オーラ診断" : "READ AURA")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .tracking(2)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    LinearGradient(
                        colors: [.magneticaViolet, .magneticaGold],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .magneticaViolet.opacity(0.5), radius: 16)
            }

            if showDiagnosis, let d = diagnosis {
                diagnosisCard(d)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }

            // Peak
            cosmicPanel(title: isJapanese ? "セッション記録" : "SESSION RECORD") {
                HStack(spacing: 16) {
                    ReadingTile(
                        label: isJapanese ? "最大磁場" : "PEAK",
                        value: String(format: "%.1f µT", magnetometer.peakMagnitude),
                        color: .magneticaViolet
                    )
                    ReadingTile(
                        label: isJapanese ? "計測数" : "READINGS",
                        value: "\(magnetometer.readingHistory.count)",
                        color: .magneticaCyan
                    )
                }

                Button {
                    magnetometer.reset()
                    showDiagnosis = false
                    diagnosis = nil
                } label: {
                    Text(isJapanese ? "リセット" : "RESET")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.magneticaFrost.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(Color.white.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
    }

    // MARK: - Meditate Mode

    private var meditateView: some View {
        VStack(spacing: 16) {
            // Meditation orb — larger, calmer
            MeditationOrbView(
                magnitude: magnetometer.currentReading?.normalizedMagnitude ?? 0,
                breathPhase: meditation.breathPhase,
                hue: magnetometer.currentReading?.auraHue ?? 0.7
            )
            .frame(height: 320)

            // Timer
            cosmicPanel(title: isJapanese ? "瞑想タイマー" : "MEDITATION TIMER") {
                HStack {
                    Text(meditation.elapsedString)
                        .font(.system(size: 40, weight: .thin, design: .monospaced))
                        .foregroundColor(.magneticaFrost)

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text(isJapanese ? "呼吸ガイド" : "BREATH")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundColor(.magneticaGold.opacity(0.6))
                        Text(meditation.breathPhase > 0.5 ? (isJapanese ? "吸う" : "INHALE") : (isJapanese ? "吐く" : "EXHALE"))
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(meditation.breathPhase > 0.5 ? .magneticaCyan : .magneticaViolet)
                    }
                }

                // Breath bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.08))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [.magneticaViolet, .magneticaCyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * meditation.breathPhase)
                            .shadow(color: .magneticaCyan.opacity(0.6), radius: 8)
                    }
                }
                .frame(height: 12)
            }

            // Current field
            cosmicPanel(title: isJapanese ? "磁場の響き" : "FIELD RESONANCE") {
                HStack(spacing: 12) {
                    ReadingTile(
                        label: isJapanese ? "周波数" : "FREQ",
                        value: String(format: "%.0f Hz", 110 + (magnetometer.currentReading?.normalizedMagnitude ?? 0) * 330),
                        color: .magneticaViolet
                    )
                    ReadingTile(
                        label: isJapanese ? "振幅" : "AMP",
                        value: String(format: "%.0f%%", magnetometer.fluctuation * 100),
                        color: .magneticaCyan
                    )
                    ReadingTile(
                        label: isJapanese ? "強度" : "FIELD",
                        value: String(format: "%.0f µT", magnetometer.currentReading?.magnitude ?? 0),
                        color: .magneticaGold
                    )
                }

                MagnitudeWaveView(history: magnetometer.readingHistory)
                    .frame(height: 60)
            }

            // Start/Stop
            Button {
                if meditation.isActive {
                    meditation.stop()
                } else {
                    meditation.start()
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: meditation.isActive ? "stop.fill" : "moon.stars.fill")
                        .font(.system(size: 16, weight: .bold))
                    Text(meditation.isActive
                         ? (isJapanese ? "瞑想を終了" : "END SESSION")
                         : (isJapanese ? "瞑想を開始" : "BEGIN MEDITATION"))
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .tracking(2)
                }
                .foregroundColor(meditation.isActive ? .magneticaFrost : .black)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    meditation.isActive
                    ? AnyShapeStyle(Color.white.opacity(0.1))
                    : AnyShapeStyle(LinearGradient(
                        colors: [.magneticaCyan, .magneticaViolet],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    meditation.isActive
                    ? RoundedRectangle(cornerRadius: 12).stroke(Color.magneticaViolet.opacity(0.4), lineWidth: 1)
                    : nil
                )
                .shadow(color: meditation.isActive ? .clear : .magneticaCyan.opacity(0.4), radius: 16)
            }
        }
    }

    // MARK: - Diagnosis Card

    private func diagnosisCard(_ d: AuraDiagnosis) -> some View {
        cosmicPanel(title: isJapanese ? "オーラ診断結果" : "AURA READING") {
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(auraColorToSwiftUI(d.color))
                        .frame(width: 44, height: 44)
                        .shadow(color: auraColorToSwiftUI(d.color).opacity(0.8), radius: 16)
                        .overlay(
                            Text(d.element)
                                .font(.system(size: 6, weight: .black, design: .monospaced))
                                .foregroundColor(.white)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(isJapanese ? d.title : d.titleEn)
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.magneticaFrost)

                        Text(d.color.rawValue)
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .tracking(2)
                            .foregroundColor(auraColorToSwiftUI(d.color))
                    }

                    Spacer()
                }

                Text(isJapanese ? d.description : d.descriptionEn)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.magneticaFrost.opacity(0.85))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - Helpers

    private func cosmicPanel<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.magneticaViolet, .magneticaViolet.opacity(0.3), .clear],
                            center: .center, startRadius: 1, endRadius: 5
                        )
                    )
                    .frame(width: 8, height: 8)

                Text(title)
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .tracking(1.5)
                    .foregroundColor(.magneticaGold.opacity(0.7))

                Rectangle()
                    .fill(LinearGradient(colors: [.magneticaViolet.opacity(0.4), .clear], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 1)
            }

            content()
        }
        .padding(14)
        .background(
            ZStack {
                Color.black.opacity(0.46)
                LinearGradient(
                    colors: [
                        .white.opacity(0.07),
                        .magneticaViolet.opacity(0.09),
                        .clear,
                        .magneticaCyan.opacity(0.06)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    LinearGradient(
                        colors: [
                            .magneticaGold.opacity(0.34),
                            .white.opacity(0.1),
                            .magneticaCyan.opacity(0.28)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.32), radius: 18, y: 8)
    }

    private func auraColorToSwiftUI(_ color: AuraColor) -> Color {
        switch color {
        case .violet: return .magneticaViolet
        case .indigo: return Color(red: 0.35, green: 0.2, blue: 0.9)
        case .gold: return .magneticaGold
        case .emerald: return Color(red: 0.15, green: 0.85, blue: 0.5)
        case .crimson: return Color(red: 0.95, green: 0.15, blue: 0.25)
        case .silver: return Color(red: 0.75, green: 0.8, blue: 0.85)
        case .azure: return .magneticaCyan
        }
    }
}

// MARK: - Sub Views

private struct ReadingTile: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.45))
            Text(value)
                .font(.system(size: 13, weight: .black, design: .monospaced))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.black.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(color.opacity(0.2), lineWidth: 1))
    }
}

private struct AxisBar: View {
    let label: String
    let value: Double
    let maxVal: Double
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundColor(color)
                .frame(width: 14)

            GeometryReader { geo in
                let normalized = min(abs(value) / maxVal, 1.0)
                let isNeg = value < 0
                ZStack {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.06))

                    HStack(spacing: 0) {
                        if isNeg {
                            Spacer()
                            RoundedRectangle(cornerRadius: 3)
                                .fill(color.opacity(0.7))
                                .frame(width: geo.size.width * 0.5 * normalized)
                                .shadow(color: color.opacity(0.5), radius: 4)
                            Spacer().frame(width: geo.size.width * 0.5)
                        } else {
                            Spacer().frame(width: geo.size.width * 0.5)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(color.opacity(0.7))
                                .frame(width: geo.size.width * 0.5 * normalized)
                                .shadow(color: color.opacity(0.5), radius: 4)
                            Spacer()
                        }
                    }

                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 1)
                }
            }
            .frame(height: 14)

            Text(String(format: "%.0f", value))
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.4))
                .frame(width: 36, alignment: .trailing)
        }
    }
}

private struct MagnitudeWaveView: View {
    let history: [MagneticReading]

    var body: some View {
        Canvas { context, size in
            guard history.count > 1 else { return }

            let maxMag = max(history.map(\.magnitude).max() ?? 1, 1)
            var path = Path()

            for (i, reading) in history.enumerated() {
                let x = CGFloat(i) / CGFloat(history.count - 1) * size.width
                let y = size.height - (reading.magnitude / maxMag) * size.height * 0.9

                if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }

            context.stroke(path, with: .linearGradient(
                Gradient(colors: [
                    Color.magneticaViolet.opacity(0.3),
                    Color.magneticaViolet,
                    Color.magneticaCyan
                ]),
                startPoint: .zero,
                endPoint: CGPoint(x: size.width, y: 0)
            ), lineWidth: 2)

            // Fill
            var fillPath = path
            fillPath.addLine(to: CGPoint(x: size.width, y: size.height))
            fillPath.addLine(to: CGPoint(x: 0, y: size.height))
            fillPath.closeSubpath()

            context.fill(fillPath, with: .linearGradient(
                Gradient(colors: [
                    Color.magneticaViolet.opacity(0.15),
                    Color.magneticaCyan.opacity(0.05),
                    Color.clear
                ]),
                startPoint: .zero,
                endPoint: CGPoint(x: 0, y: size.height)
            ))
        }
        .background(Color.black.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// MARK: - Colors

extension Color {
    static let magneticaViolet = Color(red: 0.55, green: 0.22, blue: 0.95)
    static let magneticaGold = Color(red: 1.0, green: 0.78, blue: 0.28)
    static let magneticaCyan = Color(red: 0.25, green: 0.85, blue: 0.95)
    static let magneticaFrost = Color(red: 0.88, green: 0.92, blue: 0.96)
    static let magneticaDeep = Color(red: 0.04, green: 0.02, blue: 0.12)
}

#Preview {
    ContentView()
}
