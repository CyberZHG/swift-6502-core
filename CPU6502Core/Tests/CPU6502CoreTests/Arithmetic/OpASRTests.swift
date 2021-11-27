import XCTest
@testable import CPU6502Core

final class OpASRTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testASRImmediate() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x4B, 0xCD])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x44)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x4B, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00110110)
    }
    
}
