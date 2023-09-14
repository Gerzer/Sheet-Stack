//
//  SheetStack.swift
//  Sheet Stack
//
//  Created by Gabriel Jacoby-Cooper on 9/13/23.
//

import Combine
import SwiftUI

@available(macOS 11, iOS 14, *)
@MainActor
public final class SheetStack<SheetType>: ObservableObject where SheetType: Hashable & Identifiable {
	
	struct Handle {
		
		let observedIndex: Int
		
		fileprivate init(observedIndex: Int) {
			self.observedIndex = observedIndex
		}
		
	}
	
	private var stack: [SheetType] = []
	
	let publisher = PassthroughSubject<[SheetType?], Never>()
	
	public var top: SheetType? {
		get {
			return self.stack.last
		}
		set {
			if let newValue {
				self.push(newValue)
			} else {
				self.pop()
			}
		}
	}
	
	public var count: Int {
		get {
			return self.stack.count
		}
	}
	
	public init() { }
	
	public func push(_ sheetType: SheetType) {
		self.stack.append(sheetType)
		self.publisher.send(self.stack)
		self.objectWillChange.send()
	}
	
	public func pop() {
		if !self.stack.isEmpty {
			self.stack.removeLast()
			self.publisher.send(self.stack)
			self.objectWillChange.send()
		}
	}
	
	func register() -> Handle {
		return Handle(observedIndex: self.stack.count)
	}
	
}
