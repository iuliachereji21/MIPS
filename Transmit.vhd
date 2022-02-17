library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity Transmit is
    Port ( TX_DATA : in STD_LOGIC_VECTOR (7 downto 0);
           TX_EN : in STD_LOGIC;
           BAUD_EN : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           TX : out STD_LOGIC;
           TX_RDY : out STD_LOGIC);
end Transmit;

architecture Behavioral of Transmit is
type state_type is (idle, start, bits, stop);
signal state : state_type;
signal bit_cnt: std_logic_vector(2 downto 0):="000";

begin
    process (clk, rst) --state change
    begin
        if (rst ='1') then 
            state <=idle;
        elsif (clk='1' and clk'event) then
            case state is
                when idle => 
                    if TX_EN='1' then
                        state <= start;
                    end if;
                when start => 
                    state<=bits;
                    bit_cnt<="000";
                when bits => 
                    if bit_cnt="111"  then
                        state<=stop;
                    else
                        bit_cnt<=bit_cnt+"001";
                    end if;
                when stop => 
                    state <= idle;
            end case;
        end if;
    end process process1;

    process (state) --outputs
    begin
        case state is
            when idle => TX<='1'; TX_RDY<='1';
            when start => TX<='0'; TX_RDY<='0';
            when bits => TX<=TX_DATA(conv_integer(bit_cnt)); TX_RDY<='0';
            when stop => TX<='1'; TX_RDY<='0';
        end case;
    end process process2;


end Behavioral;
