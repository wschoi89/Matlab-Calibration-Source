clear
clc

%find all files including 'error' and '.mat'
list_files = dir(fullfile(pwd,'*error*.mat'));

% the number of files
num_files = length(list_files);

% pre-allocation 
errors = zeros(num_files, 9); 

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
errorbar(errors_row_sorted(:,1), abs(errors_row_sorted(:,2)),abs(errors_row_sorted(:,6)))
hold on
% plot Y-axis error
errorbar(errors_row_sorted(:,1), abs(errors_row_sorted(:,3)),abs(errors_row_sorted(:,7)))
hold on
% plot Z-axis error
errorbar(errors_row_sorted(:,1), abs(errors_row_sorted(:,4)),abs(errors_row_sorted(:,8)))
hold on
% plot distance error
errorbar(errors_row_sorted(:,1), abs(errors_row_sorted(:,5)),abs(errors_row_sorted(:,9)))

legend x y z distance
xlabel('the number of position')
ylabel('distance error(mm)')



