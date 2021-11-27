import XCTest
@testable import CPU6502Core

final class OpPLATests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testPHA() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x48])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        let actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.SP, 0xFE)
        XCTAssertEqual(self.memory[0x01FF], 0xAB)
    }
    
    func testPLA() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x48, 0x68])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        var actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.SP, 0xFE)
        XCTAssertEqual(self.memory[0x01FF], 0xAB)
        
        self.cpu.A = 0
        actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.cpu.SP, 0xFF)
        XCTAssertEqual(self.cpu.A, 0xAB)
    }
}
