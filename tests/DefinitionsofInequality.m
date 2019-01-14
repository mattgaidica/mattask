% Test the algebraic rules of inequalities
a = 9;
b = 3;

% [ ] Add a condition to handle undefined numbers
if a < b
    disp('a is less than b');
elseif a == b
    disp('a equals b');
else
    disp('a is greater than b');
end