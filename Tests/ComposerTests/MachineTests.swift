import XCTest
@testable import Composer

final class MachineTests: XCTestCase {
	static var allTests = [
		("testWaterGenerator", testWaterGenerator),
	]
	
    func testWaterGenerator() {
		let machine = Machine.waterGenerator
		machine.tick(())
		machine.buildGUI(GUIBuilder())
		XCTAssert(machine.isActive(()))
    }
}

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

// dummy stuff

struct GUIBuilder {
	func add(_ tank: FluidTank) {
		print("adding tank to gui")
	}
}

struct EnergyStorage {
	func drain() {
		print("draining energy storage")
	}
	
	func isNotEmpty() -> Bool {
		print("checking energy storage emptiness")
		return true
	}
}

struct FluidTank {
	func fill(with fluid: Fluid) {
		print("filling tank with fluid")
	}
	
	func isFull() -> Bool {
		print("checking fluid tank fullness")
		return false
	}
}

enum Fluid {
	case water
}
