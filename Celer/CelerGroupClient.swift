//
//  CelerGroupClient.swift
//  Celer
//
//  Created by Jinyao Li on 10/17/18.
//  Copyright © 2018 Celer Network. All rights reserved.
//

import Foundation
import Celersdk

public enum CelerGroupClientError: String, Error {
  case CreateCroupClientError = "Unable to create a new group client"
  case CreateGroupError = "Unable to create a new group"
  case LeaveGroupError = "Unable to leave previous group"
  case CreateGameError = "Unable to create a new game"
  case ReceiveGroupResponseError = "Unable to receive group response"
}

public protocol CelerGroupClientCallback: class {
  func onSuccess(_ response: CelerGroupResponse)
  func onFailure(_ error: Error, _ description: String)
}


public class CelerGroupClient: NSObject, AppsdkGroupCallbackProtocol {
  var groupClient: AppsdkGroupClient? = nil
  var groupClientError: NSError?
  
  public weak var delegate: CelerGroupClientCallback?
  
  public init(serverAdress: String, keystoreJSON: String, password: String, errorHandler: @escaping (Error) -> Void) {
    super.init()
    
    groupClient = AppsdkNewGroupClient(serverAdress, keystoreJSON, password, self, &groupClientError)
    
    if (groupClientError != nil) {
      groupClient = nil
      errorHandler(CelerGroupClientError.CreateCroupClientError)
      return
    }
  }
  
  public func createGameFrom(userAddress userId: String, withStake amount: String, forNumberOfPlayers size: Int = 2, errorHandler: @escaping (Error) -> Void) {
    guard let groupClient = groupClient else {
      return
    }
    leaveGroup(userAddress: userId) { error in }
    guard let group = AppsdkGroup() else {
      errorHandler(CelerGroupClientError.CreateGroupError)
      return
    }
    do {
      group.setMyId(userId)
      group.setSize(size)
      group.setStake(amount)
      try groupClient.createPrivate(group)
    } catch {
      errorHandler(CelerGroupClientError.CreateGameError)
    }
  }
  
  public func joinGame(userAddress userId: String, withGameCode code: Int, withStake amount: String, errorHandler: @escaping (Error) -> Void) {
    guard let groupClient = groupClient else {
      return
    }
    leaveGroup(userAddress: userId) { error in }
    guard let group = AppsdkGroup() else {
      errorHandler(CelerGroupClientError.CreateGroupError)
      return
    }
    do {
      group.setMyId(userId)
      group.setCode(code)
      group.setStake(amount)
      try groupClient.joinPrivate(group)
    } catch {
      print(error.localizedDescription)
      errorHandler(CelerGroupClientError.CreateGameError)
    }
  }
  
  internal func leaveGroup(userAddress userId: String, errorHandler: @escaping (Error) -> Void) {
    guard let groupClient = groupClient else {
      return
    }
    guard let group = AppsdkGroup() else {
      errorHandler(CelerGroupClientError.CreateGroupError)
      return
    }
    do {
      group.setMyId(userId)
      try groupClient.leave(group)
    } catch {
      errorHandler(CelerGroupClientError.LeaveGroupError)
    }
  }
  
  private func parseErrorMessage() {
    
  }

  public func onRecvGroup(_ resp: AppsdkGroupResp!, err: String!) {
    if !err.isEmpty {
      delegate?.onFailure(CelerGroupClientError.ReceiveGroupResponseError, err)
    }
    if let response = resp {
      delegate?.onSuccess(CelerGroupResponse(mobileGroupResp: response))
    }
  }
}

public class CelerGroupResponse {
  internal let groupResponse: AppsdkGroupResp
  init(mobileGroupResp: AppsdkGroupResp) {
    groupResponse = mobileGroupResp
  }
  
  public func getGameCode() -> Int {
    return groupResponse.g()?.code() ?? -1
  }
  
  public func getUsers() -> String {
    return groupResponse.g()?.users() ?? ""
  }
  
  public func getRoundId() -> Int64 {
    return groupResponse.round()?.id_() ?? 0
  }
  
  public func getStake() -> String {
    return groupResponse.g()?.stake() ?? "0"
  }
}
