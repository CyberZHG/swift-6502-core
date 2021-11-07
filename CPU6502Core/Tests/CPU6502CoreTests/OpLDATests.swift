import XCTest
@testable import CPU6502Core

final class OpLDATests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testLDAImmediate() throws {
        self.memory.setBytes(start: 0x0080, bytes: [0xA9, 0x0A])
        self.cpu.PC = 0x0080
        var actualCycle = self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0082)
        XCTAssertEqual(self.cpu.A, 0x0A)
        XCTAssertEqual(self.cpu.P, 0b00100000)
        
        self.memory.setBytes(start: 0x0080, bytes: [0xA9, 0x00])
        self.cpu.PC = 0x0080
        actualCycle = self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0082)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00100010)
        XCTAssertEqual(self.cpu.Z, true)
        
        self.memory.setBytes(start: 0x0080, bytes: [0xA9, 0xFF])
        self.cpu.PC = 0x0080
        actualCycle = self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0082)
        XCTAssertEqual(self.cpu.A, 0xFF)
        XCTAssertEqual(self.cpu.P, 0b10100000)
        XCTAssertEqual(self.cpu.N, true)
    }
    
}
