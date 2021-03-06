library IEEE;
use IEEE.std_logic_1164.ALL;

entity klokdeler is
   port(clk     :in    std_logic;
        f2     :out   std_logic;
        f4     :out   std_logic;
        f8     :out   std_logic;
        f16    :out   std_logic;
        f32    :out   std_logic;
        f64    :out   std_logic;
        f128   :out   std_logic;
        f256   :out   std_logic;
        f512   :out   std_logic;
        f1024  :out   std_logic;
        f2048  :out   std_logic;
        f4096  :out   std_logic;
        f8192  :out   std_logic;
        f16384 :out   std_logic;
        f32768 :out   std_logic;
        f65536 :out   std_logic;
        f131072:out   std_logic;
reset: in std_logic);
end klokdeler;























