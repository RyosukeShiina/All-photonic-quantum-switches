function printLambdaList(lambdaList)

    k = size(lambdaList,2);

    fprintf("========= λ (GHZ basis weights) =========\n");

    labels = ["λ0⁺","λ0⁻","λ1⁺","λ1⁻","λ2⁺","λ2⁻","λ3⁺","λ3⁻"];

    for ell = 1:k
        fprintf("\n=== ℓ = %d ===\n", ell);

        for i = 1:8
            fprintf("%5s : %.4f\n", labels(i), lambdaList(i,ell));

            % 区切り：各 ± ペアごとにラインを入れる
            if mod(i,2)==0
                fprintf("---------------------------\n");
            end
        end
    end

    fprintf("=========================================\n");
end