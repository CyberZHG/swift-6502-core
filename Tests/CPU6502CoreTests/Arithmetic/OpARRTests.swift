import XCTest
@testable import CPU6502Core

final class OpARRTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testARRImmediate() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x6B, 0b11100000])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.C = false
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b01110000)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        XCTAssertEqual(self.cpu.N, false)
        XCTAssertEqual(self.cpu.V, false)
        XCTAssertEqual(self.cpu.Z, false)
        XCTAssertEqual(self.cpu.C, true)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x6B, 0b10100000])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.C = true
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b11010000)
        XCTAssertEqual(self.cpu.P, 0b11110101)
        XCTAssertEqual(self.cpu.N, true)
        XCTAssertEqual(self.cpu.V, true)
        XCTAssertEqual(self.cpu.Z, false)
        XCTAssertEqual(self.cpu.C, true)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x6B, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.C = false
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.N, false)
        XCTAssertEqual(self.cpu.V, false)
        XCTAssertEqual(self.cpu.Z, true)
        XCTAssertEqual(self.cpu.C, false)
    }
    
    func testARRImmediateBCD() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x6B, 0b11100000])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.D = true
        self.cpu.C = false
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xD0)
        XCTAssertEqual(self.cpu.P, 0b00111101)
        XCTAssertEqual(self.cpu.N, false)
        XCTAssertEqual(self.cpu.V, false)
        XCTAssertEqual(self.cpu.Z, false)
        XCTAssertEqual(self.cpu.C, true)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x6B, 0b10101010])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.D = true
        self.cpu.C = true
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x3B)
        XCTAssertEqual(self.cpu.P, 0b10111101)
        XCTAssertEqual(self.cpu.N, true)
        XCTAssertEqual(self.cpu.V, false)
        XCTAssertEqual(self.cpu.Z, false)
        XCTAssertEqual(self.cpu.C, true)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x6B, 0b01001000])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.D = true
        self.cpu.C = false
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x2A)
        XCTAssertEqual(self.cpu.P, 0b01111100)
        XCTAssertEqual(self.cpu.N, false)
        XCTAssertEqual(self.cpu.V, true)
        XCTAssertEqual(self.cpu.Z, false)
        XCTAssertEqual(self.cpu.C, false)
    }
    
}
