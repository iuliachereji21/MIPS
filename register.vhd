
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity register1 is
    Port ( RegWr : in STD_LOGIC;
           RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end register1;

architecture Behavioral of register1 is
type memoryarray is array (0 to 15) of std_logic_vector(15 downto 0);
signal mem: memoryarray := ("0000000000000000", --0
                                  "0000000000000001", --1 
                                  "0000000000000010", --2
                                  "0000000000000011", --3
                                  "0000000000000100", --4
                                  "0000000000000101", --5
                                  "0000000000000110", --6
                                  others => "0000000000000000" --0
                                 );

begin
    process(CLK)
        begin
            if rising_edge(CLK) then -- the write operation is synchronous
                if RegWr='1' then
                    mem(conv_integer(WA))<= WD;
                end if;  
            end if; 
        end process;
    RD1<=mem(conv_integer(RA1)); --the read operations are asynchronous
    RD2<=mem(conv_integer(RA2));
end Behavioral;
