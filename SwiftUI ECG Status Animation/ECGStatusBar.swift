//
//  ECGStatusBar.swift
//  SwiftUI ECG Status Animation
//
//  Created by Raúl Montón Pinillos on 8/10/23.
//

import SwiftUI

struct ECGStatusBar: View {
    
    @ObservedObject var waveformProvider: WaveformProvider
    
    var body: some View {
        ZStack (alignment: .top) {
            if waveformProvider.currentWaveform != waveformProvider.nextWaveform {
                HStack {
                    Spacer()
                    ProgressView()
                }
                .padding()
            }
            HStack(alignment: .top, spacing: .zero) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray.opacity(0.3))
                    
                    TimelineView(.animation) { context in
                        ZStack {
                            
                            Path() { path in
                                path.move(to: CGPoint(x: 0, y: 48))
                                for i in 0..<1000 {
                                    path.addLine(to: CGPoint(
                                        x: 96 * (Double(i) / 1000),
                                        y: 48 - 36 * waveformProvider.ecg(
                                            date: context.date,
                                            time: (Double(i) / 1000),
                                            beat: .last
                                        )
                                    ))
                                }
                            }
                            .stroke(style: .init(lineWidth: 4, lineJoin: .round))
                            .foregroundStyle(.red)
                            .mask {
                                HStack(spacing: .zero) {
                                    Spacer()
                                        .frame(width: CGFloat(96 * (0.1 + waveformProvider.fractionComplete(date: context.date))))
                                    LinearGradient(
                                        colors: [.clear, .black],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(width: 12)
                                    Color.black
                                }
                            }
                            Path() { path in
                                path.move(to: CGPoint(x: 0, y: 48))
                                for i in 0..<Int(1000 * waveformProvider.fractionComplete(date: context.date)) {
                                    path.addLine(to: CGPoint(
                                        x: 96 * (Double(i) / 1000),
                                        y: 48 - 36 * waveformProvider.ecg(
                                            date: context.date,
                                            time: (Double(i) / 1000)
                                        )
                                    ))
                                }
                            }
                            .stroke(style: .init(lineWidth: 4, lineJoin: .round))
                            .foregroundStyle(.red)
                            
                            Circle()
                                .foregroundColor(.red)
                                .frame(width: 8, height: 8)
                                .position(CGPoint(
                                    x: 96 * waveformProvider.fractionComplete(date: context.date),
                                    y: 48 - 36 * waveformProvider.ecg(date: context.date)
                                ))
                        }
                    }
                    /*
                     RoundedRectangle(cornerRadius: 16)
                     .stroke(style: .init(lineWidth: 2))
                     .foregroundStyle(.secondary)
                     */
                }
                .frame(width: 96, height: 72)
                .padding(12)
                
                VStack(alignment: .leading) {
                    Text(statusText(currentWaveform: waveformProvider.currentWaveform))
                        .font(.title2)
                        .bold()
                    Text(messageText(currentWaveform: waveformProvider.currentWaveform))
                }
                .padding(.vertical, 12)
                .padding(.trailing, 12)
                .opacity(waveformProvider.currentWaveform != waveformProvider.nextWaveform ? 0.3 : 1.0)
                
                Spacer()
            }
        }
        .background {
            ZStack {
                Color.white
                LinearGradient(
                    colors: [Color.gray.opacity(0.25), Color.gray.opacity(0.35)], 
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .cornerRadius(24, antialiased: true)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        }
        .padding()
    }
    
    func statusText(currentWaveform: Waveform) -> String {
        switch currentWaveform {
        case .ecg:
            return "Status: OK"
        case .torsades:
            return "Some issues"
        case .dead:
            return "Critical error"
        }
    }
    
    func messageText(currentWaveform: Waveform) -> String {
        switch currentWaveform {
        case .ecg:
            return "All systems working"
        case .torsades:
            return "Found issues in some subsystems"
        case .dead:
            return "All systems down"
        }
    }
}

#Preview {
    ECGStatusBar(waveformProvider: WaveformProvider(windowDuration: 2.5))
}
