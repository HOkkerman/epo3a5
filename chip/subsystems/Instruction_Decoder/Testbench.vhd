library IEEE;
use IEEE.std_logic_1164.ALL;

entity decoder_tb is
end entity decoder_tb;

architecture behaviour of decoder_tb is
component decoder
      port(   decoder_in : in std_logic_vector(11 downto 0);
              decoder_c : in std_logic;
              decoder_z : in std_logic;
              decoder_pc_inc : out std_logic;
              decoder_pc_ld : out std_logic;
              decoder_ibufoe : out std_logic;
              decoder_aregld : out std_logic;
              decoder_abufoe : out std_logic;
              decoder_bregld : out std_logic_vector(4 downto 0);
              decoder_bbufoe : out std_logic_vector(4 downto 0);
              decoder_alu : out std_logic_vector(2 downto 0);
              decoder_argout  : out std_logic_vector(7 downto 0));
end component;

signal decoder_in : std_logic_vector(11 downto 0);
signal decoder_c : std_logic;
signal decoder_z : std_logic;
signal decoder_pc_inc : std_logic;
signal decoder_pc_ld : std_logic;
signal decoder_ibufoe : std_logic;
signal decoder_aregld : std_logic;
signal decoder_abufoe : std_logic;
signal decoder_bregld : std_logic_vector(4 downto 0);
signal decoder_bbufoe : std_logic_vector(4 downto 0);
signal decoder_alu : std_logic_vector(2 downto 0);
signal decoder_argout: std_logic_vector(7 downto 0);

begin
lbl1: decoder port map (decoder_in, decoder_c, decoder_z, decoder_pc_inc, decoder_pc_ld, decoder_ibufoe, decoder_aregld, decoder_abufoe, decoder_bregld, decoder_bbufoe, decoder_alu, decoder_argout);
decoder_in <=     "010100001100" after 50 ns,         -- load argument w1=12
                  "011100000001" after 100 ns,        -- Store to adress R1
                  "010100001100" after 150 ns,        -- load argument w2=12
                  "011100000010" after 200 ns,        -- Store to adress R2
                  "010100000110" after 250 ns,        -- load argument barw=6
                  "011100000011" after 300 ns,        -- Store to adress R3
                  "010100001100" after 350 ns,        -- load argument x=12
                  "011100000100" after 400 ns,        -- Store to adress R4
                  "010100010000" after 450 ns,        -- load argument y=16
                  "011100000101" after 500 ns,        -- Store to adress R5
                  "010100000001" after 550 ns,        -- load argument xv=1
                  "011100000110" after 600 ns,        -- Store to adress R6
                  "010100000001" after 650 ns,        -- load argument yv=1
                  "011100000111" after 700 ns,        -- Store to adress R7
                  "010111111111" after 750 ns,        -- clear screen
                  "011100001010" after 800 ns,        -- Store to adress R10
		"000100010001" after 850 ns,	-- jump to hold (17)
		"111100000000" after 900 ns,	-- Clear c
		"011000000110" after 950 ns,	-- load inputvector R6
		"101000001000" after 1000 ns,	-- XOR 00001000
		"100011111000" after 1050 ns,	-- ADD 11111000
		"010000010111" after 1100 ns,	-- bc start
		"000100010001" after 1150 ns;	-- jump to hold (17)
decoder_c <= '0' after 0 ns;
decoder_z <= '0' after 0 ns;
end behaviour;
