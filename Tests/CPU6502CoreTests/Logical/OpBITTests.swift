import XCTest
@testable import CPU6502Core

final class OpBITTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testBITZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x24, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0b11000000
        var actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b11000000)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x24, 0x02, 0b01000000])
        self.cpu.PC = 0x0000
        self.cpu.A = 0b11000000
        actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b11000000)
        XCTAssertEqual(self.cpu.P, 0b01110100)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x24, 0x02, 0b10000000])
        self.cpu.PC = 0x0000
        self.cpu.A = 0b11000000
        actualCycle = try self.cpu.execute(memory, maxCycle: 3)
        XCTAssertEqual(actualCycle, 3)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b11000000)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
    func testBITAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x2C, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0b11111110])
        self.cpu.PC = 0x0000
        self.cpu.A = 0b11000000
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0b11000000)
        XCTAssertEqual(self.cpu.P, 0b11110100)
    }
    
}
