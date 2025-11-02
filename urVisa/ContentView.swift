//
//  ContentView.swift
//  urVisa
//
//  Created by Sonal on 31/10/25.
//

import SwiftUI

struct ContentView: View {
    // Sample carousel items - easily extensible
    // To add more items, just add to this array - takes less than 15 mins!
    let carouselItems: [CarouselItem] = [
        CarouselItem(imageName: "img1", contryName: "Italy"),
        CarouselItem(imageName: "img2", contryName: "France"),
        CarouselItem(imageName: "img3", contryName: "Germany"),
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Atlas")
                .font(.largeTitle)
                .foregroundStyle(Color.black)
                .padding(.top, 48.0)
            
            Text("Vias on Time")
                .font(.caption)
                .foregroundStyle(Color.gray)
                .padding(.bottom, 18.0)
            
            CarouselView(items: carouselItems)
                .padding(32.0)
            
            Spacer()
                .frame(height: 200)
        }
    }
}

#Preview {
    ContentView()
}
