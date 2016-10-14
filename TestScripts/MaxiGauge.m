% (c) Alvaro Sanchez Gonzalez 2014
%if (isvalid(a))
    %fclose(a);
%end

       
a = serial('COM3','BaudRate',9600);
fopen(a);
fprintf(a, 'PR1\n');
tmp=fscanf(a)
fprintf(a, '%c',5)
tmp=fscanf(a)
fclose(a)
