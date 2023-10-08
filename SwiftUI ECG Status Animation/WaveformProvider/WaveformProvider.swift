//
//  WaveformProvider.swift
//  SwiftUI ECG Status Animation
//
//  Created by Raúl Montón Pinillos on 8/10/23.
//

import SwiftUI

class WaveformProvider {
    
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
