import XCTest
@testable import CPU6502Core

final class OpBMITests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testBMIRelative() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x30, 0x02])
        self.cpu.PC = 0x0000
        self.cpu.N = true
        var actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0004)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x30, 0x69])
        self.cpu.PC = 0x0000
        self.cpu.N = false
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
    }
    
}
