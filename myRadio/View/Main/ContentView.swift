//
//  ContentView.swift
//  myRadio
//
//  Created by VVHALITI on 2020.
//  Copyright © 2020 VVHALITI. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import SystemConfiguration


struct ContentView: View {
    
    
    private let reach = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    
    // MARK: - PROPERTIES
    @EnvironmentObject var stationListViewModel: StationListModelView
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    // MARK: - VIEW
    @State var isDrawerOpen: Bool = false
    @State var show = false
    var body: some View {
        ZStack{
            NavigationView{
                ZStack(alignment: .bottom) {
                    //Color(hex: "ffe976").edgesIgnoringSafeArea(.all)
                    Color.orange.opacity(0.2).edgesIgnoringSafeArea(.all)
                    VStack(alignment: .center, spacing: 0) {
                        if stationListViewModel.favoriteStationList.count > 0 {
                            FavoriteListView()
                                .padding(.bottom, 10)
                        }
                        Divider()
                        
                        if self.stationListViewModel.dataIsLoading == false{
                            FilterView()
                           .padding(.bottom, 10)
                        }
                        
                        Divider()
                        
                        StationListView()
                        
                        if showBannerAds {
                            BannerVC()
                                .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height, alignment: .center)
                        }
                        
                        if(playerViewModel.didSet) {
                            VStack (alignment: .center, spacing: 0, content: {
                                ControllerView()
                                    .environmentObject(stationListViewModel)
                                
                            })
                        }
                        
                    } // VStack
                   
                    GeometryReader{_ in
                        HStack{
                            myMenu().offset(x : self.show ? 0 : -UIScreen.main.bounds.width)
                                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
                            Spacer()
                        }
                    }.background(Color.black.opacity(self.show ? 0.5 : 0 ))
                 // ZStack
                }.navigationBarTitle("Radio Player" , displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: {
                        self.show.toggle()
                    }, label: {
                        
                        if self.show{
                            Image(systemName: "arrow.left").font(.body).foregroundColor(.black)
                        }
                        else{
                            Image("menu")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .colorMultiply(.orange)
                        }
                       
                    })
                )
            }// Navigation
        }.onAppear{
            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(self.reach! , &flags)
            
            if self.isNetwork(with: flags){
                print("InterNet")
            }
            else{
                print ("No Inter Net")
            }
        }
    }
    func isNetwork(with flag :SCNetworkReachabilityFlags) -> Bool {
        let isreachable = flag.contains(.reachable)
        let neededconection = flag.contains(.connectionRequired)
        let connectionauto = flag.contains(.connectionOnDemand) || flag.contains(.connectionOnTraffic)
        
        let connectWitoutInteraction = connectionauto && !flag.contains(.interventionRequired)
        return isreachable && (!neededconection || connectWitoutInteraction)
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StationListModelView())
            .environmentObject(PlayerViewModel())
    }
}
struct myMenu : View {
    
    @EnvironmentObject var stationListViewModel: StationListModelView
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var showSleeperView: Bool = false
    @State private var showFvrt: Bool = false
    @State private var aboutBtn: Bool = false
    @State private var moreApps: Bool = false
    @State private var showRecordingsModal: Bool = false
    var body: some View {
        VStack(spacing : 25){
            
            Button(action: {
                self.showRecordingsModal.toggle()

            })
            {
                VStack(spacing : 8){
                    Image("record")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width : 100 , height: 100)
                    Text("Recordings")
                }
                
            }.sheet(isPresented: $showRecordingsModal) {
                RecordingsView()
                .environmentObject(self.playerViewModel)
            }
            
            
            Button(action: {
                self.showSleeperView.toggle()
            })
            {
                VStack(spacing : 8){
                    Image("sleep")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width : 50 , height: 50)
                    Text("Sleep Timer")
                    
                }
                
            }.sheet(isPresented: $showSleeperView) {
                SleepView()
                .environmentObject(self.playerViewModel)
            }
            
            
            Button(action: {
                self.aboutBtn.toggle()
            })
            {
                VStack(spacing : 8){
                    Image("about")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width : 100 , height: 100)
                    Text("About")
                }
                
            }.sheet(isPresented: $aboutBtn) {
                About()
              .environmentObject(self.playerViewModel)
            }
            Button(action: {
                self.moreApps.toggle()
               guard let google = URL(string: "https://www.google.com/"),
                   UIApplication.shared.canOpenURL(google) else {
                   return
               }
               UIApplication.shared.open(google,
                                         options: [:],
                                         completionHandler: nil)
            })
            {
                VStack(spacing : 8){
                    Image("more")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width : 100 , height: 100)
                    Text("More Apps")
                }
                
            }
            Spacer(minLength: 15)
        }.padding(35)
            .background(Color("ColorOffWhiteAdaptive")).edgesIgnoringSafeArea(.bottom)
            .foregroundColor(.black)
    }
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
