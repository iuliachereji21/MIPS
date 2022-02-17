
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (3 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

signal instr:std_logic_vector(15 downto 0) :=(others=>'0');
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal ALUSrc: std_logic;
signal Branch: std_logic;
signal Jump: std_logic;
signal ALUOp: std_logic_vector (2 downto 0);
signal MemWrite: std_logic;
signal MemtoReg: std_logic;
signal RegWrite: std_logic;
signal zero: std_logic;
signal PCSrc: std_logic;
signal sa: std_logic;
signal pcINC:std_logic_vector(15 downto 0) :=(others=>'0');
signal jumpAddress:std_logic_vector(15 downto 0) :="0000000000000000";
signal EXTImm:std_logic_vector(15 downto 0) :="0000000000000000";
signal BranchAddress:std_logic_vector(15 downto 0) :="0000000000000000";
signal ReadData1:std_logic_vector(15 downto 0) :="0000000000000000";
signal ReadData2:std_logic_vector(15 downto 0) :="0000000000000000";
signal func:std_logic_vector(2 downto 0) :="000";
signal ALURes:std_logic_vector(15 downto 0) :="0000000000000000";
signal ALURes2:std_logic_vector(15 downto 0) :="0000000000000000";
signal WriteDataReg:std_logic_vector(15 downto 0) :="0000000000000000";
signal MemData:std_logic_vector(15 downto 0) :="0000000000000000";
signal ce:std_logic_vector(3 downto 0) :=(others=>'0');
signal output:std_logic_vector(15 downto 0) :=(others=>'0');

signal TX_EN: std_logic;
signal BAUD_EN: std_logic;
signal counter:std_logic_vector(13 downto 0) :=(others=>'0');

component MPG is
    Port ( btn : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           enable : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;
 
component ControlUnit is
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
end component;

component instructionFetch is
    Port ( reset : in STD_LOGIC;
           we : in STD_LOGIC;
           clk : in STD_LOGIC;
           je : in STD_LOGIC;
           be : in STD_LOGIC; --branch enable, PCSrc
           ja : in STD_LOGIC_VECTOR (15 downto 0);
           ba : in STD_LOGIC_VECTOR (15 downto 0);
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pcinc : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component InstructionDecode is
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
end component;

component ExecutionUnit is
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
end component;

component MEM is
    Port ( clk : in STD_LOGIC;
           MemWrite : in STD_LOGIC;
           Address : in STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component Transmit is
    Port ( TX_DATA : in STD_LOGIC_VECTOR (7 downto 0);
           TX_EN : in STD_LOGIC;
           BAUD_EN : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           TX : out STD_LOGIC;
           TX_RDY : out STD_LOGIC);
end component;

component FsmReceive is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           baud_en : in STD_LOGIC;
           rx : in STD_LOGIC;
           rx_data : out STD_LOGIC_VECTOR (7 downto 0);
           rx_rdy : out STD_LOGIC);
end component;

signal WriteAddressRegisterFile: std_logic_vector(2 downto 0) :=(others=>'0');

signal RegIF_ID: std_logic_vector(31 downto 0) :=(others=>'0');
signal RegID_EX: std_logic_vector(82 downto 0) :=(others=>'0');
signal RegEX_MEM: std_logic_vector(55 downto 0) :=(others=>'0');
signal RegMEM_WB: std_logic_vector(36 downto 0) :=(others=>'0');

signal baud_en_receive:std_logic:='0';
signal rx_data: std_logic_vector(7 downto 0) :=(others=>'0');
signal rx_rdy: std_logic:='0';

signal counter_baud_receive:std_logic_vector(9 downto 0) :=(others=>'0');

begin

    debouncer: MPG port map(btn=>btn, clk=>clk, enable=>ce);
    ssd7: SSD port map(clk=>clk, digits=> output, cat=> cat, an=> an);
    ctrlUnit: ControlUnit port map(Instr=> RegIF_ID(15 downto 13), RegDst=>RegDst, ExtOp => ExtOp, ALUSrc => ALUSrc, Branch=>Branch, Jump=>Jump, ALUOp=>ALUOp, MemWrite=>MemWrite, MemtoReg=>MemtoReg, RegWrite=>RegWrite);
    execUnit: ExecutionUnit port map(RD1=>RegID_EX(57 downto 42), RD2=>RegID_EX(41 downto 26), ExtImm=>RegID_EX(25 downto 10), Func=>RegID_EX(2 downto 0), SA=>RegID_EX(3), ALUOp=>RegID_EX(78 downto 76), ALUSrc=>RegID_EX(75), PCOut=> RegID_EX(73 downto 58), ALURes=>ALURes, Zero=>zero, BranchAddress=>BranchAddress);
    instrDecode: InstructionDecode port map(clk => clk, Instr => RegIF_ID(15 downto 0), WriteData =>WriteDataReg, WriteAddress=>RegMEM_WB(2 downto 0),  RegWrite =>RegMEM_WB(35), RegDst=>RegDst, ExtOp =>ExtOp, ReadData1 =>ReadData1, ReadData2 =>ReadData2, ExtImm =>EXTImm,  Func =>func, SA =>sa);
    InstrF: instructionFetch port map(reset=>ce(0), we=>ce(1), clk=>clk, je=>Jump, be=>PCSrc, ja=>jumpAddress, ba=>RegEX_MEM(51 downto 36), instruction=>instr, pcinc=>pcINC);
    dataMemory: MEM port map(clk => clk, MemWrite =>RegEX_MEM(53), Address =>RegEX_MEM(34 downto 19), WriteData =>RegEX_MEM(18 downto 3), MemData =>MemData, ALURes2 =>ALURes2);
    
    --WriteBack-------------------------LABORATORY 8--------------
    MUX: process(RegMEM_WB(36), RegMEM_WB(18 downto 3), RegMEM_WB(34 downto 19))
        begin 
            if(RegMEM_WB(36)='0') then
                WriteDataReg<=RegMEM_WB(18 downto 3);
            else WriteDataReg<=RegMEM_WB(34 downto 19);
            end if;
        end process;

    jumpAddress <= RegIF_ID(31 downto 30) & RegIF_ID(13 downto 0);
    PCSrc<=RegEX_MEM(52) and RegEX_MEM(35);
    output<=WriteDataReg;
    
    ----------------------------LABORATORY 9----------------------
    Pipeline: process(clk, pcINC, instr)
                begin
                    if rising_edge(clk) then
                        RegIF_ID(31 downto 16)<=pcINC;
                        RegIF_ID(15 downto 0)<= instr;
                        
                        RegID_EX(9 downto 0)<=RegIF_ID(9 downto 0);
                        RegID_EX(25 downto 10)<=ExtImm;
                        RegID_EX(41 downto 26)<=ReadData2;
                        RegID_EX(57 downto 42)<=ReadData1;
                        RegID_EX(73 downto 58)<=RegIF_ID(31 downto 16);
                        RegID_EX(74)<=RegDst;
                        RegID_EX(75)<= ALUSrc;
                        RegID_EX(78 downto 76)<=ALUOp;
                        RegID_EX(79)<=Branch;
                        RegID_EX(80)<=MemWrite;
                        RegID_EX(81)<=RegWrite;
                        RegID_EX(82)<=MemToReg;
                        
                        RegEX_MEM(2 downto 0)<=WriteAddressRegisterFile;
                        RegEX_MEM(18 downto 3)<=RegID_EX(41 downto 26);
                        RegEX_MEM(34 downto 19)<=ALURes;
                        RegEX_MEM(35)<=zero;
                        RegEX_MEM(51 downto 36)<=BranchAddress;
                        RegEX_MEM(55 downto 52)<=RegID_EX(82 downto 79);
                        
                        RegMEM_WB(2 downto 0)<=RegEX_MEM(2 downto 0);
                        RegMEM_WB(18 downto 3)<=ALURes2;
                        RegMEM_WB(34 downto 19)<=MemData;
                        RegMEM_WB(36 downto 35)<=RegEX_MEM(55 downto 54);
                        
                    end if;    
                end process;
                
     MuxWriteAddressRegisterFile: process(RegID_EX(74), RegID_EX(9 downto 4))
                                    begin
                                        if RegID_EX(74)='0' then --RegDst
                                            WriteAddressRegisterFile<=RegID_EX(9 downto 7);
                                        else WriteAddressRegisterFile<=RegID_EX(6 downto 4);
                                        end if;
                                    end process;
 ------------------------------------------LABORATORY 11 ----------------------------------------
 
    baud_generate: process(clk)
            begin
                if rising_edge(clk) then
                    if conv_integer(counter)=10514 then
                        BAUD_EN<='1';
                        counter<="00000000000000";
                    else 
                        BAUD_EN<='0';
                        counter<= counter + "00000000000001";
                    end if;
               end if;     
            end process;
 
    tx_generate: process(clk)
                begin
                    if rising_edge(clk) then
                        if ce(0)='1' then
                            TX_EN<='1';
                        elsif BAUD_EN='1' then
                            TX_EN<='0';
                        end if;
                    end if;
                end process;
                
     fsm: Transmit port map(TX_DATA=>sw(7 downto 0), TX_EN=>TX_EN, BAUD_EN=>BAUD_EN, RST=>ce(1), CLK=>clk, TX=>led(0), TX_RDY=>led(1));
   
   
 ------------------------------------------LABORATORY 12 ----------------------------------------
 
    fsmRec: FsmReceive port map(clk=>clk, rst=>ce(2),baud_en=>baud_en_receive, rx=>sw(8), rx_data=>rx_data, rx_rdy=>rx_rdy);
    
    afisare:process(clk)
            begin
                if rising_edge(clk) then
                    if(rx_rdy='1') then
                        output<="00000000" & rx_data;
                    else output<="0000000000000000";
                    end if;
                end if;
            end process;
            
     generate_baud_en_receive: process(clk)
                                begin
                                    if rising_edge(clk) then
                                        if(conv_integer(counter_baud_receive)=650) then
                                            baud_en_receive<='1';
                                            counter_baud_receive<="0000000000";
                                        else
                                            baud_en_receive<='0';
                                            counter_baud_receive <= counter_baud_receive + "0000000001";
                                        end if;
                                    end if;
                                end process;
end Behavioral;
