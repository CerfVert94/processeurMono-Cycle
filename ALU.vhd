LIBRARY ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;

ENTITY ALU IS 
	PORT
	(
		OP :  IN  std_logic_vector (1 downto 0);
		A, B :  IN  std_logic_vector (31 downto 0);
		S :  OUT  std_logic_vector (31 downto 0);
		N : OUT std_logic
	);
END ALU;

ARCHITECTURE Comportemental of ALU is
  signal result: unsigned (31 downto 0) := (others => '0');
  begin
    --Resultat    
    S <= std_logic_vector(result);
    --Negatif
    N <= result(31);
   
    process (OP, A, B)
      begin
        result <= (others => '0');
        
        if OP = "00" then
          result <= unsigned(A) + unsigned(B);
     
        elsif OP = "01" then
          result <= unsigned(B);
          
        elsif OP = "10" then
          result <= unsigned(A) - unsigned(B);
		      
        elsif OP = "11" then
          result <= unsigned(A);
		  
        end if;

      end process;


end Comportemental;