--================================================================================================================================
library work;
library IEEE;

use work.functions.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.ALL;

entity main_trial is
    port( 
          clk, go : in std_logic;
          D, Y : out bit_vector( M downto 0 );
          TRAINING_TESTING_FINISHED_FLAG : out std_logic := '0'
          );
end main_trial;

architecture mixed of main_trial is

    -- WEIGHT MATRICES
    signal V_WEIGHT : matrix_JI;
    signal W_WEIGHT : matrix_KJ;
    
    -- TRAIN MATRICES
    signal X_TRAIN : matrix_MI;
    signal D_TRAIN : matrix_MK;
    signal Y_TRAIN : matrix_MK;
    
    -- TEST MATRICES
    signal X_TEST : matrix_MI;
    signal D_TEST : matrix_MK;
    signal Y_TEST : matrix_MK;

--================================================================================================================================
    signal initialization_finished : boolean := FALSE;
    signal training_finished : boolean := FALSE;
    signal testing_finished : boolean := FALSE;

begin
--================================================================================================================================
    INIT : process  
    begin
    
        wait on go;

        X_TRAIN <= setTrainingInputs;
        wait on X_TRAIN;
        
        D_TRAIN <= targetOutputs( X_TRAIN );
        wait on D_TRAIN;

        X_TEST <= setTestingInputs;
        wait on X_TEST;
        
        D_TEST <= targetOutputs( X_TEST );
        wait on D_TEST;
        
        initialization_finished <= TRUE;

    end process INIT;
--================================================================================================================================
    TRAIN : process 
    
        variable error : real := ( 0.0 );
        variable error_gradient : real := ( 0.0 );
        
        -- INPUT VECTORS
        variable x_vec : vector_I;
        variable d_vec : vector_K;
        
        -- HIDDEN VECTORS
        variable h_vec : vector_J;    -- Weighted summation vector for hidden layer ( z )
        variable z_vec : vector_J;    -- Neuron vector for hidden layer 
        
        -- OUTPUT VECTORS
        variable o_vec : vector_K;    -- Weighted summation vector for output layer ( y )
        variable y_vec : vector_K;    -- Neuron vector for output layer 
        
        -- ERROR GRADIENT VECTOR
        variable delta : vector_K;    -- Change factor gauge from error gradient  
        
    -- WEIGHT MATRICES
        variable V_UPDATE : matrix_JI;
        variable W_UPDATE : matrix_KJ;
        variable V_WEIGHT_VAR : matrix_JI;
        variable W_WEIGHT_VAR : matrix_KJ;
--================================================================================================================================        
    begin
        wait until initialization_finished = TRUE;

        W_WEIGHT_VAR := setRandomMatrix_W;
        V_WEIGHT_VAR := setRandomMatrix_V;    

        -- Loop through all epochs
        for epoch_count in 0 to EPOCHS loop
            
            -- Loop through all elements in training features matrices
            for m_count in 0 to M loop
            
                -- FORWARD PASS
                x_vec := ( X_TRAIN( m_count, 0 ), X_TRAIN( m_count, 1 ), X_TRAIN( m_count, 2 ) );

                d_vec( 0 ) := D_TRAIN( m_count, 0 );
                
                h_vec := dotProduct_Vx( V_WEIGHT_VAR, x_vec );
                z_vec := sigmoidActivation_h( h_vec );

                o_vec := dotProduct_Wz( W_WEIGHT_VAR, z_vec );
                y_vec := sigmoidActivation_o( o_vec );
                
                Y_TRAIN( m_count, 0 ) <= y_vec( 0 );

                -- BACKWARD PASS
                error_gradient := d_vec( 0 ) - y_vec( 0 );
                error := error + ( error_gradient * error_gradient ) / 2.0;
 
                delta( 0 ) := error_gradient * y_vec( 0 ) * ( 1.0 - y_vec( 0 ) );
                
                W_UPDATE := changeWeights_W( z_vec, delta );                
                V_UPDATE := changeWeights_V( W_WEIGHT_VAR, z_vec, x_vec, delta );
                               
                W_WEIGHT_VAR := updateWeights_W( W_UPDATE, W_WEIGHT_VAR );
                V_WEIGHT_VAR := updateWeights_V( V_UPDATE, V_WEIGHT_VAR );
        
            end loop; -- End m loop
            
        end loop; -- End epoch loop
        
        V_WEIGHT <= V_WEIGHT_VAR; 
        W_WEIGHT <= W_WEIGHT_VAR;
        
        training_finished <= TRUE;
            
    end process TRAIN;
--================================================================================================================================
    TEST : process
    
        variable error : real := ( 0.0 );
        variable error_gradient : real := ( 0.0 );
  
        -- INPUT VECTORS
        variable x_vec : vector_I;
        variable d_vec : vector_K;
        
        -- HIDDEN VECTORS
        variable h_vec : vector_J;    -- Weighted summation vector for hidden layer ( z )
        variable z_vec : vector_J;    -- Neuron vector for hidden layer 
        
        -- OUTPUT VECTORS
        variable o_vec : vector_K;    -- Weighted summation vector for output layer ( y )
        variable y_vec : vector_K;    -- Neuron vector for output layer 
        
--================================================================================================================================

    begin

        wait until training_finished = TRUE;
          
        -- Loop through all epochs
        for epoch_count in 0 to EPOCHS loop
        
            -- Loop through all elements in training features matrices
            for m_count in 0 to M loop
            
                -- FORWARD PASS
                x_vec := ( X_TEST( m_count, 0 ), X_TEST( m_count, 1 ), X_TEST( m_count, 2 ) );
                d_vec( 0 ) := D_TEST( m_count, 0 );
                
                h_vec := dotProduct_Vx( V_WEIGHT, x_vec );
                z_vec := sigmoidActivation_h( h_vec );

                o_vec := dotProduct_Wz( W_WEIGHT, z_vec );
                y_vec := sigmoidActivation_o( o_vec );
                
                Y_TEST( m_count, 0 ) <= y_vec( 0 );
                
                error_gradient := d_vec( 0 ) - y_vec( 0 );
                error := error + ( error_gradient * error_gradient ) / 2.0;

            end loop; -- End m loop
            
        end loop; -- End epoch loop
        
        testing_finished <= TRUE;
        
    end process TEST;
--================================================================================================================================
    RESULTS : process
    begin 
        wait until testing_finished = TRUE;

        for m_count in 0 to M loop
        
            if( D_TEST( m_count, 0 ) >= 0.5 ) then D( m_count ) <= '0';
                else D( m_count ) <= '1';
            end if;
            
            if( Y_TEST( m_count, 0 ) >= 0.5 ) then Y( m_count ) <= '0';
                else Y( m_count ) <= '1';
            end if;      
              
        end loop;

        TRAINING_TESTING_FINISHED_FLAG <= '1';
        
    wait;
    end process RESULTS;
    
end mixed;
--================================================================================================================================




