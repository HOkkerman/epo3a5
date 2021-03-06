library IEEE;
use IEEE.std_logic_1164.all;

----------------------------------------------------------------------------------------------------
--Buffer A (BA)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
entity buf_A is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic;
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_A;

architecture behaviour of buf_A is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe = '1') then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Buffer argument (Barg)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity buf_arg is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic;
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_arg;

architecture behaviour of buf_arg is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe = '1') then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Buffer in (Bin)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buf_in is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic_vector(4 downto 0);
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_in;

architecture behaviour of buf_in is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe(4) = '1' AND (unsigned(buf_oe(3 downto 0))=1)) then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Buffer 2 (B2)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buf_2 is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic_vector(4 downto 0);
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_2;

architecture behaviour of buf_2 is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe(4) = '1' AND (unsigned(buf_oe(3 downto 0))=2)) then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Buffer 3 (B3)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buf_3 is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic_vector(4 downto 0);
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_3;

architecture behaviour of buf_3 is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe(4) = '1' AND (unsigned(buf_oe(3 downto 0))=3)) then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Buffer 4 (B4)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buf_4 is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic_vector(4 downto 0);
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_4;

architecture behaviour of buf_4 is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe(4) = '1' AND (unsigned(buf_oe(3 downto 0))=4)) then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Buffer 5 (B5)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buf_5 is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic_vector(4 downto 0);
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_5;

architecture behaviour of buf_5 is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe(4) = '1' AND (unsigned(buf_oe(3 downto 0))=5)) then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;
 
  ----------------------------------------------------------------------------------------------------
--Buffer 6 (B6)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buf_6 is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic_vector(4 downto 0);
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_6;

architecture behaviour of buf_6 is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe(4) = '1' AND (unsigned(buf_oe(3 downto 0))=6)) then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Buffer 7 (B7)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buf_7 is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic_vector(4 downto 0);
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_7;

architecture behaviour of buf_7 is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe(4) = '1' AND (unsigned(buf_oe(3 downto 0))=7)) then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Buffer 8 (B8)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buf_8 is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic_vector(4 downto 0);
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_8;

architecture behaviour of buf_8 is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe(4) = '1' AND (unsigned(buf_oe(3 downto 0))=8)) then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Buffer 9 (B9)-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buf_9 is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic_vector(4 downto 0);
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_9;

architecture behaviour of buf_9 is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe(4) = '1' AND (unsigned(buf_oe(3 downto 0))=9)) then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Buffer 10 (B10)-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buf_10 is
port( buf_in  : in  std_logic_vector(7 downto 0);
      buf_oe  : in  std_logic_vector(4 downto 0);
      buf_out : out std_logic_vector(7 downto 0));
end entity buf_10;

architecture behaviour of buf_10 is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe(4) = '1' AND (unsigned(buf_oe(3 downto 0))=10)) then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;

----------------------------------------------------------------------------------------------------
--Instruction buffer--------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instr_buf is
port( buf_in  : in  std_logic_vector(11 downto 0);
      buf_oe  : in  std_logic;
      buf_out : out std_logic_vector(11 downto 0));
end entity instr_buf;

architecture behaviour of instr_buf is
begin
  process (buf_in, buf_oe)
  begin
    if (buf_oe = '1') then
      buf_out <= buf_in;
    else
      buf_out <= "ZZZZZZZZZZZZ";
    end if;
  end process;
end architecture;