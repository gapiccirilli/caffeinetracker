//
//  LoadScreen.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 11/25/22.
//

import SwiftUI
import UIKit

struct LoadScreen: View {
    
    var body: some View {
        
        VStack {
            UIViewImageLoader()
                .frame(width: 50.0, height: 50.0)
                .padding([.bottom, .trailing], 20.0)
            Text("Loading...")
                .font(.headline)
                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.395))
            
                
        }
    }
}

struct UIViewImageLoader: UIViewRepresentable, View {
    
    
    private let images = [UIImage.scaleImageToSize(img: UIImage(named: "First")!, size: CGSize(width: 125, height: 125)), UIImage(named: "Second")!, UIImage(named: "Third")!, UIImage(named: "Fourth")!, UIImage(named: "Fifth")!, UIImage(named: "sixth")!, UIImage(named: "Seventh")!, UIImage(named: "eighth")!, UIImage(named: "Ninth")!, UIImage(named: "tenth")!, UIImage(named: "Eleventh")!, UIImage(named: "Twelfth")!]
    
    func makeUIView(context: Context) -> some UIView {
        let loadingAnimation = UIImage.animatedImage(with: images, duration: 0.8)
        
        let loadScreen = UIImageView(image: loadingAnimation!)
        
        return loadScreen
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct LoadScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadScreen()
    }
}
