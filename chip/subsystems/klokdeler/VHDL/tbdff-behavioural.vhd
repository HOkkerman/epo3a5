library IEEE;
use IEEE.std_logic_1164.ALL;

architecture behavioural of tbdff is
signal clk: std_logic := '0';
signal d2: std_logic;
signal f2: std_logic;
signal reset : std_logic;
signal d2_in: std_logic;
component dff is
port (q, qbar: out std_logic; clk, d,reset: in std_logic);
end component;

begin
lbl1: dff port map(f2, d2, clk, d2_in,reset);

end behavioural; 

















