clear
clc

%find all files including 'error' and '.mat'
list_files = dir(fullfile(pwd,'*error*.mat'));

% the number of files
num_files = length(list_files);

% pre-allocation 
errors = zeros(num_files, 5);

% load each file and assign the vectors to pre-allocated array
for iter=1:num_files
   fileName = list_files(iter).name;
   error = load(fileName);
   errors(iter,:) = error.error;
   
end

% sort the rows of a matrix in ascending order based on the elemtns in the
% first column
errors_row_sorted = sortrows(errors);

% plot X-axis error
plot(errors_row_sorted(:,1), abs(errors_row_sorted(:,2)))
hold on
% plot Y-axis error
plot(errors_row_sorted(:,1), abs(errors_row_sorted(:,3)))
hold on
% plot Z-axis error
plot(errors_row_sorted(:,1), abs(errors_row_sorted(:,4)))
hold on
% plot distance error
plot(errors_row_sorted(:,1), errors_row_sorted(:,5))

legend x y z distance
xlabel('the number of position')
ylabel('distance error(mm)')



