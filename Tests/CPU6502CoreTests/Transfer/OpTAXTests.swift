import XCTest
@testable import CPU6502Core

final class OpTAXTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testTAX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xAA])
        self.cpu.PC = 0x0000
        self.cpu.X = 0xAB
        self.cpu.A = 0x00
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.cpu.X, 0x00)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0xAB
        self.cpu.A = 0xFE
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.cpu.X, 0xFE)
        
        self.cpu.PC = 0x0000
        self.cpu.X = 0xAB
        self.cpu.A = 0x12
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.cpu.X, 0x12)
    }
}
