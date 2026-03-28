function joint_prob = R_JointErrorLikelihood(error_vector, z_matrix, sig)


joint_prob_temp = 0;

%For a row vector such as (0, 0, 1, 0, 1, 0, 0), when a qubits is assumed to be 1(error), we add z_value(error likelihood). When a qubits is assumed to be 0(no error), we add (1-z_value).

for qubit_index = 1:7
     if(error_vector(qubit_index) == 1)
         joint_prob_temp = joint_prob_temp + log2(R_ErrorLikelihood(z_matrix(qubit_index), sig));
         %disp("positive value (2^(x<1)")
         %disp(log2(R_ErrorLikelihood(z_matrix(qubit_index), sig)))
     else
         joint_prob_temp = joint_prob_temp + log2(1- R_ErrorLikelihood(z_matrix(qubit_index), sig));
         %disp("negative value (2^(x>1)")
         %disp(log2(1-R_ErrorLikelihood(z_matrix(qubit_index), sig)))
     end
end

%\xi of our paper is this joint_prob
joint_prob = joint_prob_temp;
