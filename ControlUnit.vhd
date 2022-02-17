
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ControlUnit is
    Port ( Instr : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is

begin
    process(Instr) 
    begin
        case(Instr) is
            when "000"=> --R-Type
                   RegDst <= '1';
                   ExtOp  <= '0'; --X
                   ALUSrc  <= '0';
                   Branch  <= '0';
                   Jump  <= '0';
                   ALUOp  <= "010"; --function tells what to do
                   MemWrite  <= '0';
                   MemtoReg  <= '0';
                   RegWrite  <= '1';
             when "001"=> --I-Type, addi
                   RegDst <= '0';
                   ExtOp  <= '1';
                   ALUSrc  <= '1';
                   Branch  <= '0';
                   Jump  <= '0';
                   ALUOp  <= "000"; --add
                   MemWrite  <= '0';
                   MemtoReg  <= '0';
                   RegWrite  <= '1';
             when "010"=> --I-Type, load word
                   RegDst <=  '0';
                   ExtOp  <= '1';
                   ALUSrc  <= '1';
                   Branch  <= '0';
                   Jump  <= '0';
                   ALUOp  <= "000"; --add
                   MemWrite  <= '0';
                   MemtoReg  <= '1';
                   RegWrite  <=  '1';
              when "011"=> --I-Type, store word
                   RegDst <=  '0'; --X
                   ExtOp  <= '1';
                   ALUSrc  <= '1';
                   Branch  <= '0';
                   Jump  <= '0';
                   ALUOp  <= "000"; --add
                   MemWrite  <= '1';
                   MemtoReg  <= '0'; --X
                   RegWrite  <=  '0';
              when "100"=> --I-Type, branch equal
                   RegDst <=  '0'; --X
                   ExtOp  <= '1';
                   ALUSrc  <= '0';
                   Branch  <= '1';
                   Jump  <= '0';
                   ALUOp  <="001"; --subtract
                   MemWrite  <= '0';
                   MemtoReg  <= '0'; --X
                   RegWrite  <= '0';
              when "101"=> --I-Type, andi
                   RegDst <=  '0';
                   ExtOp  <= '1';
                   ALUSrc  <= '1';
                   Branch  <= '0';
                   Jump  <= '0';
                   ALUOp  <="011"; --and
                   MemWrite  <= '0';
                   MemtoReg  <= '0';
                   RegWrite  <= '1';
               when "110"=> --I-Type, ori
                   RegDst <=  '0';
                   ExtOp  <= '1';
                   ALUSrc  <= '1';
                   Branch  <= '0';
                   Jump  <= '0';
                   ALUOp  <= "100"; --or
                   MemWrite  <= '0';
                   MemtoReg  <= '0';
                   RegWrite  <= '1';
               when others=> --J-Type, jump
                   RegDst <= '0'; --X
                   ExtOp  <= '0'; --X
                   ALUSrc  <= '0'; --X
                   Branch  <= '0'; --X
                   Jump  <= '1';
                   ALUOp  <= "000"; --X
                   MemWrite  <= '0';
                   MemtoReg  <= '0'; --X
                   RegWrite  <= '0';
           end case;
    end process;

end Behavioral;
