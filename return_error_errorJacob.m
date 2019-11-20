function [error_out, grad_error_out] = return_error_errorJacob(error_input,parameter)
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치
error_out = error_input;
grad_error_out = jacobian(error_input', parameter).';
disp(size(grad_error_out))
end

