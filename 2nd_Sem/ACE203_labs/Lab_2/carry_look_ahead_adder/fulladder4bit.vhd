library ieee;
use ieee.std_logic_1164.all;

ENTITY CLA_FA IS
      PORT(
            A:   IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
            B:   IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
            Cin: IN  STD_LOGIC;
            Cout:OUT  STD_LOGIC;
            S:   OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
          );
END CLA_FA;

ARCHITECTURE structural OF CLA_FA IS

SIGNAL Prop: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL Gen: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL Car:   STD_LOGIC_VECTOR (2 DOWNTO 0);
           
COMPONENT carry_propagate_generate_unit 
is port( 
		A: IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        B: IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        G: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        P: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
END COMPONENT;

COMPONENT carry_look_ahead_unit 
is port(  
        G: IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        P: IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        Cin: IN  STD_LOGIC;
        C:   OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        C3:  OUT STD_LOGIC
        );
END COMPONENT;

COMPONENT sum_unit 
is port( 
		P:  IN   STD_LOGIC_VECTOR (3 DOWNTO 0);
		C:  IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
		Cin: IN  STD_LOGIC;
        S: OUT   STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
END COMPONENT;

BEGIN

gen_prop: carry_propagate_generate_unit PORT MAP(A,B,Gen,Prop);
                  
c_l_a: carry_look_ahead_unit
      
       PORT MAP( Cin=>Cin,
                 C3=>Cout,
                 C=>Car,
                 P=>Prop,
                 G=>Gen
               );
               
c_sum: sum_Unit
    
       PORT MAP( P=>Prop,
                 C=>Car,
                 Cin=>Cin,
                 S=>S
               );  

END structural;
                         
                    