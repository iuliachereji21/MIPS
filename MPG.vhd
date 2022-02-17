
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity MPG is
    Port ( btn : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           enable : out STD_LOGIC_VECTOR (3 downto 0));
end MPG;

architecture Behavioral of MPG is
signal counted: std_logic_vector(15 downto 0):= (others=>'0');
signal q0: std_logic_vector(3 downto 0):= (others=>'0');
signal q1: std_logic_vector(3 downto 0):= (others=>'0');
signal q2: std_logic_vector(3 downto 0):= (others=>'0');

begin
    counter: process(clk)
            begin
                if rising_edge(clk) then
                    counted<= counted+1;
                end if;
            end process;
            
    first_register: process(clk)
            begin
                if rising_edge(clk) then
                    if counted = "1111111111111111" then
                        q0 <= btn;
                    end if;
                end if;
            end process;
     second_register: process(clk)
            begin
                if rising_edge(clk) then
                        q1 <= q0;
                end if;
            end process;
      third_register: process(clk)
            begin
                if rising_edge(clk) then
                        q2 <= q1;
                end if;
            end process;
       enable<= q1 and (not q2);

end Behavioral;
