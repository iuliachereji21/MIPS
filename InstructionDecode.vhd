
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionDecode is
    Port ( clk : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);
           WriteAddress: in STD_LOGIC_VECTOR(2 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           ReadData1 : out STD_LOGIC_VECTOR (15 downto 0);
           ReadData2 : out STD_LOGIC_VECTOR (15 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           Func : out STD_LOGIC_VECTOR (2 downto 0);
           SA : out STD_LOGIC);
end InstructionDecode;

architecture Behavioral of InstructionDecode is

component register1 is
    Port ( RegWr : in STD_LOGIC;
           RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

--signal writeAddress: std_logic_vector(2 downto 0):= (others=>'0');
begin

    RegisterFile: register1 port map(RegWr=>RegWrite, RA1=>Instr(12 downto 10), RA2=>Instr(9 downto 7), WA=>WriteAddress, WD=>WriteData, CLK=>clk, RD1=>ReadData1, RD2=>ReadData2);
    
--    MUX: process(RegDst, Instr(9 downto 4))
--        begin
--            if(RegDst='0') then
--                writeAddress<=Instr(9 downto 7);
--            else writeAddress<=Instr(6 downto 4);
--            end if;
--        end process;
    extensionUnit: process(ExtOp, Instr(6 downto 0))
                    begin
                        case(ExtOp) is
                            when '1' => 
                                case (Instr(6)) is
                                    when '0' => ExtImm<=B"000000000"&Instr(6 downto 0);
                                    when others=>ExtImm<=B"111111111"&Instr(6 downto 0);
                                end case;
                            when others=> ExtImm<=B"000000000"&Instr(6 downto 0);
                        end case;
                    end process;
    SA<=Instr(3);
    Func<=Instr(2 downto 0);

end Behavioral;
