
----------- Squelette du Banc de Test pour l'exercice MinMax -------------
--Roqyun KO / 370109
--EI-SE4

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_ARITH.all;
use work.common.all;

entity Banc_ALU_tb is
 port(Done: out boolean:=FALSE);
end entity Banc_ALU_tb;

architecture BENCH of Banc_ALU_tb is
	SIGNAL TClk	: STD_LOGIC := '0';
	SIGNAL TReset : STD_LOGIC := '0';
	SIGNAL TW : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL TRA : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL TRB : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL TRW : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL TWE : STD_LOGIC;
	SIGNAL 	TOP : std_logic_vector (1 downto 0);
	SIGNAL 	TS : std_logic_vector (31 downto 0);
	SIGNAL 	TN,TZ,TC,TV : std_logic;
	SIGNAL 	TDone : boolean := false;
  
begin
  Done <= TDone;
  UUT: COMPONENT Banc_ALU PORT MAP(
	Clk	=> TClk,
	Reset => TReset,
	WE => TWE,
	RA => TRA,
	RB => TRB,
	RW => TRW,
	W => TW,
	OP => TOP,
	S => TS,
	N => TN,	
	Z => TZ,
	C => TC,
	V => TV);
	
  -- Generation d'une horloge
  TClk <= '0' when TDone else not TClk after 1 ns;
  -- Generation d'un reset au d?ut
  TReset <= '1', '0' after 1 ns;
        
  stimulus:process
  begin
    TOP <= "00";	
    wait until TReset = '0';
		wait until TClk = '0';
		TWE <= '1';
		TRW <= "0000";
		TW <= X"00000001";
    wait until TClk = '1';
  		TRW <= "0001";
		TW <= X"00000010";
    wait until TClk = '0';
    wait until TClk = '1';
		TRA <= "0000";
		TRB <= "0001";
		wait for 1 ps;
		ASSERT TS = X"11" AND TC = '0' AND TZ = '0' AND TV = '0'AND TN = '0' REPORT "NZCV test 1 failed"
		SEVERITY failure;
		REPORT "NZCV test1 passed.";
		
		wait until TClk = '0';
		TWE <= '1';
		TRW <= "0000";
		TW <= X"FFFFFFFF";
    wait until TClk = '1';
  		TRW <= "0001";
		TW <= X"00000001";
    wait until TClk = '0';
    wait until TClk = '1';
		TRA <= "0000";
		TRB <= "0001";
		wait for 1 ps;
		ASSERT TS = X"0" AND TC = '1' AND TZ = '1' AND TV = '0'AND TN = '0' REPORT "carry test 1 & zero test 1 failed"
		SEVERITY failure;
		REPORT "carry test1 & zero test1 passed.";
		
		wait until TClk = '0';
		TWE <= '1';
		TRW <= "0000";
		TW <= X"00000000";
    wait until TClk = '1';
  		TRW <= "0001";
		TW <= X"00000001";
    wait until TClk = '0';
    wait until TClk = '1';
    TOP <= "10";
		TRA <= "0000";
		TRB <= "0001";
		wait for 1 ps;
		ASSERT TS = X"FFFFFFFF" AND TC = '1' AND TZ = '0' AND TV = '0'AND TN = '1' REPORT "carry 2 & negative test 1 failed"
		SEVERITY failure;
		REPORT "carry test 2 & negative test 1 passed.";
		
		wait until TClk = '0';
		TWE <= '1';
		TRW <= "0000";
		TW <= X"80000000";
    wait until TClk = '1';
  		TRW <= "0001";
		TW <= X"80000000";
    wait until TClk = '0';
    wait until TClk = '1';
    TOP <= "00";
		TRA <= "0000";
		TRB <= "0001";
		wait for 1 ps;
		ASSERT TS = X"00000000" AND TC = '0' AND TZ = '1' AND TV = '1' AND TN = '0' REPORT "overflow 1 failed"
		SEVERITY failure;
		REPORT "overflow 1 passed.";
		
		wait until TClk = '0';
		TWE <= '1';
		TRW <= "0000";
		TW <= X"40000000";
    wait until TClk = '1';
  		TRW <= "0001";
		TW <= X"40000000";
    wait until TClk = '0';
    wait until TClk = '1';
    TOP <= "00";
		TRA <= "0000";
		TRB <= "0001";
		wait for 1 ps;
		ASSERT TS = X"80000000" AND TC = '0' AND TZ = '0' AND TV = '1' AND TN = '1' REPORT "overflow 2 & negative test 2 failed"
		SEVERITY failure;
		REPORT "overflow 2 & negative test 2 passed.";
        
		REPORT "All tests passed.";
        
    TDone <= TRUE; -- La fin du banc de teste. Le r�sultat est bon.
    WAIT; -- Boucle infinie
  end process;
end architecture BENCH;
