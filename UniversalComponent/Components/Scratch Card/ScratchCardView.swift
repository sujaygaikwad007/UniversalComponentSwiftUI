//
//  ScratchCardView.swift
//  UniversalComponent
//
//  Created by Sujay Gaikwad on 22/10/24.
//

import SwiftUI

struct ScratchCardView: View {
    
    @State private var points = [CGPoint]()
    var body: some View {
        ZStack {
            // The background of the card (which will be revealed)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.red)
                .frame(width: 250, height: 250)
            
            // The cover of the card
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.yellow)
                .frame(width: 250, height: 250)
                .overlay {
                    Image(systemName: "gift.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .foregroundColor(.cyan)
                }
                .mask {
                    Path { path in
                        if !points.isEmpty {
                            path.move(to: points.first!)
                            for point in points {
                                path.addLine(to: point)
                            }
                        }
                    }
                    .stroke(style: StrokeStyle(lineWidth: 100, lineCap: .round, lineJoin: .round))
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            points.append(value.location)
                        }
                )
        }
        .padding()
    }
}

struct ScratchCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScratchCardView()
    }
}
