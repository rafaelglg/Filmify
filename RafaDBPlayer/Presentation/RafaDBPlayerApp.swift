//
//  RafaDBPlayerApp.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI

@main
struct RafaDBPlayerApp: App {
    let movieVM = MovieViewModel()
    var body: some Scene {
        WindowGroup {
            Dashboard()
                .environment(movieVM)
            
//#error("Debo añadir el composition Root y mostrar los errores si los hay con alertas")
        }
    }
}
