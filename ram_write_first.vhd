
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity ram_write_first is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (3 downto 0);
           data_in : in STD_LOGIC_VECTOR (15 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0));
end ram_write_first;

architecture Behavioral of ram_write_first is
type ramarray is array (0 to 15) of std_logic_vector(15 downto 0);
signal ramMemory: ramarray := ( "0010010001001000",
                                "0101111010101010",
                                "1001001000100010",
                                "1111111111111111",
                                others=> "0000000000000000");
begin
        process(clk, we, address) --ce(1) is write enable
               variable mem: ramarray;
               begin
                    if rising_edge(clk) then
                        mem:=ramMemory;
                        if we='1' then
                            ramMemory(conv_integer(address))<=data_in; --this won't happen until the end of the process so we use a variable
                            mem(conv_integer(address)):=data_in;
                        end if;
                        data_out<= mem(conv_integer(address));
                    end if;    
            end process;  

end Behavioral;
