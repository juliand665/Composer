import HandyOperators

public protocol Entity {
	static var newBuilder: EntityBuilder<Self> { get }
	var builder: EntityBuilder<Self> { get }
}

public extension Entity {
	var builder: EntityBuilder<Self> { EntityBuilder(self) }
}

@dynamicMemberLookup
public struct EntityBuilder<E: Entity> {
	private var entity: E
	
	fileprivate init(_ entity: E) { self.entity = entity }
	
	public subscript<Input, Output, OutputComposer>(
		dynamicMember componentPath: WritableKeyPath<E, Composable<Input, Output, OutputComposer>>
	) -> (@escaping (Input) -> Output) -> EntityBuilder<E> {
		{ newTransform in
			self <- {
				$0.entity[keyPath: componentPath].compose(with: newTransform)
			}
		}
	}
	
	public func build() -> E { entity }
}
