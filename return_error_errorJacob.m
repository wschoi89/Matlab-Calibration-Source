function [error_out, grad_error_out] = return_error_errorJacob(error_input,parameter)
%UNTITLED �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
error_out = error_input;
grad_error_out = jacobian(error_input', parameter).';
disp(size(grad_error_out))
end

