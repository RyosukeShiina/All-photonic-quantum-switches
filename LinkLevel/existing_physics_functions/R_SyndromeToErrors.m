function error_matrix = R_SyndromeToErrors(syndrome_vec, single_error_table, double_error_table, triple_error_table)

%This function outputs all of the candidates to satisfy the parity check measurement results, syndrome_vec, for example (0, 0, 1). In this function, we consider up to three errors. 

%If we consider only a single error, using a look-up table for a single error, we know
%(0,  0,  1) indicates the 1st physical qubit got an error. 
%(0,  1,  0) indicates the 2nd physical qubit got an error. 
%(0,  1,  1) indicates the 3rd physical qubit got an error. 
%(1,  0,  0) indicates the 4th physical qubit got an error. 
%(1,  0,  1) indicates the 5th physical qubit got an error. 
%(1,  1,  0) indicates the 6th physical qubit got an error. 
%(1,  1,  1) indicates the 7th physical qubit got an error.

%However, when we also consider two errors,
%(0,  0,  1) may come from (1,  1,  0) + (1,  1,  1) mod 2.
%In this case, (0,  0,  1) also indicates 6th and 7th physical qubits got errors. 

%This function is only used in our BellMeasurementEClikelihood.m.

%Inputs: 
%syndrome_vec is one of (0, 0, 0), (0, 0, 1), (0, 1, 0), (1, 0, 0), (0, 1, 1), (1, 0, 1), (1, 1, 0), and (1, 1, 1).
%single_error_table is the same table written in our OuterLeaves.m.
%double_error_table is the same table written in our OuterLeaves.m.
%triple_error_table is the same table written in our OuterLeaves.m.

%Output:
%error_matrix is a row vector having 7-elements. Each element is corresponding to each physical qubit comprising a half of a logical-logical bell pair. 

%Example:
%tableSingleErr =    [ 0, 0, 0, 1, 1, 1, 1;
%                     0, 1, 1, 0, 0, 1, 1;
%                     1, 0, 1, 0, 1, 0, 1]';
%tableDoubleErr =  zeros(7,3,7);
%for i = 1:7
%  for j = 1:7
%       tableDoubleErr(i,:,j) = mod(tableSingleErr(i,:) + tableSingleErr(j,:), 2);
%  end
%end

%error_matrix = R_SyndromeToErrors([0, 0, 1], tableSingleErr, tableDoubleErr, tableTripleErr);)

%The output is 
%(1     0     0     0     0     0     0), 1st physical qubit got an error. 
%(0     1     1     0     0     0     0),  2nd and 3rd physical qubits got errors. 
%(0     0     0     1     1     0     0),  4th and 5th physical qubits got errors. 
%(0     0     0     0     0     1     1)   6th and 7th physical qubits got errors. 


%We make a row vector having 7-elements to record errors. Each element is corresponding to each physical qubit comprising a half of a logical-logical Bell pair. 
error_matrix = [];


%%We check the no error case: %ASK
%if syndrome_vec == [0, 0, 0]
%    %Next, we concatenate error_matrix with zeros(1, 7), (0, 0, 0, 0, 0, 0, 0).
%    error_matrix = cat(1, error_matrix, zeros(1, 7));
%end

if isequal(syndrome_vec, [0 0 0])
    error_matrix = cat(1, error_matrix, zeros(1,7));
end

%By comparing our syndrome_vec with all of the elements of tableSingleErr, if they match, we add the corresponding error. 
for i = 1:7
	if isequal(single_error_table(i,:), syndrome_vec)
		error_vector = zeros(1,7);
		error_vector(i) = 1;
        %We add the error_vector, a row vector with a one and 6 zeros, to the end of error_matrix.
		error_matrix = cat(1, error_matrix, error_vector);
    end
end

%By comparing our syndrome_vec with all of the elements of tableDoubleErr, if they match, we add the two corresponding errors. 
for i = 1:7
	for j = i+1:7
		if isequal(double_error_table(i,:,j), syndrome_vec)
			error_vector = zeros(1,7);
			error_vector(i) = 1;
			error_vector(j) = 1;
            %We add the error_vector, a row vector with 2 ones and 5 zeros, to the end of error_matrix.
			error_matrix = cat(1, error_matrix, error_vector);
        end
    end
end

for i = 1:7
	for j = i+1:7
        for k = j+1:7
            if isequal(squeeze(triple_error_table(i,j,k,:))', syndrome_vec)
                error_vector = zeros(1,7);
                error_vector(i) = 1;
                error_vector(j) = 1;
                error_vector(k) = 1;
                %We add the error_vector, a row vector with 3 ones and 4 zeros, to the end of error_matrix.
                error_matrix = cat(1, error_matrix, error_vector);
            end
        end
    end
end
