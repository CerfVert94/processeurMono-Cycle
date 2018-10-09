LIBRARY ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;

ENTITY EDS IS
  generic ( N : positive range 1 to 32 );
  
	PORT
	(
		A :  IN  std_logic_vector (N-1 downto 0);
		S :  OUT  std_logic_vector (31 downto 0)
	);
END EDS;

ARCHITECTURE Comportemental of ALU is
  begin
    S <= std_logic_vector(resize(unsigned(A),S'length));
end Comportemental;