library IEEE;
use IEEE.std_logic_1164.all;

entity spi is
	port (	clk		: in	std_logic;
		send		: in	std_logic;
		reset		: in	std_logic;
		write_enable	: in 	std_logic;
		write_in	: in	std_logic_vector (7 downto 0);
		read_out	: out	std_logic_vector (7 downto 0);
		busy		: out	std_logic;
		sclk		: out	std_logic;
		mosi		: out	std_logic;
		miso		: in	std_logic;
		ss			: out	std_logic
	);
end entity spi;

architecture structural of spi is

component counter is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;
		count_out	: out	std_logic_vector (3 downto 0)
	);
end component counter;

component shift_reg is
port(	clk: 			in std_logic;
	reset:	 		in std_logic;
	enable: 		in std_logic;
	shift_in:		in std_logic;
	reg_set:		in std_logic;
	reg_write: 		in std_logic_vector (7 downto 0);
	output: 		out std_logic_vector (7 downto 0)
	);
end component shift_reg;

component control is
port(	clk:			in std_logic;
		reset:			in std_logic;
		send:			in std_logic;
		count:			in std_logic_vector(3 downto 0);
		shift:			out std_logic;
		sclk:			out std_logic;
		c_reset:		out std_logic;
		ss:			out std_logic;
		busy:			out std_logic
	);
end component control;


signal count : std_logic_vector(3 downto 0);
signal output : std_logic_vector(7 downto 0);
signal count_reset,slave_clk : std_logic;
signal shift_reset,shift,shift_in : std_logic;
signal inv_clk : std_logic;

begin
	sclk <= slave_clk;
	read_out <= output;
	mosi <= output(7);
	inv_clk <= not clk;
	process(slave_clk,reset)
	begin
		if(reset = '1') then
			shift_in <= '0';
		else
			if(rising_edge(slave_clk)) then
				shift_in <= miso;
			end if;
		end if;
	end process;
cnt1:  counter port map (slave_clk,count_reset,count);
shft1: shift_reg port map (inv_clk,reset,shift,shift_in,write_enable,write_in,output);
ctrl1: control port map (clk,reset,send,count,shift,slave_clk,count_reset,ss,busy);

end structural;
