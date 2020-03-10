library IEEE;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

package functions is

--================================================================================================================================
-- VARIABLE_DECLARATIONS
--================================================================================================================================
    -- CONSTANTS
    constant N : integer := ( 2 - 1 );              -- Input neurons (features): x_1, x_2 --> Corresponds to x,y coordinates
    constant J : integer := ( 8 - 1 );              -- Hidden neurons 
    constant K : integer := ( 1 - 1 );              -- Output neuron
    constant I : integer := ( N + 1 );          -- Input neurons + bias (1): x_1, x_2, 1
    
    constant M      : integer := ( 400 - 1 );
    constant EPOCHS : integer := ( 5000 - 1 );
    
    constant PI     : real := ( 3.14159 );
    constant AREA   : real := ( 2.00000 );
    constant RADIUS : real := sqrt( AREA / PI );
    constant SIDE_LENGTH : integer := integer( sqrt( real( M + 1 ) ) );
                   
    constant LEARNING_RATE : real := ( 0.1 );
    constant NATURAL_LOG_BASE_E : real := ( 2.71828 );
----------------------------------------------------------------------------------------------------------------------------------
-- TYPE DEFINITIONS 

    type matrix_MI is array( 0 to M, 0 to I ) of real;        -- M x I Matrix
    type matrix_MK is array( 0 to M, 0 to K ) of real;        -- M x K Matrix
    type matrix_JI is array( 0 to J, 0 to I ) of real;
    type matrix_KJ is array( 0 to K, 0 to J ) of real;
    
    type vector_I is array( 0 to I ) of real;
    type vector_J is array( 0 to J ) of real;
    type vector_K is array( 0 to K ) of real;
----------------------------------------------------------------------------------------------------------------------------------
    
    function setRandomMatrix_W return matrix_KJ;
    function setRandomMatrix_V return matrix_JI;
    
    function setTrainingInputs return matrix_MI;   
    function setTestingInputs return matrix_MI; 
    
    function targetOutputs( mat_in : matrix_MI ) return matrix_MK;

    function dotProduct_Vx( mat_in : matrix_JI; vec_in : vector_I ) return vector_J;
    function dotProduct_Wz( mat_in : matrix_KJ; vec_in : vector_J ) return vector_K;

    function sigmoidActivation_h( vec_in : vector_J ) return vector_J;
    function sigmoidActivation_o( vec_in : vector_K ) return vector_K;  
    
    function changeWeights_W( z_vec : vector_J; delta : vector_K  ) return matrix_KJ;
    function changeWeights_V( mat_in : matrix_KJ; z_vec : vector_J; x_vec : vector_I; delta : vector_K ) return matrix_JI;
      
    function updateWeights_W( mat_delta, mat_in : matrix_KJ ) return matrix_KJ;
    function updateWeights_V( mat_delta, mat_in : matrix_JI ) return matrix_JI;
   
end package functions;

-----------------------------------------------------------------------------------------------------------------------------
package body functions is

--================================================================================================================================
-- FUNCTION_DEFINITIONS
--================================================================================================================================
-- DOT_PRODUCT
    
    function dotProduct_Vx( mat_in : matrix_JI; vec_in : vector_I ) return vector_J is variable vec_out : vector_J;
        variable summation : real := ( 0.0 );
    begin
        for row in 0 to J loop
            summation := 0.0;
            for col in 0 to I loop
                summation := mat_in( row, col ) * vec_in( col ) + summation;
            vec_out( row ) := summation;
            end loop;
        end loop;
        return( vec_out );
    end function; 

    function dotProduct_Wz( mat_in : matrix_KJ; vec_in : vector_J ) return vector_K is variable vec_out : vector_K;
        variable summation : real := ( 0.0 );
    begin
        for row in 0 to K loop
            summation := 0.0;
            for col in 0 to J loop
                summation := mat_in( row, col ) * vec_in( col ) + summation;
            vec_out( row ) := summation;
            end loop;
        end loop;
        return( vec_out );
    end function;   
----------------------------------------------------------------------------------------------------------------------------------
-- SIGMOID_ACTIVATION

    function sigmoidActivation_h( vec_in : vector_J  ) return vector_J is variable vec_out : vector_J;
        variable r_tmp_1 : real;
    begin
        for row in 0 to J loop
            r_tmp_1 := EXP( -1.0 * vec_in( row ) );
            vec_out( row ) := 1.0 / ( 1.0 + r_tmp_1 );
        end loop;
        return( vec_out );
    end function; 

    function sigmoidActivation_o( vec_in : vector_K ) return vector_K is variable vec_out : vector_K;
        variable r_tmp_1 : real;
    begin
        for row in 0 to K loop
            r_tmp_1 := EXP( -1.0 * vec_in( row ) );
            vec_out( row ) := 1.0 / ( 1.0 + r_tmp_1 );
        end loop;
        return( vec_out );
    end function; 
