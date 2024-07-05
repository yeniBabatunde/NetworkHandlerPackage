//
//  Logger.swift
//  MovieDBList
//
//  Created by Sharon Omoyeni Babatunde on 02/07/2024.
//

import Foundation

public enum LogType {
    case success
    case error
    case info
}

public class Logger {
    
   public static func printIfDebug(data: String, logType: LogType) {
#if DEBUG
        switch logType {
        case .success:
            print("🟢🟢🟢", data)
        case .error:
            print("🛑🛑🛑", data)
        case .info:
            print("🟡🟡🟡", data)
        }
#endif
    }
    
}
