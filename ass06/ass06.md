## hw6 linear model (II)

#### 1. Given a Gaussian linear regression model, Maximum likelihood estimation of 𝒘 under Gaussian noise assumption is equivalent to <font color = "red">squared loss minimization</font>. Please prove it.

Suppose data generating distribution $\mathcal{P_{\mathcal{X\times Y}}}$ follows Normal Distribution $y \sim \mathcal{N}(\boldsymbol{w^{T}x}, \sigma^2)$ and dataset $\mathcal{D}$ are i.i.d sampled. 

Under the assumption of empirical-distributed $\boldsymbol{x_i}$, the corresponding likelihood is: 

$$p(\mathcal{D} ; \boldsymbol{w}, \sigma) = \prod_{i=1}^{n}p(\boldsymbol{x_i},y_i ; \boldsymbol{w}, \sigma) = \frac{1}{n} \prod_{i=1}^{n}p(y_i | \boldsymbol{x_i}; \boldsymbol{w}, \sigma) $$

The maximum log likelihood:

$$\argmax _{\boldsymbol{w}}\log {p(\mathcal{D} ; \boldsymbol{w}, \sigma)} = \argmax_{\boldsymbol{w}}{\frac{1}{n}\sum_{i=1}^{n}\log{p(y_i | \boldsymbol{x_i}; \boldsymbol{w}, \sigma) }}$$

Since,
$$y_i|\boldsymbol{w}, \boldsymbol{x_i} \sim \mathcal{N}(\boldsymbol{w^{T}x}, \sigma^2)$$

Then,

$$p(y_i | \boldsymbol{x_i}; \boldsymbol{w}, \sigma) = \frac{1}{\sqrt{2\pi} \sigma}\exp{[-\frac{(y_i-\boldsymbol{w^Tx_i})}{2\sigma^2}^2]}$$

$$\sum_{i=1}^{n}\log{p(y_i | \boldsymbol{x_i}; \boldsymbol{w}, \sigma) } = \frac{n}{2}\log{\frac{1}{2\pi\sigma^2}}-\frac{1}{2\sigma^2}\sum_{i=1}^{n}(y_i-\boldsymbol{w^Tx_i})^{2}$$

Therefore, given fixed and known $\sigma$, we get:
$$
\argmax_{\boldsymbol{w}}{\frac{1}{n}\sum_{i=1}^{n}\log{p(y_i | \boldsymbol{x_i}; \boldsymbol{w}, \sigma) }} = \argmax_{\boldsymbol{w}}{\frac{1}{n}(\frac{n}{2}\log{\frac{1}{2\pi\sigma^2}}-\frac{1}{2\sigma^2}\sum_{i=1}^{n}(y_i-\boldsymbol{w^Tx_i})^{2})}\\
=\argmin_{\boldsymbol{w}}{\sum_{i=1}^{n}(y_i-\boldsymbol{w^Tx_i})^{2}}$$

As can been seen from the above, the maximum log likelihood of Normal Distribution conforms to squared loss minimization.


#### 2. Given a Laplacian linear regression model, Maximum likelihood estimation of 𝒘 under Laplacian noise assumption is equivalent to <font color = "red">absolute loss minimization</font>. Please prove it.

Suppose data generating distribution $\mathcal{P_{\mathcal{X\times Y}}}$ follows Laplacian Distribution and dataset $\mathcal{D}$ are i.i.d sampled. 

Then,

$$p(y_i | \boldsymbol{x_i}; \boldsymbol{w}, \sigma) = \frac{1}{2b}\exp{(-\frac{|y_i-\boldsymbol{w^Tx_i}|}{b})}$$

$$\sum_{i=1}^{n}\log{p(y_i | \boldsymbol{x_i}; \boldsymbol{w}, \sigma) } = -[n\log{2b} + \frac{1}{b}\sum_{i=1}^{n}|y_i-\boldsymbol{w^Tx_i}|]$$

Therefore, given fixed and known $b$, we get:
$$
\argmax_{\boldsymbol{w}}{\frac{1}{n}\sum_{i=1}^{n}\log{p(y_i | \boldsymbol{x_i}; \boldsymbol{w}, \sigma) }} = \argmax_{\boldsymbol{w}}{-\frac{1}{n}[n\log{2b} + \frac{1}{b}\sum_{i=1}^{n}|y_i-\boldsymbol{w^Tx_i}|]}\\
=\argmin_{\boldsymbol{w}}{\sum_{i=1}^{n}|y_i-\boldsymbol{w^Tx_i}|}$$

As can been seen from the above, the maximum log likelihood of Laplacian Distribution conforms to absolute loss minimization.


