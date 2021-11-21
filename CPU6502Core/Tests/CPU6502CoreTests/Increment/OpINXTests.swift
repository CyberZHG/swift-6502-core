import XCTest
@testable import CPU6502Core

final class OpINXTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testINXImplied() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xE8])
        self.cpu.PC = 0x0000
        self.cpu.X = 0x00
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.X, 0x01)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0xFF
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.X, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0xFE
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.X, 0xFF)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
}
