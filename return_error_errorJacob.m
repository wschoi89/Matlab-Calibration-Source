function [error_out, grad_error_out] = return_error_errorJacob(error_intput,parameter)
%UNTITLED �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
error = error_intput;
grad_error_out = jacobian(error_intput', parameter).';
end

