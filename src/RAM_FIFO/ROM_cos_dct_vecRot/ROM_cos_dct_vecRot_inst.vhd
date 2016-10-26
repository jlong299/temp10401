	component ROM_cos_dct_vecRot is
		port (
			address : in  std_logic_vector(10 downto 0) := (others => 'X'); -- address
			clock   : in  std_logic                     := 'X';             -- clk
			q       : out std_logic_vector(17 downto 0)                     -- dataout
		);
	end component ROM_cos_dct_vecRot;

	u0 : component ROM_cos_dct_vecRot
		port map (
			address => CONNECTED_TO_address, --  rom_input.address
			clock   => CONNECTED_TO_clock,   --           .clk
			q       => CONNECTED_TO_q        -- rom_output.dataout
		);

