library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity FsmReceive is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           baud_en : in STD_LOGIC;
           rx : in STD_LOGIC;
           rx_data : out STD_LOGIC_VECTOR (7 downto 0);
           rx_rdy : out STD_LOGIC);
end FsmReceive;

architecture Behavioral of FsmReceive is
type state_type is (idle, start, bits, stop, waitState);
signal state : state_type;
signal bit_cnt: std_logic_vector(2 downto 0):="000";
signal baud_cnt: std_logic_vector(3 downto 0):="0000";

begin
    process (clk, rst) --state change
    begin
        if (rst ='1') then 
            state <=idle;
        elsif (clk='1' and clk'event) then
            if(baud_en='1') then   
                baud_cnt<=baud_cnt+"0001";
            end if;
            
            case state is
                when idle => 
                    if rx='0' then
                        state <= start;
                    end if;
                    baud_cnt<="0000";
                    bit_cnt<="000";
                when start => 
                    if(rx='1')then
                        state<=idle;
                    elsif baud_cnt="0111" then
                        state<=bits;
                        baud_cnt<="0000";
                    end if;
                when bits => 
                    if bit_cnt="111" and baud_cnt="1111"  then
                        state<=stop;
                        baud_cnt<="0000";
                    end if;
                    if(baud_cnt="1111") then
                        rx_data<="00000" & bit_cnt;
                        bit_cnt<=bit_cnt + "001";
                    end if;
                when stop => 
                    if(baud_cnt="1111")then
                        state <= waitState;
                        baud_cnt<="0000";
                    end if;
                when waitState=>
                    if(baud_cnt="1111") then
                        state<=idle;
                    end if;
            end case;
        end if;
    end process process1;

    process (state) --outputs
    begin
        case state is
            when idle => rx_rdy<='0';
            when start => rx_rdy<='0';
            when bits => rx_rdy<='0';
            when stop => rx_rdy<='0';
            when waitState=> rx_rdy<='1';
        end case;
    end process process2;
end Behavioral;
