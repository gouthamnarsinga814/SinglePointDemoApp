//
//  ContentView.swift
//  SinglePointDemoApp
//
//  Created by GOUTHAM on 25/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var singlePointViewModel = SinglePointViewModel()
    @State private var choices = ["All", "Alcoholic", "Non-Alcoholic"]
    @State private var choice = 0
    @State var singlePointList:[SinglePointModel] = []
    
    let columns = [
        GridItem(.flexible(minimum: 100.0, maximum: UIScreen.main.bounds.size.width - 22.0 ))
        ]
        let height: CGFloat = 80
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        
                            ForEach(singlePointList, id: \.id) { item in
                                NavigationLink(
                                    destination: SinglePointDetailsView(singlePointItem: item),
                                    label: {
                                        SinglePointListItem(item: item)
                                            .frame(height: height)
                                            .listItemTint(.gray)
                                    })
                                
                            }
                        }
                
                }
              //  .navigationBarTitle("All Cocktails")
                .navigationBarItems(leading:
                                        VStack(alignment: .center) {
                                            
                                            Text("\(choices[choice]) Cocktails")
                                                .font(.title)
                                            
                                            Picker(selection: self.$choice, label: Text("Pick One")) {
                                                ForEach(0 ..< self.choices.count) {
                                                    Text(self.choices[$0])
                                                }
                                            }
                                            .frame(width: 330)
                                            .pickerStyle(SegmentedPickerStyle())
                                            .onChange(of: choice, perform: { value in
                                                print(choice)
                                                switch choice {
                                                case 1:
                                                    self.singlePointList = singlePointViewModel.singlePointList.filter{$0.type == "alcoholic"}
                                                case 2:
                                                    self.singlePointList = singlePointViewModel.singlePointList.filter{$0.type == "non-alcoholic"}
                                                default:
                                                    self.singlePointList = singlePointViewModel.singlePointList
                                                }
                                            })
                                            
                                        }
                                        .padding()
                )
            }
        }
        .onAppear{
            singlePointViewModel.fetchSinglePointDetails()
            self.singlePointList = singlePointViewModel.singlePointList
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
