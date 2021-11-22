--------------------------------------------------------------------------------
-- KU Leuven - ESAT/COSIC- Embedded Systems & Security
--------------------------------------------------------------------------------
-- Module Name:     registerfile - Behavioral
-- Project Name:    CD and Verif
-- Description:     The registerfile of the GameBoy
--
-- Revision     Date       Author     Comments
-- v0.1         20211022   VlJo       Initial version
--
--------------------------------------------------------------------------------

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

entity gbprocessor is
    port (
        reset : in STD_LOGIC;
        clock : in STD_LOGIC;
        instruction : in STD_LOGIC_VECTOR(7 downto 0);
        valid : in STD_LOGIC;
        probe : out STD_LOGIC_VECTOR(2*8-1 downto 0)
    );
end gbprocessor;

architecture Behavioural of gbprocessor is

    component ALU is
        port (
            A : in STD_LOGIC_VECTOR(7 downto 0);
            B : in STD_LOGIC_VECTOR(7 downto 0);
            flags_in : in STD_LOGIC_VECTOR(3 downto 0);
            Z : out STD_LOGIC_VECTOR(7 downto 0);
            flags_out : out STD_LOGIC_VECTOR(3 downto 0);
            operation: in STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    signal reset_i : STD_LOGIC;
    signal clock_i : STD_LOGIC;
    signal instruction_i : STD_LOGIC_VECTOR(7 downto 0);
    signal valid_i : STD_LOGIC;
    signal probe_i : STD_LOGIC_VECTOR(2*8-1 downto 0);

    signal regA, regB, regC, regD, regE, regF, regH, regL : STD_LOGIC_VECTOR(7 downto 0);
    signal alu_A, alu_B, alu_Z : STD_LOGIC_VECTOR(7 downto 0);
    signal alu_flags_in, alu_flags_out : STD_LOGIC_VECTOR(3 downto 0);
    signal alu_operation : STD_LOGIC_VECTOR(2 downto 0);

    signal load_regA, load_regF : STD_LOGIC;
    signal operand_selection : STD_LOGIC_VECTOR(2 downto 0);

begin
  
    -------------------------------------------------------------------------------
    -- (DE-)LOCALISING IN/OUTPUTS
    -------------------------------------------------------------------------------
    reset_i <= reset;
    clock_i <= clock;
    instruction_i <= instruction;
    valid_i <= valid;
    probe <= probe_i;


    -------------------------------------------------------------------------------
    -- COMBINATORIAL
    -------------------------------------------------------------------------------
    probe_i <= regA & regF;

    alu_A <= regA;
    alu_flags_in <= regF(7 downto 4);

    alu_operation <= instruction_i(5 downto 3);   
    operand_selection <= instruction_i(2 downto 0);

    PMUX_B: process(operand_selection, regA, regB, regC, regD, regE, regH, regL)
    begin
        case operand_selection is
            when "000" => alu_B <= regB;
            when "001" => alu_B <= regC;
            when "010" => alu_B <= regD;
            when "011" => alu_B <= regE;
            when "100" => alu_B <= regH;
            when "101" => alu_B <= regL;
            when "110" => alu_B <= x"00";
            when others => alu_B <= regA;
        end case;
    end process;
    
    load_regA <= instruction_i(7) AND not(instruction_i(6)) AND valid_i;
    load_regF <= instruction_i(7) AND not(instruction_i(6)) AND valid_i;
    

    -------------------------------------------------------------------------------
    -- ALU
    -------------------------------------------------------------------------------
    ALU_inst00: component ALU port map(
        A => alu_A,
        B => alu_B,
        flags_in => alu_flags_in,
        Z => alu_Z,
        flags_out => alu_flags_out,
        operation => alu_operation
    );


    -------------------------------------------------------------------------------
    -- COMBINATORIAL
    -------------------------------------------------------------------------------
    PREG: process(clock_i)
    begin
        if rising_edge(clock_i) then
            if reset_i = '1' then 
                regA <= x"00";
                regB <= x"01";
                regC <= x"02";
                regD <= x"03";
                regE <= x"04";
                regF <= x"00";
                regH <= x"05";
                regL <= x"06";
            else
                if load_regA = '1' then 
                    regA <= alu_Z;
                end if;
                if load_regF = '1' then 
                    regF <= alu_flags_out & "0000";
                end if;
            end if;
        end if;
    end process;


end Behavioural;