----------------------------------------------------------------------------------------------------------------------------------
-- GET_WEIGHT_CHANGES

    function changeWeights_W( z_vec : vector_J; delta : vector_K ) return matrix_KJ is variable mat_out : matrix_KJ;
    begin
        for row in 0 to K loop
            for col in 0 to J loop
                mat_out( row, col ) := LEARNING_RATE * delta( row ) * z_vec( col );
            end loop;
        end loop;
        return( mat_out );
    end function;   
    
    function changeWeights_V( mat_in : matrix_KJ; z_vec : vector_J; x_vec : vector_I; delta : vector_K ) return matrix_JI is variable mat_out : matrix_JI;
        variable summation : real;
    begin
        for row in 0 to J loop
            summation := delta( 0 ) * mat_in( 0, row );
            for col in 0 to I loop
                mat_out( row, col ) := LEARNING_RATE * z_vec( row ) * ( 1.0 - z_vec( row ) ) * x_vec( col ) * summation;
            end loop;
        end loop;
        return( mat_out );
    end function;   
----------------------------------------------------------------------------------------------------------------------------------
-- UPDATE_WEIGHTS

    function updateWeights_W( mat_delta, mat_in : matrix_KJ ) return matrix_KJ is variable mat_out : matrix_KJ;
    begin
        for row in 0 to K loop
            for col in 0 to J loop
                mat_out( row, col ) := mat_delta( row, col ) + mat_in( row, col );
            end loop;
        end loop;
        return( mat_out );
    end function;  
    
    function updateWeights_V( mat_delta, mat_in : matrix_JI ) return matrix_JI is variable mat_out : matrix_JI;
    begin
        for row in 0 to J loop
            for col in 0 to I loop
                mat_out( row, col ) := mat_delta( row, col ) + mat_in( row, col );
            end loop;
        end loop;
        return( mat_out );
    end function;
--================================================================================================================================
-- GET TARGET OUTPUTS

    function targetOutputs( mat_in : matrix_MI ) return matrix_MK is variable mat_out : matrix_MK;
        variable r_tmp_1 : real;                    
    begin
        for i in 0 to M loop
            r_tmp_1 := sqrt( ( mat_in( i, 0 ) * mat_in( i, 0 ) ) + ( mat_in( i, 1 ) * mat_in( i, 1 ) ) );
            if( r_tmp_1 < RADIUS ) then mat_out( i, 0 ) := 1.0;
                else mat_out( i, 0 ) := 0.0;
            end if;
        end loop;                             
        return( mat_out );
    end function; 
--================================================================================================================================       
    -- Return 1 x 8 matrix of random weights for training
    function setRandomMatrix_W return matrix_KJ is variable mat_out : matrix_KJ;
        variable r_tmp_1 : real;
        variable seed1 : integer := 7;
        variable seed2 : integer := 7532;

    begin
        for row in 0 to K loop
            for col in 0 to J loop
                uniform( seed1, seed2, r_tmp_1 ); -- returns pseudo-random number between 0.0 and 1.0
                mat_out( row, col ) := ( r_tmp_1 * 20.0 ) - 10.0; -- rand_float * ( max - min ) + min
            end loop;
        end loop;
        return( mat_out );
    end function; 
    
    -- Return 8 x 3 matrix of random weights for training
    function setRandomMatrix_V return matrix_JI is variable mat_out : matrix_JI; 
        variable r_tmp_1 : real;
        variable seed1 : integer := 2;
        variable seed2 : integer := 235;
    begin
        for row in 0 to J loop
            for col in 0 to I loop
                uniform( seed1, seed2, r_tmp_1 ); -- returns pseudo-random number between 0.0 and 1.0
                mat_out( row, col ) := ( r_tmp_1 * 20.0 ) - 10.0; -- rand_float * ( max - min ) + min
            end loop;
        end loop;
        return( mat_out );
    end function; 
--================================================================================================================================
    function setTrainingInputs return matrix_MI is variable mat_out : matrix_MI;
        variable r_tmp_1 : real;
        variable seed1 : integer := 28;
        variable seed2 : integer := 325;
    begin
        for row in 0 to M loop
            for col in 0 to I loop
                if( col = 2 ) then mat_out( row, col ):= 1.0;
                    else
                        uniform( seed1, seed2, r_tmp_1 ); -- returns pseudo-random number between 0.0 and 1.0
                        mat_out( row, col ) := ( r_tmp_1 * 2.0 ) - 1.0; -- rand_float * ( max - min ) + min
                end if;
            end loop;
        end loop;

        return( mat_out );
    end function; 
    
    function setTestingInputs return matrix_MI is variable mat_out : matrix_MI;

        variable increment : real := ( 0.0 );  
        variable step_size : real := 2.0 / real( SIDE_LENGTH - 1 );  

    begin
    
        for row in 0 to M loop

            if( ( ( row mod SIDE_LENGTH ) = 0 ) and ( row > 0 ) ) then increment := increment + 1.0;
            end if;
            
            mat_out( row, 0 ) := -1.0 + step_size * real( row mod SIDE_LENGTH );
            mat_out( row, 1 ) :=  1.0 - step_size * increment;
            mat_out( row, 2 ) :=  1.0;

        end loop;

        return( mat_out );
    end function; 
    
end package body functions;
