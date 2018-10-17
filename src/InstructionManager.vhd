LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

ENTITY InstructionManager IS 
	PORT
	(
		Clk		: in STD_LOGIC;
		Reset		: in STD_LOGIC;
		Offset : in std_logic_vector (23 downto 0);
		nPCSel : in std_logic;
		Instruction :  OUT  std_logic_vector (31 downto 0)
	);
END InstructionManager;

ARCHITECTURE Behavioral of InstructionManager is
  --Components are in order
  ------------------------------------------------------------
  --Signal PC
  component PCreg IS   
	PORT
	(
		clk: in std_logic;
		rst: in std_logic;
		E: in std_logic_vector (31 downto 0);
		S: out std_logic_vector (31 downto 0)
	);
  END component;
  --Multiplexor 2
  component Mux2 IS
  generic (
    N : positive range 1 to 32
    );
	PORT
	(
		COM :  IN  std_logic;
		A, B :  IN  std_logic_vector (N - 1 downto 0);
		S :  OUT  std_logic_vector (N - 1 downto 0)
	);
  END component;
  
  --sign extension
  component EDS IS
  generic ( N : positive range 1 to 32 );
  
	PORT
	(
		A :  IN  std_logic_vector (N-1 downto 0);
		S :  OUT  std_logic_vector (31 downto 0)
	);
  END component;
  --Component end
  ------------------------------------------------------------
  --Signals
  signal EDSSize: integer := 24;
  signal Mux2Size: integer := 32;
  signal Amux, Bmux, Smux, Seds, PC : std_logic_vector (31 downto 0);
  
  begin
    C1: component PCreg
    port map (
      clk => Clk,
      rst => Reset,
      E => Smux,
      S => PC
    );
    C2: component Mux2
    generic map ( N => Mux2Size)
    port map (
      COM => nPCSel,
      A => Amux,
      B => Bmux,
      S => Smux
    );
    C3: component EDS
    generic map ( N => EDSSize )
    port map (
      A => Offset,
      S => Seds
    );
    --Code begins here
    ------------------------------------------------------------
    process (clk, Reset)
      begin
        if rising_edge(Clk) then
          --Amux probleme, il renvoi XXXX alors que std_logic_vector(signed(PC) + 1) renvoi bon
          Amux <= std_logic_vector(signed(PC) + 1);
          Bmux <= std_logic_vector(signed(PC) + signed (Seds) + 1);
          
        end if;
        if Reset = '1' then
          PC <= (others => '0');
          Instruction <= (others => '0');
        end if;
      end process;
end Behavioral;