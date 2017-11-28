qqplot allows for comparison of two data sets and does so by comparing their quantiles. 
Even if both data sets do not contain the same number of values, qqplot automatically does
interpolation to create extra values for the smaller set. 
> qqplot(data1$property, data2$property)

we can also look for data normality with qqnorm(). To evaluate whether you can see a clear clear
deviation from the normal, u can add a line with qqline(). 
> qqnorm( data1$property)
> qqline( data1$property)
