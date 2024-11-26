//
//  SinglePointListItem.swift
//  SinglePointDemoApp
//
//  Created by GOUTHAM on 26/11/24.
//

import SwiftUI

struct SinglePointListItem: View {
    
    var item: SinglePointModel
    
    var body: some View {
        HStack {
        VStack(alignment: .leading) {
            Text(item.name ?? "")
                .bold()
                .font(.title2)
                .foregroundColor(.black)
            
            Text(item.shortDescription ?? "")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
            
        }
                
        }
    }
}
