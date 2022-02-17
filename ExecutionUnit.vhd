

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


entity ExecutionUnit is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ExtImm : in STD_LOGIC_VECTOR (15 downto 0);
           Func : in STD_LOGIC_VECTOR (2 downto 0);
           SA : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           ALUSrc : in STD_LOGIC;
           PCOut : in STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC;
           BranchAddress : out STD_LOGIC_VECTOR (15 downto 0));
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is
signal source2: std_logic_vector(15 downto 0):= (others=>'0');
signal ALUSelect: std_logic_vector(2 downto 0):= (others=>'0');
begin

    MUX: process(RD2, ExtImm, ALUSrc)
        begin
            if ALUSrc='1' then
                source2<=ExtImm;
            else source2<=RD2;
            end if;
        end process;
        
    BranchAddress<= PCOut + ExtImm;    
    
    ALUControl: process(Func, ALUOp)
                begin
                    case (ALUOp) is
                        when("010")=> --R Type
                            ALUSelect<=Func; --I set ALUSelect to be exactly like Func
                        when("000")=> --add
                            ALUSelect<="000";
                        when("001")=> --subtract
                            ALUSelect<="001";
                        when("011")=> --and
                            ALUSelect<="100";
                        when others => --or 
                            ALUSelect<="101";
                    end case;
                end process;
      
     ALU: process(RD1, source2, SA, ALUSelect)
            variable intermediateRES: std_logic_vector(15 downto 0):= (others=>'0');
            begin
                case(ALUSelect) is
                    when "000" => --add
                        intermediateRES:= RD1 + source2;
                    when "001" => --subtract
                        intermediateRES:= RD1 - source2;
                    when "010" => --sll
                        if(SA='1') then
                            intermediateRES:= source2(14 downto 0) & '0';
                        else intermediateRES:= source2;
                        end if;
                    when "011" => --srl
                        if(SA='1') then
                            intermediateRES:= '0' & source2(15 downto 1);
                        else intermediateRES:= source2;
                        end if; 
                    when "100" => --and
                        intermediateRES:= RD1 and source2;
                    when "101" => --or
                        intermediateRES:= RD1 or source2;
                    when "110" => --xor
                        intermediateRES:= RD1 xor source2;
                    when "111" => --slt set on less than
                        if(conv_integer(RD1)<conv_integer(source2)) then
                            intermediateRES:= "0000000000000001";    
                        else intermediateRES:= "0000000000000000";
                        end if;
                end case;
                if intermediateRES="000000000000000" then
                    Zero<='1';
                else Zero<='0';
                end if;
                ALURes<=intermediateRES;
                
            end process;


end Behavioral;
