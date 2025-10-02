import SwiftUI

// MARK: - Root Demo using FWNavigationManager
public struct DemoFWNavigationManager: View {
    private enum Routes1: Hashable, Codable{
    case screen1
    }
    @StateObject private var nav = FWNavigationManager()
    public init(){}
    public var body: some View {
        VStack{
            Text("Current path count=\(nav.path.count)")
            NavigationStack(path: $nav.path) {
                VStack{
                    Button {
                        nav.push(id: 1, Routes1.screen1)
                    } label: {
                        Text("Move to screen 1")
                    }
                }.navigationDestination(for: Routes1.self){ val in
                    
                    if val == .screen1{
                        Screen1()
                    }
                    else {
                        Text("else DemoFWNavigationManager")
                    }
                }
                
            }
            .environmentObject(nav)
        }
    }
}
private struct Screen1:View{
    @EnvironmentObject private var nav:FWNavigationManager
    private enum Routes2: Hashable, Codable{
    case screen2
    }
    var body: some View{
        VStack{
            Text("Screen 1")
            Button {
                nav.push(id: 2, Routes2.screen2)
            } label: {
                Text("Move to screen 2")
            }
        }.navigationDestination(for: Routes2.self){ val in
            if val == .screen2{
                Screen2()
            }else{
                Text("else Screen1")
            }
        }

    }
}
private struct Screen2:View{
    @EnvironmentObject private var nav:FWNavigationManager
    private enum Routes3: Hashable, Codable{
    case screen3
    }
    var body: some View{
        VStack{
            Text("Screen 2")
            Button {
                nav.push(id: 3, Routes3.screen3)
            } label: {
                Text("Move to screen 3")
            }
        }.navigationDestination(for: Routes3.self){ val in
            if val == .screen3{
                Screen3()
            }else{
                Text("else Screen2")
            }
        }

    }
}
private struct Screen3:View{
    @EnvironmentObject private var nav:FWNavigationManager
    var body: some View{
        VStack{
            Text("Screen 3")
            Button {
                nav.popTo(id: 1)
            } label: {
                Text("Back to screen 1")
            }
            Button {
                nav.popToRoot()
            } label: {
                Text("Back to root")
            }
        }

    }
}

#Preview {
    DemoFWNavigationManager()
}
