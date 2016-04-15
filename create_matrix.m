function matrix = create_matrix(master_image, class_number)
matrix=zeros(size(master_image)); %This generates a matrix the same size as the image
matrix = repmat(matrix, 1,1,class_number);
%this matrix will be populated as the classifiers run
%%This script creates the result matrix
