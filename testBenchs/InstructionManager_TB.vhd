library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.common.all;

entity InstructionManager_TB is
 port(Done: out boolean:=FALSE);
end entity InstructionManager_TB;


Architecture bench of InstructionManager_TB is
  
  signal TClk: std_logic := '0';
  signal TnPCSel, TReset  : std_logic;
  signal TInstruc : std_logic_vector (31 downto 0);
  signal TOff : std_logic_vector (23 downto 0);
  signal TDone : boolean := false;
  
  begin
    UUT: COMPONENT InstructionManager PORT MAP(
	    Clk => TClk,
      Reset => TReset,
      Offset => TOff,
      nPCSel => TnPCSel,
      Instruction => TInstruc
    );
    

  -- Generation d'une horloge
  TClk <= '0' when TDone else not TClk after 2 ns;
  -- Generation d'un reset au debut
  TReset <= '1', '0' after 3 ns;

  test_bench : process
  begin
   
        wait until TReset = '0';
        TnPCSel <= '0';
        TOff <= "000000000000000000000001";
        wait for 1 ps;
        ASSERT TInstruc = x"E3A01020" REPORT "ERROR: InstructionManager TEST 1 FAILED" -- InstructionManager Test 1
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 1 passed." SEVERITY note;
        
        TnPCSel <= '1';
        wait until TClk = '1';
        wait for 1 ps;
        ASSERT TInstruc = x"E6110000" REPORT "ERROR: InstructionManager TEST 2 FAILED (nPCSel = 1, PC + OFFSET + 1)" -- InstructionManager Test 2
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 2 passed." SEVERITY note;
        
        TOff <= "000000000000000000000010";
        TnPCSel <= '0';   
        wait until TClk = '1';
        wait for 1 ps;
        ASSERT TInstruc = x"E0822000" REPORT "ERROR: InstructionManager TEST 3 FAILED)" -- InstructionManager Test 2
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 3 passed." SEVERITY note;
        
        TnPCSel <= '1';
        wait until TClk = '1';
        wait for 1 ps;
        ASSERT TInstruc = x"BAFFFFFB" REPORT "ERROR: InstructionManager TEST 4 FAILED (nPCSel = 1, PC + OFFSET + 1)" -- InstructionManager Test 2
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 4 passed." SEVERITY note;
        
        wait until TClk = '1';
        wait for 1 ps;
        ASSERT TInstruc = x"EAFFFFF6" REPORT "ERROR: InstructionManager TEST 4 FAILED)" -- InstructionManager Test 2
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 5 passed." SEVERITY note;
        REPORT "Bench test is successfully finished." SEVERITY note;
        TDone <= TRUE;
        Wait;
  end process;
  Done <= TDone;
End BENCH;