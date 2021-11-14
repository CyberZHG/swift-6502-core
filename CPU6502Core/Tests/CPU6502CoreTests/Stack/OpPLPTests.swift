import XCTest
@testable import CPU6502Core

final class OpPLPTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testPHP() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x08])
        self.cpu.PC = 0x0000
        self.cpu.P = 0b10100110
        let actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b10100110)
        XCTAssertEqual(self.cpu.SP, 0xFE)
        XCTAssertEqual(self.memory[0x01FF], 0b10100110)
    }
    
    func testPLP() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x08, 0x28])
        self.cpu.PC = 0x0000
        self.cpu.P = 0b10100110
        var actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b10100110)
        XCTAssertEqual(self.cpu.SP, 0xFE)
        XCTAssertEqual(self.memory[0x01FF], 0b10100110)
        
        self.cpu.P = 0b00100000
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b10100110)
        XCTAssertEqual(self.cpu.SP, 0xFF)
    }
}
