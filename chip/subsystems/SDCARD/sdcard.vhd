library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sdcard is
port(	clk:			in std_logic;
		div_clk:		in std_logic; --between 100kHz and 400kHz
		reset:			in std_logic;
		address:		in std_logic_vector(31 downto 0);
		output:			out std_logic_vector(7 downto 0);
		busy:			out std_logic;
		
		sclk:			out std_logic;
		mosi:			out std_logic;
		miso:			in std_logic;
		ss:				out std_logic
	);
end entity sdcard;

architecture behavioural of sdcard is

	component spi is
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
	end component spi;

	type trans_state is (
				reset_state,
				dummy_count,start_dummy_send,dummy_send,
				start_init_count,init_cmd,start_init_send,init_send,
				init_read,start_init_receive,init_receive,
				load_cmd8,start_send_cmd8,send_cmd8,
				wait_for_r7,start_read_wait,read_wait,
				read_r7,start_receive_r7,receive_r7,
				idle,
				load_cmd,start_send_part,send_part,
				read_response,start_receive_response,receive_response,
				wait_data,start_read_data_part,read_data_part,
				start_read_data,read_data,
				buffer_data,error);
	signal state : trans_state;
	signal send,write_enable,busy_spi,mosi_spi,slave_select,dummy_signal : std_logic;
	signal write_in : std_logic_vector(7 downto 0);
	signal output_reg,new_output_reg,spi_output : std_logic_vector(7 downto 0);
	signal new_data,mosi_high,sig_send,send_switch,send_reset : std_logic;
	signal address_buf : std_logic_vector(31 downto 0);
	signal send_cnt,new_send_cnt : unsigned(3 downto 0);
	signal address_change,data_read : std_logic;
	signal sd_clk,divide_clock : std_logic;
begin

