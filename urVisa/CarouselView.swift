//
//  CarouselView.swift
//  urVisa
//
//  Created for Atlys take-home assignment
//

import SwiftUI
import UIKit

struct CarouselView: View {
    let items: [CarouselItem]
    let preferredHeight: CGFloat = 250
    
    @State private var activeIdx: Int = 0
    @State private var horizontalOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let squareDimension = proxy.size.height
            let midPointX = proxy.size.width / 2
            
            VStack(spacing: 0) {
                ZStack {
                    ForEach(items.indices, id: \.self) { idx in
                        CardView(
                            data: items[idx],
                            position: idx,
                            dimension: squareDimension,
                            height: proxy.size.height,
                            midX: midPointX,
                            activeIdx: activeIdx,
                            offset: horizontalOffset
                        )
                    }
                }
                .frame(height: proxy.size.height)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            guard items.count > 1 else { return }
                            horizontalOffset = gesture.translation.width
                        }
                        .onEnded { gesture in
                            guard items.count > 1 else { return }
                            afterDragAction(
                                gesture: gesture,
                                cardDimension: squareDimension,
                                width: proxy.size.width
                            )
                        }
                    )
                
                CurrCardIndicator(
                    selectedIdx: activeIdx,
                    totalCnt: items.count
                )
                .padding(.top, 24.0)
            }
        }
        .frame(maxHeight: preferredHeight)
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            if !items.isEmpty {
                activeIdx = items.count / 2
            }
        }
    }
    
    private func afterDragAction(
        gesture: DragGesture.Value,
        cardDimension: CGFloat,
        width: CGFloat
    ) {
        
        let velocity = gesture.predictedEndTranslation.width - gesture.translation.width
        let minDistance = cardDimension * 0.2
        
        var targetIdx = activeIdx
        
        let fastSwipe = abs(velocity) > 600
        let significantDrag = abs(gesture.translation.width) > minDistance
        
        if fastSwipe {
            if velocity > 0 && activeIdx > 0 {
                targetIdx = activeIdx - 1
            } else if velocity < 0 && activeIdx < items.count - 1 {
                targetIdx = activeIdx + 1
            }
        } else if significantDrag {
            if gesture.translation.width > 0 && activeIdx > 0 {
                targetIdx = activeIdx - 1
            } else if gesture.translation.width < 0 && activeIdx < items.count - 1 {
                targetIdx = activeIdx + 1
            }
        }
        
        targetIdx = clamp(targetIdx, min: 0, max: items.count - 1)
        
        activeIdx = targetIdx
        horizontalOffset = 0
    }
    
    private func clamp(_ value: Int, min: Int, max: Int) -> Int {
        return Swift.max(min, Swift.min(max, value))
    }
}

struct CardView: View {
    let data: CarouselItem
    let position: Int
    let dimension: CGFloat
    let height: CGFloat
    let midX: CGFloat
    let activeIdx: Int
    let offset: CGFloat
    
    private var horizontalPosition: CGFloat {
        let offsetFromActive = position - activeIdx
        let spacing = CGFloat(offsetFromActive) * dimension
        return midX + spacing + offset
    }
    
    private var distanceToMidpoint: CGFloat {
        abs(horizontalPosition - midX)
    }
    
    private var zoomMultiplier: CGFloat {
        let referenceDistance = dimension * 1.5
        let normalizedDist = min(distanceToMidpoint / referenceDistance, 1.0)
        let multiplier = 1.1 - (normalizedDist * 0.25)
        return Swift.max(0.85, Swift.min(1.1, multiplier))
    }
    
    private var computedDimension: CGFloat {
        return dimension * zoomMultiplier
    }
    
    var body: some View {
        Image(data.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: computedDimension, height: computedDimension)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(alignment: .bottomLeading, content: {
                    Text(data.contryName)
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.white)
                        .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                        .background(RoundedRectangle(cornerRadius: 8.0, style: .continuous).fill(Color.gray))
                        .offset(x: -8.0)
                        .clipped()
                        .offset(y: -30)
                })
                .position(
                    x: horizontalPosition,
                    y: height / 2
                )
                .zIndex(1.0 - abs(Double(position - activeIdx)) * 0.01)
                .animation(
                    offset == 0
                        ? .linear(duration: 0.3)
                        : nil,
                    value: activeIdx
                )
    }
}

struct CurrCardIndicator: View {
    let selectedIdx: Int
    let totalCnt: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalCnt, id: \.self) { idx in
                Circle()
                    .fill(idx == selectedIdx ? Color.black : Color.gray)
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: selectedIdx)
            }
        }
    }
}

struct CarouselItem: Identifiable {
    let id = UUID()
    let imageName: String
    let contryName: String
}
