LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Si 0 on prend A, si 1 on prend B
ENTITY Mux2 IS
  generic (
    N : positive range 1 to 32
    );
    
	PORT
	(
		COM :  IN  std_logic;
		A, B :  IN  std_logic_vector (N - 1 downto 0);
		S :  OUT  std_logic_vector (N-1 downto 0)
	);
END Mux2;

ARCHITECTURE Comportemental of Mux2 is
  begin
    
    process(A,B,COM)
      begin
        S <= B;
        if COM = '0' then
          S <= A;
        end if;
      end process;
          
end Comportemental;
