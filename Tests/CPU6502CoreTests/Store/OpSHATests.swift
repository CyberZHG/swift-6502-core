import XCTest
@testable import CPU6502Core

final class OpSHATests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testSHAAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x9F, 0xCD, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        self.cpu.X = 0xCD
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.memory[0xABCE], 0x88)
    }
    
    func testSHAIndirectIndexed() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x93, 0x40])
        self.memory.setBytes(start: 0x0040, bytes: [0xCD, 0xAB])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        self.cpu.X = 0xCD
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.memory[0xABCE], 0x01)
    }
    
}
