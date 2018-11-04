library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity IManTB is
 port(Done: out boolean:=FALSE);
end entity IManTB;


Architecture bench of IManTB is
  
  signal TClk, TReset, TnPCSel: std_logic;
  signal TInstruc : std_logic_vector (31 downto 0);
  signal TOff : std_logic_vector (23 downto 0);
  signal Start : boolean := false;
  
  component InstructionManager IS 
	PORT
	(
		Clk		: in STD_LOGIC;
		Reset		: in STD_LOGIC;
		Offset : in std_logic_vector (23 downto 0);
		nPCSel : in std_logic;
		Instruction :  OUT  std_logic_vector (31 downto 0)
	);
  END component;
  
  begin
    UUT: COMPONENT InstructionManager PORT MAP(
	    Clk => TClk,
      Reset => TReset,
      Offset => TOff,
      nPCSel => TnPCSel,
      Instruction => TInstruc
    );
    

  -- Generation d'une horloge
  TClk <= '0' when not Start else not TClk after 2 ns;
  -- Generation d'un reset au debut
  TReset <= '1', '0' after 2 ns;

  test_bench : process
  begin
   
   wait for 1 ns;
   
        
        Start <= true;
        TnPCSel <= '0';
        TOff <= "000000000000000000000001";
        wait until TClk = '1';
        wait for 3 ns;
        ASSERT TInstruc = x"E3A01020" REPORT "ERROR: InstructionManager TEST 1 FAILED)" -- InstructionManager Test 1
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 1 passed." SEVERITY note;
        
        TnPCSel <= '1';
        wait for 4 ns;
        ASSERT TInstruc = x"E3A02000" REPORT "ERROR: InstructionManager TEST 2 FAILED)" -- InstructionManager Test 2
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 2 passed." SEVERITY note;
        
        TOff <= "000000000000000000000010";
        TnPCSel <= '0';
        wait for 4 ns;
        ASSERT TInstruc = x"E0822000" REPORT "ERROR: InstructionManager TEST 3 FAILED)" -- InstructionManager Test 2
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 3 passed." SEVERITY note;
        
        TnPCSel <= '1';
        wait for 4 ns;
        ASSERT TInstruc = x"E2811001" REPORT "ERROR: InstructionManager TEST 4 FAILED)" -- InstructionManager Test 2
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 4 passed." SEVERITY note;
        
        wait for 4 ns;
        ASSERT TInstruc = x"E6012000" REPORT "ERROR: InstructionManager TEST 4 FAILED)" -- InstructionManager Test 2
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 4 passed." SEVERITY note;

        
  REPORT "Bench test is successfully finished." SEVERITY note;
  Done <= TRUE;
  Wait;
  end process;
  
End BENCH;