spi5:	spi port map(sd_clk,send,reset,write_enable,write_in,spi_output,busy_spi,sclk,mosi_spi,miso,dummy_signal);
	output <= output_reg;
	
	sd_clk <= div_clk when (divide_clock = '1') else clk;
	
	address_change <= '0' when ((address_buf and address) = address) else
				'1';
	process(address_change,data_read)
	begin
	if(address_change = '1') then
		new_data <= '1';
	else
		if(data_read = '1') then
			new_data <= '0';
		else
			new_data <= new_data;
		end if;
	end if;
	end process;
	
	send <= sig_send and send_switch;
	
	process(busy_spi,send_reset)
	begin
		if(send_reset = '1') then
			send_switch <= '1';
		else	
			if(rising_edge(busy_spi)) then
				send_switch <= '0';
			end if;
		end if;
	end process;

	mosi <= '1' when (mosi_high = '1') else
		mosi_spi;
	ss <= slave_select;
	
	process(sd_clk,reset)
	begin
		if(reset = '1') then
			output_reg <= (others => '0');
		else
			if(rising_edge(sd_clk)) then
				output_reg <= new_output_reg;
			end if;
		end if;
	end process;
	
	process(sd_clk,reset)
		begin
		if(reset = '1') then
			state <= reset_state;
			address_buf <= (others => '0');
		else
			if rising_edge(sd_clk)  then
				address_buf <= address;
				case state is 
					when reset_state =>
						if(reset = '0') then
							state <= dummy_count;
						else
							state <= reset_state;
						end if;
					when dummy_count =>
						if(send_cnt = "1000") then 
							state <= start_init_count;
						else
							state <= start_dummy_send;
						end if;
					when start_dummy_send =>
						state <= dummy_send;
					when dummy_send =>
						if(busy_spi = '0') then 
							state <= dummy_count;
						else
							state <= dummy_send;
						end if;
					when start_init_count =>
						state <= init_cmd;
					when init_cmd =>
						if(send_cnt = "0110") then
							state <= init_read;
						else
							state <= start_init_send;
						end if;
					when start_init_send =>
						state <= init_send;
					when init_send => 
						if(busy_spi = '0') then
							state <= init_cmd;
						else
							state <= init_send;
						end if;
					when init_read => 
						if(spi_output = "00000000") then
							state <= load_cmd8;
						elsif(spi_output = "11111111") then
							state <= start_init_receive;
						else
							state <= error;
						end if;
					when start_init_receive =>
						state <= init_receive;
					when init_receive =>
						if(busy_spi = '0') then
							state <= init_read;
						else
							state <= init_receive;
						end if;
					when load_cmd8 =>
						if(send_cnt = "0110") then
							state <= read_r7;
						else
							state <= start_send_cmd8;
						end if;
					when start_send_cmd8 =>
						state <= send_cmd8;
					when send_cmd8 =>
						if(busy_spi = '0') then
							state <= load_cmd8;
						else
							state <= send_cmd8;
						end if;
					when wait_for_r7 =>
						if(spi_output = "11111111") then
							state <= start_read_wait;
						elsif(spi_output = "00000000") then
							state <= read_r7;
						else
							state <= error;
						end if;
					when start_read_wait =>
						state <= read_wait;
					when read_wait =>
						if(busy_spi = '0') then
							state <= wait_for_r7;
						else
							state <= read_wait;
						end if;
					when read_r7 =>
						case send_cnt is
							when "0001" =>
								if(spi_output = "00000000") then
									state <= read_r7;
								else
									state <= error;
								end if;
							when "0010" =>
								if(spi_output = "00000000") then
									state <= read_r7;
								else
									state <= error;
								end if;
							when "0011" =>
								if(spi_output = "00000001") then
									state <= read_r7;
								else
									state <= error;
								end if;
							when "0100" =>
								if(spi_output = "10101010") then
									state <= idle;
								else
									state <= error;
								end if;
							when others =>
								state <= read_r7;
						end case;
					when start_receive_r7 =>
						state <= read_wait;
					when receive_r7 =>
						if(busy_spi = '0') then
							state <= wait_for_r7;
						else
							state <= read_wait;
						end if;
						
						-- TODO: indicate to high capacity cards that we do not support HC
						
						-- TODO: set read length
						
					when idle =>
						if(new_data = '1') then
							state <= load_cmd;
						else
							state <= idle;
						end if;
					when load_cmd =>
						if(send_cnt = "0101") then
							state <= read_response;
						else
							state <= start_send_part;
						end if;
					when start_send_part =>
						state <= send_part;
					when send_part =>
						if(busy_spi = '0') then
							state <= load_cmd;
						else
							state <= send_part;
						end if;
					when read_response =>
						if(spi_output = "00000000") then
							state <= wait_data;
						elsif(spi_output = "11111111") then
							state <= start_receive_response;
						else
							state <= error;
						end if;
					when start_receive_response =>
						state <= receive_response;
					when receive_response =>
						if(busy_spi = '0') then
							state <= read_response;
						else
							state <= receive_response;
						end if;
					when wait_data =>
						if(spi_output = "11111110") then
							state <= start_read_data;
						else
							state <= start_read_data_part;
						end if;
					when start_read_data_part =>
						state <= read_data_part;
					when read_data_part =>
						if(busy_spi = '0') then
							state <= wait_data;
						else
							state <= read_data_part;
						end if;
					when start_read_data =>
						state <= read_data;
					when read_data =>
						if(busy_spi = '0') then
							state <= buffer_data;
						else
							state <= read_data;
						end if;
					when buffer_data =>
						state <= idle;
					when error =>
						state <= error;
				end case;	
			end if;	
		end if;
	end process;
	
	process(state)
	begin
		case state is 
			when reset_state =>
				slave_select <= '1';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when dummy_count =>
				slave_select <= '1';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '0';
				new_send_cnt <= send_cnt + 1;
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when start_dummy_send =>
				slave_select <= '1';
				mosi_high <= '1';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= send_cnt;
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when dummy_send =>
				slave_select <= '1';
				mosi_high <= '1';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= send_cnt;
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when start_init_count =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when init_cmd =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '1';
				new_send_cnt <= send_cnt + 1;
				case send_cnt is
					when "0000" =>
						write_in <= "01000000";
					when "0001" =>
						write_in <= "00000000";
					when "0010" =>
						write_in <= "00000000";
					when "0011" =>
						write_in <= "00000000";
					when "0100" =>
						write_in <= "00000000";
					when "0101" =>
						write_in <= "10010101";
					when "0110" =>
						write_in <= "11111111";
					when others =>
						write_in <= "01000010";
				end case;
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when start_init_send =>
				slave_select <= '0';
				mosi_high <= '0';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= send_cnt;
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when init_send =>
				slave_select <= '0';
				mosi_high <= '0';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= send_cnt;
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when init_read =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when start_init_receive =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when init_receive =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= (others => '0');
				data_read <= '0';
				divide_clock <= '1';
			when load_cmd8 =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '1';
				new_send_cnt <= send_cnt + 1;
				case send_cnt is
					when "0000" =>
						write_in <= "01001000";
					when "0001" =>
						write_in <= (others => '0');
					when "0010" =>
						write_in <= (others => '0');
					when "0011" =>
						write_in <= "00000001";
					when "0100" =>
						write_in <= "10101010";
					when "0101" =>
						write_in <= "10000111";
					when "0110" =>
						write_in <= "11111111";
					when others =>
						write_in <= "01000010";
				end case;
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when start_send_cmd8 =>
				slave_select <= '0';
				mosi_high <= '0';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= send_cnt;
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when send_cmd8 =>
				slave_select <= '0';
				mosi_high <= '0';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= send_cnt;
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when idle =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";	
				busy <= '0';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when load_cmd =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '1';
				new_send_cnt <= send_cnt + 1;
				case send_cnt is
					when "0000" =>
						write_in <= "01010001";
					when "0001" =>
						write_in <= address(31 downto 24);
					when "0010" =>
						write_in <= address(23 downto 16);
					when "0011" =>
						write_in <= address(15 downto 8);
					when "0100" =>
						write_in <= address(7 downto 0);
					when "0101" =>
						write_in <= "11111111";
					when others =>
						write_in <= "01000010";
				end case;
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when start_send_part =>
				slave_select <= '0';
				mosi_high <= '0';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= send_cnt;
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when send_part =>
				slave_select <= '0';
				mosi_high <= '0';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= send_cnt;
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when read_response =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when start_receive_response =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when receive_response =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when wait_data =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when start_read_data_part =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when read_data_part =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when start_read_data =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when read_data =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '1';
				send_reset <= '0';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";
				busy <= '1';
				new_output_reg <= output_reg;
				data_read <= '0';
				divide_clock <= '0';
			when buffer_data =>
				slave_select <= '0';
				mosi_high <= '1';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= spi_output;
				data_read <= '1';
				divide_clock <= '0';
			when error =>
				slave_select <= '1';
				mosi_high <= '0';
				sig_send <= '0';
				send_reset <= '1';
				write_enable <= '0';
				new_send_cnt <= (others => '0');
				write_in <= "11111111";	
				busy <= '1';
				new_output_reg <= spi_output;
				data_read <= '0';
				divide_clock <= '1';
		end case;
	end process;
	
	process(sd_clk,reset)
	begin
		if(reset = '1') then
			send_cnt <= (others => '0');
		else
			if(rising_edge(sd_clk)) then
				send_cnt <= new_send_cnt;
			end if;
		end if;
	end process;

end behavioural;
