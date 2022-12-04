//
//  CustomErrorMessageView.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/29/22.
//

import SwiftUI

struct CustomErrorMessageView: View {
    @State var message: String = "Your text shown here"
    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .font(.largeTitle)
                .fontWeight(.medium)
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.center)
            Spacer()
        }
            
    }
}

struct CustomErrorMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CustomErrorMessageView()
    }
}
