//
//  ContentView.swift
//  SwiftUI ECG Status Animation
//
//  Created by Raúl Montón Pinillos on 8/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
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
                                    y: 48 - 36 * ecgWavefunction(time: (Double(i) / 1000))
                                ))
                            }
                        }
                        .stroke(style: .init(lineWidth: 4, lineJoin: .round))
                        .foregroundStyle(.red)
                        .mask {
                            HStack(spacing: .zero) {
                                Spacer()
                                    .frame(width: CGFloat(96 * (0.1 + fractionComplete(date: context.date))))
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
                            for i in 0..<Int(1000 * fractionComplete(date: context.date)) {
                                path.addLine(to: CGPoint(
                                    x: 96 * (Double(i) / 1000),
                                    y: 48 - 36 * ecgWavefunction(time: (Double(i) / 1000))
                                ))
                            }
                        }
                        .stroke(style: .init(lineWidth: 4, lineJoin: .round))
                        .foregroundStyle(.red)
                        
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 8, height: 8)
                            .position(CGPoint(
                                x: 96 * fractionComplete(date: context.date),
                                y: 48 - 36 * ecgWavefunction(time: fractionComplete(date: context.date))
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
                Text("Status: OK")
                    .font(.title2)
                    .bold()
                Text("All systems working")
            }
            .padding(.vertical, 12)
            .padding(.trailing, 12)
            
            Spacer()
        }
        .background(.secondary.opacity(0.15))
        .cornerRadius(24, antialiased: true)
        .padding()
    }
    
    private func fractionComplete(date: Date) -> Double {
        return date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 2.5) / 2.5
    }
    
    private func ecgWavefunction(time: Double) -> Double {
        
        // return 0.3 + 0.5 * sin(5 * time) * sin(66 * time)
                                
        if time >= 0.2 && time < 0.3 {
            // P wave
            let pWaveTime = time - 0.2
            return 0.1 * exp(-pow((pWaveTime - 0.05) / 0.02, 2))
        } else if time >= 0.3 && time < 0.35 {
            return 0.0
        } else if time >= 0.35 && time < 0.4 {
            // Q
            let qSpikeTime = time - 0.35
            return -0.15 * qSpikeTime / 0.05
        } else if time >= 0.4 && time < 0.46 {
            // R up
            let qrsTime = time - 0.4
            // return 1.0
            return ((1.0 - 0.05) * qrsTime / 0.05) - 0.15
        } else if time >= 0.45 && time < 0.5 {
            // R down
            let qrsTime = time - 0.45
            return 1.3 - ((1.0 + 0.6) * qrsTime / 0.05)
        } else if time >= 0.5 && time < 0.55 {
            // S
            let sSpikeTime = time - 0.5
            return 0.3 * sSpikeTime / 0.05 - 0.3
        } else if time > 0.6 && time < 0.8 {
            // T wave
            let tWaveTime = time - 0.6
            return 0.2 * exp(-pow((tWaveTime - 0.1) / 0.05, 2))
        }
        return 0.0
    }
}

#Preview {
    ContentView()
}
