//
//  ContentView.swift
//  SwiftUI ECG Status Animation
//
//  Created by Raúl Montón Pinillos on 8/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var waveformProvider = WaveformProvider(windowDuration: 2.5)
    
    var body: some View {
        VStack(alignment: .leading) {
            ECGStatusBar(waveformProvider: waveformProvider)
            HStack(spacing: 48) {
                VStack(alignment: .leading){
                    row(text: "Server 0")
                    row(text: "Server 1")
                    row(text: "Server 2")
                    row(text: "Server 3")
                }
                VStack(alignment: .leading){
                    row(text: "Server 4")
                    row(text: "Server 5")
                    row(text: "Server 6")
                    row(text: "Server 7")
                }
            }
            .padding(.leading, 48)
            
            Spacer()
            
            HStack {
                Spacer()
                Button(
                    action: {
                        waveformProvider.transition(to: .ecg)
                    },
                    label: {
                        Text("OK")
                            .padding(4)
                    }
                )
                .buttonStyle(.borderedProminent)
                Button(
                    action: {
                        waveformProvider.transition(to: .torsades)
                    },
                    label: {
                        Text("Warn")
                            .padding(4)
                    }
                )
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                Button(
                    action: {
                        waveformProvider.transition(to: .dead)
                    },
                    label: {
                        Text("Error")
                            .padding(4)
                    }
                )
                .buttonStyle(.borderedProminent)
                .tint(.red)
                Spacer()
            }
            .padding()
        }
    }
    
    @MainActor @ViewBuilder func row(text: String) -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(randomStatus())
                .frame(width: 12, height: 12)
            Text(text)
        }
    }
    
    @MainActor private func randomStatus() -> Color {
        switch waveformProvider.currentWaveform {
        case .ecg:
            return .green
        case .dead:
            return .red
        case .torsades:
            if Double.random(in: 0..<1) < 0.5 {
                return .green
            }
            return .red
        }
    }
}

#Preview {
    ContentView()
}
