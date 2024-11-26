//
//  SinglePointDetailsView.swift
//  SinglePointDemoApp
//
//  Created by GOUTHAM on 26/11/24.
//

import SwiftUI

struct SinglePointDetailsView: View {
    
    var singlePointItem: SinglePointModel
    
    var body: some View {
        ScrollView {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(singlePointItem.name ?? "")
                .font(.title)
                .foregroundColor(.black)
                .padding(.leading,10)
            
            ClockView(minutes: singlePointItem.preparationMinutes ?? 0)
                .padding(.leading, 10)
            
            Image(singlePointItem.imageName ?? "")
                .resizable()
                .frame(height: 200.0)
                .padding(5.0)

            Text(singlePointItem.longDescription ?? "")
                .font(.callout)
                .multilineTextAlignment(.leading)
                .padding(10)

            Text("Ingredients")
                .font(.callout)
                .fontWeight(.bold)
                .padding(10)
                

            if let ingrediates = singlePointItem.ingredients {
                ForEach(ingrediates, id: \.self) { ingrediate in
                    IngredientItem(itemString: ingrediate)
                }
            }
        }
            Spacer()
        }
    }
}

struct IngredientItem: View {
    
    var itemString: String
    
    var body: some View {
        HStack {
            Image("arrow-right")
                .frame(width: 15, height: 15, alignment: .leading)
                .padding(.leading, 10)
                .fixedSize()
            
            Text(itemString)
                .font(.callout)
        }
    }
}

struct ClockView: View {
    var minutes: Int
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .frame(width: 12, height: 12, alignment: .leading)
            Text("\(minutes) Minutes")
        }
        
    }
}
