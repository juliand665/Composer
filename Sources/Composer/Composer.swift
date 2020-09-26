public protocol Composer {
	associatedtype Value
	
	static func compose(accumulated: Value, new: @autoclosure () -> Value) -> Value
}

public protocol MonoidComposer: Composer {
	static var identity: Value { get }
}

public enum Composers {
	public enum SequentialExecution: MonoidComposer {
		public static let identity: Void = ()
		public static func compose(accumulated: Void, new: () -> Void) -> Void {
			new()
		}
	}
	
	public enum BooleanAnd: MonoidComposer {
		public static let identity = true
		public static func compose(accumulated: Bool, new: () -> Bool) -> Bool {
			accumulated && new()
		}
	}
}
