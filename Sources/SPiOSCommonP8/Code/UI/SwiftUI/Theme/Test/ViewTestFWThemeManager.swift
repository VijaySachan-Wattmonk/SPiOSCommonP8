import SwiftUI

public struct ViewTestFWThemeManager: View {
    @EnvironmentObject var themeManager: FWThemeManager

    public init() {}

    public var body: some View {
        VStack {
            Text("Root View (ViewTestFWThemeManager)")
                .foregroundColor(themeManager.text)
                .padding()
            NavigationLink("Go to Theme Demo View 1") {
                ThemeDemoView1()
            }
        }
        .background(themeManager.background)
    }
}

struct ThemeDemoView1: View {
    @EnvironmentObject var themeManager: FWThemeManager

    var body: some View {
        VStack {
            Text("Theme Demo View 1")
                .foregroundColor(themeManager.text)
                .padding()
            NavigationLink("Go to Theme Demo View 2") {
                ThemeDemoView2()
            }
        }
        .background(themeManager.background)
    }
}

struct ThemeDemoView2: View {
    @EnvironmentObject var themeManager: FWThemeManager

    var body: some View {
        VStack {
            Text("Theme Demo View 2")
                .foregroundColor(themeManager.text)
                .padding()
            NavigationLink("Go to Theme Demo View 3") {
                ThemeDemoView3()
            }
        }
        .background(themeManager.background)
    }
}

struct ThemeDemoView3: View {
    @EnvironmentObject var themeManager: FWThemeManager

    var body: some View {
        Text("Theme Demo View 3")
            .foregroundColor(themeManager.text)
            .padding()
            .background(themeManager.background)
    }
}
