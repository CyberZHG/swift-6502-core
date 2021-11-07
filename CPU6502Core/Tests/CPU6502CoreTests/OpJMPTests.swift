import XCTest
@testable import CPU6502Core

final class OpJMPTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testJMPAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x4C, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xA9, 0x0A])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0xABCF)
        XCTAssertEqual(self.cpu.A, 0x0A)
        XCTAssertEqual(self.cpu.P, 0b00100000)
    }
    
    func testJMPIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x6C, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xAB, 0xCD])
        self.memory.setBytes(start: 0xCDAB, bytes: [0xA9, 0x0A])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0xCDAD)
        XCTAssertEqual(self.cpu.A, 0x0A)
        XCTAssertEqual(self.cpu.P, 0b00100000)
    }
}
