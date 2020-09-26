# Composer

##### Easily compose components into entities from various sources.

Playing around with this idea right now—no guarantees, but it's an interesting concept.

For an example, check out [MachineTests.swift](Tests/ComposerTests/MachineTests.swift). An excerpt:

```swift

struct Machine: Entity {
	static let newBuilder = Self().builder
	
	@Composable(Composers.SequentialExecution.self)
	var tick: (()) -> Void
	
	@Composable(Composers.SequentialExecution.self)
	var buildGUI: (_ builder: GUIBuilder) -> Void
	
	@Composable(Composers.BooleanAnd.self)
	var isActive: (()) -> Bool
}

extension EntityBuilder where E == Machine {
	func withDefaultEnergyInput() -> Self {
		let storage = EnergyStorage()
		return self
			.$tick(storage.drain)
			.$isActive(storage.isNotEmpty)
	}
	
	func withDefaultFluidOutput(fluid: Fluid) -> Self {
		let tank = FluidTank()
		return self
			.$tick { tank.fill(with: fluid) }
			.$buildGUI { $0.add(tank) }
			.$isActive { !tank.isFull() }
	}
}

extension Machine {
	static let waterGenerator = newBuilder
		.withDefaultEnergyInput()
		.withDefaultFluidOutput(fluid: .water)
		.build()
}

```

