//
//  ContentView.swift
//  DetectorSwiftUIDemo
//
//  Created by  YNET on 2021/10/19.
//

import SwiftUI
 

struct ContentView: View {
    @available(iOS 13.0.0, *)
    var body: some View {
        
        TabView{
            
            NavigationView{
                VStack{
                    Text("Hello, world!")
                        .padding()
                    
                    Button(action: {
                        print("点击了拍照")
                    }, label: {
                        Text("拍照")
                    })

                }
            }.tabItem { 
                Image.init(systemName: "star.fill")
                Text("蔚公子").font(.subheadline)
            }
            
            NavigationView{
                Text("这是第2个tab")
            }.tabItem { 
                Image.init(systemName: "star.fill")
                Text("莹总").font(.subheadline)
            }
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        ContentView()
    }
}

