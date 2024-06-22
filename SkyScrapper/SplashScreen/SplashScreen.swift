////
////  SplashScreen.swift
////  SkyScrapper
////
////  Created by Angélica Rodrigues on 09/06/2024.
////
//
//import SwiftUI
//
//struct SplashScreen: View {
//    @State private var animate = false
//    @State private var animateAirplane = false
//    @State private var showText = false
//
//    var body: some View {
//        ZStack {
//            Color(hex: "3ABEF9")
//                .edgesIgnoringSafeArea(.all)
//            ZStack {
//                Image(systemName: "icloud.fill")
//                    .resizable()
//                    .frame(width: 64, height: 64, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .foregroundColor(.white)
//                    .position(x: animate ? UIScreen.main.bounds.midX : UIScreen.main.bounds.midX,
//                              y: animate ? 50 : UIScreen.main.bounds.midY)
//                    .animation(.easeInOut(duration: 2), value: animate)
//                
//                Image(systemName: "cloud.fill")
//                    .resizable()
//                    .frame(width: 64, height: 64, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .foregroundColor(.white)
//                    .position(x: animate ? 50 : UIScreen.main.bounds.midX,
//                              y: animate ? UIScreen.main.bounds.midY : UIScreen.main.bounds.midY)
//                    .animation(.easeInOut(duration: 2), value: animate)
//                
//                Image(systemName: "cloud.fill")
//                    .resizable()
//                    .frame(width: 56, height: 56, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .foregroundColor(.white)
//                    .scaleEffect(x: -1, y: 1)
//                    .position(x: animate ? UIScreen.main.bounds.width - 50 : UIScreen.main.bounds.midX,
//                              y: animate ? UIScreen.main.bounds.midY : UIScreen.main.bounds.midY)
//                    .animation(.easeInOut(duration: 2), value: animate)
//                Image(systemName: "airplane")
//                    .resizable()
//                    .frame(width: 64, height: 64, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .foregroundColor(Color(hex: "373A40"))
//                    .rotationEffect(.degrees(-45))
//                    .position(x: animateAirplane ? UIScreen.main.bounds.width - 50 : 50,
//                              y: animateAirplane ? 50 : UIScreen.main.bounds.height - 50)
//                    .animation(.easeInOut(duration: 2).delay(1), value: animateAirplane)
//                Text("SkyScrapper")
//                    .font(.bold(.largeTitle)())
//                    .opacity(showText ? 1 : 0)
//                    .animation(.easeInOut(duration: 1), value: showText)
//                
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .onAppear {
//                animate = true
//                animateAirplane = true
//                showText = true
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    SplashScreen()
//}
