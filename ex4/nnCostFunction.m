function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


%===PART 1: CALCULATING THE UNREGULARISED COST FUNCTION===
%vectorising y
y_matrix = eye(num_labels)(y, :); %size: 5000 x 10
%fprintf('Size of y_matrix %f', size(y_matrix));

X = [ones(m, 1) X];
a2 = sigmoid(X * Theta1'); %size: 5000 x 25
a2 = [ones(m, 1) a2];

hfunc = sigmoid(a2 * Theta2'); %size: 5000 x 10 

%the first / outer sum is to sum all of the cost function of all dataset
%   (summing over column)
%the second / inner sum is to sum the cost function of each dataset's 
%    probability of being either the 10 values (summing over row)
J = sum(sum((-y_matrix .* log(hfunc)) - (1-y_matrix) .* log(1-hfunc))) /m;



%===PART 2: REGULARISING COST FUNCTION===
%size of Theta1: 25 x 401
%size of Theta2: 10 x 26
J += lambda * (sum(sum((Theta1(:, 2:end)).^2)) + sum(sum((Theta2(:, 2:end)).^2))) ... 
  / (2*m);

  
  
%===PART 3: BACKPROPAGATION===
a1 = X; %size: 5000 x 401
z2 = a1 * Theta1'; %size: 5000 x 25
a2 = [ones(m, 1) sigmoid(z2)]; %size: 5000 x 26
z3 = a2 * Theta2'; a3 = sigmoid(z3);%size: 5000 x 10
d3 = a3 - y_matrix; %size: 5000 x 10
d2 = d3 * Theta2(:, 2:end) .* sigmoidGradient(z2); %size: 5000 x 25
Delta1 = d2' * a1; Theta1_grad = Delta1 / m; %size: 25 x 401
Delta2 = d3' * a2; Theta2_grad = Delta2 / m;%size: 10 x 26



%===PART 4: REGULARISING BACKPROPAGATION===
Theta1_grad(:, 2:end) += lambda * Theta1(:, 2:end) / m;
Theta2_grad(:, 2:end) += lambda * Theta2(:, 2:end) / m;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
