import HandyOperators

@propertyWrapper
public struct Composable<Input, Output, OutputComposer>
where OutputComposer: Composer, OutputComposer.Value == Output {
	public typealias Transform = (Input) -> Output
	public var wrappedValue: Transform
	public var projectedValue: Self {
		get { self }
		set { self = newValue }
	}
	
	init(wrappedValue: @escaping Transform, _: OutputComposer.Type) {
		self.wrappedValue = wrappedValue
	}
	
	init(_: OutputComposer.Type) where OutputComposer: MonoidComposer {
		self.init(wrappedValue: { _ in OutputComposer.identity }, OutputComposer.self)
	}
	
	mutating func compose(with newTransform: @escaping Transform) {
		wrappedValue = { [wrappedValue] input in
			OutputComposer.compose(
				accumulated: wrappedValue(input),
				new: newTransform(input)
			)
		}
	}
	
	// TODO: can't get this to work rn, but in theory it could replace the builder entirely
	/*
	public static subscript<EnclosingSelf>(
		_enclosingInstance entity: EnclosingSelf,
		projected valuePath: KeyPath<EnclosingSelf, Transform>,
		storage storagePath: WritableKeyPath<EnclosingSelf, Self>
	) -> (@escaping Transform) -> EnclosingSelf {
		{ newTransform in
			entity <- {
				$0[keyPath: storagePath].compose(with: newTransform)
			}
		}
	}
	*/
}
