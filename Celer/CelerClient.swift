//
//  CelerClient.swift
//  Celer
//
//  Created by Jinyao Li on 10/16/18.
//  Copyright © 2018 Celer Network. All rights reserved.
//

import Foundation
import Celersdk

public typealias SessionIdentifier = String

public enum BalanceViewOption: Int {
  case local = 1
  case localAndOnChain = 2
}

public enum CelerClientError: String, Error {
  case SessionInitialization
}

public protocol CelerClientDelegate: class {
  func didReceiveNewStatus(newState: Int)
  func didReceiveGameState(data: Data)
}

public class CelerClient: NSObject {
  
  public weak var delegate: CelerClientDelegate?
  
  var client: CelersdkClient? = nil
  
  let capp = CelersdkCApp()
  
  public init(keyStore: String, password: String, config: String) throws {
    var error: NSError?
 
    client = CelersdkNewClient(keyStore, password, config, &error)
    
    if let error = error {
      client = nil
      throw error
    }
  }
  
  public func joinCeler(basedOnToken type: String, providing clientDepositAmount: String, requiring serverDepositAmount: String) throws {
    do {
      try client?.joinCeler(type,
                            amtWei: clientDepositAmount,
                            peerAmtWei: serverDepositAmount)
    } catch {
      throw error
    }
  }
  
  public func avaibleReceivingAmount(for address: String) throws -> String {
    do {
      return try client?.hasJoinedCeler(address) ?? "0"
    } catch {
      throw error
    }
  }
  
  public func pay(receiver address: String, amount: String) throws {
    do {
      try client?.sendPay(address, amtWei: amount)
    } catch {
      throw error
    }
  }
  
  public func getAvailableBalance(_ option: BalanceViewOption = .local) -> String {
    return client?.getBalance(option.rawValue)?.available() ?? "0"
  }
  
  public func getPendingBalance(_ option: BalanceViewOption = .local) -> String {
    return client?.getBalance(option.rawValue)?.pending() ?? "0"
  }
  
  public func getTotalBalance(_ option: BalanceViewOption = .local) -> String {
    return client?.getBalance(option.rawValue)?.total() ?? "0"
  }
  
  public func initNewSession(groupResponse: CelerGroupResponse, errorHandler: @escaping (Error) -> Void) -> SessionIdentifier {
    guard let capp = capp else {
      errorHandler(CelerClientError.SessionInitialization)
      return "Empty CAPP"
    }
    capp.setCallback(self)
    let playerAddresses = groupResponse.getUsers().components(separatedBy: ",")
    if playerAddresses.count == 1 {
      return ""
    }

    let constructor = "000000000000000000000000\(playerAddresses[0].dropFirst(2))000000000000000000000000\(playerAddresses[1].dropFirst(2))0000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000003"

    do {
      guard let sessionIdentifier = try client?.newCAppSession(capp, constructor: constructor, nonce: groupResponse.getRoundId()) else {
        return "ErrorIndentifier"
      }
      return sessionIdentifier
    } catch {
      print(error.localizedDescription)
      return "\(error.localizedDescription)"
    }
  }
  
  public func sendState(sessionId: String, opponentAddress: String, state: Data) {
    do {
      try client?.sendCAppState(sessionId, dst: opponentAddress, state: state)
    } catch {
      NSLog("Error: \(error.localizedDescription)")
    }
  }
}

extension CelerClient: CelersdkCAppCallbackProtocol {
  public func onReceiveState(_ state: Data!) -> Bool {
    guard let state = state else {
      return false
    }
    delegate?.didReceiveGameState(data: state)
    return true
  }

  public func onStatusChanged(_ status: Int) {

  }
}

