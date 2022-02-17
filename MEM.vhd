
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEM is
    Port ( clk : in STD_LOGIC;
           MemWrite : in STD_LOGIC;
           Address : in STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes2 : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
component ram_write_first is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (3 downto 0);
           data_in : in STD_LOGIC_VECTOR (15 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0));
end component;
begin

    mem: ram_write_first port map(clk=>clk, we=>MemWrite, address=>Address(3 downto 0), data_in=>WriteData, data_out=>MemData);
    ALURes2<=Address;
    
end Behavioral;
