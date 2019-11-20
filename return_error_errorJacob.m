function [error_out, grad_error_out] = return_error_errorJacob(error_intput,parameter)
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치
error = error_intput;
grad_error_out = jacobian(error_intput', parameter).';
end

