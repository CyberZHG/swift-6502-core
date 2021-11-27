import XCTest
@testable import CPU6502Core

final class OpSBXTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testSBXImmediate() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xCB, 0x89])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        self.cpu.X = 0xCD
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.X, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00110111)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xCB, 0x88])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        self.cpu.X = 0xCD
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.X, 0x01)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        
        self.memory.setBytes(start: 0x0000, bytes: [0xCB, 0x8A])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xAB
        self.cpu.X = 0xCD
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.X, 0xFF)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
}
