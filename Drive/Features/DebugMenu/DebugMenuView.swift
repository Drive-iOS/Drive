//
//  DebugMenuView.swift
//  Drive
//
//  Created by Amanuel Ketebo on 11/14/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import SwiftUI

struct DebugMenuView: View {
    var featureFlags: [FeatureFlag]

    var body: some View {
        NavigationView {
            List {
                ForEach(featureFlags, id: \.description) { flag in
                    DebugMenuRow(featureFlag: flag)
                }
            }.navigationBarTitle("Debug Menu")
        }
    }
}

struct DebugMenuRow: View {
    @ObservedObject var featureFlag: FeatureFlag

    var body: some View {
        Toggle(isOn: self.$featureFlag.isEnabled, label: {
            Text(featureFlag.description)
        })
    }
}

struct DebugMenuView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuView(featureFlags: FeatureFlags.all)
    }
}