#### 3. Given a linear regression model, please write down the Tikhonov Form and Ivanov Form of Ridge Regression, and these two forms of Lasso Regression as well.

* Ridge Regression:
	* Tikhonov Form: given  nonnegative $\lambda$
	$$\hat{\boldsymbol{w}} = \argmin_{\boldsymbol{w}\in \mathbb{R^d}}{\frac{1}{n}\left\| \boldsymbol{y}-\boldsymbol{Xw} \right \|^{2} + \lambda{\left\|  \boldsymbol{w} \right \|}_{2}^{2}}$$
	* Ivanov Form: give nonnegative $r$
	$$\hat{\boldsymbol{w}} = \argmin_{\boldsymbol{\left\| w\right\|_{2}^{2}\leqslant r^2}}{\frac{1}{n}\left\| \boldsymbol{y}-\boldsymbol{Xw} \right \|^{2} }$$

* Lasso Regression:
	* Tikhonov Form: given  nonnegative $\lambda$
	$$\hat{\boldsymbol{w}} = \argmin_{\boldsymbol{w}\in \mathbb{R^d}}{\frac{1}{n}\left\| \boldsymbol{y}-\boldsymbol{Xw} \right \|^{2}  + \lambda{\left\|  \boldsymbol{w} \right \|}_{1}}$$
	* Ivanov Form: give nonnegative $r$
	$$\hat{\boldsymbol{w}} = \argmin_{\boldsymbol{\left\| w\right\|_{1}\leqslant r}}{\frac{1}{n}\left\| \boldsymbol{y}-\boldsymbol{Xw} \right \|^{2} }$$

#### 4. By adding a Ridge Regression in the linear regression model of Question 4 in hw5-linear-model, can we get a lower generalization error?  

If yes, use cross validation to attain the best regularization parameter 𝜆, whose possible values are 
``[1.e-06, 1.e-05, 1.e-04, 1.e-03, 1.e-02, 1.e-01, 1.e+00, 1.e+01, 1.e+02, 1.e+03, 1.e+04, 1.e+05, 1.e+06].``

If no, please explain why. 

Yes.
Large generalization error is an indicator of overfitting phenomenon. Regularization methods constrain hypothesis space by limiting feasible solutions to a certain area ( a hypersphere in ridge reg. case) to prevent the model from trying to fit the optimal solution on training set. In this way, overfitting and generalization error can be reduced.

The corresponding Python codes are as follows:
```py
model_ridge = linear_model.RidgeCV(alphas=np.logspace(-6, 6, 13), cv=5, fit_intercept=True)

model_ridge.fit(X, y)

print(model_ridge.coef_, model_ridge.intercept_, model_ridge.alpha_)
```
We can get regularized models under different $\lambda$ values. And the best one among the given parameter set is 100.
```
[-1.15920284 0.31171027 -0.21347097] 3.964663902708537 100.0
```


#### 5. By adding a Lasso Regression in the linear regression model of Question 4 in hw5-linear-model, can we get a lower generalization error? 
If yes, use cross validation to attain the best regularization parameter 𝜆, whose possible values are 
``[1.e-06, 1.e-05, 1.e-04, 1.e-03, 1.e-02, 1.e-01, 1.e+00, 1.e+01, 1.e+02, 1.e+03, 1.e+04, 1.e+05, 1.e+06]. ``

If no, please explain why. 

Yes.
Large generalization error is an indicator of overfitting phenomenon. Regularization methods constrain hypothesis space by limiting feasible solutions to a certain area ( a hyperpolyhedron in lasso reg. case) to prevent the model from trying to fit the optimal solution on training set. In this way, overfitting and generalization error can be reduced.

The corresponding Python codes are as follows:
```py
model_lasso = linear_model.LassoCV(alphas=np.logspace(-6, 6, 13), cv=5, fit_intercept=True)

model_lasso.fit(X, y)

print(model_lasso.coef_, model_lasso.intercept_, model_lasso.alpha_)
```
We can get regularized models under different $\lambda$ values. And the best one among the given parameter set is 0.1.
```
[-1.93814754 0.46195158 -0.2012904 ] 5.198196758698374 0.1
```
#### Note: The criteria to choose cross validation value
[A 2017 paper](https://www.researchgate.net/publication/321222744_Multiple_predicting_K_-fold_cross-validation_for_model_selection) has proposed an empirical method to choose $K$ in K-fold cross validation:
* $K\approx\log{n}$
* $n/K>3d$

For this dataset $n=100$, $d=3$, and $\log{(100)} = 4.60$, $100/5 = 20 > 3\times 3$
So we can choose $K=5$


