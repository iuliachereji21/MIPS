
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity instructionFetch is
    Port ( reset : in STD_LOGIC;
           we : in STD_LOGIC;
           clk : in STD_LOGIC;
           je : in STD_LOGIC;
           be : in STD_LOGIC; --branch enable, PCSrc
           ja : in STD_LOGIC_VECTOR (15 downto 0);
           ba : in STD_LOGIC_VECTOR (15 downto 0);
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pcinc : out STD_LOGIC_VECTOR (15 downto 0));
end instructionFetch;

architecture Behavioral of instructionFetch is

type ROM is array (0 to 255) of std_logic_vector(15 downto 0);
signal instructionMemory: ROM := (B"000_001_001_001_0_110",        -- 0. xor $1, $1, $1 ; put 0 in $1
                                  B"000_111_111_111_0_110",        -- 1. xor $7, $7, $7 ; put 0 in $7 meaning the result is not done
                                  "0000000000000000",              --2
                                  "0000000000000000",              --3
                                  "0000000000000000",              --4
                                  B"001_001_101_0001010",        -- 5. addi $5, $1, x ; put x (the number) in $5 here we add 10 (  2   )
                                  B"001_001_010_0000001",        -- 6. addi $2, $1, 1 ; put 1 in $2           3
                                  B"001_001_011_0000001",        -- 7. addi, $3, $1, 1 ; put 1 in $3             4
                                  B"001_001_110_0000011",        -- 8. addi, $6, $1, 3 ; put 3 in $6            5
                                  "0000000000000000",              --9
                                  "0000000000000000",              --10
                                  "0000000000000000",              --11
                                  "0000000000000000",              --12
                                  B"000_101_110_111_0_111",        -- 13. slt $7, $5, $6 ; if($5 < $6) then $7<- 1 else $7<-0, (if x<3)       6
                                  "0000000000000000",              --14
                                  "0000000000000000",              --15
                                  "0000000000000000",              --16
                                  "0000000000000000",              --17
                                  B"100_010_111_0100101",        -- 18. beq $7,$2, 14; if($7 == $2) then jump to instruction 37(14) (if $7 == 1)  7  
                                  "0000000000000000",              --19
                                  "0000000000000000",              --20
                                  "0000000000000000",              --21
                                  "0000000000000000",              --22
                                  B"000_010_011_100_0_000",        -- 23. add $4, $2, $3; $4<- $2 + $3            8
                                  B"000_011_001_010_0_000",       -- 24. add $2, $3, $1; $2<- $3              9
                                  B"000_100_001_011_0_000",        -- 25. add $3, $4, $1; $3<- $4            10
                                  B"100_110_101_0100101",        -- 26. beq $5, $6, 14; if($5 == $6) jump to 37(14)       11
                                  "0000000000000000",              --27
                                  "0000000000000000",              --28
                                  "0000000000000000",              --29
                                  "0000000000000000",              --30
                                  B"001_110_110_0000001",        -- 31. addi $6, $6, 1; $6++               12
                                  B"111_0000000010010",        -- 32. j 7; jump to instruction 18 (7)       13
                                  "0000000000000000",              --33
                                  "0000000000000000",              --34
                                  "0000000000000000",              --35
                                  "0000000000000000",              --36
                                  B"001_001_111_0000001",        -- 37. addi $7, $1, 1 ; put 1 in $7 and agorithm is done, result is in $3            14
                                  others => "0000000000000000" --end of program
                                 );
                   
signal pcAddress:std_logic_vector(15 downto 0) :=(others=>'0'); 
signal nextAddress:std_logic_vector(15 downto 0) :=(others=>'0'); 
signal pcPlus1:std_logic_vector(15 downto 0) :=(others=>'0');  
signal addrAfterBranch:std_logic_vector(15 downto 0) :=(others=>'0');  
                   
begin

    PC: process(reset,we, nextAddress, clk)
        begin
            if(reset='1') then
                pcAddress<="0000000000000000";
            elsif (rising_edge(clk)) then
                if(we='1') then
                    pcAddress<=nextAddress;
                end if;
            end if;
        end process;
        
     instruction<=instructionMemory(conv_integer(pcAddress(7 downto 0))); 
     pcPlus1<=pcAddress + 1;
     pcinc<=pcAddress + 1; --output
     
     mux1: process(be, ba, pcPlus1)
            begin
                if(be='1') then 
                    addrAfterBranch<=ba;
                else addrAfterBranch<=pcPlus1;
                end if;
            end process;
      mux2: process(addrAfterBranch, ja, je)
            begin
                if(je='1') then
                    nextAddress<=ja;
                else nextAddress<=addrAfterBranch;
                end if;
            end process;

end Behavioral;
